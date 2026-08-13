clear;
clc;
close all;

mass_kg = 1500;
power_W = 150000;
efficiency = 0.9;

wheelPower_W = power_W * efficiency;

speed_ms = 5:5:40;

tractionForce_N = wheelPower_W ./ speed_ms;

acceleration_ms2 = tractionForce_N / mass_kg;

plot(speed_ms, acceleration_ms2);
xlabel('Speed (m/s)');
ylabel('Acceleration (m/s^2)');
title('Acceleration vs Speed');
grid on;