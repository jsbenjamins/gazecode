function [tijd,x,y] = leesgazedataPupFG(filenaam)

fid     = fopen(filenaam);
[fid,message] = fopen(filenaam);
if fid == -1
    error(message);
end

skip = 1;                           % to skip header
for p=1:skip,
    fgetl(fid);
end
% 2023-06-26: changed textscan string to circumvent issue with sixth column not being numerical in Pupil Labs FG and Core data
dummy = textscan(fid,[repmat('%f',1,5),'%s',repmat('%f',1,15)],'delimiter',',');
fclose(fid);

tijd    = dummy{:,1};
x       = dummy{:,4};
y       = dummy{:,5};


disp(sprintf('%d lines of file %s processed',length(tijd),filenaam));