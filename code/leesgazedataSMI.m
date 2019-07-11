function [tijd,x,y,wcr] = leesgazedataSMI(filenaam)

wcr = [960 720];

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
lefty           = dummy{:,11};

rightx          = dummy{:,12};
righty          = dummy{:,13};

x               = mean([leftx,rightx],2);
y               = mean([lefty,righty],2);

disp(sprintf('%d lines of file %s processed',length(tijd),filenaam));