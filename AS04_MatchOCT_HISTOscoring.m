%Match OCT and HISTO data

  pathtodata='C:\Users\spvaanan\Unison\work\Autoscore_software\';


OCTvsHISTOfilename={
'NM101 MC3M Frame 6'	'NM10MC3M'
'NM102 P1M Frame 7'	'NM10P1M'
'NM103 SR Frame 9'	'NM10SR'
'NM104 MC3L Frame 1'	'NM10MC3L'
'NM105 P1L Frame 3'	'NM10P1L'
'NM111 MC3M Frame 1'	'NM11MC3M'
'NM112 P1M Frame 1 '	'NM11P1M'
'NM113 SR Frame 18'	'NM11SR'
'NM114 MC3L Frame 1'	'NM11MC3L'
'NM115 P1L Frame 1'	'NM11P1L'
'NM121 Frame 18'	'NM12MC3M'
'NM122 Frame 14'	'NM12P1M'
'NM123 Frame 1'	'NM12P1L'
'NM124 Frame 9'	'NM12SR'
'NM125 Frame 7'	'NM12MC3L'
'NM131 MC3MAA Frame 11'	'NM13MC3MAA'
'NM132 P1M Frame 1'	'NM13MC3MAA'%HISTO ADDED
'NM133 SR Frame 26'	'NM13SR'
'NM134 MC3L Frame 8'	'NM13MC3L'
'NM135 P1L 1st Frame 12'	'NM13P1L'
'NM136 MC3M Frame 1'	'NM13MC3M'
'NM151 MC3L Frame 9'	'NM15MC3L'
'NM152 P1L Frame 11'	'NM15MC3L'%HISTO ADDED
'NM153SR frame13'	'NM15SR'
'NM154 MC3M 1st Frame 11'	'NM15MC3M'
'NM154 MC3MP Frame 9'	'NM15MC3MP'
'NM155 P1M Frame 14'	'NM15P1M'
'NM156 SRL 2nd Frame 1'	'NM15SRL'
'NM161 MC3M 3th Frame 1'	'NM15SRL'%HISTO ADDED
'NM162 P1M Frame 1'	'NM16P1M'
'NM163 SR Frame 1'	'NM16SR'
'NM164 MC3L Frame 1'	'NM16MC3L'
'NM165 P1L Frame 3'	'NM16P1L'
'NM166 SRL frame 4'	'NM16SRL'
'NM191 Frame 1'	'NM19MC3L'
'NM192 Frame 7'	'NM19P1L'
'NM193 SR Frame 1'	'NM19SR'
'NM193 SRP 3 frame 36'	'NM19SRP'
'NM194 Frame 5'	'NM19MC3M'
'NM195 Frame 11'	'NM19P1M'
'NM211 MC3L rec5 Frame 20'	'NM21MC3L'
'NM212 P1L Frame 25'	'NM21MC3L' %HISTO ADDED
'NM212 P1L retake frame 6'	'NM21P1L'
'NM213 SR Frame 17'	'NM21SR'
'NM214 Frame 5'	'NM21MC3M'
'NM215 Frame 35'	'NM21MC3M' %HISTO ADDED
'NM215 P1M retake Frame 8'	'NM21P1M'
'NM221 MC3M Frame 17'	'NM22MC3M'
'NM222 P1M Frame 1'	'NM22P1M'
'NM223 SR Frame 35'	'NM22SR'
'NM224 MC3L Frame 1'	'NM22MC3L'
'NM225 P1L Frame 6'	'NM22P1L'
'NM231 MC3L 2nd Frame 1'	'NM23MC3L'
'NM232 P1L 1st Frame 10'	'NM23P1L'
'NM233 SR Frame 1'	'NM23SR'
'NM234 MC3M Frame 1'	'NM23MC3M'
'NM235 P1M Frame 1'	'NM23P1M'
'NM236 MC3LAA Frame 1'	'NM23MC3LAA'
'NM241 MC3M Frame 7'	'NM24MC3M'
'NM242 P1M 2nd Frame 8'	'NM24P1M'
'NM243 SR Frame 1'	'NM24SR'
'NM244 MC3L Frame 16'	'NM24MC3L'
'NM245 P1L Frame 1'	'NM24P1L'
'NM245 P1L Frame 1'	'NM24SRP'  %OCT ADDED
'NM251 MC3M Frame 2'	'NM25MC3M'
'NM252 P1M Frame 9'	'NM25P1M'
'NM253 SR Frame 49'	'NM25SR'
'NM254 MC3L Frame 23'	'NM25MC3L'
'NM255 P1L Frame 16'	'NM25P1L'
'NM261 Frame 8'	'NM26MC3M'
'NM262 Frame 1'	'NM26P1M'
'NM263 SR Frame 1'	'NM26SR'
'NM264 Frame 2'	'NM26MC3L'
'NM265 Frame 1'	'NM26P1L'
'NM271 MC3LAA Frame 1'	'NM27MC3LAA'
'NM272 SR Frame 13'	'NM27SR'
'NM273 Frame 1'	'NM27P1M'
'NM274 Frame 1'	'NM27MC3L'
'NM275 SRP OCD2 Frame 27'	'NM27SRP'
'NM277 Frame 1'	'NM27P1L'
'NM278 Frame 1'	'NM27MC3M'
'NM278 Frame 1'	'NM27EX'  %OCT ADDED
'NM301 P1M Frame 4'	'NM30P1M'
'NM302 SR Frame 1'	'NM30SR'
'NM303 MC3L Frame 1'	'NM30MC3L'
'NM304 P1L Frame 1'	'NM30P1L'
'NM305 MC3M Frame 1'	'NM30MC3M'
'NM311 MC3M Frame 1'	'NM31MC3M'
'NM312 P1M 2nd Frame 11'	'NM31P1M'
'NM313 SR Frame 17'	'NM31SR'
'NM314 MC3L Frame 1'	'NM31MC3L'
'NM315 P1L 1st Frame 12'	'NM31P1L'
'NM331 MC3LAA Frame 17'	'NM33MC3LAA'
'NM332 P1L 2nd Frame 6'	'NM33P1L'
'NM333 SR Frame 1'	'NM33SR'
'NM334 MC3M 2nd Frame 8'	'NM33MC3M'
'NM335 P1M 2nd Frame 3'	'NM33P1M'
'NM336 MC3L Frame 1'	'NM33MC3L'
'NM81 MC3M Frame 10'	'NM8MC3M'
'NM82 P1M Frame 1'	'NM8P1M'
'NM83 SR Frame 6'	'NM8SR'
'NM84 MC3L Frame 12'	'NM8MC3L'
'NM85 P1L Frame 1'	'NM8P1L'
};
 

