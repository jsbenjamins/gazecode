load('../results/2022-12-20-12-56-29/2022-12-20-12-56-29.mat')

figure;
ax1 = subplot(2,1,1);
plot(gv.datt,gv.datx,'r-');
hold on

for a=1:numel(gv.mfr)
    st = gv.datwt(gv.bfr(a));
    mt = gv.datwt(gv.mfr(a));
    et = gv.datwt(gv.efr(a));

    plot([st mt et],[gv.fixxposB(a) gv.fixxpos(a) gv.fixxposE(a)],'k.-')
end

xlabel('Time (ms)')
ylabel('Horizontal position (pix)')

ax2 = subplot(2,1,2);
plot(gv.datt,gv.daty,'b-')
hold on

for a=1:numel(gv.mfr)
    st = gv.datwt(gv.bfr(a));
    mt = gv.datwt(gv.mfr(a));
    et = gv.datwt(gv.efr(a));

    plot([st mt et],[gv.fixyposB(a) gv.fixypos(a) gv.fixyposE(a)],'k.-')
end

xlabel('Time (ms)')
ylabel('Vertical position (pix)')

linkaxes([ax1 ax2],'x')