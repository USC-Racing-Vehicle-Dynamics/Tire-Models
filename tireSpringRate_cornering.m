%% Title: Tire Spring Rate Comparison (Pressure Sensitivity)

% 1st tire model: Hoosier 43075 R20 16"x7.5"
% 2nd tire model: Hoosier 43075 LCO 16"x7.5"
% 3rd tire model: Hoosier 43100 R20 18"x6"

% x-axis: Loaded Tire Radius, RL
% y-axis: Normal Force, FZ (TTC raw data)
% Additional Ouput: Fit FZ vs. RL by line and display the slope

% Notes: Plot under different inflation
% pressures

%% Clear

clear, clc, close all;

%% Unit Conversion

in2cm = 2.54;
N2lbf = 0.224809;

%% Setup

% Load 1st tire model
R20run4 = load("Raw Data/RawData_Cornering_Matlab_SI_Round9_Runs_1to15/B2356raw4.mat");
R20run5 = load("Raw Data/RawData_Cornering_Matlab_SI_Round9_Runs_1to15/B2356raw5.mat");
R20run6 = load("Raw Data/RawData_Cornering_Matlab_SI_Round9_Runs_1to15/B2356raw6.mat");

R20run4_ET = R20run4.ET;                                                    % Elapsed time [s]
R20run4_FZ = R20run4.FZ*N2lbf;                                              % Normal load [lbf]
R20run4_RL = R20run4.RL/in2cm;                                              % Loaded tire radius [in]

R20run5_ET = R20run5.ET;                                                    % Elapsed time [s]
R20run5_FZ = R20run5.FZ*N2lbf;                                              % Normal load [lbf]
R20run5_RL = R20run5.RL/in2cm;                                              % Loaded tire radius [in]

R20run6_ET = R20run6.ET;                                                    % Elapsed time [s]
R20run6_FZ = R20run6.FZ*N2lbf;                                              % Normal load [lbf]
R20run6_RL = R20run6.RL/in2cm;                                              % Loaded tire radius [in]

% Load 2nd tire model
LCOrun18 = load("Raw Data/RawData_Cornering_Matlab_SI_10inch_Round8/B1965raw18.mat");
LCOrun19 = load("Raw Data/RawData_Cornering_Matlab_SI_10inch_Round8/B1965raw19.mat");

LCOrun18_ET = LCOrun18.ET;                                                  % Elapsed time [s]
LCOrun18_FZ = LCOrun18.FZ*N2lbf;                                            % Normal load [lbf]
LCOrun18_RL = LCOrun18.RL/in2cm;                                            % Loaded tire radius [in]

LCOrun19_ET = LCOrun19.ET;                                                  % Elapsed time [s]
LCOrun19_FZ = LCOrun19.FZ*N2lbf;                                            % Normal load [lbf]
LCOrun19_RL = LCOrun19.RL/in2cm;                                            % Loaded tire radius [in]

% Load 3rd tire model
R20run31 = load("Raw Data/RawData_Cornering_Matlab_SI_Round9_Runs_16to49/B2356raw31.mat");
R20run32 = load("Raw Data/RawData_Cornering_Matlab_SI_Round9_Runs_16to49/B2356raw32.mat");

R20run31_ET = R20run31.ET;                                                  % Elapsed time [s]
R20run31_FZ = R20run31.FZ*N2lbf;                                            % Normal load [lbf]
R20run31_RL = R20run31.RL/in2cm;                                            % Loaded tire radius [in]

R20run32_ET = R20run32.ET;                                                  % Elapsed time [s]
R20run32_FZ = R20run32.FZ*N2lbf;                                            % Normal load [lbf]
R20run32_RL = R20run32.RL/in2cm;                                            % Loaded tire radius [in]

%% Vector Spaces

% 1st tire model
tire1_ET_space = cell(3, 6);                                                % Record ET under specific test condition
tire1_FZ_space = cell(3, 6);                                                % Record FZ under specific test condition
tire1_RL_space = cell(3, 6);                                                % Record RL under specific test condition
tire1_FZ_combinedSpace = cell(3, 4);                                        % FZ space after combining data under 12 psi
tire1_RL_combinedSpace = cell(3, 4);                                        % RL space after combining data under 12 psi
tire1_fittedFZ_space = cell(3, 4);                                          % Record fitted FZ under specific test condition

