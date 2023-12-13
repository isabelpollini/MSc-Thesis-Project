clc
clear
close all

% Word setting
addpath(genpath('Plots\'))
load('schwalbe_T03R01.mat');
word                                = actxserver('Word.Application');               %start Word
word.Visible                        = 1;                                            %make Word Visible
document                            = word.Documents.Open([pwd,'\template.docx']);  %create new Document
selection                           = word.Selection;                               %set Cursor
selection.Font.Name                 = 'Times New Roman';                            %set Font
selection.Font.Size                 = 12;                                           %set Size
selection.GoToNext('wdGoToPage');
selection.MoveDown(5,43);
selection.ParagraphFormat.Alignment = 3;
  
% Parameters
vecP        = [300 400 500];
vecFz       = [343 404 488];
vecCamber   = [0 5 -5];
tireBrand   = 'schwalbe';
tireCode    = 'T03';
rimCode     = 'R01';

fzString = [];
for xx = 1:length(vecFz)
    if vecFz(xx) == vecFz(end)
        fzString = [fzString, num2str(vecFz(xx)),'N'];
    else
        fzString = [fzString, num2str(vecFz(xx)),'N, '];
    end
end

camString = [];
for xx = 1:length(vecCamber)
    if vecCamber(xx) == vecCamber(end)
        camString = [camString, num2str(vecCamber(xx)),'N'];
    else
        camString = [camString, num2str(vecCamber(xx)),'N, '];
    end
end

pString = [];
for xx = 1:length(vecP)
    if vecP(xx) == vecP(end)
        pString = [pString, num2str(vecP(xx)),'N'];
    else
        pString = [pString, num2str(vecP(xx)),'N, '];
    end
end

% Load variation: Lateral force
selection.InsertBreak;
selection.Font.Bold = 1; 
selection.TypeText('Results: Load variation');         
selection.TypeParagraph;  
selection.TypeText('Lateral force'); 
selection.Font.Bold = 0;
selection.TypeParagraph;

figN = 1;
tabN = 1;

for ii = 1:length(vecP)
    p = vecP(ii);
    for jj = 1:length(vecCamber)
        cam = vecCamber(jj);
        if cam < 0
            signString  = 'meno';
            signS       = ' - ';
        else 
            signString  = '';
            signS       = '';
        end
        camberString    = strcat(signString,num2str(abs(cam)));
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphJustify';
        selection.TypeText(['Lateral force in function of the side slip angle, for pressure equal to ',...
            num2str(p),' kPa, camber equal to ', num2str(cam),'° and varying vertical load Fz = (',...
            fzString,') ']);
        selection.Font.Italic = 1;
        selection.TypeText(['(Figure ',num2str(figN),')']);
        selection.TypeParagraph;
        selection.TypeParagraph;
        emfName         = [tireBrand,'_',tireCode,rimCode,'_',num2str(p),'kPa_Fy_camber_',num2str(cam),'°.emf'];
        emfPath         = [pwd,'\Plots\emf\',emfName]; 
        selection.InlineShapes.AddPicture(emfPath);
        selection.TypeText(['Figure ',num2str(figN)])
        selection.Font.Italic = 0;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        selection.TypeParagraph;
        selection.TypeParagraph;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphJustify';
        selection.TypeText(['In order to have a better understanding of the Figure ',num2str(figN),...
            ', the values of the lateral force for side slip angles of 4° and -4° are collected in Table '...
            num2str(tabN),'.']);
        selection.TypeParagraph;
        sz              = 2*length(vecFz) + 1;
        selection.TypeParagraph;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        word.ActiveDocument.Tables.Add(word.Selection.Range,sz,5);
        selection.TypeText("Inflation Pressure [kPa]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Vertical Load [N]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Camber [°]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Side slip angle [°]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Fz [N]");
        selection.MoveRight(12,1,0);

        for kk1 = 1:length(vecFz)
            Fz          = vecFz(kk1);
            fieldname   = strcat('Fz_',num2str(Fz),'_camber_',camberString); 
            tab         = avgStorage(jj,kk1,ii).(fieldname).tab;
            selection.TypeText(num2str(p));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(Fz));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(cam));
            selection.MoveRight(12,1,0);
            selection.TypeText('4');
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(round(tab.FyP4,1)));
            selection.MoveRight(12,1,0);
        end

        for kk2 = 1:length(vecFz)
            Fz              = vecFz(kk2);
            fieldname       = strcat('Fz_',num2str(Fz),'_camber_',camberString); 
            tab             = avgStorage(jj,kk2,ii).(fieldname).tab;
            selection.TypeText(num2str(p));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(Fz));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(cam));
            selection.MoveRight(12,1,0);
            selection.TypeText('-4');
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(round(tab.FyN4,1)));
            if Fz == vecFz(end)
                tableObj = word.ActiveDocument.Tables.Item(6 + figN);
                tableObj.Borders.Enable = 1;
                selection.MoveDown(5,1);
            else
                selection.MoveRight(12,1,0);
            end
        end
        selection.Font.Italic = 1;
        selection.TypeText(['Table ',num2str(tabN)])
        selection.Font.Italic = 0;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        selection.TypeParagraph;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphJustify';
        figN = figN + 1;
        tabN = tabN + 1;
        selection.InsertBreak;
    end
