%% Tire Coefficient

% USC Racing 2025 - Tianpai Le

% Find the tire force multiplying coefficient of a target tire (with missing testing data) 
% with respect to a reference tire (with complete testing data)

%% Clear

clear, clc, close all;

%% Setup

% Pressure (typical: 8~14 psi)
IP_psi = 11; 
IP_pa = IP_psi * 6894.76;

% Inclination angle (typical value: 0~4 deg)
IA_deg = 2;
IA_rad = deg2rad(IA_deg);

% Normal load (positive -z)
FZ_lb = 200; 
FZ_N = FZ_lb * 4.448;

% Slip angle
SA_deg_space = -18: 0.5: 18;
SA_rad_space = deg2rad(SA_deg_space);

% UI Table
rowCount = 1;

%% Tire Models

% Reference tire model: needs to have both cornering and drive/brake testing data
% Model: Hoosier 43100 R20 18''x6''
tire_fy_ref = load('Fitted Data/43100_R20_18x6_FY0.mat');

% Target tire model
% Model: Hoosier 43075 R20 16''x7.5''
tire_fy = load('Fitted Data/43075_R20_16x7.5_FY0.mat');

%%

FYR = [];
FY = [];
for i = 1: length(SA_rad_space)

    SA_rad = SA_rad_space(i);

    % Lateral force of reference tire
    [~, fyr] = magicformula(tire_fy_ref.mfparams, 0, SA_rad, FZ_N, IP_pa, IA_rad); 
    FYR = [FYR fyr];

    % Lateral force of target tire
    [~, fy] = magicformula(tire_fy.mfparams, 0, SA_rad, FZ_N, IP_pa, IA_rad); 
    FY = [FY fy];

end
cof_rmax = max(FYR / FZ_N);
cof_rmin = min(FYR / FZ_N);
cof_max = max(FY / FZ_N);
cof_min = min(FY / FZ_N);

coeff = ((cof_max/cof_rmax) + (cof_min/cof_rmin))/2;