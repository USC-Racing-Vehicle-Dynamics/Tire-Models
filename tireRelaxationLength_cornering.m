%% Title: Tire Relaxation Length Comparison (v2)

% 1st tire model: Hoosier 43075 R20 16"x7.5"
% 2nd tire model: Hoosier 43075 LCO 16"x7.5"

% x-axis: Elapased Time, ET
% y-axis: Lateral Force, FY

%% Clear

clear, clc, close all;

%% Unit Conversion

in2cm = 2.54;
N2lbf = 0.224809;
kph2fts = 0.911344;

%% Setup

% Load 1st tire model
tire1 = load("Raw Data/RawData_Cornering_Matlab_SI_Round9_Runs_1to15/B2356raw2.mat");
tire2 = load("Raw Data/RawData_Cornering_Matlab_SI_10inch_Round8/B1965raw17.mat");

tire1_ET = tire1.ET;                                                        % Elapsed time [s]
tire1_SA = tire1.SA;                                                        % Slip angle [deg]
tire1_FY = tire1.FY*N2lbf;                                                  % Lateral force [lbf]

tire2_ET = tire2.ET;                                                        % Elapsed time [s]
tire2_SA = tire2.SA;                                                        % Slip angle [deg]
tire2_FY = tire2.FY*N2lbf;                                                  % Lateral force [lbf]

% Road Speed [in/s]
V = 24*kph2fts;

%% Vector Spaces

tire1_ET_space = cell(9, 3);                                                % Record ET under specific test condition
tire1_FY_space = cell(9, 3);                                                % Record FY under specific test condition
tire1_fit_space = cell(9, 3);                                               % Record the fitted parameters under specific test condition
tire1_RL_ypos = zeros(9, 3);                                                % Record the y-positon of the point at T = 1 (at relaxation length) under specific test condition
tire1_RL_value = zeros(9, 3);                                               % Record the relaxation under specific test condition

tire2_ET_space = cell(9, 3);                                                     
tire2_FY_space = cell(9, 3);                                                     
tire2_fit_space = cell(9, 3);                                               
tire2_RL_ypos = zeros(9, 3);                                                
tire2_RL_value = zeros(9, 3); 

% Lower and upper bounds of time under each testing condition 
% 1st tire model
tire1_ET_lwrbnd = [174.3 196.3 218.3;
                   240.3 262.3 284.3;
                   306.3 328.3 350.3;
                   389.3 411.3 433.3;
                   455.3 477.3 499.3;
                   521.3 543.3 565.3;
                   604.3 626.3 648.3;
                   670.3 692.3 714.3;
                   736.3 758.3 780.3];

tire1_ET_uprbnd = [176.3 201.2 223.4;
                   245.2 267.3 289.4;
                   311.4 333.3 355.1;
                   394.0 416.5 438.5;
                   460.2 482.3 504.3;
                   525.8 548.1 570.3;
                   609.3 631.6 653.5;
                   675.1 697.3 719.4;
                   741.5 763.3 785.3];

% 2nd tire model
tire2_ET_lwrbnd = [174.3 196.3 218.3;
                   240.3 262.3 284.3;
                   306.3 328.3 350.3;
                   389.3 411.3 433.3;
                   455.3 477.3 499.3;
                   521.3 543.3 565.3;
                   604.3 626.3 648.3;
                   670.3 692.3 714.3;
                   736.3 758.3 780.3];

tire2_ET_uprbnd = [179.5 201.3 223.4;
                   245.2 267.3 289.3;
                   311.4 333.3 355.1;
                   394.3 416.6 438.5;
                   460.3 482.3 504.3;
                   525.8 548.3 570.3;
                   609.4 631.7 653.5;
                   675.0 697.3 719.3;
                   741.5 763.0 785.1];

% Testing conditons
% 1) Inflation pressure [psi]
IP = [12 12 12;
      12 12 12;
      12 12 12;
      10 10 10;
      10 10 10;
      10 10 10;
      14 14 14;
      14 14 14;
      14 14 14];

% 2) Slip angle [deg]
SA = [-1 -1 -1;
       1  1  1;
       6  6  6;
      -1 -1 -1;
       1  1  1;
       6  6  6;
      -1 -1 -1;
       1  1  1;
       6  6  6];

% 3) Normal load [lbf]
FZ = [50 150 250;
      50 150 250;
      50 150 250;
      50 150 250;
      50 150 250;
      50 150 250;
      50 150 250;
      50 150 250;
      50 150 250];

