%% Tire Temperature Analysis

% USC Racing 2024 - Tianpai Le

% 1st tire model: Hoosier 43075 LCO 16"x7.5"
% 2nd tire model: Hoosier 43075 R20 16"x7.5"
% Run Condition: 8 psi

% X-axis: Tire Surface Temperature (center), TSTC
% Y-axis: Lateral Tire Force, FY (original TTC data)

% Note: 1) Contains all data points from TTC, no filtering for certain 
%          conditions

%% Clear

clear, clc, close all;

%% Unit Conversions

% degF = (9/5)*degC + 32;                                                   % Degrees Celcius to degrees Fahrenheit
N2lbs = 1/4.448;                                                            % Newtons to pound force

%% Load Tire Models

tire1 = load('Raw Data/RawData_Cornering_Matlab_SI_Round9_Runs_1to15/B2356raw6.mat');
tire2 = load('Raw Data/RawData_Cornering_Matlab_SI_10inch_Round8/B1965raw19.mat');

%% Obtain Data

% 1st tire model
R20_ET = tire1.ET;                                                          % Elapsed time [s]
R20_SA = tire1.SA;                                                          % Slip Angle [deg]
R20_FY = tire1.FY*N2lbs;                                                    % Lateral force [lbf]
R20_FZ = tire1.FZ*N2lbs;                                                    % Normal Load [lbf]
R20_TSTC = (9/5)*tire1.TSTC + 32;                                           % Tire surface temperature (center) [degF]

% 2nd tire model
LCO_ET = tire2.ET;                                                          % Elapsed time [s]
LCO_SA = tire2.SA;                                                          % Slip Angle [deg]
LCO_FY = tire2.FY*N2lbs;                                                    % Lateral force [N]
LCO_FZ = tire2.FZ*N2lbs;                                                    % Normal Load [lbf]
LCO_TSTC = (9/5)*tire2.TSTC + 32;                                           % Tire surface temperature (center) [degF]

%% Find the Cold-to-hot Sweep Region

% 1st tire model
R20_ET_C2H = R20_ET(R20_ET >= 13 & R20_ET <= 92);
R20_SA_C2H = R20_SA(R20_ET >= 13 & R20_ET <= 92); 
R20_FY_C2H = R20_FY(R20_ET >= 13 & R20_ET <= 92); 
R20_FZ_C2H = R20_FZ(R20_ET >= 13 & R20_ET <= 92); 
R20_TSTC_C2H = R20_TSTC(R20_ET >= 13 & R20_ET <= 92); 

% 2nd tire model
LCO_ET_C2H = LCO_ET(LCO_ET >= 13 & LCO_ET <= 92); 
LCO_SA_C2H = LCO_SA(LCO_ET >= 13 & LCO_ET <= 92); 
LCO_FY_C2H = LCO_FY(LCO_ET >= 13 & LCO_ET <= 92);
LCO_FZ_C2H = LCO_FZ(LCO_ET >= 13 & LCO_ET <= 92); 
LCO_TSTC_C2H = LCO_TSTC(LCO_ET >= 13 & LCO_ET <= 92); 

% Get Coefficient of Friction
R20_f_C2H = R20_FY_C2H./R20_FZ_C2H;
LCO_f_C2H = LCO_FY_C2H./LCO_FZ_C2H;

%% Filter Data by Constraining Slip Angle(s)

% Set upper and lower bounds for slip angle
SA1_uprbnd = 9.1;
SA1_lwrbnd = 8.9;
SA2_uprbnd = -8.9;
SA2_lwrbnd = -9.1;

% 1st tire model
R20_ET_C2H_SA1 = R20_ET_C2H(R20_SA_C2H >= SA1_lwrbnd & R20_SA_C2H <= SA1_uprbnd);
R20_TSTC_C2H_SA1 = R20_TSTC_C2H(R20_SA_C2H >= SA1_lwrbnd & R20_SA_C2H <= SA1_uprbnd);

R20_ET_C2H_SA2 = R20_ET_C2H(R20_SA_C2H >= SA2_lwrbnd & R20_SA_C2H <= SA2_uprbnd);
R20_TSTC_C2H_SA2 = R20_TSTC_C2H(R20_SA_C2H >= SA2_lwrbnd & R20_SA_C2H <= SA2_uprbnd);

% 2nd tire model
LCO_ET_C2H_SA1 = LCO_ET_C2H(LCO_SA_C2H >= SA1_lwrbnd & LCO_SA_C2H <= SA1_uprbnd);
LCO_TSTC_C2H_SA1 = LCO_TSTC_C2H(LCO_SA_C2H >= SA1_lwrbnd & LCO_SA_C2H <= SA1_uprbnd);

LCO_ET_C2H_SA2 = LCO_ET_C2H(LCO_SA_C2H >= SA2_lwrbnd & LCO_SA_C2H <= SA2_uprbnd);
LCO_TSTC_C2H_SA2 = LCO_TSTC_C2H(LCO_SA_C2H >= SA2_lwrbnd & LCO_SA_C2H <= SA2_uprbnd);

%% Filter Data by Constraining Temperature(s)

% Find the maximum coefficient of friction from each temperature interval
TSTC_min = 100;                                                             % Minimum temperature [degF]
TSTC_max = 170;                                                             % Maximum temperature [degF]
TempStep = 0.2;                                                             % Step length (interval) of temperature [degF]

