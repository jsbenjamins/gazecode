function gazecode(settings)

% GazeCode (beta version)
%
% See readme.md for usage details
%
% This open-source toolbox has been developed by J.S. Benjamins, R.S.
% Hessels and I.T.C. Hooge. When you use it, please cite:
%
% Jeroen S. Benjamins, Roy S. Hessels, and Ignace T. C. Hooge. 2018.
% Gazecode: open-source software for manual mapping of mobile eye-tracking
% data. In Proceedings of the 2018 ACM Symposium on Eye Tracking Research &
% Applications (ETRA '18). ACM, New York, NY, USA, Article 54, 4 pages.
% DOI: https://doi.org/10.1145/3204493.3204568
%
% For importing data from Tobii Glasses 2, it uses GlassesViewer. When
% using this toolbox with Tobii Glasses data, please also cite
% Niehorster, D.C., Hessels, R.S., and Benjamins, J.S. (in prep).
% GlassesViewer: Open-source software for viewing and analyzing data from
% the Tobii Pro Glasses 2 eye tracker.
%
% For more information, questions, or to check whether we have updated to a
% better version, e-mail: j.s.benjamins@uu.nl. GazeCode is available from
% www.github.com/jsbenjamins/gazecode and GlassesViewer from
% https://github.com/dcnieho/glassesviewer
%
% Most parts of GazeCode are licensed under the Creative Commons
% Attribution 4.0 (CC BY 4.0) license. Some functions are under MIT
% license, and some may be under other licenses.
%
% Tested on:
% Matlab 2017a, 2018b on Mac OSX 10.10.5 and Max OSX 10.14.3
% Matlab 2016a, 2018a on Windows 10

%% start fresh
clear all; close all; clc;
qDEBUG = false;
if qDEBUG
    dbstop if error
end

% myDir     = fileparts(mfilename('fullpath'));


% set it to false. If coding from GlassesViewer exists it will be loaded
% from there.
dataIsCrap = false;

%% ========================================================================
% BIG NOTE: every variable that is needed somewhere in this code is stored
% in a structure array called gv that is added to the main window with the
% handle hm as userdata. When changing or adding variables in this struct
% it is thus needed to fetch using gv = get(hm, 'userdata') an update using
% use set(hm,'userdata',gv);
%% ========================================================================

% global gv;
gv.curframe     = 1;
gv.minframe     = 1;
gv.maxframe     = 1;
gv.curfix       = 1;
gv.maxfix       = 1;
skipdataload    = false;

% buttons
gv.fwdbut  = 'x'; % move forward (next fixation)
gv.bckbut  = 'z'; % move backward (previous fixation)
gv.cat1but = {'1','numpad1'};
gv.cat2but = {'2','numpad2'};
gv.cat3but = {'3','numpad3'};
gv.cat4but = {'4','numpad4'};
gv.cat5but = {'5','numpad5'};
gv.cat6but = {'6','numpad6'};
gv.cat7but = {'7','numpad7'};
gv.cat8but = {'8','numpad8'};
gv.cat9but = {'9','numpad9'};
gv.catjbut = 'j';


%% directories and settings
gv.fs           = filesep;
gv.codedir      = cd; cd ..;
gv.rootdir      = cd;
cd(gv.rootdir);

gv.resdir       = [cd gv.fs 'results'];
cd(gv.resdir);

cd ..;

gv.catdir       = [cd gv.fs 'categories'];
cd(gv.catdir);

cd ..;

gv.appdir       = [cd gv.fs 'images'];
cd(gv.appdir);

cd ..;

gv.datadir      = [cd gv.fs 'data'];
cd(gv.datadir);

cd(gv.rootdir);

gv.glassesviewerdir  = [cd gv.fs 'GlassesViewer'];
cd(gv.glassesviewerdir);

addpath(genpath(gv.rootdir),genpath(gv.glassesviewerdir));
cd(gv.codedir);

if nargin<1 || isempty(settings)
    if ~isempty(which('matlab.internal.webservices.fromJSON'))
        jsondecoder = @matlab.internal.webservices.fromJSON;
    elseif ~isempty(which('jsondecode'))
        jsondecoder = @jsondecode;
    else
        error('Your MATLAB version does not provide a way to decode json (which means its really old), upgrade to something newer');
    end
    settings  = jsondecoder(fileread(fullfile(gv.glassesviewerdir,'defaults.json')));
end

gv.splashh = gazesplash([gv.appdir gv.fs 'splash.png']);
pause(1);
close(gv.splashh);
%% Select type of data you want to code (currently a version for Pupil Labs and Tobii Pro Glasses are implemented

% this is now a question dialog, but needs to be changed to a dropdown for
% more options. Question dialog allows for only three options
models = {'Pupil Labs','Tobii Pro Glasses 2','SMI Glasses','Positive Science'};
modelIdx = listdlg ('ListString', models,'SelectionMode', 'Single', 'PromptString', 'Select eye-tracker', 'Initialvalue', 2,'Cancelstring','Quit','ListSize',[160 160]);
assert(~isempty(modelIdx),'You did not select a type of mobile eye-tracking data, exiting');

gv.datatype = models{modelIdx};
% set camera settings of eye-tracker data
switch gv.datatype
    case 'Pupil Labs'
        gv.wcr = [1280 720]; % world cam resolution
        gv.ecr = [640 480]; % eye cam resolution
    case 'SMI Glasses'
        gv.wcr = [960 720]; % world cam resolution, can also be 960 x 720
        gv.ecr = [640 480]; % eye cam resolution (assumption, not known ATM)
    case 'Positive Science'
        gv.wcr = [640 480]; % wordl cam resolution
        gv.ecr = [320 240]; % eye cam resolution (assumption, not known ATM)
    case 'Tobii Pro Glasses 2'
        % this is in glassesViewer's export, at
        % data.video.scene.width, data.video.scene.height
        % data.video.eye.width, data.video.eye.height
end

%%
disp('Select directory of categories');
gv.catfoldnaam    = uigetdir(gv.catdir,'Select directory of categories');
clc;
assert(ischar(gv.catfoldnaam),'You did not select a categories directory, exiting');

%% load data folder
switch gv.datatype
    case 'Tobii Pro Glasses 2'
        % do the selecor thing
        disp('Select projects directory of SD card');
        selectedDir = uigetdir(gv.datadir,'Select projects directory of SD card');
        % adding disp as Mac does not show title of UI elements
        clc;
        assert(ischar(selectedDir),'You did not select a data directory, exiting');
        
        if exist(fullfile(selectedDir,'segments'),'dir') && exist(fullfile(selectedDir,'recording.json'),'file')
            % user selected what is very likely a recording's dir directly
            recordingDir = selectedDir;
        else
            % assume this is a project dir. G2ProjectParser will fail if it is not
            if ~exist(fullfile(selectedDir,'lookup.xls'),'file')
                success = G2ProjectParser(selectedDir);
                if ~success
                    error('Could not find projects in the folder: %s',selectedDir);
                end
            end
            recordingDir = recordingSelector(selectedDir);
            if isempty(recordingDir)
                return
            end
        end
        
        gv.foldnaam = recordingDir;
        
        filmnaam    = fullfile(gv.foldnaam,'segments','1','fullstream.mp4');
        gv.filmnaam = filmnaam;
        
        fid = fopen(fullfile(gv.foldnaam,'recording.json'),'rt');
        recording = jsondecoder(fread(fid,inf,'*char').');
        fclose(fid);
        gv.recName = recording.rec_info.Name;
        fid = fopen(fullfile(gv.foldnaam,'participant.json'),'rt');
        participant = jsondecoder(fread(fid,inf,'*char').');
        gv.partName = participant.pa_info.Name;
        fclose(fid);
    otherwise
        disp('Select data directory to code');
        gv.foldnaam    = uigetdir(gv.datadir,'Select data directory to code');
        % adding disp as Mac does not show title of UI elements
        clc;
        assert(ischar(gv.foldnaam),'You did not select a data directory, exiting');
        
        filmnaam    = strsplit(gv.foldnaam,gv.fs);
        gv.filmnaam    = filmnaam{end};
        
        gv.resdir = [gv.resdir gv.fs gv.filmnaam];
        
        if exist([gv.resdir gv.fs gv.filmnaam '.mat']) > 0
            oudofnieuw = questdlg(['There already is a results directory with a file for ',gv.filmnaam,'. Do you want to load previous results or start over? Starting over will overwrite previous results.'],'Folder already labeled?','Load previous','Start over','Load previous');
            if strcmp(oudofnieuw,'Load previous')
                % IMPORANT NOTE FOR TESTING! This reloads gv! Use start over when
                % making changes to this file.
                load([gv.resdir gv.fs gv.filmnaam '.mat']);
                skipdataload = true;
            else
                rmdir(gv.resdir,'s');
                mkdir(gv.resdir);
            end
        elseif exist(gv.resdir) == 0
            mkdir(gv.resdir);
        else
            % do nothing
        end
end

%% init main screen, don't change this section if you're not sure what you are doing
hm          = figure('Name','GazeCode','NumberTitle','off','Visible','off');
hmmar       = [150 100];

set(hm, 'Units', 'pixels');
ws          = truescreensize();
ws          = [1 1 ws];

% set figure full screen, position is bottom left width height!;
set(hm,'Position',[ws(1) + hmmar(1), ws(2) + hmmar(2), ws(3)-2*hmmar(1), ws(4)-2*hmmar(2)]);
% this is the first time gv is set to hm!
set(hm,'windowkeypressfcn',@verwerkknop,'closerequestfcn',@sluitaf,'userdata',gv);

% get coordinates main screen
hmpos       = get(hm,'Position');

hmxmax      = hmpos(3);
hmymax      = hmpos(4);

% disable all button etc.
set(hm,'MenuBar','none');
set(hm,'DockControls','off');
set(hm,'Resize','off');


% main menu 1
mm1         = uimenu(hm,'Label','Menu');
% sub menu of main menu 1
sm0         = uimenu(mm1,'Label','Save to text','CallBack',@savetotext);
sm1         = uimenu(mm1,'Label','About GazeCode','CallBack','uiwait(msgbox(''This is version 1.0.1'',''About FixLabel''))');

% first get sizes of panels
pmar        = [50 20];
knopsizeL 	= [100 100];
knopsizeR   = [150 150];
knopmar     = [20 10];
panelWidth(1) = (hmxmax/2)-2*pmar(1);
panelWidth(2) = knopsizeR(1)*3+knopmar(1)*4;
% position them
leftoverSpace = hmxmax - sum(panelWidth);
pmarhn        = leftoverSpace/3;

%% left panel (Child 2 of hm), don't change this section if you're not sure what you are doing

lp          = uipanel(hm,'Title','Fix Playback/Lookup','Units','pixels','FontSize',16,'BackgroundColor',[0.8 0.8 0.8]);
gv.lp       = lp;

set(lp,'Position',[1+pmarhn 1+pmar(2) panelWidth(1) hmymax-2*pmar(2)]);
lpsize = get(lp,'Position');
lpsize = lpsize(3:end);



fwknop = uicontrol(lp,'Style','pushbutton','string','>>','callback',@playforward,'userdata',gv.fwdbut);
set(fwknop,'position',[lpsize(1)-knopsizeL(1)-knopmar(1) knopmar(2) knopsizeL]);
% set(fwknop,'backgroundcolor',[1 0.5 0]);
set(fwknop,'fontsize',20);

bkknop = uicontrol(lp,'Style','pushbutton','string','<<','callback',@playback,'userdata',gv.bckbut);
set(bkknop,'position',[knopmar knopsizeL]);
% set(bkknop,'backgroundcolor',[1 0.5 0]);
set(bkknop,'fontsize',20);

%% right panel (child 1 of hm), don't change this section if you're not sure what you are doing
rp          = uipanel('Title','Categories','Units','pixels','FontSize',16,'BackgroundColor',[0.8 0.8 0.8]);

set(rp,'Position',[pmarhn*2+panelWidth(1) 1+pmar(2) panelWidth(2) hmymax-2*pmar(2)]);
rpsize      = get(rp,'Position');
rpsize      = rpsize(3:end);

% right panel buttons
% make grid
widthgrid   = knopsizeR(1)*3+2*knopmar(1);
heightgrid  = knopsizeR(2)*3+2*knopmar(1);
xstartgrid    = floor((rpsize(1) - widthgrid)/2);
ystartgrid  = rpsize(2) - heightgrid - knopmar(1);

opzij       = knopmar(1)+knopsizeR(1);
omhoog      = knopmar(1)+knopsizeR(2);
gridpos     = [...
    xstartgrid, ystartgrid, knopsizeR;...
    xstartgrid+opzij, ystartgrid, knopsizeR;...
    xstartgrid+2*opzij, ystartgrid, knopsizeR;...
    
    xstartgrid ystartgrid+omhoog knopsizeR;...
    xstartgrid+opzij ystartgrid+omhoog knopsizeR;...
    xstartgrid+2*opzij ystartgrid+omhoog knopsizeR;...
    
    xstartgrid ystartgrid+2*omhoog knopsizeR;...
    xstartgrid+opzij ystartgrid+2*omhoog knopsizeR;...
    xstartgrid+2*opzij ystartgrid+2*omhoog knopsizeR;...
    ];

gv.knoppen = [];

for p = 1:size(gridpos,1)
    gv.knoppen(p) = uicontrol(rp,'Style','pushbutton','HorizontalAlignment','left','string','','callback',@labelfix,'userdata',gv);
    set(gv.knoppen(p),'position',gridpos(p,:));
    set(gv.knoppen(p),'backgroundcolor',[1 1 1]);
    set(gv.knoppen(p),'fontsize',20);
    set(gv.knoppen(p),'userdata',p);
%     imgData = imread([gv.catfoldnaam gv.fs num2str(p) '.png']);
%     imgData = imgData./maxall(imgData);
%     imgData = double(imgData);
      [imgData,cmap,a] = imread([gv.catfoldnaam gv.fs num2str(p) '.png']);
      if ~isempty(cmap)
          % if indexed image, turn into normal
          cmap    = permute(cmap,[1 3 2]);
          imgData  = reshape(cmap(imdata(:)+1,1,:),[size(imdata) 3]);
          % don't think this occurs, but be safe in case it does
          if isa(a,'uint8')
              a = double(a)/255;
          end
      end
%       imgData          = cat(3,imgData,a);  % add alpha channel, if any
      if isa(imgData,'uint8')
          imgData = double(imgData)/255;
      elseif isa(imgData,'uint16')
          imgData = double(imgData)/65535;
      end
    set(gv.knoppen(p),'CData',imgData);
end
set(hm,'userdata',gv);

%% position axes of right panel to upper part of right panel. Don't change this section if you're not sure what you are doing
rpax = axes('Units','normal', 'Position', [0 0 1 1], 'Parent', rp,'visible','off');
set(rpax,'Units','pixels');
rpaxpos = get(rpax,'position');

tempx = rpaxpos(1);
tempy = rpaxpos(2);
tempw = rpaxpos(3);
temph = rpaxpos(4);

tempw = tempw - mod(tempw,16);
temph = (tempw/16) * 9;

tempx = floor((rpaxpos(3) - tempw)/2);
tempy = rpaxpos(4)-temph;

set(rpax,'Position',[tempx tempy tempw temph],'visible','off');
gv.rpaxpos = get(rpax,'position');


%% position axes of left panel to upper part of left panel. Don't change this section if you're not sure what you are doing
lpax = axes('Units','normal', 'Position', [0 0 1 1], 'Parent', lp,'visible','off');
set(lpax,'Units','pixels');
lpaxpos = get(lpax,'position');

tempx = lpaxpos(1);
tempy = lpaxpos(2);
tempw = lpaxpos(3);
temph = lpaxpos(4);

tempw = tempw - mod(tempw,16);
temph = (tempw/16) * 9;

tempx = floor((lpaxpos(3) - tempw)/2);
tempy = lpaxpos(4)-temph;

set(lpax,'Position',[tempx tempy tempw temph],'visible','on');
gv.lpaxpos = get(lpax,'position');

%% read video of visualisation, here cases can be added for other mobile eye trackers

% the Pupil Labs version expects the data to be in a specific folder that
% is default when exporting visualisations in Pupil Labs with a default
% name of the file, Tobii Pro Glasses does not, so select it.
switch gv.datatype
    case 'Tobii Pro Glasses 2'
        gv.vidObj = VideoReader(gv.filmnaam);
    otherwise
        cd(gv.foldnaam);
        disp('Select the video file');
        [videofile,videopath] = uigetfile('*.asf;*.asx;*.avi;*.m4v;*.mj2;*.mov;*.mp4;*.mpg;*.wmv;','Select video file');
        clc;
        cd(gv.codedir);
        disp('loading video file...')
        gv.vidObj = VideoReader([videopath gv.fs videofile]);
        clc;
end

gv.fr       = get(gv.vidObj,'FrameRate');
frdur       = 1000/gv.fr;
nf          = get(gv.vidObj,'NumberOfFrames');
gv.maxframe = nf;
gv.centerx  = gv.vidObj.Width/2;
gv.centery  = gv.vidObj.Height/2;
set(hm,'userdata',gv);

%% fixation detection using data
% read data and determine fixations, here cases can be added for other
% mobile eye trackers, as well as changing the fixation detection algorithm
% by altering the function that now runs on line 423.
if ~skipdataload
    % to be done still, select data file from results directory if you
    % want to skip data loading
    
    gv = get(hm,'userdata');
    switch gv.datatype
        case 'SMI Glasses'
            cd(gv.foldnaam);
            disp('Select data file with gaze positions');
            [filenaam, filepad] = uigetfile('.txt','Select data file with gaze positions');
            clc;
            cd(gv.codedir);
            % gv.wcr gets updated based om data as an extra safety measure
            [gv.datt, gv.datx, gv.daty] = leesgazedataSMI([filepad gv.fs filenaam]);
            
            % determine start and end times of each fixation in one vector (odd
            % number start times of fixations even number stop times)
            
            % The line below determines fixations start and stop times since the
            % beginning of the recording. For this detection of fixations the algo-
            % rithm of Hessels et (2019 submitted) is used, but this can be replaced
            % by your own favourite or perhaps more suitable fixation detection algorithm.
            % Important is that this algorithm returns a vector that has fixation
            % start times at the odd and fixation end times at the even positions
            % of it.
            
            disp('Determining fixations...');
            gv.fmark = fixdetectmovingwindow(gv.datx,gv.daty,gv.datt,gv);
            
            disp('Determining fixations...');
            % gv.fmark = fixdetect(gv.datx,gv.daty,gv.datt,gv);
            gv.fmark = fixdetectmovingwindow(gv.datx,gv.daty,gv.datt,gv);
        case 'Positive Science'
            cd(gv.foldnaam);
            disp('Select data file with gaze positions');
            [filenaam, filepad] = uigetfile('.txt','Select data file with gaze positions');
            clc;
            cd(gv.codedir);
            
            % gv.wcr gets updated based om data as an extra safety measure
            [gv.datt, gv.datx, gv.daty] = leesgazedataPosSci([filepad gv.fs filenaam]);
            
            % determine start and end times of each fixation in one vector (odd
            % number start times of fixations even number stop times)
            
            % The line below determines fixations start and stop times since the
            % beginning of the recording. For this detection of fixations the algo-
            % rithm of Hessels et (2019 submitted) is used, but this can be replaced
            % by your own favourite or perhaps more suitable fixation detection algorithm.
            % Important is that this algorithm returns a vector that has fixation
            % start times at the odd and fixation end times at the even positions
            % of it.
            
            disp('Determining fixations...');
            gv.fmark = fixdetectmovingwindow(gv.datx,gv.daty,gv.datt,gv);
        case 'Pupil Labs'
            cd(gv.foldnaam);
            disp('Select data file with gaze positions');
            [filenaam, filepad] = uigetfile('.csv','Select data file with gaze positions');
            clc;
            cd(gv.codedir);
            
            % this file reads the exported data file from Pupil Labs and gets time
            % stamp and x and y coordinates
            [gv.datt, gv.datx, gv.daty] = leesgazedata(filenaam);
            % recalculate absolute timestamps to time from onset (0 ms)
            gv.datt = double(gv.datt);
            gv.datt2 = gv.datt;
            gv.datt2(1) = 0;
            for p = 2:length(gv.datt)
                gv.datt2(p) = gv.datt(p) - gv.datt(p-1);
                gv.datt2(p) = gv.datt2(p) + gv.datt2(p-1);
            end
            gv.datt2 = gv.datt2*1000;
            gv.datt = gv.datt2;
            
            gv.datx(gv.datx > 1) = NaN;
            gv.datx(gv.datx < 0) = NaN;
            
            gv.daty(gv.daty > 1) = NaN;
            gv.daty(gv.daty < 0) = NaN;
            
            gv.datx = gv.datx * gv.wcr(1);
            gv.daty = gv.wcr(2) - gv.daty * gv.wcr(2);
            
            % determine start and end times of each fixation in one vector (odd
            % number start times of fixations even number stop times)
            
            % The line below determines fixations start and stop times since the
            % beginning of the recording. For this detection of fixations the algo-
            % rithm of Hessels et (2019 submitted) is used, but this can be replaced
            % by your own favourite or perhaps more suitable fixation detection algorithm.
            % Important is that this algorithm returns a vector that has fixation
            % start times at the odd and fixation end times at the even positions
            % of it.
            
            disp('Determining fixations...');
            gv.fmark = fixdetectmovingwindow(gv.datx,gv.daty,gv.datt,gv);
            
        case 'Tobii Pro Glasses 2'
            
            data                = getTobiiDataFromGlasses(gv.foldnaam,qDEBUG);
            data.quality        = computeDataQuality(gv.foldnaam, data, settings.dataQuality.windowLength);
            data.ui.haveEyeVideo = isfield(data.video,'eye');
            coding              = getCodingData(gv.foldnaam, '', settings.coding, data);
            coding.dataIsCrap   = dataIsCrap;
            gv.coding           = coding;
            
            % use coding from getCodingData.
            [streamIdx,eventToCode] = streamSelectorGUI(gv.coding);
            assert(~isempty(streamIdx),'You did not select a stream to code, exiting');
            streams = find(coding.stream.available);
            qGazeCodeStream = isfield(coding.settings.streams{streams(streamIdx)},'tag') && strcmp(coding.settings.streams{streams(streamIdx)}.tag,'gazeCodeStream');
            assert(~isempty(streamIdx)||qGazeCodeStream,'You did not select an event to code, exiting')
            if ~isempty(eventToCode)
                assert(~isempty(gv.coding.type{streamIdx})&&any(gv.coding.type{streamIdx}==eventToCode),'Selected stream does not contain any events of the selected category. Nothing to code. Exiting.')
            end
            
            % ask user where to store coding output
            [outStreamIdx,newStreamName] = outputStreamSelectorGUI(coding,streamIdx);
            assert(~isempty(outStreamIdx),'You did not select a stream for storing coding output, exiting');
            gv.coding.outIdx        = outStreamIdx;
            gv.coding.streamName    = newStreamName;
            % make new coding stream for user's output if wanted
            if outStreamIdx~=streamIdx
                assert(isempty(newStreamName) || gv.coding.outIdx==length(gv.coding.mark)+1,'internal error, contact developer')
                gv.coding.mark{gv.coding.outIdx}    = gv.coding.mark{streamIdx};
                gv.coding.type{gv.coding.outIdx}    = gv.coding.type{streamIdx};
            end
            
            % prep output stream, if not loading and editing existing
            % stream or copying a GazeCode stream
            if outStreamIdx~=streamIdx && ~qGazeCodeStream
                % set everything not of interest to type 1 ('other')
                gv.coding.type{gv.coding.outIdx}(gv.coding.type{gv.coding.outIdx}~=eventToCode) = 1;
                % set everything of interest to type 2 ('uncoded')
                gv.coding.type{gv.coding.outIdx}(gv.coding.type{gv.coding.outIdx}==eventToCode) = 2;
                % merge adjacent, coding should not contain consecutive
                % same events
                iAdj = find(diff(gv.coding.type{gv.coding.outIdx})==0);
                i=length(iAdj);
                while i>0
                    % find start and end of run of adjacent events
                    e = iAdj(i)+1;
                    s = iAdj(i);
                    while i>1&&iAdj(i-1)==s-1
                        i = i-1;
                        s = iAdj(i);
                    end
                    gv.coding.mark{gv.coding.outIdx}(s+1:e) = [];
                    gv.coding.type{gv.coding.outIdx}(s+1:e) = [];
                    i=i-1;
                end
            end
            
            % get start and end marks of those events the user wanted to
            % code
            if outStreamIdx~=streamIdx && ~qGazeCodeStream
                qEvents = gv.coding.type{gv.coding.outIdx}==2;
            else
                % include also already coded events, since we are reloading
                % GazeCode session
                qEvents = gv.coding.type{gv.coding.outIdx}>=2;
            end
            % fmark should contain start and end of each event to code, one
            % after the other
            iEvents = find(qEvents);
            gv.fmark = reshape([gv.coding.mark{gv.coding.outIdx}(iEvents); gv.coding.mark{gv.coding.outIdx}(iEvents+1)]*1000,1,[]);  % s->ms
            
            % only select data from ts > 0, ts is nulled at onset scene camera!
            sel = data.eye.binocular.ts >= data.time.startTime & data.eye.binocular.ts <= data.time.endTime;
            
            gv.datt = data.eye.binocular.ts(sel);
            gv.datx = data.eye.binocular.gp(sel,1);
            gv.daty = data.eye.binocular.gp(sel,2);
            
            gv.datt = gv.datt*1000;
%             gv.datx = gv.datx * data.video.scene.width;
%             gv.daty = gv.daty * data.video.scene.height;
            
        otherwise
            disp('Unknown data type, crashing in 3,2,1,...');
    end
    
    
    fixB = gv.fmark(1:2:end)';
    fixE = gv.fmark(2:2:end)';
    fixD = fixE- fixB;
    
    [temptijd,idxtB,idxfixB] = intersect(gv.datt,fixB);
    xstart = gv.datx(idxtB);
    ystart = gv.daty(idxtB);
    
    [temptijd,idxtE,idxfixE] = intersect(gv.datt,fixE);
    xend = gv.datx(idxtE);
    yend = gv.daty(idxtE);
    
    for p = 1:length(idxtB)
        xmean(p,1) = mean(gv.datx(idxtB(p):idxtE(p)));
        ymean(p,1) = mean(gv.daty(idxtB(p):idxtE(p)));
        
        xsd(p,1) = std(gv.datx(idxtB(p):idxtE(p)));
        ysd(p,1) = std(gv.daty(idxtB(p):idxtE(p)));
    end
    
    fixnr = [1:length(fixB)]';
    fixlabel    = zeros(size(fixnr));
    
    if size(fixB,2) > 1
        fixB = fixB';
        fixE = fixE';
        fixD = fixD';
    end
    
    gv.data = [fixnr, fixB, fixE, fixD, xstart, ystart, xend, yend, xmean, xsd, ymean, ysd, fixlabel];
    gv.maxfix   = max(fixnr);
    
    switch gv.datatype
        case 'Tobii Pro Glasses 2'
            if outStreamIdx==streamIdx || qGazeCodeStream  % TODO: this is specific to Tobii code...
                % when loading existing file, put already coded labels into gv.data
                qWhich = gv.coding.type{gv.coding.outIdx}>1;
                assert(sum(qWhich)==size(gv.data,1),'internal error contact developer')
                gv.data(:,end) = log2(gv.coding.type{gv.coding.outIdx}(qWhich))-1;
                % added such that if previously coded, GazeCode will pickup at the
                % last coded event.
                % JSB: changed for the special case where somebody coded some data,
                % but then resets all to zero and then closes.
                wheretocontinue = find(gv.data(:,end)>1, 1,'last');
                if ~isempty(wheretocontinue) 
                    gv.curfix = wheretocontinue;
                end
            end
        otherwise
            % do nothing
    end
    
    set(hm,'userdata',gv);
    disp('... done');
    
    % determine begin and end frame beloning to fixations start and end
    % times
    switch gv.datatype
        case  'Tobii Pro Glasses 2'
            % use frame time info from GlassesViewer's export
            [gv.bfr,gv.efr] = deal(nan(size(fixB)));
            for p=1:length(fixB)
                if fixB(p) < 0
                    gv.bfr(p) = 1;
                else
                    gv.bfr(p) = find(data.video.scene.fts<=fixB(p)/1000,1,'last');
                end
                gv.efr(p) = find(data.video.scene.fts<=fixE(p)/1000,1,'last');       
            end
        otherwise
            gv.bfr     = floor(fixB/frdur);
            gv.efr     = ceil(fixE/frdur);
    end
    gv.bfr(gv.bfr<1) = 1;
    gv.bfr(gv.bfr>gv.maxframe) = gv.maxframe;
    
    gv.efr(gv.efr<1) = 1;
    gv.efr(gv.efr>gv.maxframe) = gv.maxframe;
    
    % determine the frame between beginning and end frame for a fixations,
    % this one will be displayed
    gv.mfr = floor((gv.bfr+gv.efr)/2);
    
    % needed for marker in scene camera
    gv.fixxpos = xmean;
    gv.fixypos = ymean;
    
    gv.fixxposB = xstart;
    gv.fixyposB = ystart;
    
    gv.fixxposE = xend;
    gv.fixyposE = yend;
    
    set(hm,'userdata',gv);
end

%% start to show the first frame or when reloading the frame last coded.
showmainfr(hm,gv);
set(hm,'Visible','on');

end

% function to attribute a category code to the fixation, this is a function
% of the buttons in the right panel
function labelfix(src,evt)
if isempty(evt)
    categorie = get(src,'userdata');
    rp = get(src,'parent');
    hm = get(rp,'parent');
    gv = get(hm,'userdata');
else
    categorie = get(src,'userdata');
    rp = get(src,'parent');
    hm = get(rp,'parent');
    gv = get(hm,'userdata');
    if gv.data(gv.curfix,end) == categorie
        if categorie ~= 0
            categorie = 0;
        end
    end
end
data = gv.data;
data(gv.curfix,end) = categorie;
switch gv.datatype
    case 'Tobii Pro Glasses 2'
        % put categorie also in coding struct, note that categories are power of 2,
        % and that 1 is "other". categorie 0 ("uncoded") should correspond to code
        % 2, categorie 1 to code 4, etc, so categorie+1 below
        qWhich = gv.coding.mark{gv.coding.outIdx}==gv.fmark(2*gv.curfix-1)/1000;
        assert(sum(qWhich)==1,'Internal error, contact developer')
        gv.coding.type{gv.coding.outIdx}(qWhich) = 2^(categorie+1);
    otherwise
        % nothing
end
gv.data = data;
setlabel(gv);

set(hm,'userdata',gv);
end

% function to show the current frame and fixation being labeled
function showmainfr(hm,gv)
plaat = read(gv.vidObj,gv.mfr(gv.curfix));
imagesc(plaat);
gv.frameas = gca;
axis off;
axis equal;


disp(['Current event: ', num2str(gv.curfix),'/',num2str(gv.maxfix)]);

set(gv.lp,'Title',['Current event: ' num2str(gv.curfix),'/',num2str(gv.maxfix) ]);
hold(gv.frameas,'on');
stip = scatter(gv.fixxpos(gv.curfix),gv.fixypos(gv.curfix),1000,'ro');
set(stip,'MarkerEdgeColor',[0 0.85 1],'MarkerFaceAlpha',.65,'MarkerFaceColor',[0 0.85 1],'LineWidth',2);


hold(gv.frameas,'off');
setlabel(gv);

if isempty(gv.data(:,end)==0)
    msgbox('All fixations of this directory seem to be labeled','Warning','warn');
end

set(hm,'userdata',gv);
end

function setlabel(gv)
if gv.data(gv.curfix,end) > 0
    for p = 1:size(gv.knoppen,2)
        if p == gv.data(gv.curfix,end)
            set(gv.knoppen(p),'backgroundcolor',[1 0.5 0]);
        else
            set(gv.knoppen(p),'backgroundcolor',[1 1 1]);
        end
    end
else
    for p = 1:size(gv.knoppen,2)
        set(gv.knoppen(p),'backgroundcolor',[1 1 1]);
    end
end
end

% function to move one fixation further, function of button in left panel
function playforward(src,evt)
lp = get(src,'parent');
hm = get(lp,'parent');
gv = get(hm,'userdata');

if gv.curfix < gv.maxfix
    gv.curfix = gv.curfix + 1;
    showmainfr(hm,gv);
else
    msgbox('Last fixation reached','Warning','warn');
end
set(hm,'userdata',gv);
end

% function move one fixation back, function of button in left panel
function playback(src,evt)
lp = get(src,'parent');
hm = get(lp,'parent');
gv = get(hm,'userdata');

if gv.curfix > 1
    gv.curfix = gv.curfix - 1;
    showmainfr(hm,gv);
else
    h = msgbox('First fixation reached','Warning','warn');
end
set(hm,'userdata',gv);
end

% function to handle keypresses as shortcuts, function of main screen
function verwerkknop(src,evt)
gv = get(src,'userdata');
switch evt.Key
    case gv.fwdbut
        playforward(findobj('UserData',gv.fwdbut),evt);
    case gv.bckbut
        playback(findobj('UserData',gv.bckbut),evt);
    case gv.cat1but
        labelfix(findobj('UserData',1),evt);
    case gv.cat2but
        labelfix(findobj('UserData',2),evt);
    case gv.cat3but
        labelfix(findobj('UserData',3),evt);
    case gv.cat4but
        labelfix(findobj('UserData',4),evt);
    case gv.cat5but
        labelfix(findobj('UserData',5),evt);
    case gv.cat6but
        labelfix(findobj('UserData',6),evt);
    case gv.cat7but
        labelfix(findobj('UserData',7),evt);
    case gv.cat8but
        labelfix(findobj('UserData',8),evt);
    case gv.cat9but
        labelfix(findobj('UserData',9),evt);
    case gv.catjbut
        welkefix = inputdlg('Jump to which event?','Jump',1,{num2str(gv.curfix)});
        if isempty(welkefix),return,end
        welkefix = str2num(welkefix{:});
        if isnumeric(welkefix)
            if isempty(welkefix)|| welkefix < 1 || welkefix > gv.maxfix
                fprintf('Wrong input! Use numbers between 1 and %d\n',gv.maxfix);
            else
                gv.curfix = welkefix;
                set(src,'userdata',gv);
                showmainfr(src,gv);
            end
        end
    otherwise
        % disp('Unknown key pressed');
end

end

function savetotext(src,evt)
disp('Saving to text...');
mm1 = get(src,'parent');
hm = get(mm1,'parent');
gv = get(hm,'userdata');
switch gv.datatype
    case 'Tobii Pro Glasses 2'
        tempresdir = fullfile(gv.resdir,gv.partName,gv.recName);
        if ~exist(tempresdir)
            mkdir(fullfile(gv.resdir,gv.partName,gv.recName));
        end
        streamName = gv.coding.streamName;
        % remove invalid characters
        streamName = regexprep(streamName,'[^\w\.!@#$^+=-]','_');   % remove characters invalid in Windows filename from stream name
        filenaam = fullfile(gv.resdir,gv.partName,gv.recName,[gv.recName,'_',streamName, '.xls']);
        while exist(filenaam,'file')
            answer = inputdlg(['File: ''', filenaam ,''' already exists. Enter a new file name'],'Warning: file already exists',1,{[gv.recName,'_',streamName,'_01.xls']});
            if isempty(answer)  % to prevent pressing cancel going wrong (TODO, kill cancel button)
                disp('... saving cancelled');
                return; % test this!
            else
                filenaam = fullfile(gv.resdir,gv.partName,gv.recName, answer{1});
            end
        end
    otherwise
        filenaam = fullfile(gv.resdir,[gv.filmnaam '.xls']);
        while exist(filenaam,'file')
            answer = inputdlg(['File: ''', filenaam ,''' already exists. Enter a new file name'],'Warning: file already exists',1,{[gv.filmnaam '_01.xls']});
            if isempty(answer) % to prevent pressing cancel going wrong (TODO, kill cancel button)
                % filenaam = filenaam;
                disp('... saving cancelled');
                return;
            else
                filenaam = fullfile(gv.resdir, answer{1});
            end
        end   
end
fid = fopen(filenaam,'w+');
fprintf(fid,[repmat('%s\t',1,12),'%s\n'],'fix nr','fix start (ms)','fix end (ms)','fix dur (ms)','x start','y start','x end','y end','mean x','sd x','mean y','sd y','label');
fgetl(fid);
fprintf(fid,[repmat('%d\t',1,12),'%d\n'],gv.data');
fclose(fid);
disp('... done');
end

% closing and saving function
function sluitaf(src,evt)
try
    gv = get(src,'userdata');
    knopsluit = questdlg('You''re about to close the program. Are you sure you''re done and want to quit?','Are you sure?','Yes','No','No');
    if strcmp('Yes',knopsluit)
        switch gv.datatype
            case 'Tobii Pro Glasses 2'
                % get gazeCodes for GlasseViewer and write them to a text
                % file
                streamName = gv.coding.streamName;
                % remove invalid characters
                streamName = regexprep(streamName,'[^\w\.!@#$^+=-]','_');   % remove characters invalid in Windows filename from stream name
                fname = fullfile(gv.foldnaam,['gazeCodeCoding_' streamName '.txt']);
                gazecodes = [gv.coding.mark{gv.coding.outIdx}(1:end-1)', gv.coding.type{gv.coding.outIdx}'];
                fid = fopen(fname,'w');    % TODO: unieke naam per stream? lijkt me wel handig
                fprintf(fid,'%f\t%d\n',gazecodes');
                fclose(fid);
                % also store to coding.mat
                % 1. add stream to settings, if needed
                if gv.coding.outIdx>sum(gv.coding.stream.available)
                    str = getCodingStreamSetup(gv.coding.streamName);
                    gv.coding.settings.streams = [gv.coding.settings.streams; str];
                    % 2. add also to coding.stream.available
                    gv.coding.stream.available = [gv.coding.stream.available true];
                end
                % 3. mark and type are already good, we're ready to save
                coding = rmfield(gv.coding,{'outIdx','streamName'});
                save(fullfile(gv.foldnaam,'coding.mat'),'-struct','coding');
            otherwise
                gv = rmfield(gv,'lp');
                save(fullfile(gv.resdir,[gv.filmnaam '.mat']),'gv');
        end
        
        set(src,'closerequestfcn','closereq');
        rmpath(genpath(gv.rootdir),genpath(gv.glassesviewerdir));
        delete(src);
    else
        disp('Program not closed. Continuing.');
    end
catch
    closereq()
end
end


function str = getCodingStreamSetup(name)
str.type        = 'handStream';
str.tag         = 'gazeCodeStream';
str.lbl         = name;
str.locked      = false;
str.categories  = {'other';20;'uncoded';1;'GC1';2;'GC2';3;'GC3';4;'GC4';5;'GC5';6;'GC6';7;'GC7';8;'GC8';9;'GC9';10};
end