%% Data Fitter

% Define fit type: First-order system response
% Constain time constant (T) to greater than 0
% Constain time delay (t_s) to greater than 0
% Constain time (t) to greater than 0
% When slip angle < 0, constain steady state FY (M) to greater than 0,
% when slip angle > 0, constain steady state FY (M) to less than 0,
ftype = fittype('M*(1-exp(-(t-t_s)/T))', 'indep', 't');
fo1 = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [1 1e-2 1e-2], 'Lower', [0 0 0]);
fo2 = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [-1 1e-2 1e-2], 'Lower', [-inf 0 0]);

%% Loop

for i = 1: size(tire1_ET_space, 1)

    for j = 1: size(tire1_ET_space, 2)

        % Extract FY vs. ET under specific testing condition, and store
        % them separately
        tire1_ET_space{i, j} = tire1_ET(tire1_ET >= tire1_ET_lwrbnd(i, j) & tire1_ET <= tire1_ET_uprbnd(i, j)) - tire1_ET_lwrbnd(i, j);
        tire1_FY_space{i, j} = tire1_FY(tire1_ET >= tire1_ET_lwrbnd(i, j) & tire1_ET <= tire1_ET_uprbnd(i, j));

        tire2_ET_space{i, j} = tire2_ET(tire2_ET >= tire2_ET_lwrbnd(i, j) & tire2_ET <= tire2_ET_uprbnd(i, j)) - tire2_ET_lwrbnd(i, j);
        tire2_FY_space{i, j} = tire2_FY(tire2_ET >= tire2_ET_lwrbnd(i, j) & tire2_ET <= tire2_ET_uprbnd(i, j));

        % Decide fit modes based on slip angle
        % Slip angle < 0
        if SA(i, j) == -1

            fo = fo1;

        % Slip angle > 0
        else

            fo = fo2;

        end

        % Fit data by first-order system response
        tire1_fit_space{i, j} = fit(tire1_ET_space{i, j}, tire1_FY_space{i, j}, ftype, fo);
        % Calculate the y-position (FY) at relaxation length
        tire1_RL_ypos(i, j) = tire1_fit_space{i, j}.M*(1-exp(-(tire1_fit_space{i, j}.T-tire1_fit_space{i, j}.t_s)/tire1_fit_space{i, j}.T));
        % Calculate relaxation length
        tire1_RL_value(i, j) = tire1_fit_space{i, j}.T*V;

        tire2_fit_space{i, j} = fit(tire2_ET_space{i, j}, tire2_FY_space{i, j}, ftype, fo);
        tire2_RL_ypos(i, j) = tire2_fit_space{i, j}.M*(1-exp(-(tire2_fit_space{i, j}.T-tire2_fit_space{i, j}.t_s)/tire2_fit_space{i, j}.T));
        tire2_RL_value(i, j) = tire2_fit_space{i, j}.T*V;

    end

end

%% Plot

% % All plots, split by each testing condition
% for i = 1: size(tire1_ET_space, 1)
% 
%     for j = 1: size(tire1_ET_space, 2)
% 
%         % Start a new figure when testing condition changes
%         figure
% 
%         % 1st tire model
%         % Raw and fitted data
%         p1 = plot(tire1_fit_space{i, j}, tire1_ET_space{i, j}, tire1_FY_space{i, j});
%         hold on
%         grid on
%         set(p1(1), Color='#00AAFF', Marker='o');
%         set(p1(2), Color='b', LineWidth=2);
%         % Mark the point reaching relaxation length
%         plot(tire1_fit_space{i, j}.T, tire1_RL_ypos(i, j), '.k', Markersize=20);
%         % Type relaxation length
%         text(1.5, 0.075*tire1_fit_space{i, j}.M, sprintf('R20 Relaxation Length = %.3f in', tire1_RL_value(i, j)));
% 
%         % 2nd tire model
%         p2 = plot(tire2_fit_space{i, j}, tire2_ET_space{i, j}, tire2_FY_space{i, j});
%         set(p2(1), Color='#FFAA00', Marker='o');
%         set(p2(2), Color='r', LineWidth=2);
%         plot(tire2_fit_space{i, j}.T, tire2_RL_ypos(i, j), '.k', Markersize=20);
%         text(1.5, 0.15*tire1_fit_space{i, j}.M, sprintf('LCO Relaxation Length = %.3f in', tire2_RL_value(i, j)));
%         hold off
% 
%         % Set axis limits and legend positions based on slip angle
%         % Slip angle < 0
%         if SA(i, j) == -1
% 
%             xlim([0 inf]);
%             ylim([0 inf]);
%             legend_location = 'southeast';
% 
%         % Slip angle > 0
%         else
% 
%             xlim([0 inf]);
%             ylim([-inf 0]);
%             legend_location = 'northeast';
% 
%         end
% 
%         xlabel('Elapsed Time [s]');
%         ylabel('Lateral Force [lbf]');
%         title('Tire Relaxation Length', ...
%             sprintf('IP = %d psi, SA = %d deg, FZ = %d lbf', ...
%             IP(i, j), SA(i, j), FZ(i, j)));
%         legend('R20', 'R20 Fitted', '', ...
%             'LCO', 'LCO Fitted', 'Location', legend_location);
% 
%     end
% 
% end