end

selection.TypeText('[Insert tables and considerations on cornering stiffness (only for varying Fz and P) here.]');
selection.InsertBreak;

% Load variation: Self-aligning moment
selection.Font.Bold = 1;        
selection.TypeText('Self-aligning moment'); 
selection.Font.Bold = 0;
selection.TypeParagraph;


for ii = 1:length(vecP)
    p = vecP(ii);
    for jj = 1:length(vecCamber)
        cam = vecCamber(jj);
        if cam < 0
            signString  = 'meno';
            signS       = ' - ';
        else 
            signString  = '';
            signS       = '';
        end
        camberString    = strcat(signString,num2str(abs(cam)));
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphJustify';
        selection.TypeText(['Self-aligning moment in function of the side slip angle, for pressure equal to ',...
            num2str(p),' kPa, camber equal to ', num2str(cam),'° and varying vertical load Fz = (',...
            fzString,') ']);
        selection.Font.Italic = 1;
        selection.TypeText(['(Figure ',num2str(figN),')']);
        selection.TypeParagraph;
        selection.TypeParagraph;
        emfName         = [tireBrand,'_',tireCode,rimCode,'_',num2str(p),'kPa_Mz_camber_',num2str(cam),'°.emf'];
        emfPath         = [pwd,'\Plots\emf\',emfName]; 
        selection.InlineShapes.AddPicture(emfPath);
        selection.TypeParagraph;
        selection.TypeText(['Figure ',num2str(figN)])
        selection.Font.Italic = 0;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        selection.TypeParagraph;
        selection.TypeParagraph;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphJustify';
        selection.TypeText(['In order to have a better understanding of the Figure ',num2str(figN),...
            ', the peak values of the self-aligning moment and the relative values of side slip angles are collected in Table '...
            num2str(tabN),'.']);
        selection.TypeParagraph;
        sz = 2*length(vecFz) + 1;
        selection.TypeParagraph;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        word.ActiveDocument.Tables.Add(word.Selection.Range,sz,5);
        selection.TypeText("Inflation Pressure [kPa]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Vertical Load [N]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Camber [°]");
        selection.MoveRight(12,1,0);
        selection.TypeText('alpha Mz_max [°]');
        selection.MoveRight(12,1,0);
        selection.TypeText("Mz_max [N]");
        selection.MoveRight(12,1,0);

        for kk1 = 1:length(vecFz)
            Fz          = vecFz(kk1);
            fieldname   = strcat('Fz_',num2str(Fz),'_camber_',camberString); 
            tab         = avgStorage(jj,kk1,ii).(fieldname).tab;
            selection.TypeText(num2str(p));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(Fz));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(cam));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(round(tab.alphaMzMin,1)));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(round(tab.MzMin,1)));
            selection.MoveRight(12,1,0);
        end

        for kk2 = 1:length(vecFz)
            Fz              = vecFz(kk2);
            fieldname       = strcat('Fz_',num2str(Fz),'_camber_',camberString); 
            tab             = avgStorage(jj,kk2,ii).(fieldname).tab;
            selection.TypeText(num2str(p));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(Fz));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(cam));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(round(tab.alphaMzMax,1)));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(round(tab.MzMax,1)));
            if Fz == vecFz(end)
                tableObj = word.ActiveDocument.Tables.Item(6 + figN);
                tableObj.Borders.Enable = 1;
                selection.MoveDown(5,1);
            else
                selection.MoveRight(12,1,0);
            end
        end
        selection.Font.Italic = 1;
        selection.TypeText(['Table ',num2str(tabN)])
        selection.Font.Italic = 0;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        selection.TypeParagraph;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphJustify';
        figN = figN + 1;
        tabN = tabN + 1;
        selection.InsertBreak;
    end
