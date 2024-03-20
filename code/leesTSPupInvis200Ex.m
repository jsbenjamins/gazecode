function [tijd,x,y] = leesTSPupInvis200Ex(filenaam)

fid     = fopen(filenaam);
[fid,message] = fopen(filenaam);
if fid == -1
    error(message);
end

skip = 1;                           % to skip header
for p=1:skip,
    fgetl(fid);
end

dummy = textscan(fid,[repmat('%f',1,2)],'delimiter',',');
fclose(fid);

tijd    = dummy{:,1};



disp(sprintf('%d lines of file %s processed',length(tijd),filenaam));