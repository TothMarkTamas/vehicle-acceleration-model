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

rpm_data = [1000, 2000, 3000, 4000, 5000, 6000, 6500];
torque_data_Nm = [180, 260, 320, 350, 330, 280, 230];

power_data_W = torque_data_Nm .* (rpm_data * 2 * pi / 60);
power_data_kW = power_data_W / 1000;

rpm_fine = 1000:50:6500;
torque_fine_Nm = interp1(rpm_data, torque_data_Nm, rpm_fine, 'spline');
power_fine_kW = interp1(rpm_data, power_data_kW, rpm_fine, 'spline');

power_W = max(power_fine_kW) * 1000;
wheelPower_W = power_W * efficiency;

speed_ms = 0.1:0.1:40;

rollingResistance_N = rollingResistanceCoefficient * mass_kg * g_ms2;
dragForce_N = 1/2 * airDensity * dragCoefficient * frontalArea .* speed_ms.^2;
maxTireForce_N = tireGripCoefficient * mass_kg * g_ms2;

tractionForce_N = wheelPower_W ./ speed_ms;
actualTractionForce_N = min(tractionForce_N, maxTireForce_N);

transitionSpeed_ms = wheelPower_W / maxTireForce_N;
transitionSpeed_kmh = transitionSpeed_ms * 3.6;

acceleration_ms2 = (actualTractionForce_N - rollingResistance_N - dragForce_N) / mass_kg;

time_s = 0;
targetSpeed_ms = 100 / 3.6;
i = 1;

while speed_ms(i) < targetSpeed_ms
    deltaTime_s = 0.1 / acceleration_ms2(i);
    time_s = time_s + deltaTime_s;
    i = i + 1;
end

fprintf('Estimated 0-100 km/h time: %.2f s\n', time_s);
fprintf('Traction to power limited transition: %.2f km/h\n', transitionSpeed_kmh);

figure;

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

figure;

plot(speed_ms, acceleration_ms2, 'LineWidth', 1.5);
xlabel('Speed (m/s)');
ylabel('Acceleration (m/s^2)');
title('Vehicle Acceleration vs Speed');
grid on;

xline(transitionSpeed_ms, '--', ...
    sprintf('Transition: %.2f km/h', transitionSpeed_kmh), ...
    'LabelVerticalAlignment', 'bottom', ...
    'LabelHorizontalAlignment', 'left');

legend('Acceleration', 'Location', 'northeast');
