%% Tire Model Test

% USC Racing 2024 - Tianpai Le

% This script is reserved to test ramdom tire models

%% Clear

clear, clc, close all;

%% Unit Conversions

N2lbf = 0.224809;
psi2pa = 6894.76;

%% Setup

% Pressure
IP_psi = 11; % from +8 to +14
IP_pa = IP_psi*psi2pa;

% Inclination angle
IA_deg = 2; % from 0 to +4
IA_rad = deg2rad(IA_deg);

% Normal load
FZ_lbs = 250; % positive is down(-z)
FZ_N = FZ_lbs/N2lbf;

% Slip angle
SA_deg = -18: 0.5: 18;
SA_rad = deg2rad(SA_deg);

% Slip ratio
SX = -0.99: 0.05: 0.99;

% UI Table
rowCount = 1;

%% Vector Spaces

% Lateral force, FY [lbf]
FY_R20 = zeros(length(SA_rad), 1);
FY_LCO = zeros(length(SA_rad), 1);
FY_R25B = zeros(length(SA_rad), 1);
FY_R20n = zeros(length(SA_rad), 1);

FYSA_R20 = zeros(2, length(SA_rad));
FYSA_LCO = zeros(2, length(SA_rad));
FYSA_R25B = zeros(2, length(SA_rad));
FYSA_R20n = zeros(2, length(SA_rad));

%%

tireX = load('Fitted Data/43100_R20_18x6_FX02.mat');
tireY = load('Fitted Data/43100_R20_18x6_FY0.mat');
tireXY = load('Fitted Data/43100_R20_18x6_FX0FY0.mat');
FX = [];
FY = [];
FX2 = [];
FY2 = [];

for i = 1: length(SA_rad)

    SA = SA_rad(i);
    [~, FY(i)] = magicformula(tireXY.mfparams, 0, SA, FZ_N, IP_pa, IA_rad);

    [~, FY2(i)] = magicformula(tireY.mfparams, 0, SA, FZ_N, IP_pa, IA_rad);

end

figure;
plot(SA_rad,FY, 'r', LineWidth=4); hold on;  
plot(SA_rad,FY2, 'k', LineWidth=2);

for j = 1: length(SX)

    [FX(j), ~] = magicformula(tireXY.mfparams, SX(j), 0, FZ_N, IP_pa, IA_rad);

    [FX2(j),~] = magicformula(tireX.mfparams, SX(j), 0, FZ_N, IP_pa, IA_rad);

end

figure;
plot(SX, FX, 'r', LineWidth=4); hold on;  
plot(SX, FX2, 'k', LineWidth=2);
