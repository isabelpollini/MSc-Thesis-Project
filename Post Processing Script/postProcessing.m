%% Post Processing: main script

% Environment Preparation
clc
clear
close all
fclose('all');
set(0,'DefaultFigureWindowStyle','normal')
set(groot,'defaultfigureposition',[300 150 900 550])
set(groot,'DefaultAxesFontSize',11)
% Adding folders to the path
addpath('input\')
addpath(genpath('Toolbox\'))
% Input data
measuringData
kinematicData
tireBrand               = 'scalato';
tireCode                = 'T05';
rimCode                 = 'R01';
slope                   = 1;
% IMPORTANT: 0 must always be the first element in the camberVals vector
camberVals              = [0 -5 5];             % Camber angle [°]
loadVals                = [343 404 488];        % Static force [N]
dataTest.p              = 400;                  % Pressure [kPa]
dataTest.alphaCut       = 1;                    % Cut-off slip angle [°]
dataVetyt.m_wheel       = 12.73;                % Mass shaft+fork+wheel [kg]
% Loading the zero file corresponding to the test session
zero                    = load(['zero_22_11_2022.dat']); 
% Generate struct containing all averaged and wanted data
initChoice = menu('Do you want to use previously saved data?','Yes','No');
if initChoice == 1
    load(uigetfile('*.mat'));
else
    avgStorage = repmat(struct(),length(camberVals),length(loadVals));   
    for iii = 1:length(loadVals)
        dataTest.Fz0 = loadVals(iii);
        for jjj = 1:length(camberVals)
            dataTest.camber = camberVals(jjj);
            disp([dataTest.Fz0 dataTest.camber])
            % Running processingData script to obtaine the elaborated
            % test data
            processingData
            % Storing all the elaborated data into the 'avgStorage' struct
            fieldname = strcat('Fz_',num2str(dataTest.Fz0),'_camber_',...
            num2str(signString),num2str(camberAbs));        
            avgStorage(jjj,iii).(fieldname) = dataElab;                  
        end
    end
    % Saving the struct
    choice = menu('Do you want to save the elaborated data?','Yes','No');
    if choice == 1
        stdFilename = strcat(num2str(tireBrand),'_',num2str(tireCode),num2str(rimCode),'.mat');
        save(uiputfile('*.*','File Selection',stdFilename),'avgStorage');
    end 
end
% Interactive selector to choose the analysis type (load variation, camber
% variation, cornering stiffness, all)
selectorGUI
% Loading file containing the operator choice
load('selector.mat')
% Actuating the selection
% VARYING LOAD
if selector(1) == 1 || selector(4) == 1         
    % Plot varying load
    for ww = 1:length(camberVals)
        camber = camberVals(ww);
        if camber < 0
            signString  = 'meno';
            signS       = ' - ';
        else 
            signString  = '';
            signS       = '';
        end
        camberString    = strcat(signString,num2str(abs(camber)));        
        % Plot Mz
        figure('Name',strcat('Mz: camber=',num2str(camber),'°'),'Color','w')        
        for xx = 1:length(loadVals)
            Fz              = loadVals(xx);    
            fieldname       = strcat('Fz_',num2str(Fz),'_camber_',...
                            camberString); 
            toPlot          = avgStorage(ww,xx).(fieldname); 
            legendinfoA{xx} = ['Fz = ',num2str(Fz),'N'];            
            plot(toPlot.alphaMz,toPlot.Mz)
            hold on
            grid on
            title('Self-aligning moment vs slip angle')
            subtitle(['P = ',num2str(dataTest.p),'kPa, ','\gamma = ',signS,num2str(abs(camber)),'°'])
            xlim([-4 4])
            ylim([-6 6])
            xlabel('\alpha [deg]')
            ylabel('M_z [Nm]')
            legend(legendinfoA)
        end
        % Plot Fy
        figure('Name',strcat('Fy: camber=',num2str(camber),'°'),'Color','w')
        for xx = 1:length(loadVals)
            Fz              = loadVals(xx);    
            fieldname       = strcat('Fz_',num2str(Fz),'_camber_',...
                            camberString); 
            toPlot          = avgStorage(ww,xx).(fieldname); 
            legendinfoB{xx} = ['F_z = ',num2str(Fz),'N'];            
            plot(toPlot.alphaFy,toPlot.Fy)
            hold on
            grid on
            title('Lateral force vs slip angle')
            subtitle(['P = ',num2str(dataTest.p),'kPa, ','\gamma = ',signS,num2str(abs(camber)),'°'])
            xlim([-7 7])
            ylim([-500 500])
            xlabel('\alpha [deg]')
            ylabel('F_y [N]')
            legend(legendinfoB,'Location','southeast')
        end
    end
end
% VARYING CAMBER
if selector(2) == 1 || selector(4) == 1
    % plot varying camber
    for ww = 1:length(loadVals)
        Fz = loadVals(ww);
        % Plot Mz
        figure('Name',strcat('Mz: Fz=',num2str(Fz),'N'),'Color','w')
        for xx = 1:length(camberVals)
            camber = camberVals(xx);
            if camber < 0
                signString  = 'meno';
            else 
                signString  = '';
            end
            camberString    = strcat(signString,num2str(abs(camber)));            
            fieldname       = strcat('Fz_',num2str(Fz),'_camber_',...
                            camberString); 
            toPlot          = avgStorage(xx,ww).(fieldname); 
            legendinfoC{xx} = ['\gamma = ',num2str(camber),'°'];            
            plot(toPlot.alphaMz,toPlot.Mz)
            hold on
            grid on
            title('Self-aligning moment vs slip angle')
            subtitle(['P = ',num2str(dataTest.p),'kPa, ','F_z = ',num2str(Fz),'N'])
            xlim([-4 4])
            ylim([-6 6])
            xlabel('\alpha [deg]')
            ylabel('M_z [Nm]')
            legend(legendinfoC)
        end
        % Plot Fy
        figure('Name',strcat('Fy: Fz=',num2str(Fz),'N'),'Color','w')
        for xx = 1:length(camberVals)
            camber = camberVals(xx);
            if camber < 0
                signString  = 'meno';
            else 
                signString  = '';
            end
            camberString    = strcat(signString,num2str(abs(camber)));            
            fieldname       = strcat('Fz_',num2str(Fz),'_camber_',...
                            camberString); 
            toPlot          = avgStorage(xx,ww).(fieldname); 
            legendinfoD{xx} = ['\gamma = ',num2str(camber),'°'];
            plot(toPlot.alphaFy,toPlot.Fy)
            hold on
            grid on
            title('Lateral force vs slip angle')
            subtitle(['P = ',num2str(dataTest.p),'kPa, ','F_z = ',num2str(Fz),'N'])
            xlim([-7 7])
            ylim([-500 500])
            xlabel('\alpha [deg]')
            ylabel('F_y [N]')
            legend(legendinfoD,'Location','southeast')
        end
    end
end
% Generate Cornering Stiffness table 
if selector(3) == 1 || selector(4) == 1
    CS          = zeros(length(camberVals),length(loadVals));
    varNames    = {'camber'};
    for ww = 1:length(loadVals)
        Fz          = loadVals(ww);
        varNames    = [varNames strcat('Fz',num2str(Fz))];
        for xx = 1:length(camberVals)
            camber = camberVals(xx);
            if camber < 0
                signString  = 'meno';
            else 
                signString  = '';
            end
            camberString    = strcat(signString,num2str(abs(camber)));
            
            fieldname       = strcat('Fz_',num2str(Fz),'_camber_',...
                            camberString); 
            CS(xx,ww)       = avgStorage(xx,ww).(fieldname).cs;
        end
    end
    csTable = array2table([camberVals' CS],'VariableNames',varNames);
end 
delete 'Toolbox\Temp'\selector.mat
% Automatic saving
if selector(1) == 1 || selector(2) == 1 || selector(3) == 1
    choice5 = menu('Do you want to save the plots?','Yes','No');     
    if choice5 == 1
        % Generating Plots folder
        if ~exist('Plots', 'dir')
            mkdir('Plots');
        end
        % Generating fig folder
        if ~exist('Plots/fig', 'dir')
            mkdir('Plots/fig');
        end
        % Generating emf folder
        if ~exist('Plots/emf', 'dir')
            mkdir('Plots/emf');
        end
        
        folderName_fig  = 'Plots/fig';
        folderName_jpg  = 'Plots/JPG/';
        figList         = findobj(allchild(0), 'flat', 'Type', 'figure');
        for iFig = 1:length(figList)
            % Generating plot name
            figHandle   = figList(iFig);
            figName     = strrep(strrep(get(figHandle, 'Name'),': ','_'),'=','_');
            fileName    = [num2str(tireBrand),'_',num2str(tireCode),num2str(rimCode),...
                        '_',num2str(dataTest.p),'kPa_',figName];
            % Saving fig
            savefig(figHandle, fullfile(folderName_fig, fileName));
            % Saving emf
            exportgraphics(figHandle, [folderName_jpg, fileName,'.emf'],'ContentType','vector')
        end
    end
end
