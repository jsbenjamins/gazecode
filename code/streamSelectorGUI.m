function [stream,eventCat] = streamSelectorGUI(coding)

% panel layout:
%%%%%%%
% () stream 1
% () stream 2
% () stream N
%%%%%%%
% if not a gazeCode stream, then:
% for selected stream, show categories, user needs to select one also
%%%%%%%

nStream         = length(coding.mark);
qGazeCodeStream = cellfun(@(x) isfield(x,'tag') && strcmp(x.tag,'gazeCodeStream'),coding.settings.streams);
qGazeCodeStream(~coding.stream.available) = [];
% get names of code categories for each stream
names(~qGazeCodeStream) = arrayfun(@(x)getCodeCategories(coding,x),find(~qGazeCodeStream),'uni',false);
[names{qGazeCodeStream}]= deal({'This is a GazeCode stream, no need to select anything here to modify or review it'});
% get number of characters in longest stream label
nCharS = max(cellfun(@length,coding.stream.lbls));
% get number of characters for each code category label
nCharC = cellfun(@(x) cellfun(@length,x),names,'uni',false);
nCharC = max(cat(1,nCharC{:}));

selector   = dialog('WindowStyle', 'normal', 'Position',[100 100 200 200],'Name','Select an event stream to code/review','Visible','off');
selector.UserData.catNames = names;

% create panel
marginsP = [3 3];
marginsB = [2 5 5];   % horizontal: [margin from left edge, margin between radiobutton and text, vertical item spacing]
buttonSz = [80 24];


% temp uipanel because we need to figure out size of margins
temp    = uipanel('Units','pixels','Position',[10 10 400 400],'title','Xxj','Parent',selector);

% temp checkbox and label because we need their sizes too
% use largest label
h= uicomponent('Style','radiobutton', 'Parent', temp,'Units','pixels','Position',[10 10 400 100], 'String',repmat('m',1,max([nCharS nCharC])));
drawnow
% get sizes, delete
relExt      = h.Extent; relExt(3) = relExt(3)+15;    % radiobutton not counted in, guess a bit safe
off         = [temp.InnerPosition(1:2)-temp.Position(1:2) temp.Position(3:4)-temp.InnerPosition(3:4)];
delete(temp);

% determine size of popup
rowWidth        = marginsB(1)*2+marginsB(2)+relExt(3);
panelWidth      = rowWidth+ceil(off(3));
popUpWidth      = panelWidth+marginsP(1)*2;
% determine height of two panels (stream selector, code cat selector)
rowHeight       = relExt(4) + marginsB(3);
panelHeight(1)  = rowHeight*nStream + nStream*2*marginsB(3);
nCodeCatMax     = max(cellfun(@length,names));
panelHeight(2)  = rowHeight*nCodeCatMax + nCodeCatMax*2*marginsB(3);
% popup height
popUpHeight     = sum(panelHeight)+ 2*ceil(off(4)) + 3*marginsP(2)+buttonSz(2);

selector.UserData.relExt    = relExt;
selector.UserData.marginsB  = marginsB;

% determine position and create in right size
scrSz = get(0,'ScreenSize');
pos = [(scrSz(3)-popUpWidth)/2 (scrSz(4)-popUpHeight)/2 popUpWidth popUpHeight];
selector.Position = pos;

% create button
selector.UserData.button = uicontrol(...
    'Style','pushbutton','Tag','executeReload','Position',[3+marginsB(1) marginsP(2) buttonSz],...
    'Callback',@(hBut,~) buttonClick(hBut),'String','Use selection',...
    'Parent',selector);

% create panels
selector.UserData.streamPanel = uipanel('Units','pixels','Position',[marginsP(1) 2*marginsP(2)+buttonSz(2)+ceil(off(4))+panelHeight(2) panelWidth panelHeight(1)],'Parent',selector,'title','select event stream');
selector.UserData.catPanel    = uipanel('Units','pixels','Position',[marginsP(1) 2*marginsP(2)+buttonSz(2)                             panelWidth panelHeight(2)],'Parent',selector,'title','select event category to code');

% make items in stream selector panel
for s=1:nStream
    p=nStream-s;
    selector.UserData.streamPanelItems(s)  = uicomponent('Style','radiobutton', 'Parent', selector.UserData.streamPanel,'Units','pixels','Position',[3 p*(relExt(4)+2*marginsB(3)) + marginsB(3) 200 20], 'String',coding.stream.lbls{s},'Value',false, 'Callback',@(src,~) changeEventStream(src,selector));
end
selector.UserData.catPanelItems = gobjects(0);
selector.UserData.nCodeCatMax   = nCodeCatMax;

selector.Visible = 'on';
uiwait(selector);

if ishghandle(selector)
    stream = find([selector.UserData.streamPanelItems.Value]);
    if ~isempty(stream)
        eventCat = 2^(find([selector.UserData.catPanelItems.Value])-1); % this is safe because the flag fields removed above are always the last in the code cats. Else store a look up table somewhere and use that
    end
else
    [stream,eventCat] = deal([]);
end

delete(selector);
end

function changeEventStream(src,selector)
% see which was selected
qSel = selector.UserData.streamPanelItems==src;
% make sure others are not selected
[selector.UserData.streamPanelItems(~qSel).Value] = deal(false);

% delete all current category panel items
delete(selector.UserData.catPanelItems);
selector.UserData.catPanelItems(:) = [];
% make new ones
if selector.UserData.streamPanelItems(qSel).Value
    names = selector.UserData.catNames{qSel};
    for s=1:length(names)
        p=selector.UserData.nCodeCatMax-s;
        selector.UserData.catPanelItems(s)  = uicomponent('Style','radiobutton', 'Parent', selector.UserData.catPanel,'Units','pixels','Position',[3 p*(selector.UserData.relExt(4)+2*selector.UserData.marginsB(3)) + selector.UserData.marginsB(3) selector.UserData.relExt(3) 20], 'String',names{s},'Value',false, 'Callback',@(src,~) changeEventCat(src,selector));
    end
end
end

function changeEventCat(src,selector)
% see which was selected
qSel = selector.UserData.catPanelItems==src;
% make sure others are not selected
[selector.UserData.catPanelItems(~qSel).Value] = deal(false);
end

function buttonClick(~)
uiresume;
end

function names = getCodeCategories(coding,idx)
% this skips flag fields and for names removes the flag-possible indicator
names = coding.codeCats{idx}(:,1);
for p=length(names):-1:1
    if names{p}(1) == '*'
        names(p) = [];
    elseif names{p}(end) == '+'
        names{p}(end) = [];
    end
end
end