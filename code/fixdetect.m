function fmark = fixdetect(datx,daty,dattime,gv)

dat.x = datx;
dat.y = daty;
dat.time = dattime;

%%%%% eye tracker defaults
gv.tracker          = gv.datatype;
 

gv.camres       = gv.wcr;   % resolutie van de oogcamera
gv.trackres     = gv.ecr;    % resolutie van de scenecamera

 
f                   = initeventdetect(gv.tracker);
 
%%%%% Zorg dat in je data NaN zitten op plaatsen met dataloss (pupillabs doet nul) 
% ik ga er hier van uit dat je een x, y en een tijdssignaal hebt
% bijvoorbeeld dat.x, dat.y en dat.time
 
%%%%% bepaal snelheid
vx                  = detvel(dat.x,dat.time);
vy                  = detvel(dat.y,dat.time);
dat.v               = pythagoras(vx,vy);
 
%%%%% detecteer fixaties
fmark               = detectfixaties2015(dat.v,f,dat.time);
