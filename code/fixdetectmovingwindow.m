function fmark = fixdetectmovingwindow(datx,daty,dattime,gv)
% NOTE: lamdba does not function exactly as you might think. Lamdba is used
% to iteratively remove high velocities (mean + lamdba * std). Final
% velocity is hard coded to mean + 3*std in detectfixaties2018thr. 

dat.x = datx;
dat.y = daty;
dat.time = dattime;

%%%%% eye tracker defaults
gv.tracker          = gv.datatype;
 

gv.camres       = gv.wcr;   % resolution of eye camera
gv.trackres     = gv.ecr;    % resolution of scene camera

 
f                   = initeventdetect(gv.tracker);
 
%%%%% Make sure there are NaNs where there is data loss (pupillabs uses zero) 
% assuming there is an x, y and time signal
% for example dat.x, dat.y, dat.time
 
%%%%% determine velocity
vx                  = detvel(dat.x,dat.time);
vy                  = detvel(dat.y,dat.time);
dat.v               = pythagoras(vx,vy);
 
%%%%% detect fixations with moving window averaged threshold
% max windowstart
maxwinstart = numel(dat.time)-f.windowsize+1;
    
for b=1:maxwinstart
    %tempt   = dat.time(b:b+f.windowsize-1); % get time
    tempv   = dat.v(b:b+f.windowsize-1); % get vel
    
    % get fixation-classification threshold
    thrfinal = detectfixaties2022thr(tempv,f);
    
    if b==1
        thr = thrfinal;
        ninwin = ones(length(thrfinal),1);
    else
        % append threshod
        thr(end-length(thrfinal)+2:end) = thr(end-length(thrfinal)+2:end)+thrfinal(1:end-1);
        thr = [thr; thrfinal(end)];
        % update number of times in win
        ninwin(end-length(thrfinal)+2:end) = ninwin(end-length(thrfinal)+2:end)+1;
        ninwin = [ninwin; 1];
    end
end

% now get final thr
thr = thr./ninwin;

fmark = detectfixaties2018fmark(dat.v,f,dat.time,thr);