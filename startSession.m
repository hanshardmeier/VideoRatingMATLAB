%% Shortcut script to start the program

% turn off backtrace for warnings
warning off backtrace

% Adds custom Code to default search path
path(path,strcat(pwd,'/Code/'));

%Starts application
window = StartWindow();