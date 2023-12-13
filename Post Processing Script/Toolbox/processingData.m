%% 'processingData.m': elaboration of the DAT file inside the for-loop

% Get camber sign
if dataTest.camber < 0
    signString  = 'meno';
    camberAbs   = abs(dataTest.camber);
else 
    signString  = '';
    camberAbs   = dataTest.camber;
end

% Automatic struct field name creation
filename    = strcat(num2str(tireBrand),'_',num2str(tireCode),num2str(rimCode),...
              '_',num2str(dataTest.p),'kPa_Fz_',num2str(dataTest.Fz0),'_camber_',...
               num2str(signString),num2str(camberAbs),'*.dat');
fpattern    = fullfile('input',filename);
files       = dir(fpattern);

for ii = 1 : length(files)
    testname = strcat('test',num2str(ii));
    tests.(testname) = load(files(ii).name);
end

% Comparison between tests with same parameters 
% Plot for-loop 
for jj = 1:length(files)
    d       = load(files(jj).name);

    % Subtracting zero file
    d(:,1)  = d(:,1) - mean(zero(:,2));
    d(:,2)  = d(:,2) - mean(zero(:,3));  
    
    % Filtering
    d       = idfilt(d,4,dataTest.fcut*2/1612,'Noncausal');
    
    % Quick data elaboration
    time    = (0:1/dataTest.fsamp:1/dataTest.fsamp*(size(d,1) - 1))';  
    Fw1     = d(:,1)*100/1.953821*9.81*1000;        % FWatt1 [N]
    Fw2     = d(:,2)*100/1.953821*9.81*1000;        % FWatt2 [N]
    alpha   = d(:,5);                               % Slip angle [deg]
    Fwatt   = Fw2 - Fw1;

    % Plots
    legendinfo{jj} = num2str(jj);

    subplot(2,1,1)
    plot(time,Fwatt)
    hold on
    grid on
    ylabel('F_w_a_t_t [N]')
    title('F Watt')
    legend(legendinfo)

    subplot(2,1,2)
    plot(time,alpha)
    hold on
    grid on
    ylabel('\alpha [deg]')
    title('Slip angle')
    legend(legendinfo)
end

% Analysis type selector
choice1 = menu('Analysis type:','Single Test','Average');
if choice1 == 1                                     % Choice: 'Single Test'
    % Single test selector
    choice2     = menu('Which test?',legendinfo);   
    it          = 0;
    check       = 0;
    while check == 0 
        it = it + 1;     
        if choice2 == it
            % Loading the selected test
            fieldname1              = strcat('test',num2str(it));
            analysing.(fieldname1)  = tests.(fieldname1);
            check                   = 1;        
        end
    end
else                                                % Choice: 'Average'
    n               = numel(fieldnames(tests));
    fiGUI           = uifigure('Position',[650 250 300 300]);
    lbl             = uilabel(fiGUI);
    
    % Tests to average selector
    lbl.Text        = 'Choose which tests to average:'; 
    lbl.Position    = [30 215 200 100];
    lbl.FontSize    = 13;
    cbx             = zeros(n,1);    
    for ii = 1:n
        h           = 210 - (ii - 1)*22;
        cbx(ii,1)   = uicheckbox(fiGUI,'Position',[55 h 102 15],...
                     'Text',strcat('Test',num2str(ii)));  
    end     
    cbxAll  = uicheckbox(fiGUI,'Position',[55 (h - 22) 102 15],...
                  'Text',strcat('All'));  
    b       = uibutton(fiGUI,'push','ButtonPushedFcn',@(b,event) buttonPushed(b,cbx,cbxAll,tests,n,fiGUI));
    b.Text  = 'Confirm';   
    uiwait(fiGUI)
    load('analysing.mat')
end
close all

% Filter data
[dataF]     = filterData(dataTest,analysing,zero);

% Select only the interesting part of the test
[dataCut]   = cuttingData(dataF,slope);

% Averaging
[averaged]  = averagingData(dataCut,dataTest);

% Calculation of the wanted physical quantities
if dataTest.camber == 0
    shift = [];
end
[dataElab,shift]  = calcs(averaged,dataKin,dataVetyt,dataTest,slope,shift);

% Cornering stiffess calculation
[valueCS]   = corneringStiffness(dataElab,dataTest,slope);
dataElab.cs = valueCS; 

% Delete temporary files
if exist('Toolbox\Temp\analysing.mat','file')
    delete 'Toolbox\Temp\analysing.mat'
end
clear tests legendinfo analysing

% Callback function for the push button
function buttonPushed(~,cbx,cbxAll,tests,n,fiGUI)
    allToggle = get(cbxAll,'Value');
    if allToggle == 0
         for ii = 1:n
            toggle = get(cbx(ii,1),'Value');
            if toggle == 1
                fieldname2              = strcat('test',num2str(ii));
                analysing.(fieldname2)  = tests.(fieldname2);
            end
         end
    else
        for jj = 1:n
            fieldname2              = strcat('test',num2str(jj));
            analysing.(fieldname2)  = tests.(fieldname2);
        end
    end
    save('Toolbox/Temp/analysing','analysing')    
    uiresume(fiGUI)
    close(fiGUI)
end
