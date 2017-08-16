function [fmark] = detectfixaties2015(mvel,f,time)

% opschoonactie
% 16 oktober 2011 IH

thr             = f.thr;
counter         = f.counter;
minfix          = f.minfix;                        % minfix in ms

qvel            = mvel < thr;                      % kijk waar de snelheid kleiner is dan thr
qnotnan         = ~isnan(mvel);
qall            = qnotnan & qvel;
meanvel         = mean(mvel(qall));                % bepaal mean van de velocity tijdens de fixaties
stdvel          = std(mvel(qall));                 % bepaal de std van de velocity tijdens de fixaties

counter         = 0;
oldthr          = 0;
while 1,
    thr2        = meanvel + f.lambda*stdvel;
    qvel        = mvel < thr2;                     % kijk waar de snelheid kleiner is dan thr
    
    if round(thr2) == round(oldthr) | counter == f.counter, % f.counter voor maximaal aantal iteraties
        break;
    end
    meanvel     = mean(mvel(qvel));
    stdvel      = std(mvel(qvel));                 % bepaal de std van de velocity tijdens de fixaties    
    oldthr      = thr2;
    counter     = counter + 1;
end

thr2            = meanvel + 3*stdvel;              % bepaal nieuwe drempel gebaseerd opde ruis in de data
qvel            = mvel < thr2;                     % kijk waar de snelheid kleiner is dan thr
[on,off]        = detectswitches(qvel');           % bepaal fixaties

on              = time(on);                        % converteer naar tijd
off             = time(off);                       % converteer naar tijd

qfix            = off - on > minfix;               % kijk waar de kleine fixaties zitten       
on              = on(qfix);                        % gooi de fixaties kleiner dan minfix eruit
off             = off(qfix);                       % gooi de fixaties kleiner dan minfix eruit

on(2:end)       = on(2:end);                       % 
off(1:end-1)    = off(1:end-1);                    % 

fmark           = sort([on;off]);                  % gooi de markers op volgorde achter elkaar
