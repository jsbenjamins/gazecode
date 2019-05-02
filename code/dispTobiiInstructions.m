function dispTobiiInstructions()
% Tobii Pro Glasses note
% ======================
%
% Tobii Pro Glasses has no default export filenames for data and visualisa
% tion videos, and saves data in a proprietary file format with  extension TSV. 
% Open the TSV file in Excel and save it as a tab delimited text, extension
% TXT. For easy of use store this data export TXT file and the exported 
% visualisation (in MP4 format) in one and the same folder. GazeCode will
% prompt you for this video and data file.
%
% This version of GazeCode expects a certian number of columns in the exported 
% data file, make sure when exporting the data you only export these varia
% bles and place them in this particular order:
%
% Project name
% Recording name
% Recording date
% Recording timestamp
% Gaze point X
% Gaze point Y
% Gaze direction left X
% Gaze direction left Y
% Pupil position left X
% Pupil position left Y
% Eye movement type
% Gaze event duration
% 
% If you do not have these files ready, choose "No & quit" at the next 
% prompt you get.
% ======================

commandwindow;
disp('... press any key to continue');
pause();