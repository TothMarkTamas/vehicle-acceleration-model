clear;
clc;
close all;

mass_kg = 1500;
power_W = 150000;
efficiency = 0.9;

g_ms2 = 9.81;
rollingResistanceCoefficient = 0.012;

airDensity = 1.225;
dragCoefficient = 0.3;
frontalArea = 2.2;

wheelPower_W = power_W * efficiency;

speed_ms = 0.1:0.1:40;

tractionForce_N = wheelPower_W ./ speed_ms;

rollingResistance_N = rollingResistanceCoefficient * mass_kg * g_ms2;

dragForce_N = 1/2 * airDensity * dragCoefficient * frontalArea .* speed_ms.^2;

acceleration_ms2 = (tractionForce_N - rollingResistance_N - dragForce_N) / mass_kg;

time_s = 0;
targetSpeed_ms = 100 / 3.6;
i = 1;

while speed_ms(i) < targetSpeed_ms

    deltaTime_s = 0.1 / acceleration_ms2(i);
    time_s = time_s + deltaTime_s;

    i = i + 1;

end

fprintf('Estimated 0-100 km/h time: %.2f s\n', time_s);


plot(speed_ms, acceleration_ms2);
xlabel('Speed (m/s)');
ylabel('Acceleration (m/s^2)');
title('Acceleration vs Speed');
grid on;