% 2nd tire model
tire2_ET_space = cell(3, 6);                                               
tire2_FZ_space = cell(3, 6);                                                
tire2_RL_space = cell(3, 6);  
tire2_FZ_combinedSpace = cell(3, 4);
tire2_RL_combinedSpace = cell(3, 4); 
tire2_fittedFZ_space = cell(3, 4);

% 3rd tire model
tire3_ET_space = cell(3, 6);                                               
tire3_FZ_space = cell(3, 6);                                                
tire3_RL_space = cell(3, 6);  
tire3_FZ_combinedSpace = cell(3, 4);
tire3_RL_combinedSpace = cell(3, 4); 
tire3_fittedFZ_space = cell(3, 4);  

% Run numbers for each tire model
tire1_runNumber = [6 5 4 4 6 5];
tire2_runNumber = [19 18 18 18 19 18];
tire3_runNumber = [32 31 31 31 32 31];

% Lower and upper bounds of time under each testing condition 
% 1st tire model
tire1_ET_lwrbnd = [636 321 93  806 1249 928;
                   659 344 117 829 1271 951;
                   683 367 140 853 1295 974];

tire1_ET_uprbnd = [657 342 115 827 1270 949;
                   681 365 138 850 1293 972;
                   704 389 162 874 1317 996];

% 2nd tire model
tire2_ET_lwrbnd = [636 1413 94  806 1248 2020;
                   659 1435 116 828 1271 2043;
                   683 1459 140 852 1295 2066];

tire2_ET_uprbnd = [657 1434 115 827 1270 2041;
                   681 1457 138 850 1293 2064;
                   704 1481 162 874 1317 2088];

% 3rd tire model
tire3_ET_lwrbnd = [637 1413 93  806 1249 2020;
                   659 1436 117 829 1271 2043;
                   683 1460 140 853 1295 2067];

tire3_ET_uprbnd = [657 1434 115 827 1270 2041;
                   681 1458 138 851 1293 2065;
                   705 1481 162 874 1317 2088];

% Testing conditons
% 1) Inflation pressure [psi]
IP = [8 10 12 12 12 14;
      8 10 12 12 12 14;
      8 10 12 12 12 14];

IP_combined = [8 10 12 14];

% 2) Inclination angle [deg]
IA = [0 0 0 0 0 0;
      2 2 2 2 2 2;
      4 4 4 4 4 4];

% Colors for plotting
tire1_colors = {'b', '#0055AA', '#00AA55', 'g'};
tire2_colors = {'r', '#FF5500', '#FFAA00', 'y'};
tire3_colors = {'b', '#5500FF', '#AA00FF', '#FF00FF'};

%% Data Acquisition

