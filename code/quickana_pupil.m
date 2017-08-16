clear all; close all; clc;

load pupil

data = [fixnr(:,1), categorie];

overeen = 0;
for p = 1:length(data)
    if data(p,2) == data(p,3)
        overeen = overeen + 1;
        matchen(p,1) = overeen;
    else
        matchen(p,1) = overeen;
    end
end

plot(data(:,1),matchen,'kd');
axis([0 length(data) 0 length(data)])