%-------------------------------------------------------------------------

% % Plot relaxation length with respect to FY and SA
% figure
% 
% Color_space = {'#FF8000', '#0080FF', '#00FF80'};
% Legend = cell(1, 27);
% 
% for i = 1: size(tire1_ET_space, 1)
% 
%     for j = 1: size(tire1_ET_space, 2)
% 
%     switch IP(i, j)
% 
%         case(10) 
%             Color = Color_space(1);
%         case(12) 
%             Color = Color_space(2);
%         case(14) 
%             Color = Color_space(3);
% 
%     end
% 
%         plot3(SA(i, j), FZ(i, j), tire1_RL_value(i, j), '.', Color=char(Color), MarkerSize=25);
%         hold on
% 
%         if rem(i, 3) == 0 && rem(j, 3) == 0
% 
%             Legend{3*(i-1) + j} = sprintf('%d psi', IP(i, j));
% 
%         else
% 
%             Legend{3*(i-1) + j} = '';
% 
%         end
% 
%     end
% 
% end
% 
% grid on
% xlabel('Slip Angle [deg]');
% ylabel('Normal Load, FZ [lbf]');
% zlabel('Relaxation Length [in]');
% legend(Legend);

%-------------------------------------------------------------------------

% Plots under 12 psi, split by each testing condition

Tire1Colors = {'#00FFFF', '#00AAAA', 'b'};
Tire2Colors = {'#FF00FF', '#FFAA00', 'r'};
Xlimits = [4, 2];

for i = 1: 3

    for j = size(tire1_ET_space, 2): -1: 1

        % Start a new figure when slip angle changes
        if j == size(tire1_ET_space, 2)

            figure

        end

        % 1st tire model
        % Raw and fitted data
        p1 = plot(tire1_fit_space{i, j});%, tire1_ET_space{i, j}, tire1_FY_space{i, j});
        hold on
        grid on
        set(p1, Color=char(Tire1Colors(j)), LineWidth=2);

        % 2nd tire model
        p2 = plot(tire2_fit_space{i, j});%, tire2_ET_space{i, j}, tire2_FY_space{i, j});
        set(p2, Color=char(Tire2Colors(j)), LineWidth=2);

        % Set axis limits and legend positions based on slip angle
        % Slip angle = -1
        if SA(i, j) == -1

            xlim([0 4]);
            ylim([0 inf]);

        % Slip angle = 1
        elseif SA(i, j) == 1

            xlim([0 4]);
            ylim([-inf 0]);

        % Slip angle = 6
        else

            xlim([0 2]);
            ylim([-inf 0]);

        end

    end

    xlabel('Elapsed Time [s]');
    ylabel('Lateral Force [lbf]');
    title('Tire Relaxation Length', ...
        sprintf('IP = %d psi, SA = %d deg', ...
        IP(i, j), SA(i, j)));

    for k = size(tire1_ET_space, 2): -1: 1

        % Mark the point reaching relaxation length
        % Plot later so they would be on upper layers
        plot(tire1_fit_space{i, k}.T, tire1_RL_ypos(i, k), ...
            'o', Markersize=6, MarkerFaceColor='k', MarkerEdgeColor='w');
        hold on

        plot(tire2_fit_space{i, k}.T, tire2_RL_ypos(i, k), ...
            'o', Markersize=6, MarkerFaceColor='k', MarkerEdgeColor='w');

    end

    legend('R20, 250 lbf', 'LCO, 250 lbf', ...
    'R20, 150 lbf', 'LCO, 150 lbf', ...
    'R20, 50 lbf', 'LCO, 50 lbf', ...
    'Location', 'southoutside', 'NumColumns', 3);

end