TSTC_range = TSTC_min: TempStep: TSTC_max;                                  % Temperature range [degF]
% Spaces to store maximum coefficient of friction
R20_maxf_C2H_TSTC = zeros((TSTC_max - TSTC_min)/TempStep + 1, 1); 
LCO_maxf_C2H_TSTC = zeros((TSTC_max - TSTC_min)/TempStep + 1, 1);


for i = 1: (TSTC_max - TSTC_min)/TempStep + 1

    % Set upper and lower bounds for slip angle
    TSTC_uprbnd = TSTC_min + TempStep*i;
    TSTC_lwrbnd = TSTC_min + TempStep*(i - 2);
    
    % 1st tire model
    R20_f_C2H_TSTC = R20_f_C2H(R20_TSTC_C2H >= TSTC_lwrbnd & R20_TSTC_C2H <= TSTC_uprbnd);

    if size(R20_f_C2H_TSTC, 1) == 0

        R20_maxf_C2H_TSTC(i) = NaN;

    else

        R20_maxf_C2H_TSTC(i) = max(abs(R20_f_C2H_TSTC));

    end
    
    % 2nd tire model
    LCO_f_C2H_TSTC = LCO_f_C2H(LCO_TSTC_C2H >= TSTC_lwrbnd & LCO_TSTC_C2H <= TSTC_uprbnd);

    if size(LCO_f_C2H_TSTC, 1) == 0

        LCO_maxf_C2H_TSTC(i) = NaN;

    else

        LCO_maxf_C2H_TSTC(i) = max(abs(LCO_f_C2H_TSTC));

    end

end

%% Plot

% Lateral force vs. TSTC
figure
plot(R20_TSTC_C2H, abs(R20_FY_C2H), 'b', LineWidth=1);
hold on
grid on
plot(LCO_TSTC_C2H, abs(LCO_FY_C2H), 'r', LineWidth=1);
xlabel(['Tire Surface Temperature (center) [' char(176) 'F]']);
ylabel('Lateral Force [lbf]');
title('Lateral Force with Temperature Sensitivity');
legend('R20', 'LCO', 'Location', 'southeast');

% Coefficient of friction vs. TSTC
figure
plot(R20_TSTC_C2H, abs(R20_f_C2H), '-b', LineWidth=1);
hold on
grid on
plot(LCO_TSTC_C2H, abs(LCO_f_C2H), '-r', LineWidth=1);
xlabel(['Tire Surface Temperature (center) [' char(176) 'F]']);
ylabel('Coefficient of Friction, f');
title('Coefficient of Friction with Temperature Sensitivity');
legend('R20', 'LCO', 'Location', 'southeast');

% TSTC vs. elapsed time
figure
plot(R20_ET_C2H, R20_TSTC_C2H, '-b', LineWidth=1);
hold on
grid on
plot(LCO_ET_C2H, LCO_TSTC_C2H, '-r', LineWidth=1);
xlabel('Elapsed Time [s]');
ylabel(['Tire Surface Temperature (center) [' char(176) 'F]']);
title('Temperature vs. Time');
legend('R20', 'LCO', 'Location', 'southeast');

% figure
% plot(R20_ET_C2H_SA1, R20_TSTC_C2H_SA1, 'o', Color='#0080FF', LineWidth=1);
% hold on
% grid on
% plot(R20_ET_C2H_SA2, R20_TSTC_C2H_SA2, 'o', Color='#0080FF', LineWidth=1);
% plot(LCO_ET_C2H_SA1, LCO_TSTC_C2H_SA1, 'o', Color='#FF8000', Linewidth=1);
% plot(LCO_ET_C2H_SA2, LCO_TSTC_C2H_SA2, 'o', Color='#FF8000', LineWidth=1);
% xlabel('Elapsed Time [s]');
% ylabel(['Tire Surface Temperature (center) [' char(176) 'F]']);
% title('Temperature vs. Time');
% legend('R20', 'R20', 'LCO', 'LCO', 'Location', 'southeast');

% TSTC vs. slip angle
figure
plot(R20_SA_C2H, R20_TSTC_C2H, '-b', LineWidth=1);
hold on
grid on
plot(LCO_SA_C2H, LCO_TSTC_C2H, '-r', LineWidth=1);
xlabel('Slip Angle [deg]');
ylabel(['Tire Surface Temperature (center) [' char(176) 'F]']);
title('Temperature vs. Slip Angle');
legend('R20', 'LCO', 'Location', 'southeast');

% Max. coefficient of friction 
% (picked from each temperature interval) vs. TSTC
figure
plot(TSTC_range, R20_maxf_C2H_TSTC, '-b', LineWidth=1);
hold on
grid on
plot(TSTC_range, LCO_maxf_C2H_TSTC, '-r', LineWidth=1);
xlabel(['Tire Surface Temperature (center) [' char(176) 'F]']);
ylabel('Coefficient of Friction, f');
title('Max. Coefficient of Friction vs. Temperature', ...
    sprintf(['Temperature Interval: %.1f ' char(176) 'F'], TempStep)); 
legend('R20', 'LCO', 'Location', 'southeast');