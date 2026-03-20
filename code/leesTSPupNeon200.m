function [tijd,x,y] = leesTSPupNeon200(filenaam,datatype)

fid     = fopen(filenaam);
[fid,message] = fopen(filenaam);
if fid == -1
    error(message);
end

skip = 1;                           % to skip header
for p=1:skip,
    fgetl(fid);
end

dummy = textscan(fid,'%s%f','delimiter',',');
fclose(fid);

switch datatype
    case 'Pupil Labs Neon (cloud export 200 Hz)'
        tijd    = dummy{:,3};
    case 'Pupil Labs Neon (Neon Player (v6.0.07b and up) export 200 Hz)'
        tijd    = dummy{:,2};
end

disp(sprintf('%d lines of file %s processed',length(tijd),filenaam));