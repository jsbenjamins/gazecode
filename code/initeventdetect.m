function [f] = initeventdetect(eyetracker)

if strcmp(eyetracker,'Pupil Labs')
    f.thr           = 5000;     % set very high
    f.counter       = 200; 
    f.minfix        = 60;       % ms 
    f.lambda        = 4;        % lambda rel treshhold in sd's 
elseif strcmp(eyetracker,'Tobii Pro Glasses')
    f.thr           = 5000;     % set very high
    f.counter       = 200; 
    f.minfix        = 80;       % ms 
    f.lambda        = 2.5;      % lambda rel treshhold in sd's 
    f.windowlength  = 8000;     % ms moving window average
    f.sf            = 50;       % sampling freq
    f.windowsize    = round(f.windowlength./(1000/f.sf)); % window size in samples
else
    sprintf('%s','unknown eye tracker');
end

