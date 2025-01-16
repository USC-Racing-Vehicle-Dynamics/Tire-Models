%% Title: Comparing Multiple Tire Models by Cornering Stiffness

% 1st tire model: Hoosier 43075 R20 16"x7.5"
% 2nd tire model: Hoosier 43075 LCO 16"x7.5"

% X-axis: Slip Angle, SA
% Y-axis: Cornering Stiffness, C (Fitted)

% Notes: 1) Normal load (FZ) varied
%        2) Inflation pressure (IP) & inclination angle (IA) set to be constant
%        3) Tire performing at optimum temperature

%% Clear

clear, clc, close all;

%% Setup

% Pressure
IP_psi = 11; % from +8 to +14
IP_pa = IP_psi*6894.76;

% Inclination angle
IA_deg = 2; % from 0 to +4
IA_rad = deg2rad(IA_deg);

% Normal load
fz_lbs_space = [50, 100, 150, 200, 250]; % positive is down(-z)
fz_N_space = fz_lbs_space*4.448;
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
fy1 = zeros(length(sa_rad), 1);
fy2 = zeros(length(sa_rad), 1);

% Lateral Tire Force at 0 slip angle
fy1_0 = zeros(length(fz_lbs_space), 1);
fy2_0 = zeros(length(fz_lbs_space), 1);

% Cornering Stiffness, C
C_R20 = zeros(length(fz_lbs_space), length(sa_rad) - 1);
C_LCO = zeros(length(fz_lbs_space), length(sa_rad) - 1);

% Colors for plotting
colors1 = {'b', '#0033CC', '#006699', '#009966', '#00CC33', 'g'};
colors2 = {'r', '#FF3300', '#FF6600', '#FF9900', '#FFCC00', 'y'};

%% Figure 1: Cornering Stiffness of 1st Tire under Different Normal Loads

for i = 1: length(fz_lbs_space)
    
    for j = 1: length(sa_rad)

        [FX1, FY1] = magicformula(tire1.mfparams, 0, sa_rad(j), fz_N_space(i), IP_pa, IA_rad);
        fy1(j) = FY1/4.448;

    end
    
    % Calculate cornering stiffness
    for k = 1: length(sa_rad) - 1

        C_R20(i, k) = (fy1(k+1) - fy1(k))/(sa_rad(k+1) - sa_rad(k));

    end

    figure(1);
    plot(sa_deg(1: length(sa_deg)-1), C_R20(i, :), Color=char(colors1(i)), LineWidth = 1);
    hold on

end

grid on
xlabel('Slip Angle [deg]');
ylabel('C [lbf/rad]');
title('Hoosier 43075 R20 16"x7.5"', ...
    sprintf(['Cornering Stiffness at IP = %d psi, IA = %d' char(176)], ...
    IP_psi, IA_deg));
legend('FZ = 50 lbf', 'FZ = 100 lbf', 'FZ = 150 lbf', 'FZ = 200 lbf', ...
    'FZ = 250 lbf', 'Location', 'southeast');
hold off

%% Figure 2: Cornering Stiffness of 2nd Tire under Different Normal Loads

for i = 1: length(fz_lbs_space)

    for j = 1: length(sa_rad)

        [FX2, FY2] = magicformula(tire2.mfparams, 0, sa_rad(j), fz_N_space(i), IP_pa, IA_rad);
        fy2(j) = FY2/4.448;

    end
    
    % Calculate cornering stiffness
    for k = 1: length(sa_rad) - 1

        C_LCO(i, k) = (fy2(k+1) - fy2(k))/(sa_rad(k+1) - sa_rad(k));

    end

    figure(2);
    plot(sa_deg(1: length(sa_deg)-1), C_LCO(i, :), Color=char(colors2(i)), LineWidth = 1);
    hold on

end

grid on
xlabel('Slip Angle [deg]');
ylabel('C [lbf/rad]');
title('Hoosier 43075 LCO 16"x7.5"', ...
    sprintf(['Cornering Stiffness at IP = %d psi, IA = %d' char(176)], ...
    IP_psi, IA_deg));
legend('FZ = 50 lbf', 'FZ = 100 lbf', 'FZ = 150 lbf', 'FZ = 200 lbf', ...
    'FZ = 250 lbf', 'Location', 'southeast');
hold off

%% Plot Figure 3: Cornering Stiffness Comparison

figure(3);
tiledlayout(3, 2);

for i = 1: length(fz_lbs_space)

    nexttile,
    plot(sa_deg(1: length(sa_deg)-1), C_R20(i, :), 'b');
    hold on;
    grid on;
    plot(sa_deg(1: length(sa_deg)-1), C_LCO(i, :), 'r');     
    xlabel('Slip Angle [deg]');
    ylabel('C [lbf/rad]');
    title(sprintf('FZ = %d lbf', fz_lbs_space(i)));
    legend('R20', 'LCO', 'Location', 'southeast');

end

sgtitle(sprintf(['Cornering Stiffness Comparison\n' ...
    'IP = %d psi, IA = %d' char(176)], IP_psi, IA_deg));

% figure(3)
% 
% for i = 1: length(fz_lbs_space)
% 
%     subplot(3, 2, i);
% 
%     % For 1st tire model, find FY at no slip 
%     % Use it as a basis point for calculating the slope of FY/SA
%     [FX1_0, FY1_0] = magicformula(tire1.mfparams, 0, 0, fz_N_space(i), IP_pa, IA_rad);
%     fy1_0(i) = FY1_0/4.448;
% 
%     for j = 1: length(sa_rad)
% 
%         [FX1, FY1] = magicformula(tire1.mfparams, 0, sa_rad(j), fz_N_space(i), IP_pa, IA_rad);
%         fy1(j) = FY1/4.448;
% 
%     end
% 
%     % Calculate cornering stiffness
%     for jj = 1: length(sa_rad) - 1
% 
%         C_R20(jj) = (fy1(jj+1) - fy1(jj))/(sa_rad(jj+1) - sa_rad(jj));
% 
%     end
% 
%     % Repeat previous steps for 2nd tire model
%     [FX2_0, FY2_0] = magicformula(tire2.mfparams, 0, 0, fz_N_space(i), IP_pa, IA_rad);
%     fy2_0(i) = FY2_0/4.448;
% 
%     for k = 1: length(sa_rad)
% 
%         [FX2, FY2] = magicformula(tire2.mfparams, 0, sa_rad(k), fz_N_space(i), IP_pa, IA_rad);
%         fy2(k) = FY2/4.448;
% 
%     end
% 
%     % Calculate cornering stiffness
%     for kk = 1: length(sa_rad) - 1
% 
%         C_LCO(kk) = (fy2(kk+1) - fy2(kk))/(sa_rad(kk+1) - sa_rad(kk));
% 
%     end
% 
%     plot(sa_deg(1: length(sa_deg)-1), C_R20, 'b', LineWidth = 1);
%     hold on
%     grid on
%     plot(sa_deg(1: length(sa_deg)-1), C_LCO, 'r', LineWidth = 1);   
%     xlabel('Slip Angle [deg]');
%     ylabel('C [lbf/rad]');
%     title(sprintf('FZ = %d lbf', fz_lbs_space(i)));
%     legend('R20', 'LCO', 'Location', 'southeast');
%     hold off
% 
% end
% 
% sgtitle(sprintf(['Cornering Stiffness Comparison\n' ...
%     'IP = %d psi, IA = %d' char(176)], IP_psi, IA_deg));