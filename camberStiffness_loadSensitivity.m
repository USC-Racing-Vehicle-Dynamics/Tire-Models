%% Title: Comparing Multiple Tire Models by Camber Stiffness

% 1st tire model: Hoosier 43075 R20 16"x7.5"
% 2nd tire model: Hoosier 43075 LCO 16"x7.5"

% X-axis: Slip Angle, SA
% Y-axis: Cornering Stiffness, C (Fitted)

% Notes: 1) Normal load (FZ) varied
%        2) Inflation pressure (IP) & set to be constant
%        3) Tire performing at optimum temperature

%% Clear

clear, clc, close all;

%% Setup

% Pressure
IP_psi = 11; % from +8 to +14
IP_pa = IP_psi*6894.76;

% Inclination angle
IA_deg = [0, 2]; % from 0 to +4
IA_rad = deg2rad(IA_deg);

% Normal load
fz_lbs = [50, 150, 250]; % positive is down(-z)
fz_N = fz_lbs*4.448;
fz_count = 5;

% Slip angle
sa_deg = linspace(-15, 15, 1000);
sa_rad = sa_deg*(pi/180);

%% Load Tire Models

% 1st tire model
tire1 = load("Fitted Data/43075_R20_16x7.5_FY0.mat");
% 2nd tire model
tire2 = load("Fitted Data/43075_LCO_16x7.5_FY0.mat");

%% Vector Spaces

% Lateral Tire Force, FY
FY_R20 = zeros(length(fz_lbs), length(sa_rad));
FY_LCO = zeros(length(fz_lbs), length(sa_rad));

% Camber Stiffnesses
CamberStiffness_R20 = zeros(length(fz_lbs), length(sa_rad));
CamberStiffness_LCO = zeros(length(fz_lbs), length(sa_rad));

% Colors for plotting
colors1 = {'g', '#008080', 'b'};
colors2 = {'y', '#FF8000', 'r'};

%% Plot Figure 1: Cornering Stiffness of 1st Tire under Different Normal Loads

figure(1)

for i = 1: length(fz_lbs)
    
    for j = 1: length(sa_rad)

        [FX11, FY11] = magicformula(tire1.mfparams, 0, sa_rad(j), fz_N(i), IP_pa, IA_rad(1));
        [FX12, FY12] = magicformula(tire1.mfparams, 0, sa_rad(j), fz_N(i), IP_pa, IA_rad(2));
        FY_R20(i, j) = -(FY12 - FY11)/4.448;

        CamberStiffness_R20(i, j) = FY_R20(i, j)/(IA_deg(2) - IA_deg(1));

    end

    plot(sa_deg, CamberStiffness_R20(i, :), ...
        Color=char(colors1(i)), LineWidth=2);
    hold on

end

grid on
xlabel('Slip Angle [deg]');
ylabel('Camber Stiffness [lbf/deg]');
title('Hoosier 43075 R20 16"x7.5"', ...
    sprintf(['Camber Stiffness at IP = %d psi, ' ...
    'IA evaluated at %d' char(176) ' and %d' char(176)], ...
    IP_psi, IA_deg(1), IA_deg(2)));
legend('FZ = 50 lbf', 'FZ = 150 lbf', 'FZ = 250 lbf', 'Location', 'northeast');
hold off

%% Plot Figure 2: Cornering Stiffness of 2nd Tire under Different Normal Loads

figure(2)

for i = 1: length(fz_lbs)
    
    for j = 1: length(sa_rad)

        [FX21, FY21] = magicformula(tire2.mfparams, 0, sa_rad(j), fz_N(i), IP_pa, IA_rad(1));
        [FX22, FY22] = magicformula(tire2.mfparams, 0, sa_rad(j), fz_N(i), IP_pa, IA_rad(2));
        FY_LCO(i, j) = -(FY22 - FY21)/4.448;

        CamberStiffness_LCO(i, j) = FY_LCO(i, j)/(IA_deg(2) - IA_deg(1));

    end

    plot(sa_deg, CamberStiffness_LCO(i, :), ...
        Color=char(colors2(i)), LineWidth=2);
    hold on

end

grid on
xlabel('Slip Angle [deg]');
ylabel('Camber Stiffness [lbf/deg]');
title('Hoosier 43075 LCO 16"x7.5"', ...
    sprintf(['Camber Stiffness at IP = %d psi, ' ...
    'IA evaluated at %d' char(176) ' and %d' char(176)], ...
    IP_psi, IA_deg(1), IA_deg(2)));
legend('FZ = 50 lbf', 'FZ = 150 lbf', 'FZ = 250 lbf', 'Location', 'northeast');
hold off

%% Plot Figure 3: Cornering Stiffness Comparison

figure(3)

for i = 1: length(fz_lbs)

    subplot(2, 2, i);
    
    for j = 1: length(sa_rad)

        [FX11, FY11] = magicformula(tire1.mfparams, 0, sa_rad(j), fz_N(i), IP_pa, IA_rad(1));
        [FX12, FY12] = magicformula(tire1.mfparams, 0, sa_rad(j), fz_N(i), IP_pa, IA_rad(2));
        FY_R20(i, j) = -(FY12 - FY11)/4.448;

        [FX21, FY21] = magicformula(tire2.mfparams, 0, sa_rad(j), fz_N(i), IP_pa, IA_rad(1));
        [FX22, FY22] = magicformula(tire2.mfparams, 0, sa_rad(j), fz_N(i), IP_pa, IA_rad(2));
        FY_LCO(i, j) = -(FY22 - FY21)/4.448;

    end

    plot(sa_deg, FY_R20(i, :)/(IA_deg(2) - IA_deg(1)), 'b', LineWidth=2);
    hold on
    grid on
    plot(sa_deg, FY_LCO(i, :)/(IA_deg(2) - IA_deg(1)), 'r', LineWidth=2); 
    xlabel('Slip Angle [deg]');
    ylabel('Camber Stiffness [lbf/deg]');
    title(sprintf('FZ = %d lbf', fz_lbs(i)));
    legend('R20', 'LCO', 'Location', 'northeast');
    hold off
 
end

sgtitle(sprintf(['Camber Stiffness Comparison\n', ...
    'IP = %d psi, IA evaluated at %d' char(176) ' and %d' char(176)], ...
    IP_psi, IA_deg(1), IA_deg(2)));