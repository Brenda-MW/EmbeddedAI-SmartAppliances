% This is the code for checking workshop folder
% as part of the Hands-On AI Workshop presented
% in MATLAB Expo 2025

% Run this file to check your environment


% Check permissions for Exercise1
fileName = 'ex0.m';
[fid,errmsg] = fopen(fileName, 'w');
if ~isempty(errmsg)&&strcmp(errmsg,'Permission denied') 
    fprintf('\nError: You do not have write permission in the folder containing (%s).\n',fileName);
    fprintf('\nPlease make a copy of the original workshop folder and navigate to it.\n');
    fprintf('You will run the exercises out of the repository folder you created.\n');
else
    fprintf('\nWelcome to the Hands-On Workshop!\n');
    fprintf('\nYou have write permission in this folder.\n');
    fprintf('\nInitializing the exercises...\n');
    % Add files to path
    addpath(genpath(pwd)); 

    fprintf('\nEnvironment Check is Complete!\n');
    fprintf('\nEnjoy the workshop!\n');
end
fclose(fid); 