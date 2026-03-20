function [tijd,x,y] = leesgazePupNeon200data(filenaam,datatype)

fid     = fopen(filenaam);
[fid,message] = fopen(filenaam);
if fid == -1
    error(message);
end

skip = 1;                           % to skip header
for p=1:skip,
    fgetl(fid);
end

dummy = textscan(fid,['%s',repmat('%f',1,8)],'delimiter',',');
fclose(fid);

switch datatype
    case 'Pupil Labs Neon (cloud export 200 Hz)'
        tijd    = dummy{:,3};
        x       = dummy{:,4};
        y       = dummy{:,5};
    case 'Pupil Labs Neon (Neon Player (v6.0.07b and up) export 200 Hz)'
        tijd    = dummy{:,2};
        x       = dummy{:,3};
        y       = dummy{:,4};
end
disp(sprintf('%d lines of file %s processed',length(tijd),filenaam));