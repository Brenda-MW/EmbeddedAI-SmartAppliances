function [XTrain, TTrain, XTest, TTest] = trainWithTabularData(tbl)

numObservations = size(tbl, 1); 
[idxTrain,idxTest] = trainingPartitions(numObservations,[0.80 0.20]);

tblTrain = tbl(idxTrain,:);
tblTest = tbl(idxTest,:);

XTrainR = table2array(tblTrain(:, "ToFReading")); 
for idxT = 1:length(XTrainR)
    XTrain(:, :, 1, idxT) = XTrainR{idxT}; %#ok<SAGROW>
end

TTrain = tblTrain.Gesture; 

XTestR = table2array(tblTest(:, "ToFReading")); 
for idxR = 1:length(XTestR)
    XTest(:, :, 1, idxR) = XTestR{idxR}; %#ok<SAGROW>
end
TTest = tblTest.Gesture; 

