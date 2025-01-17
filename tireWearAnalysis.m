%% Tire Wear Analysis

% 1st tire model: Hoosier 43075 R20 16"x7.5"
% 2nd tire model: Hoosier 43075 LCO 16"x7.5"

% x-axis: Normal Load, FZ
% y-axis: Coefficient of Friction

% Notes: Plotted from repeated tests under IP = 12 psi

%% Clear

clear, clc, close all;

%% Unit Conversion

in2cm = 2.54;
N2lbf = 0.224809;

%% Setup

% Load 1st tire model
R20run4 = load("Raw Data/RawData_Cornering_Matlab_SI_Round9_Runs_1to15/B2356raw4.mat");
R20run6 = load("Raw Data/RawData_Cornering_Matlab_SI_Round9_Runs_1to15/B2356raw6.mat");

R20run4_ET = R20run4.ET;                                                    % Elapsed time [s]
R20run4_SA = R20run4.SA;                                                    % Slip angle [deg]
R20run4_FY = abs(R20run4.FY*N2lbf);                                         % Lateral force [lbf]
R20run4_FZ = -R20run4.FZ*N2lbf;                                             % Normal load [lbf]

R20run6_ET = R20run6.ET;                                                    % Elapsed time [s]
R20run6_SA = R20run6.SA;                                                    % Slip angle [deg]
R20run6_FY = abs(R20run6.FY*N2lbf);                                         % Lateral force [lbf]
R20run6_FZ = -R20run6.FZ*N2lbf;                                             % Normal load [lbf]

% Load 2nd tire model
LCOrun18 = load("Run Data/RunData_Cornering_Matlab_SI_10inch_Round8/B1965run18.mat");
LCOrun19 = load("Run Data/RunData_Cornering_Matlab_SI_10inch_Round8/B1965run19.mat");

LCOrun18_ET = LCOrun18.ET;                                                  % Elapsed time [s]
LCOrun18_SA = LCOrun18.SA;                                                  % Slip angle [deg]
LCOrun18_FY = abs(LCOrun18.FY*N2lbf);                                       % Lateral force [lbf]
LCOrun18_FZ = -LCOrun18.FZ*N2lbf;                                           % Normal load [lbf]

LCOrun19_ET = LCOrun19.ET;                                                  % Elapsed time [s]
LCOrun19_SA = LCOrun19.SA;                                                  % Slip angle [deg]
LCOrun19_FY = abs(LCOrun19.FY*N2lbf);                                       % Lateral force [lbf]
LCOrun19_FZ = -LCOrun19.FZ*N2lbf;                                           % Normal load [lbf]

%% Data Acquisition

% Find FZ and RL within the time range under different IP and IA conditions
% 1st tire model
% Initial test, IA = 0 deg
R20_SA_IT_IA0 = R20run4_SA(R20run4_ET >= 231 & R20run4_ET <= 465);
R20_FZ_IT_IA0 = R20run4_FZ(R20run4_ET >= 231 & R20run4_ET <= 465);
R20_FY_IT_IA0 = R20run4_FY(R20run4_ET >= 231 & R20run4_ET <= 465);

% Initial test, IA = 2 deg
R20_SA_IT_IA2 = R20run4_SA(R20run4_ET >= 468 & R20run4_ET <= 635);
R20_FZ_IT_IA2 = R20run4_FZ(R20run4_ET >= 468 & R20run4_ET <= 635);
R20_FY_IT_IA2 = R20run4_FY(R20run4_ET >= 468 & R20run4_ET <= 635);

% Initial test, IA = 4 deg
R20_SA_IT_IA4 = R20run4_SA(R20run4_ET >= 637 & R20run4_ET <= 804);
R20_FZ_IT_IA4 = R20run4_FZ(R20run4_ET >= 637 & R20run4_ET <= 804);
R20_FY_IT_IA4 = R20run4_FY(R20run4_ET >= 637 & R20run4_ET <= 804);
R20_f_IT_IA4 = R20_FY_IT_IA4./R20_FZ_IT_IA4;

% Final test, IA = 0 deg
R20_SA_FT_IA0 = R20run6_SA(R20run6_ET >= 707 & R20run6_ET <= 908);
R20_FZ_FT_IA0 = R20run6_FZ(R20run6_ET >= 707 & R20run6_ET <= 908);
R20_FY_FT_IA0 = R20run6_FY(R20run6_ET >= 707 & R20run6_ET <= 908);

% Final test, IA = 2 deg
R20_SA_FT_IA2 = R20run6_SA(R20run6_ET >= 910 & R20run6_ET <= 1077);
R20_FZ_FT_IA2 = R20run6_FZ(R20run6_ET >= 910 & R20run6_ET <= 1077);
R20_FY_FT_IA2 = R20run6_FY(R20run6_ET >= 910 & R20run6_ET <= 1077);

