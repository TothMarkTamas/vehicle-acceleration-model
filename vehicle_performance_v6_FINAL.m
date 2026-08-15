clear;
clc;
close all;

mass_kg = 1500;
efficiency = 0.9;
g_ms2 = 9.81;
rollingResistanceCoefficient = 0.012;
airDensity = 1.225;
dragCoefficient = 0.3;
frontalArea = 2.2;
tireGripCoefficient = 1.0;

r_wheel = 0.316;
i_final = 3.9;
i_gear = [3.50, 2.10, 1.40, 1.00];

maxTireForce_N = tireGripCoefficient * mass_kg * g_ms2;

rpm_data = [1000, 2000, 3000, 4000, 5000, 6000, 6500];
torque_data_Nm = [180, 260, 320, 350, 330, 280, 230];

power_data_W = torque_data_Nm .* (rpm_data * 2 * pi / 60);
power_data_kW = power_data_W / 1000;

rpm_fine = 1000:50:6500;
torque_fine_Nm = interp1(rpm_data, torque_data_Nm, rpm_fine, 'spline');
power_fine_kW = interp1(rpm_data, power_data_kW, rpm_fine, 'spline');

power_W_peak = max(power_fine_kW) * 1000;
wheelPower_W_peak = power_W_peak * efficiency;

speed_ms = 0.1:0.1:40;
speed_kmh = speed_ms * 3.6;

rollingResistance_N = rollingResistanceCoefficient * mass_kg * g_ms2;
dragForce_N = 1/2 * airDensity * dragCoefficient * frontalArea .* speed_ms.^2;
rpm_wheel = (speed_ms ./ (2 * pi * r_wheel)) * 60;

tractionForce_CVT = wheelPower_W_peak ./ speed_ms;
actualTraction_CVT = min(tractionForce_CVT, maxTireForce_N);
accel_CVT = (actualTraction_CVT - rollingResistance_N - dragForce_N) / mass_kg;

maxAvailableTraction_V6 = zeros(size(speed_ms));

for i = 1:length(speed_ms)
    best_force = 0;
    for g = 1:length(i_gear)
        rpm_engine = rpm_wheel(i) * i_gear(g) * i_final;
        rpm_lookup = max(rpm_engine, 1000);
        
        if rpm_lookup <= 6500
            torque_engine = interp1(rpm_data, torque_data_Nm, rpm_lookup, 'spline');
            F_gear = (torque_engine * i_gear(g) * i_final * efficiency) / r_wheel;
            if F_gear > best_force
                best_force = F_gear;
            end
        end
    end
    maxAvailableTraction_V6(i) = min(best_force, maxTireForce_N);
end

accel_V6 = (maxAvailableTraction_V6 - rollingResistance_N - dragForce_N) / mass_kg;

time_s = 0;
targetSpeed_ms = 100 / 3.6;
i = 1;

while speed_ms(i) < targetSpeed_ms
    deltaTime_s = 0.1 / accel_V6(i);
    time_s = time_s + deltaTime_s;
    i = i + 1;
end

fprintf('=== SIMULATION RESULTS ===\n');
fprintf('Estimated 0-100 km/h time: %.2f s\n', time_s);

figure('Name', 'Engine Curves (V5)');
yyaxis left
plot(rpm_fine, torque_fine_Nm, 'b-', 'LineWidth', 2);
ylabel('Torque (Nm)');
ylim([0, 400]);

yyaxis right
plot(rpm_fine, power_fine_kW, 'r-', 'LineWidth', 2);
ylabel('Power (kW)');
ylim([0, 250]);

xlabel('Engine Speed (RPM)');
title('Engine Torque and Power Curve');
grid on;
legend('Torque', 'Power', 'Location', 'south');

figure('Name', 'Traction Force by Gear (V6)');
hold on;
yline(maxTireForce_N, 'k--', 'Tire Traction Limit', 'LineWidth', 1.5);

for g = 1:length(i_gear)
    rpm_engine = rpm_wheel * i_gear(g) * i_final;
    valid_idx = (rpm_engine >= 1000) & (rpm_engine <= 6500);
    
    torque_engine = zeros(size(speed_ms));
    torque_engine(valid_idx) = interp1(rpm_data, torque_data_Nm, rpm_engine(valid_idx), 'spline');
    
    F_traction = (torque_engine * i_gear(g) * i_final * efficiency) / r_wheel;
    plot(speed_kmh, F_traction, 'LineWidth', 1.5, 'DisplayName', sprintf('%d. Gear', g));
end

xlabel('Vehicle Speed (km/h)');
ylabel('Traction Force (N)');
title('Traction Force vs Speed by Gear (V6)');
ylim([0, 20000]);
grid on;
legend('Location', 'northeast');

figure('Name', 'Acceleration Comparison (V5 vs V6)');
plot(speed_kmh, accel_CVT, 'r--', 'LineWidth', 1.5, 'DisplayName', 'V5 (Ideal CVT)');
hold on;
plot(speed_kmh, accel_V6, 'b-', 'LineWidth', 1.5, 'DisplayName', 'V6 (Manual Gearbox)');
xlabel('Speed (km/h)');
ylabel('Acceleration (m/s^2)');
title('Vehicle Acceleration vs Speed (V5 vs V6)');
grid on;
legend('Location', 'northeast');