function [fold,teller] = folderfromfolder(folder,mode)
% [fold,nfold] = folderfromfolder(folder)
%
% Returns all folders in the folder "folder"

if nargin == 1
    silent = false;
elseif strcmp(mode,'silent')
    silent = true;
else
    silent = false;
end

A       = double('A');                         % asci-code A
Z       = double('Z');                         % asci-code Z
a       = double('a');                         % asci-code a
z       = double('z');                         % asci-code z
nul     = double('0');                         % asci-code 0
negen   = double('9');                         % asci-code 9

filelist = dir(folder);

teller = 0;
for p=1:length(filelist),
    stri = filelist(p).name;
    fc = double(stri(1));                      % fc is asci code of first character
    if ((fc >= A && fc <= Z)||(fc >= a && fc <= z)||(fc >= nul && fc <= negen)) && filelist(p).isdir==1,
        teller = teller +1;
        fold(teller).name = stri;
        fold(teller).date = datestr(filelist(p).datenum,1);
    end
end

if teller == 0,
    fold = [];
    if silent
        disp(sprintf(['folderfromfolder: No folders found in: ' strrep(folder,'\','\\')]));
    elseif ~silent
        error(['folderfromfolder: No folders found in: ' folder]);
    end
end