% Final test, IA = 4 deg
R20_SA_FT_IA4 = R20run6_SA(R20run6_ET >= 1079 & R20run6_ET <= 1246);
R20_FZ_FT_IA4 = R20run6_FZ(R20run6_ET >= 1079 & R20run6_ET <= 1246);
R20_FY_FT_IA4 = R20run6_FY(R20run6_ET >= 1079 & R20run6_ET <= 1246);
R20_f_FT_IA4 = R20_FY_FT_IA4./R20_FZ_FT_IA4;

% 2nd tire model
% Initial test, IA = 0 deg
LCO_SA_IT_IA0 = LCOrun18_SA(LCOrun18_ET >= 231 & LCOrun18_ET <= 464);
LCO_FZ_IT_IA0 = LCOrun18_FZ(LCOrun18_ET >= 231 & LCOrun18_ET <= 464);
LCO_FY_IT_IA0 = LCOrun18_FY(LCOrun18_ET >= 231 & LCOrun18_ET <= 464);

% Initial test, IA = 2 deg
LCO_SA_IT_IA2 = LCOrun18_SA(LCOrun18_ET >= 467 & LCOrun18_ET <= 634);
LCO_FZ_IT_IA2 = LCOrun18_FZ(LCOrun18_ET >= 467 & LCOrun18_ET <= 634);
LCO_FY_IT_IA2 = LCOrun18_FY(LCOrun18_ET >= 467 & LCOrun18_ET <= 634);

% Initial test, IA = 4 deg
LCO_FZ_IT_IA4 = LCOrun18_FZ(LCOrun18_ET >= 636 & LCOrun18_ET <= 803);
LCO_FY_IT_IA4 = LCOrun18_FY(LCOrun18_ET >= 636 & LCOrun18_ET <= 803);

% Final test, IA = 0 deg
LCO_SA_FT_IA0 = LCOrun19_SA(LCOrun19_ET >= 707 & LCOrun19_ET <= 908);
LCO_FZ_FT_IA0 = LCOrun19_FZ(LCOrun19_ET >= 707 & LCOrun19_ET <= 908);
LCO_FY_FT_IA0 = LCOrun19_FY(LCOrun19_ET >= 707 & LCOrun19_ET <= 908);

% Final test, IA = 2 deg
LCO_SA_FT_IA2 = LCOrun19_SA(LCOrun19_ET >= 910 & LCOrun19_ET <= 1077);
LCO_FZ_FT_IA2 = LCOrun19_FZ(LCOrun19_ET >= 910 & LCOrun19_ET <= 1077);
LCO_FY_FT_IA2 = LCOrun19_FY(LCOrun19_ET >= 910 & LCOrun19_ET <= 1077);

% Final test, IA = 4 deg
LCO_FZ_FT_IA4 = LCOrun19_FZ(LCOrun19_ET >= 1079 & LCOrun19_ET <= 1246);
LCO_FY_FT_IA4 = LCOrun19_FY(LCOrun19_ET >= 1079 & LCOrun19_ET <= 1246);

%% Data Filtering

% Set upper and lower bounds for slip angle
SA_lwrbnd = -8.1;
SA_uprbnd = -7.9;

% Filter by slip angle
% 1st tire model
% Initial test, IA = 0 deg
R20_FZ_IT_IA0 = R20_FZ_IT_IA0(R20_SA_IT_IA0 >= SA_lwrbnd & R20_SA_IT_IA0 <= SA_uprbnd);
R20_FY_IT_IA0 = R20_FY_IT_IA0(R20_SA_IT_IA0 >= SA_lwrbnd & R20_SA_IT_IA0 <= SA_uprbnd);
R20_f_IT_IA0 = R20_FY_IT_IA0./R20_FZ_IT_IA0;

% Initial test, IA = 2 deg
R20_FZ_IT_IA2 = R20_FZ_IT_IA2(R20_SA_IT_IA2 >= SA_lwrbnd & R20_SA_IT_IA2 <= SA_uprbnd);
R20_FY_IT_IA2 = R20_FY_IT_IA2(R20_SA_IT_IA2 >= SA_lwrbnd & R20_SA_IT_IA2 <= SA_uprbnd);
R20_f_IT_IA2 = R20_FY_IT_IA2./R20_FZ_IT_IA2;

% Final test, IA = 0 deg
R20_FZ_FT_IA0 = R20_FZ_FT_IA0(R20_SA_FT_IA0 >= SA_lwrbnd & R20_SA_FT_IA0 <= SA_uprbnd);
R20_FY_FT_IA0 = R20_FY_FT_IA0(R20_SA_FT_IA0 >= SA_lwrbnd & R20_SA_FT_IA0 <= SA_uprbnd);
R20_f_FT_IA0 = R20_FY_FT_IA0./R20_FZ_FT_IA0;

% Final test, IA = 2 deg
R20_FZ_FT_IA2 = R20_FZ_FT_IA2(R20_SA_FT_IA2 >= SA_lwrbnd & R20_SA_FT_IA2 <= SA_uprbnd);
R20_FY_FT_IA2 = R20_FY_FT_IA2(R20_SA_FT_IA2 >= SA_lwrbnd & R20_SA_FT_IA2 <= SA_uprbnd);
R20_f_FT_IA2 = R20_FY_FT_IA2./R20_FZ_FT_IA2;