end

% Camber variation: Lateral force
selection.Font.Bold = 1; 
selection.TypeText('Results: Camber variation');         
selection.TypeParagraph;  
selection.TypeText('Lateral force'); 
selection.Font.Bold=0;
selection.TypeParagraph; 

for ii = 1:length(vecP)
    p = vecP(ii);
    for jj = 1:length(vecFz)
        fz = vecFz(jj);
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphJustify';
        selection.TypeText(['Lateral force in function of the side slip angle, for pressure equal to ',...
            num2str(p),' kPa, vertical load  Fz = ', num2str(fz),'N and varying camber gamma = (',...
            camString,') ']);
        selection.Font.Italic = 1;
        selection.TypeText(['(Figure ',num2str(figN),')']);
        selection.TypeParagraph;
        selection.TypeParagraph;
        emfName         = [tireBrand,'_',tireCode,rimCode,'_',num2str(p),'kPa_Fy_Fz_',num2str(fz),'N.emf'];
        emfPath         = [pwd,'\Plots\emf\',emfName]; 
        selection.InlineShapes.AddPicture(emfPath);
        selection.TypeText(['Figure ',num2str(figN)])
        selection.Font.Italic = 0;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        selection.TypeParagraph;
        selection.TypeParagraph;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphJustify';
        selection.TypeText(['In order to have a better understanding of the Figure ',num2str(figN),...
            ', the values of the lateral force for side slip angles of 2° and -2° are collected in Table '...
            num2str(tabN),'.']);
        selection.TypeParagraph;
        sz = 2*length(vecFz) + 1;
        selection.TypeParagraph;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        word.ActiveDocument.Tables.Add(word.Selection.Range,sz,5);
        selection.TypeText("Inflation Pressure [kPa]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Vertical Load [N]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Camber [°]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Side slip angle [°]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Fz [N]");
        selection.MoveRight(12,1,0);
        
        for kk1 = 1:length(vecCamber)
            cam         = vecCamber(kk1);
            if cam < 0
                signString  = 'meno';
                signS       = ' - ';
            else 
                signString  = '';
                signS       = '';
            end
            camberString    = strcat(signString,num2str(abs(cam)));
            fieldname   = strcat('Fz_',num2str(fz),'_camber_',camberString); 
            tab         = avgStorage(kk1,jj,ii).(fieldname).tab;
            selection.TypeText(num2str(p));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(Fz));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(cam));
            selection.MoveRight(12,1,0);
            selection.TypeText('2');
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(round(tab.FyP4,1)));
            selection.MoveRight(12,1,0);
        end

        for kk2 = 1:length(vecCamber)
            cam         = vecCamber(kk2);
            if cam < 0
                signString  = 'meno';
                signS       = ' - ';
            else 
                signString  = '';
                signS       = '';
            end
            camberString    = strcat(signString,num2str(abs(cam)));
            fieldname       = strcat('Fz_',num2str(fz),'_camber_',camberString); 
            tab             = avgStorage(kk2,jj,ii).(fieldname).tab;
            selection.TypeText(num2str(p));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(Fz));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(cam));
            selection.MoveRight(12,1,0);
            selection.TypeText('-2');
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(round(tab.FyN4,1)));
            if cam == vecCamber(end)
                tableObj = word.ActiveDocument.Tables.Item(6 + figN);
                tableObj.Borders.Enable = 1;
                selection.MoveDown(5,1);
            else
                selection.MoveRight(12,1,0);
            end 
        end
        selection.Font.Italic = 1;
        selection.TypeText(['Table ',num2str(tabN)])
        selection.Font.Italic = 0;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        selection.TypeParagraph;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphJustify';
        figN = figN + 1;
        tabN = tabN + 1;
        selection.InsertBreak;
    end
end

selection.TypeText(['Insert tables and considerations on cornering stiffness '... 
     ' (for varying Fz, P and camber) here.']);
selection.InsertBreak;

