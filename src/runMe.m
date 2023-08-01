%% Clustering Algorithms, Homework 2
%  Clustering analysis on country data in order to determine which
%  group of countries are in need of financial aid.
%
%  This script makes use of the following provided functions:
%
%     rand_data_init.m
%     k_means.m
%
%  Two further functions, written by the authors, were also used
%  for editting plot variables, namely:
%
%     PlotDimensions.m
%     ChangeInterpreter.m
%

%% Initialisation
clear; close all; clc

%% ================= Part 1: Feeling the data ========================

% Import the CSV file
data = readtable('../dataset/Country-data.csv');

% Extract the labels from the first column
countryNames = data{:, 1};

% Extract the column names and keep only feature labels
featureNames = data.Properties.VariableNames;
featureNames = featureNames(1, 2:end);

% Convert the table-data to an array
data = table2array(data(:, 2:end));

% Determine the dimensions of the data set
[numRows, numCols] = size(data);

% Preallocate cell array for feature type
featureType = cell(1, 9);

% Print a header row for the table
fprintf('%-13s %-9.5s %-30s %-11s %-11s\n', 'Feature',...
    'Type', 'Range', 'Mean', 'Std Dev');
fprintf('%-13s %-8s  %-30s %-11s %-11s\n',...
    '-----------', '--------',...
    '-----------------------------', '-----------', '-----------');

% Create a grid of subplots, with one subplot for each feature
figure(1);
subplot(3, 3, 1:numCols);

for i = 1:numCols
    uniqueVal = unique(data(:, i));
    if isstring(uniqueVal)
        featureType(1, i) = {'categorical'};
    elseif isinteger(uniqueVal)
        featureType(1, i) = {'integer'};
    elseif isfloat(uniqueVal)
        featureType(1, i) = {'float'};
    end
    
    % Determine the range of values, mean, and standard deviation
    % for the current column
    minVal  = min(data(:, i));
    maxVal  = max(data(:, i));
    meanVal = mean(data(:, i));
    stdVal  = std(data(:, i));

    % Print a row for the current column
    fprintf(' %-11s  %-8s  [%12.4f, %12.4f] %12.4f %12.4f\n',...
        featureNames{i}, featureType{i}, minVal, maxVal,...
        meanVal, stdVal);
    
    % Select the subplot for the current feature
    subplot(3, 3, i);
    
    % Extract the data for the current feature
    featureData = data(:, i);
    
    % Create a histogram for the current feature
    histogram(featureData, 'Normalization', 'pdf');
    
    % Allow the distribution plot to be superimposed on the histogram
    hold on;
    x = linspace(min(featureData), max(featureData), 100);
    y = ksdensity(featureData, x);
    plot(x, y, 'LineWidth', 2);
    xlabel(featureNames(i), 'Interpreter', 'none');
    
    % Reset the hold state
    hold off;
end
PlotDimensions(figure(1), 'centimeters', [15.747, 14], 12)
ChangeInterpreter(figure(1), 'latex')

% Plot image in pdf format
h = figure(1);
set(h,'Units','Inches');
pos = get(h,'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches',...
    'PaperSize', [pos(3), pos(4)])
print(h, '..\output\histogram', '-dpdf', '-r0')

% Calculate the Pearson correlation coefficient between
% each pair of features
corrMatrix = corr(data);

% Create a heatmap of the correlation matrix
figure(2);
heatmap(featureNames, featureNames, corrMatrix);
title('Pearson correlation between features')
PlotDimensions(figure(2), 'centimeters', [15.747, 14], 12)
ChangeInterpreter(figure(2), 'latex')

% Plot image in pdf format
h = figure(2);
set(h,'Units','Inches');
pos = get(h,'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches',...
    'PaperSize', [pos(3), pos(4)])
print(h, '..\output\corr1', '-dpdf', '-r0')

% Calculate the mean and standard deviation of each column
meanVals = mean(data, 1);
stdDevs = std(data, 0, 1);

% Perform standard score normalization on each feature
standardizedData = (data - meanVals) ./ stdDevs;

% Calculate the Pearson correlation coefficient between
% each pair of standardised features
standardizedCorrMatrix = corr(standardizedData);

% Create a heatmap of the standardised correlation matrix
figure(3);
heatmap(featureNames, featureNames, standardizedCorrMatrix);
title('Pearson correlation between standardised features')
PlotDimensions(figure(3), 'centimeters', [15.747, 14], 12)
ChangeInterpreter(figure(3), 'latex')

