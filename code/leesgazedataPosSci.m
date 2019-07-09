function [tijd,x,y] = leesgazedataPosSci(filenaam)

fid     = fopen(filenaam);
[fid,message] = fopen(filenaam);
if fid == -1
    error(message);
end

skip = 7;                           % to skip header
for p=1:skip,
    fgetl(fid);
end

dummy = textscan(fid,'%d%d%f%s%s%f%f%f%f%f%f%f%f','delimiter',' ');
fclose(fid);

tijd        = dummy{:,5};
tijd2       = cellfun(@(x) strsplit(x,'.'),tijd,'UniformOutput',false);
tijd2a      = cellfun(@(x) strsplit(x{2},'/'),tijd2,'UniformOutput',false);
tijd2b      = cellfun(@(x) datevec(datenum(x{1},'DD:HH:MM:SS')),tijd2,'UniformOutput',false);
tijdexms    = cellfun(@(x) (x(4)*60*60*1000 + x(5)*60*1000 + x(6)*1000),tijd2b,'UniformOutput',false);
tijdms      = cellfun(@(x) 1000*(str2num(x{1})/str2num(x{2})),tijd2a,'UniformOutput',false);
tijdms      = cell2mat(tijdms);
tijdexms    = cell2mat(tijdexms);

finaltijd   = tijdexms + tijdms;

tijd        = finaltijd;

x       = dummy{:,6};
y       = dummy{:,7};


disp(sprintf('%d lines of file %s processed',length(tijd),filenaam));