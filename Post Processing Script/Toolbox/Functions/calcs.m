%% 'calcs.m' function: performs all needed calculations

function [dataElab,shift] = calcs(averaged,dataKin,dataVetyt,dataTest,slope,shift)
    % Getting kinematinc data and acquired signals in the correct units
    braccio     = dataKin(5,:);
    ALPHA       = dataKin(6,:);
    Fw1         = averaged.Fw1*100/1.953821*9.81*1000;     % Measured Watt Linkage force (1) [N]                                                           
    Fw2         = averaged.Fw2*100/1.953821*9.81*1000;     % Measured Watt Linkage force (2) [N]
    Fsteer      = averaged.Fsteer*50/2.0037*9.81*1000;     % Measured steering force [N]
    Fvert       = averaged.Fz*250/1.9968*9.81*1000;        % Measured vertical force [N]
    alpha       = averaged.alpha;                          % Measured slip angle [°]
    Fw          = Fw2 - Fw1;   
    % Getting the steering arm correspondent to each slip angle [mm]
    arm = [];
    for jj = 1:length(alpha)
        arm(jj)     = braccio(1);
        error_alpha = abs(ALPHA(1) - alpha(jj));
        for kk = 2:length(ALPHA)
            if abs(ALPHA(kk) - alpha(jj)) < error_alpha
                arm(jj)     = braccio(kk);
                error_alpha = abs(ALPHA(kk) - alpha(jj));
            end
        end
    end
    arm     = arm';                                   
    % Lateral force developed in the tyre (correction pneumatic trail) [N]
    Fy      = (Fw.*dataVetyt.L + Fsteer.*arm)./(dataVetyt.L2.*cos(alpha.*pi/180));   
    trail   = Fsteer.*arm./Fy;                           % Pneumatic trail length [mm]                                                                     
    Mz      = Fsteer.*arm./1000;                         % Self-aligning moment [N.m]
    % Fy corrections
    if dataTest.camber == 0
        [v1,idxFy]          = min(abs(Fy - 0));
        alphaA              = alpha(idxFy);
        shift.alphaA        = alphaA;
        dataElab.alphaFy    = alpha - alphaA;
    else 
        dataElab.alphaFy    = alpha - shift.alphaA;
    end     
    % Cut alpha vector for Mz correction
    alpha_Mz    = alpha - dataTest.Mz_x0;
    Mz          = Mz - dataTest.Mz_y0;
    check   = 0;        
    it      = 0;
    if slope > 0
        while check < 2
            it = it + 1;
            if alpha_Mz(it) > -3 && check == 0
                posLW_Mz   = it;
                check      = 1;
            elseif alpha_Mz(it) > 3 && check == 1
                posRW_Mz   = it;
                check      = 2;
            end
        end
    elseif slope < 0
        while check < 2
            it = it + 1;
            if alpha_Mz(it) < 4 && check == 0
                posLW_Mz   = it;
                check      = 1;
            elseif alpha_Mz(it) < -4 && check == 1
                posRW_Mz   = it;
                check      = 2;
            end
        end
    end
    alpha_Mz    = alpha(posLW_Mz:posRW_Mz);
    Mzcut       = Mz(posLW_Mz:posRW_Mz);
    % Mz correction
    if dataTest.camber == 0
        meanMz              = 0.5*(max(Mzcut) + min(Mzcut));
        [v2,idxMz]          = min(abs(Mzcut - meanMz));
        shift.meanMz        = meanMz; 
        alphaB              = alpha(posLW_Mz + idxMz - 1);
        shift.alphaB        = alphaB;
        dataElab.alphaMz    = alpha - alphaB;
    else
        dataElab.alphaMz    = alpha - shift.alphaB;
    end
    % Vertical force corrected due to camber
    if dataTest.camber >= 0
        Fz = (Fvert + Fy*sin(abs(dataTest.camber*pi/180)) - ...
            dataVetyt.m_wheel*dataVetyt.g*cos(abs(dataTest.camber*pi/180)))/...
            cos(abs(dataTest.camber*pi/180));               
    else
        Fz = (Fvert - Fy*sin(abs(dataTest.camber*pi/180)) - ...
            dataVetyt.m_wheel*dataVetyt.g*cos(abs(dataTest.camber*pi/180)))/...
            cos(abs(dataTest.camber*pi/180));
    end
    % Building the 'dataElab' struct   
    dataElab.time       = averaged.time;
    dataElab.Fw1        = Fw1;
    dataElab.Fw2        = Fw2;
    dataElab.Fw         = Fw;
    dataElab.Fsteer     = Fsteer;
    dataElab.Fz         = Fz;
    dataElab.alpha      = alpha;
    dataElab.Mz         = Mz;
    dataElab.Fy         = Fy;
end