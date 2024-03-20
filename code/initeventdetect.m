function [f] = initeventdetect(eyetracker)

switch eyetracker
    case {'Tobii Pro Glasses 2','Tobii Pro Glasses 3'}
        f.thr           = 5000;     % set very high
        f.counter       = 200;
        f.minfix        = 80;       % ms
        f.lambda        = 2.5;      % lambda rel treshhold in sd's
        f.windowlength  = 8000;     % ms moving window average
        f.sf            = 50;       % sampling freq
        f.windowsize    = round(f.windowlength./(1000/f.sf)); % window size in samples
    case 'Pupil Labs (first gen + Core)'   % experimental, settings not thoroughly tested
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
    case 'Pupil Labs invisible (200 Hz)'
        f.thr           = 5000;     % set very high
        f.counter       = 200;
        f.minfix        = 60;       % ms
        f.lambda        = 2.5;      % lambda rel treshhold in sd's
        f.windowlength  = 8000;     % ms moving window average
        f.sf            = 200;      % sampling freq
        f.windowsize    = round(f.windowlength./(1000/f.sf));
        disp('using Pupil invisible 200 hz settings');
    case 'Pupil Labs Neon (200 Hz)'
        f.thr           = 5000;     % set very high
        f.counter       = 200;
        f.minfix        = 60;       % ms
        f.lambda        = 2.5;      % lambda rel treshhold in sd's
        f.windowlength  = 8000;     % ms moving window average
        f.sf            = 200;      % sampling freq
        f.windowsize    = round(f.windowlength./(1000/f.sf));
        disp('using Pupil Neon 200 hz settings');    
    otherwise
        f.thr           = 5000;     % set very high
        f.counter       = 200;
        f.minfix        = 60;       % ms
        f.lambda        = 4;        % lambda rel treshhold in sd's
        f.windowlength  = 8000;     % ms moving window average
        f.sf            = 50;       % sampling freq
        f.windowsize    = round(f.windowlength./(1000/f.sf)); % window size in samples
end

