function [fmark] = detectfixaties2018fmark(mvel,f,time,thr2)

minfix          = f.minfix;                        % minfix in ms

qvel            = mvel < thr2;                     % look for velocity below threshold
[on,off]        = detectswitches(qvel');           % determine fixations

on              = time(on);                        % convcert to time
off             = time(off);                       % convert to time

qfix            = off - on > minfix;               % look for small fixations       
on              = on(qfix);                        % delete fixations smaller than minfix
off             = off(qfix);                       % delete fixations smaller than minfix

on(2:end)       = on(2:end);                       % 
off(1:end-1)    = off(1:end-1);                    % 

fmark           = sort([on;off]);                  % sort the markers
