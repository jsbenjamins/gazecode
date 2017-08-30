function [f] = initeventdetect(eyetracker)

if strcmp(eyetracker,'Pupil Labs')
    f.thr           = 5000;     % set very high
    f.counter       = 200; 
    f.minfix        = 60;       % ms 
    f.lambda        = 4;        % lambda rel treshhold in sd's 
elseif strcmp(eyetracker,'Tobii Pro Glasses')
    f.thr           = 5000;     % set very high
    f.counter       = 200; 
    f.minfix        = 60;       % ms 
    f.lambda        = 4;        % lambda rel treshhold in sd's 
else
    sprintf('%s','unknown eye tracker');
end

