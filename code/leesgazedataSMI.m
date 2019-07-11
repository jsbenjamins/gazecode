function [tijd,x,y] = leesgazedataSMI(filenaam)

fid     = fopen(filenaam);
[fid,message] = fopen(filenaam);
if fid == -1
    error(message);
end

firstskip = 16;                           % to skip header unitl calibration info
for p=1:firstskip,
    fgetl(fid);
end

calibarea = fgetl(fid);
calibparams = strsplit(calibarea,'\t');
wcr = [str2num(calibparams{2}) str2num(calibparams{3})];

secondskip = 17;                           % to skip rest of the header
for p=1:secondskip,
    fgetl(fid);
end


dummy = textscan(fid,'%f%s%f%f%f%f%f%f%f%f%f%f%f%s%f%f%f%f%f%f%f%f%f%f%f%f','delimiter','\t');
fclose(fid);

tijd            = dummy{:,1};
% time needs to be set to zero and is in microseconds!
tijd2           = tijd;
tijd2(2:end)    = (tijd2(2:end)- tijd2(1))/1000;
tijd2(1)        = 0;

tijd = tijd2;

leftx           = dummy{:,10};
% correct for data that is beyond the world camera
leftx(leftx<0)      = NaN;
leftx(leftx>wcr(1)) = NaN;
lefty           = dummy{:,11};
% correct for data that is beyond the world camera
lefty(lefty<0)      = NaN;
lefty(lefty>wcr(2)) = NaN;

rightx          = dummy{:,12};
% correct for data that is beyond the world camera
rightx(rightx<0)      = NaN;
rightx(rightx>wcr(1)) = NaN;
righty          = dummy{:,13};
% correct for data that is beyond the world camera
righty(righty<0)      = NaN;
righty(righty>wcr(2)) = NaN;

x               = nanmean([leftx,rightx],2);
y               = nanmean([lefty,righty],2);

disp(sprintf('%d lines of file %s processed',length(tijd),filenaam));