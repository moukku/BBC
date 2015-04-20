% Optimize ORI between OCT and HISTO

%edit calculateORI.m

pathtodata='C:\Users\spvaanan\Unison\work\Autoscore_software\';

catheder_diameter_mm=0.9;



%% Check for which images both ORI and HISTO are  defined 0
[~,OCTname]=xlsread('Matching images with scores.xlsx','Scores','AS2:AS96');
[~,Histonametmp]=xlsread('Matching images with scores.xlsx','Scores','AW2:AW96');
scoreallHISTO=xlsread('Matching images with scores.xlsx','Scores','V2:V96');
scoreallHISTO=(scoreallHISTO);
scoreallOCT=xlsread('Matching images with scores.xlsx','Scores','AR2:AR96');
scoreallOCT=(scoreallOCT);

VetMeanHISTOscore=xlsread('Matching images with scores.xlsx','Scores','V2:V96');
VetMeanOSTscore=xlsread('Matching images with scores.xlsx','Scores','AR2:AR96');

OCTORI=xlsread('Matching images with scores.xlsx','Scores','AT2:AT96');
OCTlesiondepthratio=xlsread('Matching images with scores.xlsx','Scores','AU2:AU96');

HISTOORI=xlsread('Matching images with scores.xlsx','Scores','AX2:AX96');
HISTOlesiondepthratio=xlsread('Matching images with scores.xlsx','Scores','AY2:AY96');

%OCTscore
OCTscore=NaN(size(VetMeanHISTOscore));

OCTscore(OCTlesiondepthratio>0.5)=3;
OCTscore(OCTlesiondepthratio<0.5&OCTlesiondepthratio>0.1)=2;

OCTORI2=OCTORI;
OCTORI2(~isnan(OCTscore))=NaN;
mm=minmax(OCTORI2');

thresh=diff(mm)/2+mm(1);

OCTscore(OCTORI2>thresh)=1;
OCTscore(OCTORI2<=thresh)=0;


%HISTO score
HISTOscore=NaN(size(VetMeanHISTOscore));

HISTOscore(HISTOlesiondepthratio>0.5)=3;
HISTOscore(HISTOlesiondepthratio<0.5&HISTOlesiondepthratio>0.1)=2;

HISTOORI2=HISTOORI;
HISTOORI2(~isnan(HISTOscore))=NaN;
mm=minmax(HISTOORI2');

thresh=diff(mm)/2+mm(1);

HISTOscore(HISTOORI2>thresh)=1;
HISTOscore(HISTOORI2<=thresh)=0;

%Plot
subplot(1,3,1)
plot(VetMeanHISTOscore,VetMeanOSTscore,'*')

subplot(1,3,2)
plot(VetMeanHISTOscore,OCTscore,'*')

subplot(1,3,3)
plot(VetMeanHISTOscore,HISTOscore,'*')


pathtodata='C:\Users\spvaanan\Unison\work\Autoscore_software\';


 
 
 