% Camber variation: Self-aligning moment
selection.Font.Bold = 1;   
selection.TypeText('Self-aligning moment'); 
selection.Font.Bold = 0;
selection.TypeParagraph;


for ii = 1:length(vecP)
    p = vecP(ii);
    for jj = 1:length(vecFz)
        fz = vecFz(jj);
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphJustify';
        selection.TypeText(['Self-aligning moment in function of the side slip angle, for pressure equal to ',...
            num2str(p),' kPa, camber equal to ', num2str(cam),'° and varying vertical load Fz = (',...
            fzString,') ']);
        selection.Font.Italic = 1;
        selection.TypeText(['(Figure ',num2str(figN),')']);
        selection.TypeParagraph;
        selection.TypeParagraph;
        emfName         = [tireBrand,'_',tireCode,rimCode,'_',num2str(p),'kPa_Mz_Fz_',num2str(fz),'N.emf'];
        emfPath         = [pwd,'\Plots\emf\',emfName]; 
        selection.InlineShapes.AddPicture(emfPath);
        selection.TypeText(['Figure ',num2str(figN)])
        selection.Font.Italic = 0;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        selection.TypeParagraph;
        selection.TypeParagraph;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphJustify';
        selection.TypeText(['In order to have a better understanding of the Figure ',num2str(figN),...
            ', the peak values of the self-aligning moment and the relative values of side slip angles are collected in Table '...
            num2str(tabN),'.']);
        selection.TypeParagraph;
        sz = 2*length(vecFz) + 1;
        selection.TypeParagraph;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        word.ActiveDocument.Tables.Add(word.Selection.Range,sz,5);
        selection.TypeText("Inflation Pressure [kPa]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Vertical Load [N]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Camber [°]");
        selection.MoveRight(12,1,0);
        selection.TypeText("alpha Mz_max [°]");
        selection.MoveRight(12,1,0);
        selection.TypeText("Mz_max [N]");
        selection.MoveRight(12,1,0);
        
        for kk1 = 1:length(vecCamber)
            cam         = vecCamber(kk1);
            if cam < 0
                signString  = 'meno';
                signS       = ' - ';
            else 
                signString  = '';
                signS       = '';
            end
            camberString    = strcat(signString,num2str(abs(cam)));
            fieldname   = strcat('Fz_',num2str(fz),'_camber_',camberString); 
            tab         = avgStorage(kk1,jj,ii).(fieldname).tab;
            selection.TypeText(num2str(p));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(Fz));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(cam));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(round(tab.alphaMzMin,1)));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(round(tab.MzMin,1)));
            selection.MoveRight(12,1,0);
        end

        for kk2 = 1:length(vecCamber)
            cam         = vecCamber(kk2);
            if cam < 0
                signString  = 'meno';
                signS       = ' - ';
            else 
                signString  = '';
                signS       = '';
            end
            camberString    = strcat(signString,num2str(abs(cam)));
            fieldname       = strcat('Fz_',num2str(fz),'_camber_',camberString); 
            tab             = avgStorage(kk2,jj,ii).(fieldname).tab;
            selection.TypeText(num2str(p));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(Fz));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(cam));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(round(tab.alphaMzMax,1)));
            selection.MoveRight(12,1,0);
            selection.TypeText(num2str(round(tab.MzMax,1)));
            if cam == vecCamber(end)
                tableObj = word.ActiveDocument.Tables.Item(6 + figN);
                tableObj.Borders.Enable = 1;
                selection.MoveDown(5,1);
            else
                selection.MoveRight(12,1,0);
            end
        end
        selection.Font.Italic = 1;
        selection.TypeText(['Table ',num2str(tabN)])
        selection.Font.Italic = 0;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        selection.TypeParagraph;
        selection.TypeParagraph;
        selection.ParagraphFormat.Alignment = 'wdAlignParagraphJustify';
        figN = figN + 1;
        tabN = tabN + 1;
        selection.InsertBreak;
    end
end

selection.TypeText(['Insert tables and considerations on eventual other analysis if present,'... 
     ' and finally add some conclusions here.']);

% Auto-save and close

cSave   = menu('Do you want to save the report?','Yes','No');

if cSave == 1
    document.SaveAs2([pwd,'/',tireBrand,tireCode,rimCode,'.docx']); %save Document
else
end

cClose  = menu('Do you want to close the report?','Yes','No');

if cClose == 1
    word.Quit();                                                    %close Word
else
end




