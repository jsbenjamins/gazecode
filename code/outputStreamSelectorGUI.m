function [stream,name] = outputStreamSelectorGUI(coding,codeStreamIdx)

% can only overwrite/continue GazeCode streams
% so shows list of selectable GazeCode streams, plus a textbox to write
% name of new stream

qGazeCodeStream = cellfun(@(x) isfield(x,'tag') && strcmp(x.tag,'gazeCodeStream'),coding.settings.streams);
qGazeCodeStream(~coding.stream.available) = [];
% get number of characters in longest stream label
nCharS = max(cellfun(@length,coding.stream.lbls(qGazeCodeStream)));
if isempty(nCharS)
    nCharS = 1;
end
streamIdxs = [find(qGazeCodeStream); length(qGazeCodeStream)+1];

selector   = dialog('WindowStyle', 'normal', 'Position',[100 100 200 200],'Name','Select where to store coding output','Visible','off');


% create panel
marginsB = [2 5 5];   % horizontal: [margin from left edge, margin between radiobutton and text, vertical item spacing]
buttonSz = [80 24];
textBoxSz= [220 20];


% temp checkbox and label because we need their sizes too
% use largest label
h  = uicomponent('Style','radiobutton', 'Parent', selector,'Units','pixels','Position',[10 10 400 100], 'String',repmat('m',1,max(nCharS)));
drawnow
% get sizes, delete
textSz      = h.Extent; textSz(3) = textSz(3)+15;    % radiobutton not counted in, guess a bit safe
delete(h);

% determine size of popup
rowWidth        = marginsB(1)*2+marginsB(2)+max([textSz(3),textBoxSz(1)+15+marginsB(2)]);
popUpWidth      = rowWidth;
% determine height of popup
rowHeight       = max([textSz(4) textBoxSz(2)]) + marginsB(3);
nRow            = sum(qGazeCodeStream)+1;
popUpHeight     = rowHeight*nRow + nRow*2*marginsB(3) + buttonSz(2);

% determine position and create in right size
scrSz = get(0,'ScreenSize');
pos = [(scrSz(3)-popUpWidth)/2 (scrSz(4)-popUpHeight)/2 popUpWidth popUpHeight];
selector.Position = pos;

% create button
selector.UserData.button = uicontrol(...
    'Style','pushbutton','Tag','executeReload','Position',[3+marginsB(1) marginsB(3) buttonSz],...
    'Callback',@(hBut,~) buttonClick(hBut),'String','Use selection',...
    'Parent',selector);

% make items in popup
for s=1:nRow
    p=nRow-s;
    if p>0
        lbl = coding.stream.lbls{streamIdxs(s)};
    else
        lbl = '';
    end
    selector.UserData.streamItems(s)  = uicomponent('Style','radiobutton', 'Parent', selector,'Units','pixels','Position',[3 p*(textSz(4)+2*marginsB(3)) + 2*marginsB(3)+buttonSz(2) 200 20], 'String',lbl,'Value',false, 'Callback',@(src,~) changeEventStream(src,selector));
    if streamIdxs(s)==codeStreamIdx
        selector.UserData.streamItems(s).FontWeight = 'bold';
    end
    if p==0
        selector.UserData.editBox = uicomponent('Style','edit', 'Parent', selector,'Units','pixels','Position',[3+15+marginsB(2) 2*marginsB(3)+buttonSz(2) textBoxSz], 'String','change me!','HorizontalAlignment','left','KeyPressFcn',@(src,~) editBoxCB(src,selector));
    end
end
if nRow==1 && isscalar(selector.UserData.streamItems)
    % preselect if only one possible output, else easy to click button
    % without selection causing execution to stop
    selector.UserData.streamItems.Value = 1;
end

selector.Visible = 'on';
uiwait(selector);

if ishghandle(selector)
    name = '';
    stream = find([selector.UserData.streamItems.Value]);
    if ~isempty(stream)
        if stream==nRow
            name = selector.UserData.editBox.String;
        end
        stream = streamIdxs(stream);
    end
else
    [stream,name] = deal([],'');
end

delete(selector);
end

function changeEventStream(src,selector)
% see which was selected
qSel = selector.UserData.streamItems==src;
% make sure others are not selected
[selector.UserData.streamItems(~qSel).Value] = deal(false);
end

function editBoxCB(~,selector)
% make sure editbox item is selected
selector.UserData.streamItems(end).Value = true;
% make sure others are not selected
[selector.UserData.streamItems(1:end-1).Value] = deal(false);
end

function buttonClick(~)
uiresume;
end