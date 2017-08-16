function [on2,off2] = detectswitches(data)
% voer een boolean vector (alleen enen en nullen). 
% als er een serie enen in zit wordt daarvan begin-
% en eindpositie teruggegeven

% voeg nullen aan begin en einde toe, zodat enen in oorspronkelijke
% data file aan begin en einde ook als zodanig worden gevonden
data	= [0 data 0];

% zoek de overgangen mbv de verschuiftruc
data11	= data(1:end-1);
data12	= data(2:end);

numvect	= [1:1:length(data11)];

mdata	= data11 - data12;
on		= mdata == -1;				% deze is een sample te vroeg
off		= mdata == 1;				% deze is goed

on2		= numvect(on);              % corrigeer voor index te vroeg
off2	= numvect(off)-1;