% Plot image in pdf format
h = figure(3);
set(h,'Units','Inches');
pos = get(h,'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches',...
    'PaperSize', [pos(3), pos(4)])
print(h, '..\output\corr2', '-dpdf', '-r0')

% Find the minimum and maximum values in each column of the data
minVals = min(data);
maxVals = max(data);

% Normalize the data using max-min normalization
normalisedData = (data - minVals) ./ (maxVals - minVals);

% Calculate the Pearson correlation coefficient between
% each pair of normalised features
minMaxCorrMatrix = corr(normalisedData);

% Create a heatmap of the min-max correlation matrix
figure(4);
heatmap(featureNames, featureNames, minMaxCorrMatrix);
title('Pearson correlation between normalised features')
PlotDimensions(figure(4), 'centimeters', [15.747, 14], 12)
ChangeInterpreter(figure(4), 'latex')

% Plot image in pdf format
h = figure(4);
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches',...
    'PaperSize', [pos(3), pos(4)])
print(h, '..\output\corr3', '-dpdf', '-r0')

%% ================= Part 2: Feature selection ========================

% Normalize the columns by their mean values
%dataNorm = data ./ mean(data, 1);

% Create the first new feature by adding the normalized
% columns 2 and 4
%trade = dataNorm(:, 2) + dataNorm(:, 4);
trade = data(:, 4);
% Create the second new feature by adding the normalized
% columns 5, 6, and 9
%finance = dataNorm(:, 5) + dataNorm(:, 6) + dataNorm(:, 9);
finance = data(:, 6);
% Create the third new feature by concatenating the remaining columns
%health = dataNorm(:, 1) + dataNorm(:, 3) + dataNorm(:, 7)...
%    + dataNorm(:, 8);
health = data(:, 3);
% Concatenate the new features
newFeatures = [trade finance health];

% Normalise the new features using max-min normalization
dataFinal = (newFeatures - min(newFeatures)) ./...
    (max(newFeatures) - min(newFeatures));


%% ===== Part 3: Selection and execution of clustering algorithms ======

% Transpose dataFinal for input to k_means function
dataFinal = dataFinal';

% Set number of runs and range of values for m
nRuns = 40;
mMin = 2;
mMax = 10;

% Preallocate array to store results
jM = zeros(1, mMax - mMin + 1);

% Loop over values of m
for m = mMin:mMax
    % Initialize temporary minimum value
    jTempMin = inf;
    
    % Loop over number of runs
    for t = 1:nRuns
        % Generate initial theta values using randDataInit function
        thetaIni = rand_data_init(dataFinal, m);
        
        % Run kMeans function and store results
        [theta, bel, j] = k_means(dataFinal, thetaIni);
        
        % Update temporary minimum value if necessary
        if jTempMin > j
            jTempMin = j;
        end
    end
    
    % Append minimum value to jM array
    jM(m - mMin + 1) = jTempMin;
end

% Define m values for plot
m = mMin:mMax;

% Create figure and plot jM versus m
figure(5), plot(m, jM);
xlabel("Number of clusters m");
ylabel("Cost function values J");
ChangeInterpreter(figure(5), 'latex')

% Plot image in pdf format
h = figure(5);
set(h,'Units','Inches');
pos = get(h,'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches',...
    'PaperSize', [pos(3), pos(4)])
print(h, '..\output\elbow', '-dpdf', '-r0')

evaluation = evalclusters(dataFinal', "kmeans",...
    "CalinskiHarabasz", "KList", 1:10);
figure(6), plot(evaluation)
ChangeInterpreter(figure(6), 'latex')

% Plot image in pdf format
h = figure(6);
set(h,'Units','Inches');
pos = get(h,'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches',...
    'PaperSize', [pos(3), pos(4)])
print(h, '..\output\eval', '-dpdf', '-r0')

% Set fixed value of m
m = 3;

% Preallocate theta and bel arrays
nRuns = 100;
theta = zeros(m, size(dataFinal, 1), nRuns);
bel = zeros(1, size(dataFinal, 2), nRuns);

% Initialize temporary minimum value
jTempMin = inf;

