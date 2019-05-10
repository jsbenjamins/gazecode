function coding = addGazeCodeToCoding(labels,coding,classNum)


coding.fileOrClass(6) = true;
coding.mark{6} = coding.mark{classNum};
coding.type{6} = coding.type{classNum};
coding.type{6}((coding.type{6}==4)) = -1;
coding.type{6}((coding.type{6}==2)) = labels;

coding.codeCats{6}{1,1} = 'GC0';
coding.codeCats{6}{2,1} = 'GC1';
coding.codeCats{6}{3,1} = 'GC2';
coding.codeCats{6}{4,1} = 'GC3';
coding.codeCats{6}{5,1} = 'GC4';
coding.codeCats{6}{6,1} = 'GC5';
coding.codeCats{6}{7,1} = 'GC6';
coding.codeCats{6}{8,1} = 'GC7';
coding.codeCats{6}{9,1} = 'GC8';
coding.codeCats{6}{10,1} = 'GC9';

coding.codeCats{6}{1,2} = 0;
coding.codeCats{6}{2,2} = 1;
coding.codeCats{6}{3,2} = 2;
coding.codeCats{6}{4,2} = 3;
coding.codeCats{6}{5,2} = 4;
coding.codeCats{6}{6,2} = 5;
coding.codeCats{6}{7,2} = 6;
coding.codeCats{6}{8,2} = 7;
coding.codeCats{6}{9,2} = 8;
coding.codeCats{6}{10,2} = 9;


coding.codeColors{6}{1} = [128 128 128];
coding.codeColors{6}{2} = [255 0 0];
coding.codeColors{6}{3} = [0 255 0];
coding.codeColors{6}{4} = [0 0 255];
coding.codeColors{6}{5} = [255 100 100];
coding.codeColors{6}{6} = [100 255 100];
coding.codeColors{6}{7} = [100 100 255];
coding.codeColors{6}{8} = [255 150 150];
coding.codeColors{6}{9} = [150 255 150];
coding.codeColors{6}{10} = [150 150 255];
