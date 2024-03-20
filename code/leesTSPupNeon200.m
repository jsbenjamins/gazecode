function [tijd,x,y] = leesTSPupNeon200(filenaam)

fid     = fopen(filenaam);
[fid,message] = fopen(filenaam);
if fid == -1
    error(message);
end

skip = 1;                           % to skip header
for p=1:skip,
    fgetl(fid);
end

dummy = textscan(fid,'%s%s%f','delimiter',',');
fclose(fid);

tijd    = dummy{:,3};



disp(sprintf('%d lines of file %s processed',length(tijd),filenaam));