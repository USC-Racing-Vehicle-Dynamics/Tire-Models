%% Tire Friction Ellipse (Curve Fit)

% USC Racing 2024 - Tianpai Le

% This script plots one set of tire friction ellipse data, picks the outer
% perimeter of data points, and fits them with a closed curve

%% Clear

clear, clc, close all;

%% Setup

% Unit conversion
N2lbf = 0.224809;

% Slip ratio
SX = -1: 0.01: 1;

% Slip angle
SA_deg = horzcat(linspace(-13, -2.5, 20), linspace(2.5, 13, 20));
SA_rad = deg2rad(SA_deg);

% Normal load
FZ_lbs = 50; % positive is down(-z) [lbf]
FZ_N = FZ_lbs./N2lbf;

% Internal pressure
IP_psi = 11; % from +8 to +14
IP_pa = IP_psi*6894.76;

% Inclination angle (camber)
IA_deg = 0;
IA_rad = deg2rad(IA_deg);

% Tire model
tire = load("Fitted Data/43100_R20_18x6_FX0FY0.mat");

%% Vector Spaces

slip_ratio = zeros(length(SX), length(SA_rad));
slip_angle = zeros(length(SX), length(SA_rad));

fx = zeros(length(SX), length(SA_rad));
fy = zeros(length(SX), length(SA_rad));

r = zeros(length(SX), length(SA_rad));
theta = zeros(length(SX), length(SA_rad));

%% Plot Friction Ellipse

figure(1); hold on; grid on;

% Loop to solve FY
for i = 1: length(SX)
for j = 1: length(SA_rad)

    slip_ratio(i, j) = SX(i);
    slip_angle(i, j) = SA_deg(j);

    [FX, FY] = magicformula(tire.mfparams, SX(i), SA_rad(j), FZ_N, IP_pa, IA_rad);
    fx(i, j) = FX*N2lbf;
    fy(i, j) = -FY*N2lbf;

    r(i, j) = sqrt((fx(i, j))^2 + (fy(i, j))^2);

    if fy(i, j) >= 0 && fx(i, j) >= 0
        theta(i, j) = atan(fx(i, j)/fy(i, j));
    elseif fy(i, j) < 0 && fx(i, j) >= 0
        theta(i, j) = atan(fx(i, j)/fy(i, j)) + pi;
    elseif fy(i, j) < 0 && fx(i, j) < 0
        theta(i, j) = atan(fx(i, j)/fy(i, j)) + pi;
    else
        theta(i, j) = atan(fx(i, j)/fy(i, j)) + 2*pi;
    end

end

p = plot(fy(i, :), fx(i, :), '.r');
dt = p.DataTipTemplate;
dt.DataTipRows(1) = dataTipTextRow('FY', fy(i, :));
dt.DataTipRows(2) = dataTipTextRow('FX', fx(i, :));
dt.DataTipRows(3) = dataTipTextRow('Slip Ratio', slip_ratio(i, :));
dt.DataTipRows(4) = dataTipTextRow('Slip Angle', slip_angle(i, :));

end

xlabel('FY (lb)'); ylabel('FX (lb)'); title('Tire Friction Ellipse, Raw Data');

%% Data Filtering

sections = 120 + 1;
section_angle = linspace(0, 2*pi, sections);

rmax = zeros(sections, 1);
fy_data = ones(sections, 1) * nan;
fx_data = ones(sections, 1) * nan;

for a = 1: length(section_angle)

    for i1 = 1: length(SX)
    for j1 = 1: length(SA_rad)

        section_index = floor(theta(i1, j1) / (2*pi/(sections - 1))) + 1;

        if r(i1, j1) >= rmax(section_index)
            fy_data(section_index) = fy(i1, j1);
            fx_data(section_index) = fx(i1, j1);
            rmax(section_index) = r(i1, j1);
        end

    end
    end

end

%% Curve Fitting

fy_clipped = fy_data(~isnan(fy_data));
fx_clipped = fx_data(~isnan(fx_data));

fy_final = [fy_clipped; fy_clipped(1)];
fx_final = [fx_clipped; fx_clipped(1)];

% Fit with smoothing spline
smooth_param = 0.8;
ft_fy = fit((1:length(fy_final))', fy_final, 'smoothingspline', 'SmoothingParam', smooth_param);
ft_fx = fit((1:length(fx_final))', fx_final, 'smoothingspline', 'SmoothingParam', smooth_param);

% Evaluate on a finer grid
tFine = linspace(1, length(fy_final), 1000);
fy_fit = feval(ft_fy, tFine);
fx_fit = feval(ft_fx, tFine);

figure(2); hold on; grid on;
plot(fy_final, fx_final, 'ob', fy_fit, fx_fit, '-r');
xlabel('FY (lb)'); ylabel('FX (lb)');
legend('Filtered Data', 'Fitted Curve'); title('Tire Friction Ellipse, Processed Data');


