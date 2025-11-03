clear
clc
% Set up folder paths
rootFolder = '.\RollingElementBearingFaultDiagnosis-Data-master';
folders = {'train_data', 'test_data'};
allData = table();

segmentLength = 5000; % Number of samples per segment

for f = 1:length(folders)
    folderPath = fullfile(rootFolder, folders{f});
    matFiles = dir(fullfile(folderPath, '*.mat'));
    
    for k = 1:length(matFiles)
        fileName = matFiles(k).name;
        filePath = fullfile(matFiles(k).folder, fileName);
        
        % Load bearing struct
        S = load(filePath);
        bearing = S.bearing;
        
        % Identify label from file name
        if contains(fileName, 'baseline', 'IgnoreCase', true)
            label = 'Normal';
        elseif contains(fileName, 'InnerRaceFault', 'IgnoreCase', true)
            label = 'InnerRaceFault';
        elseif contains(fileName, 'OuterRaceFault', 'IgnoreCase', true)
            label = 'OuterRaceFault';
        else
            error('Unknown label in %s', fileName);
        end
        
        % Extract data and downsample if needed
        data = bearing.gs;
        sr = bearing.sr;
        target_sr = 48828;
        
        if sr ~= target_sr
            % Downsample to 48828 Hz
            [P, Q] = rat(target_sr / sr);
            data = resample(data, P, Q);
        end
        
        % Split data into segments
        numSegments = floor(length(data) / segmentLength);
        for seg = 1:numSegments
            idxStart = (seg-1)*segmentLength + 1;
            idxEnd = seg*segmentLength;
            segmentData = data(idxStart:idxEnd);
            time = (0:segmentLength-1)' / target_sr; % Restart time for each segment
            TT = timetable(seconds(time), segmentData);
            TT.Properties.VariableNames = {'gs'};
            
            % Add to table
            if isnumeric(bearing.load)
                load_b = bearing.load;
            else
                load_b = str2double(bearing.load); % Convert load to numeric
            end

            T = table({fileName}, categorical({label}), load_b, {TT}, ...
                'VariableNames', ["fileName", "label", "load", "data"]);
            allData = [allData; T];
        end
    end
end

% Balance the data by label
labels = categories(allData.label);
minCount = min(countcats(allData.label));

% For each label, randomly permute and split
rng(42); % For reproducibility
trainIdx = [];
valIdx = [];
testIdx = [];
for i = 1:numel(labels)
    idx = find(allData.label == labels{i});
    idx = idx(randperm(length(idx), minCount)); % balance
    nTrain = round(0.75 * minCount);
    nVal = round(0.05 * minCount);
    nTest = minCount - nTrain - nVal;
    trainIdx = [trainIdx; idx(1:nTrain)];
    valIdx = [valIdx; idx(nTrain+1:nTrain+nVal)];
    testIdx = [testIdx; idx(nTrain+nVal+1:end)];
end

% Create tables
trainTable = allData(trainIdx, :);
valTable = allData(valIdx, :);
testTable = allData(testIdx, :);
minimalTable = allData([1,40,300,340,500,700],:);

% Save all tables
save('allBearingData.mat', 'allData');
save('trainTable.mat','trainTable')
save('testTable.mat','testTable')
save('valTable.mat','valTable')
save('minimalTable.mat','minimalTable')