for i = 1: size(tire1_ET_space, 1)

    for j = 1: size(tire1_ET_space, 2)

        % Extract FZ vs. RL under specific testing condition, and store
        % them separately
        % 1st tire model
        switch(tire1_runNumber(j))

            case(4)
                tire1_FZ_space{i, j} = R20run4_FZ(R20run4_ET >= tire1_ET_lwrbnd(i, j) & R20run4_ET <= tire1_ET_uprbnd(i, j));
                tire1_RL_space{i, j} = R20run4_RL(R20run4_ET >= tire1_ET_lwrbnd(i, j) & R20run4_ET <= tire1_ET_uprbnd(i, j));
            
            case(5)
                tire1_FZ_space{i, j} = R20run5_FZ(R20run5_ET >= tire1_ET_lwrbnd(i, j) & R20run5_ET <= tire1_ET_uprbnd(i, j));
                tire1_RL_space{i, j} = R20run5_RL(R20run5_ET >= tire1_ET_lwrbnd(i, j) & R20run5_ET <= tire1_ET_uprbnd(i, j));
               
            case(6)
                tire1_FZ_space{i, j} = R20run6_FZ(R20run6_ET >= tire1_ET_lwrbnd(i, j) & R20run6_ET <= tire1_ET_uprbnd(i, j));
                tire1_RL_space{i, j} = R20run6_RL(R20run6_ET >= tire1_ET_lwrbnd(i, j) & R20run6_ET <= tire1_ET_uprbnd(i, j));

        end

        % 2nd tire model
        switch(tire2_runNumber(j))

            case(18)
                tire2_FZ_space{i, j} = LCOrun18_FZ(LCOrun18_ET >= tire2_ET_lwrbnd(i, j) & LCOrun18_ET <= tire2_ET_uprbnd(i, j));
                tire2_RL_space{i, j} = LCOrun18_RL(LCOrun18_ET >= tire2_ET_lwrbnd(i, j) & LCOrun18_ET <= tire2_ET_uprbnd(i, j));
            
            case(19)
                tire2_FZ_space{i, j} = LCOrun19_FZ(LCOrun19_ET >= tire2_ET_lwrbnd(i, j) & LCOrun19_ET <= tire2_ET_uprbnd(i, j));
                tire2_RL_space{i, j} = LCOrun19_RL(LCOrun19_ET >= tire2_ET_lwrbnd(i, j) & LCOrun19_ET <= tire2_ET_uprbnd(i, j));
              
        end

        % 3rd tire model
        switch(tire3_runNumber(j))

            case(31)
                tire3_FZ_space{i, j} = R20run31_FZ(R20run31_ET >= tire3_ET_lwrbnd(i, j) & R20run31_ET <= tire3_ET_uprbnd(i, j));
                tire3_RL_space{i, j} = R20run31_RL(R20run31_ET >= tire3_ET_lwrbnd(i, j) & R20run31_ET <= tire3_ET_uprbnd(i, j));
            
            case(32)
                tire3_FZ_space{i, j} = R20run32_FZ(R20run32_ET >= tire3_ET_lwrbnd(i, j) & R20run32_ET <= tire3_ET_uprbnd(i, j));
                tire3_RL_space{i, j} = R20run32_RL(R20run32_ET >= tire3_ET_lwrbnd(i, j) & R20run32_ET <= tire3_ET_uprbnd(i, j));
              
        end

        % Combining data under 12 psi and store them into new spaces
        switch(IP(i, j))

            case(8)
                tire1_FZ_combinedSpace{i, 1} = tire1_FZ_space{i, j};
                tire1_RL_combinedSpace{i, 1} = tire1_RL_space{i, j};

                tire2_FZ_combinedSpace{i, 1} = tire2_FZ_space{i, j};
                tire2_RL_combinedSpace{i, 1} = tire2_RL_space{i, j};

                tire3_FZ_combinedSpace{i, 1} = tire3_FZ_space{i, j};
                tire3_RL_combinedSpace{i, 1} = tire3_RL_space{i, j};

            case(10)
                tire1_FZ_combinedSpace{i, 2} = tire1_FZ_space{i, j};
                tire1_RL_combinedSpace{i, 2} = tire1_RL_space{i, j};

                tire2_FZ_combinedSpace{i, 2} = tire2_FZ_space{i, j};
                tire2_RL_combinedSpace{i, 2} = tire2_RL_space{i, j};

                tire3_FZ_combinedSpace{i, 2} = tire3_FZ_space{i, j};
                tire3_RL_combinedSpace{i, 2} = tire3_RL_space{i, j};

            case(12)
                tire1_FZ_combinedSpace{i, 3} = vertcat(tire1_FZ_combinedSpace{i, 3}, tire1_FZ_space{i, j}); 
                tire1_RL_combinedSpace{i, 3} = vertcat(tire1_RL_combinedSpace{i, 3}, tire1_RL_space{i, j}); 

                tire2_FZ_combinedSpace{i, 3} = vertcat(tire2_FZ_combinedSpace{i, 3}, tire2_FZ_space{i, j}); 
                tire2_RL_combinedSpace{i, 3} = vertcat(tire2_RL_combinedSpace{i, 3}, tire2_RL_space{i, j}); 
            
                tire3_FZ_combinedSpace{i, 3} = vertcat(tire3_FZ_combinedSpace{i, 3}, tire3_FZ_space{i, j}); 
                tire3_RL_combinedSpace{i, 3} = vertcat(tire3_RL_combinedSpace{i, 3}, tire3_RL_space{i, j}); 
            
            case(14)
                tire1_FZ_combinedSpace{i, 4} = tire1_FZ_space{i, j};
                tire1_RL_combinedSpace{i, 4} = tire1_RL_space{i, j};

                tire2_FZ_combinedSpace{i, 4} = tire2_FZ_space{i, j};
                tire2_RL_combinedSpace{i, 4} = tire2_RL_space{i, j};

                tire3_FZ_combinedSpace{i, 4} = tire3_FZ_space{i, j};
                tire3_RL_combinedSpace{i, 4} = tire3_RL_space{i, j};

        end

    end

end

%% Data Fitting & Plot

