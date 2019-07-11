function [f] = initeventdetect(eyetracker)

switch eyetracker
    case 'Tobii Pro Glasses 2'
        f.thr           = 5000;     % set very high
        f.counter       = 200;
        f.minfix        = 80;       % ms
        f.lambda        = 2.5;      % lambda rel treshhold in sd's
        f.windowlength  = 8000;     % ms moving window average
        f.sf            = 50;       % sampling freq
        f.windowsize    = round(f.windowlength./(1000/f.sf)); % window size in samples
    case 'Pupil Labs'               % experimental, settings not thoroughly tested
        f.thr           = 5000;     % set very high
        f.counter       = 200;
        f.minfix        = 60;       % ms
        f.lambda        = 4;        % lambda rel treshhold in sd's
        f.windowlength  = 8000;     % ms moving window average
        f.sf            = 50;       % sampling freq
        f.windowsize    = round(f.windowlength./(1000/f.sf)); % window size in samples
    case 'SMI Glasses'              % experimental, settings not thoroughly tested
        f.thr           = 5000;     % set very high
        f.counter       = 200;
        f.minfix        = 60;       % ms
        f.lambda        = 4;        % lambda rel treshhold in sd's
        f.windowlength  = 8000;     % ms moving window average
        f.sf            = 50;       % sampling freq
        f.windowsize    = round(f.windowlength./(1000/f.sf)); % window size in samples
    case 'Positive Science'         % experimental, settings not thoroughly tested
        f.thr           = 5000;     % set very high
        f.counter       = 200;
        f.minfix        = 60;       % ms
        f.lambda        = 4;        % lambda rel treshhold in sd's
        f.windowlength  = 8000;     % ms moving window average
        f.sf            = 50;       % sampling freq
        f.windowsize    = round(f.windowlength./(1000/f.sf)); % window size in samples
    otherwise
        f.thr           = 5000;     % set very high
        f.counter       = 200;
        f.minfix        = 60;       % ms
        f.lambda        = 4;        % lambda rel treshhold in sd's
        f.windowlength  = 8000;     % ms moving window average
        f.sf            = 50;       % sampling freq
        f.windowsize    = round(f.windowlength./(1000/f.sf)); % window size in samples
end