% 2nd tire model
% Initial test, IA = 0 deg
LCO_FZ_IT_IA0 = LCO_FZ_IT_IA0(LCO_SA_IT_IA0 >= SA_lwrbnd & LCO_SA_IT_IA0 <= SA_uprbnd);
LCO_FY_IT_IA0 = LCO_FY_IT_IA0(LCO_SA_IT_IA0 >= SA_lwrbnd & LCO_SA_IT_IA0 <= SA_uprbnd);
LCO_f_IT_IA0 = LCO_FY_IT_IA0./LCO_FZ_IT_IA0;

% Initial test, IA = 2 deg
LCO_FZ_IT_IA2 = LCO_FZ_IT_IA2(LCO_SA_IT_IA2 >= SA_lwrbnd & LCO_SA_IT_IA2 <= SA_uprbnd);
LCO_FY_IT_IA2 = LCO_FY_IT_IA2(LCO_SA_IT_IA2 >= SA_lwrbnd & LCO_SA_IT_IA2 <= SA_uprbnd);
LCO_f_IT_IA2 = LCO_FY_IT_IA2./LCO_FZ_IT_IA2;

% Final test, IA = 0 deg
LCO_FZ_FT_IA0 = LCO_FZ_FT_IA0(LCO_SA_FT_IA0 >= SA_lwrbnd & LCO_SA_FT_IA0 <= SA_uprbnd);
LCO_FY_FT_IA0 = LCO_FY_FT_IA0(LCO_SA_FT_IA0 >= SA_lwrbnd & LCO_SA_FT_IA0 <= SA_uprbnd);
LCO_f_FT_IA0 = LCO_FY_FT_IA0./LCO_FZ_FT_IA0;

% Final test, IA = 2 deg
LCO_FZ_FT_IA2 = LCO_FZ_FT_IA2(LCO_SA_FT_IA2 >= SA_lwrbnd & LCO_SA_FT_IA2 <= SA_uprbnd);
LCO_FY_FT_IA2 = LCO_FY_FT_IA2(LCO_SA_FT_IA2 >= SA_lwrbnd & LCO_SA_FT_IA2 <= SA_uprbnd);
LCO_f_FT_IA2 = LCO_FY_FT_IA2./LCO_FZ_FT_IA2;

%% Data Fitting

R20_fittedf_IT_IA0 = fit(R20_FZ_IT_IA0, R20_f_IT_IA0, 'exp2');
R20_fittedf_FT_IA0 = fit(R20_FZ_FT_IA0, R20_f_FT_IA0, 'exp2');

R20_fittedf_IT_IA2 = fit(R20_FZ_IT_IA2, R20_f_IT_IA2, 'exp2');
R20_fittedf_FT_IA2 = fit(R20_FZ_FT_IA2, R20_f_FT_IA2, 'exp2');

LCO_fittedf_IT_IA0 = fit(LCO_FZ_IT_IA0, LCO_f_IT_IA0, 'exp2');
LCO_fittedf_FT_IA0 = fit(LCO_FZ_FT_IA0, LCO_f_FT_IA0, 'exp2');

LCO_fittedf_IT_IA2 = fit(LCO_FZ_IT_IA2, LCO_f_IT_IA2, 'exp2');
LCO_fittedf_FT_IA2 = fit(LCO_FZ_FT_IA2, LCO_f_FT_IA2, 'exp2');

%% Plot Figure 1

figure(1)

plot11 = plot(R20_fittedf_IT_IA0, R20_FZ_IT_IA0, R20_f_IT_IA0); 
set(plot11(1), Color='#00AAFF', Marker='o');
set(plot11(2), Color='b', LineWidth=2);
hold on
grid on

plot12 = plot(R20_fittedf_FT_IA0, R20_FZ_FT_IA0, R20_f_FT_IA0);
set(plot12(1), Color='#00FFAA', Marker='o');
set(plot12(2), Color='#008000', LineWidth=2);

plot21 = plot(LCO_fittedf_IT_IA0, LCO_FZ_IT_IA0, LCO_f_IT_IA0);
set(plot21(1), Color='#FFAAFF', Marker='o');
set(plot21(2), Color='r', LineWidth=2);

plot22 = plot(LCO_fittedf_FT_IA0, LCO_FZ_FT_IA0, LCO_f_FT_IA0);
set(plot22(1), Color='#FFAA00', Marker='o');
set(plot22(2), Color='#FF5500', LineWidth=2);

xlabel('Normal Load, FZ [lbf]');
ylabel('Coefficient of Friction, f');
title('Tire Wear with Load Sensitivity', ...
    sprintf(['IP = 12 psi, IA = 0' char(176) ...
    ', SA between %.2f' char(176) ' and %.2f' char(176)], SA_lwrbnd, SA_uprbnd));
legend('R20 Initial Run', 'R20 Initial Run (fitted)', 'R20 Final Run', 'R20 Final Run (fitted)', ...
    'LCO Initial Run', 'LCO Initial Run (fitted)', 'LCO Final Run', 'LCO Final Run (fitted)', Location='eastoutside');
hold off