%Get scoring for both files:
fid=1;
fid=fopen('Matched_OCT_HISTO_ORI_Lesiondepth.csv','w');
fprintf(fid,'OCT filename,OCT ORI,OCT lesiondepthratio,OCT lesiondepthmm,HISTO filename,HISTO ORI,HISTO lesiondepthratio,HISTO lesiondepthmm\n');

for ii=1:length(OCTvsHISTOfilename)

    sOCT=load([pathtodata,'autoscore_debugdata_',OCTvsHISTOfilename{ii,1},'.mat'],'OCTROI_ORI',...
        'OCTROI_lesiondepthratio','OCTROI_lesiondepthmm');
    
    sHISTO=load([pathtodata,'autoscore_HISTO_',OCTvsHISTOfilename{ii,2},'.mat'],'HISTROI_ORI',...
        'HISTROI_lesiondepthratio','HISTROI_lesiondepthmm');
    
    %Write to csv file
    %('OCT ORI, OCT lesiondepthratio, OCT lesiondepthmm,HISTO ORI, HISTO lesiondepthratio, HISTO lesiondepthmm\n')
    fprintf(fid,'%s,%8.6f,%8.6f,%8.6f,%s,%8.6f,%8.6f,%8.6f\n',...
        OCTvsHISTOfilename{ii,1},...
        sOCT.OCTROI_ORI,sOCT.OCTROI_lesiondepthratio,sOCT.OCTROI_lesiondepthmm,...
        OCTvsHISTOfilename{ii,2},...
        sHISTO.HISTROI_ORI,sHISTO.HISTROI_lesiondepthratio,sHISTO.HISTROI_lesiondepthmm);
end
fclose(fid)

fid=1;
fid=fopen('Matched_OCT_HISTO_ORI_LesiondepthPAIR.csv','w');
fprintf(fid,'OCT filename,HISTO filename,OCT ORI (mm),HISTO ORI (mm),OCT lesiondepthratio,HISTO lesiondepthratio,OCT lesiondepth (mm),HISTO lesiondepth (mm)\n');

for ii=1:length(OCTvsHISTOfilename)

    sOCT=load([pathtodata,'autoscore_debugdata_',OCTvsHISTOfilename{ii,1},'.mat'],'OCTROI_ORI',...
        'OCTROI_lesiondepthratio','OCTROI_lesiondepthmm');
    
    sHISTO=load([pathtodata,'autoscore_HISTO_',OCTvsHISTOfilename{ii,2},'.mat'],'HISTROI_ORI',...
        'HISTROI_lesiondepthratio','HISTROI_lesiondepthmm');
    
    %Write to csv file
    %('OCT ORI, OCT lesiondepthratio, OCT lesiondepthmm,HISTO ORI, HISTO lesiondepthratio, HISTO lesiondepthmm\n')
    fprintf(fid,'%s,%s,%8.6f,%8.6f,%8.6f,%8.6f,%8.6f,%8.6f\n',...
        OCTvsHISTOfilename{ii,1},...
        OCTvsHISTOfilename{ii,2},...
        sOCT.OCTROI_ORI,sHISTO.HISTROI_ORI,...
        sOCT.OCTROI_lesiondepthratio,sHISTO.HISTROI_lesiondepthratio,...
        sOCT.OCTROI_lesiondepthmm,sHISTO.HISTROI_lesiondepthmm);
end
fclose(fid)