% Loop over number of runs
for t = 1:nRuns
    % Generate initial theta values using randDataInit function
    thetaIni = rand_data_init(dataFinal, m);
    
    % Run kMeans function and store results
    [theta(:, :, t), bel(:, :, t), j] = k_means(dataFinal, thetaIni);
    
    % Update temporary minimum value and corresponding
    % outputs if necessary
    if jTempMin > j
        jTempMin = j;
        thetaMin = theta(:, :, t);
        belMin = bel(:, :, t);
    end
end

% Plot the clusters
figure(7), plot3(dataFinal(1, belMin==1),...
    dataFinal(2, belMin==1), dataFinal(3, belMin==1),'rx',...
    dataFinal(1, belMin==2), dataFinal(2, belMin==2),...
    dataFinal(3, belMin==2),'go', dataFinal(1, belMin==3),...
    dataFinal(2, belMin==3), dataFinal(3, belMin==3),'bd');
hold on
plot3(thetaMin(1,:), thetaMin(2,:), thetaMin(3,:), 'k+', 'LineWidth', 2)
xlabel("Trade")
ylabel("Finance")
zlabel("Health")
legend("Cluster 1", "Cluster 2", "Cluster 3", "Centroid",...
    'Location', 'NorthEast')
grid on
hold off

ChangeInterpreter(figure(7), 'latex')
PlotDimensions(figure(7), 'centimeters', [18, 18], 12)
Plot2LaTeX(figure(7), '..\output\test')

%% ============= Part 4: Characterisation of clusters ================

cluster1 = countryNames(belMin == 1);
cluster2 = countryNames(belMin == 2);
cluster3 = countryNames(belMin == 3);

% Get the lengths of the cell arrays
len1 = length(cluster1);
len2 = length(cluster2);
len3 = length(cluster3);

% Sort the strings in each cell array in alphabetical order
cluster1 = sort(cluster1);
cluster2 = sort(cluster2);
cluster3 = sort(cluster3);

% Print the cluster labels
fprintf('%20s\t%20s\t%20s\n', 'Cluster 1', 'Cluster 2', 'Cluster 3');
fprintf('%20s\t%20s\t%20s\n', '----------', '----------',...
    '----------');

% Print the first 5 strings of each cell array
fprintf('%20s\t%20s\t%20s\n', cluster1{1:5}, ...
    cluster2{1:5}, cluster3{1:5});

% Print the dots if there are more than 10 strings
% in any of the cell arrays
if len1 > 10 || len2 > 10 || len3 > 10
    fprintf('%20s\t%20s\t%20s\n', '.', '.', '.');
    fprintf('%20s\t%20s\t%20s\n', '.', '.', '.');
    fprintf('%20s\t%20s\t%20s\n', '.', '.', '.');
end

% Print the last 5 strings of each cell array
fprintf('%20s\t%20s\t%20s\n', cluster1{max(1, len1-4):len1},...
    cluster2{max(1, len2-4):len2}, cluster3{max(1, len3-4):len3});

clusters = ["Cluster 1", "Cluster 2", "Cluster 3"];
clusterData1 = data(belMin' == 1, :);
clusterData2 = data(belMin' == 2, :);
clusterData3 = data(belMin' == 3, :);

% Concatenate row vectors and append data to grouping variables
childMortality = [clusterData1(:, 1)' clusterData2(:, 1)'...
    clusterData3(:, 1)'];
income = [clusterData1(:, 5)' clusterData2(:, 5)'...
    clusterData3(:, 5)'];
grp = [zeros(1, length(clusterData1(:, 1)')),...
    ones(1, length(clusterData2(:, 1)')),...
    2 * ones(1, length(clusterData3(:, 1)'))];

% Boxplot of child mortality for all clusters
figure(8), boxplot(childMortality, grp, 'Labels', clusters);
ylabel("child mortality")
ChangeInterpreter(figure(8), 'latex')

% Plot image in pdf format
h = figure(8);
set(h,'Units','Inches');
pos = get(h,'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches',...
    'PaperSize', [pos(3), pos(4)])
print(h, '..\output\childmortbox', '-dpdf', '-r0')

% Boxplot of income for all clusters
figure(9), boxplot(income, grp, 'Labels', clusters);
ylabel("income")
ChangeInterpreter(figure(9), 'latex')

% Plot image in pdf format
h = figure(9);
set(h,'Units','Inches');
pos = get(h,'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches',...
    'PaperSize', [pos(3), pos(4)])
print(h, '..\output\healthbox', '-dpdf', '-r0')
