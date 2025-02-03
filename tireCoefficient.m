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
FZ_lb = 250; 
FZ_N = FZ_lb / 0.224809;

% Slip angle
SA_deg = -18: 0.5: 18;
SA_rad = deg2rad(SA_deg);

% UI Table
rowCount = 1;

%% Tire Models

% Reference tire model: needs to have both cornering and drive/brake testing data
% Model: Hoosier 43100 R20 18''x6''
tire_fx_ref = load('Fitted Data/43100_R20_18x6_FX0.mat');
tire_fy_ref = load('Fitted Data/43100_R20_18x6_FY0.mat');

% %% Vector Spaces
% 
% % Lateral force, FY [lbf]
% FY_R20 = zeros(length(SA_rad), 1);
% FY_LCO = zeros(length(SA_rad), 1);
% FY_R25B = zeros(length(SA_rad), 1);
% FY_R20n = zeros(length(SA_rad), 1);
% 
% FYSA_R20 = zeros(2, length(SA_rad));
% FYSA_LCO = zeros(2, length(SA_rad));
% FYSA_R25B = zeros(2, length(SA_rad));
% FYSA_R20n = zeros(2, length(SA_rad));

%%

% tire = load('Run Data/RunData_DriveBrake_Matlab_SI_Round9/B2356run72.mat');
% dataPts = length(tire.ET);
% plot(tire.SL, tire.FX);