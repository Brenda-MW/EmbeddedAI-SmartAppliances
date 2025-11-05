function label = predictFromModel(x) %#codegen
%PREDICTFROMMODEL Label new observations using trained model
Mdl = loadLearnerForCoder('incrementalModel');
label = predict(Mdl,x);
end