% 1st tire model
for ii = 1: size(tire1_RL_combinedSpace, 1)

    for jj = 1: size(tire1_RL_combinedSpace, 2)

        % Fit data by a line
        tire1_fittedFZ_space{ii, jj} = fit(tire1_RL_combinedSpace{ii, jj}, tire1_FZ_combinedSpace{ii, jj}, 'poly1');

        figure(ii);
        p1 = plot(tire1_fittedFZ_space{ii, jj}, tire1_RL_combinedSpace{ii, jj}, tire1_FZ_combinedSpace{ii, jj});
        hold on
        set(p1(1), Marker='.', Color=tire1_colors{jj}, MarkerSize=5);
        set(p1(2), Color='#EDB120', Linewidth=2);
        text(min(tire1_RL_combinedSpace{ii, 1}), max(tire1_FZ_combinedSpace{ii, 2})-15*(jj-1), ...
            sprintf('IP = %d psi, slope = %.2f', IP_combined(jj), tire1_fittedFZ_space{ii, jj}.p1));

        if jj == size(tire1_RL_combinedSpace, 2)

            grid on
            xlabel('Loaded Radius, RL [in]');
            ylabel('Normal Load, FZ [lbf]');
            title('Hoosier 43075 R20 16"x7.5"', sprintf(['Spring Rate at IA = %d' char(176)], IA(ii, jj)));
            legend('IP = 8 psi', '', 'IP = 10 psi', '', ...
                'IP = 12 psi', '', 'IP = 14 psi', '', Location='southeast');
            hold off

        end

    end

end

% 2nd tire model
for ii = 1: size(tire1_RL_combinedSpace, 1)

    for jj = 1: size(tire1_RL_combinedSpace, 2)

        tire2_fittedFZ_space{ii, jj} = fit(tire2_RL_combinedSpace{ii, jj}, tire2_FZ_combinedSpace{ii, jj}, 'poly1');

        figure(ii + size(tire1_RL_combinedSpace, 1));
        p2 = plot(tire2_fittedFZ_space{ii, jj}, tire2_RL_combinedSpace{ii, jj}, tire2_FZ_combinedSpace{ii, jj});
        hold on
        set(p2(1), Marker='.', Color=tire2_colors{jj}, MarkerSize=5);
        set(p2(2), Color='#EDB120', Linewidth=2);
        text(min(tire2_RL_combinedSpace{ii, 1}), max(tire2_FZ_combinedSpace{ii, 2})-15*(jj-1), ...
            sprintf('IP = %d psi, slope = %.2f', IP_combined(jj), tire2_fittedFZ_space{ii, jj}.p1));

        if jj == size(tire1_RL_combinedSpace, 2)

            grid on
            xlabel('Loaded Radius, RL [in]');
            ylabel('Normal Load, FZ [lbf]');
            title('Hoosier 43075 LCO 16"x7.5"', sprintf(['Spring Rate at IA = %d' char(176)], IA(ii, jj)));
            legend('IP = 8 psi', '', 'IP = 10 psi', '', ...
                'IP = 12 psi', '', 'IP = 14 psi', '', Location='southeast');
            hold off

        end

    end

end

% 3rd tire model
for ii = 1: size(tire1_RL_combinedSpace, 1)

    for jj = 1: size(tire1_RL_combinedSpace, 2)

        tire3_fittedFZ_space{ii, jj} = fit(tire3_RL_combinedSpace{ii, jj}, tire3_FZ_combinedSpace{ii, jj}, 'poly1');

        figure(ii + 2*size(tire1_RL_combinedSpace, 1));
        p2 = plot(tire3_fittedFZ_space{ii, jj}, tire3_RL_combinedSpace{ii, jj}, tire3_FZ_combinedSpace{ii, jj});
        hold on
        set(p2(1), Marker='.', Color=tire3_colors{jj}, MarkerSize=5);
        set(p2(2), Color='#EDB120', Linewidth=2);
        text(min(tire3_RL_combinedSpace{ii, 1}), max(tire3_FZ_combinedSpace{ii, 2})-15*(jj-1), ...
            sprintf('IP = %d psi, slope = %.2f', IP_combined(jj), tire3_fittedFZ_space{ii, jj}.p1));

        if jj == size(tire1_RL_combinedSpace, 2)

            grid on
            xlabel('Loaded Radius, RL [in]');
            ylabel('Normal Load, FZ [lbf]');
            title('Hoosier 43100 R20 18"x6"', sprintf(['Spring Rate at IA = %d' char(176)], IA(ii, jj)));
            legend('IP = 8 psi', '', 'IP = 10 psi', '', ...
                'IP = 12 psi', '', 'IP = 14 psi', '', Location='southeast');
            hold off

        end

    end

end