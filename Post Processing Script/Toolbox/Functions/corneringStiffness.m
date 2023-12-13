%% 'corneringStiffness.m' function: calculates the cornering stiffness

function [valueCS] = corneringStiffness(dataElab,dataTest,slope)
    itCS      = 0;
    checkCS   = 0;
    % Cutting the slip angle signal to get the interval defined by the
    % operator for the calculation of the cornering stiffness
    if slope > 0
        while checkCS < 2
            itCS = itCS + 1;
            if dataElab.alphaFy(itCS) > -dataTest.alphaCut && checkCS == 0
                tLWCS     = dataElab.time(itCS);
                posLWCS   = itCS;
                checkCS   = 1;
            elseif dataElab.alphaFy(itCS) > dataTest.alphaCut && checkCS == 1
                tRWCS     = dataElab.time(itCS);
                posRWCS   = itCS;
                checkCS   = 2;
            end
        end
    elseif slope < 0
        while checkCS < 2
            itCS = itCS + 1;
            if dataElab.alphaFy(itCS) < dataTest.alphaCut && checkCS == 0
                tLWCS     = dataElab.time(itCS);
                posLWCS   = itCS;
                checkCS   = 1;
            elseif dataElab.alphaFy(itCS) < -dataTest.alphaCut && checkCS == 1
                tRWCS     = dataElab.time(itCS);
                posRWCS   = itCS;
                checkCS   = 2;
            end
        end
    end
    dataCS.time         = dataElab.time(posLWCS:posRWCS);
    dataCS.Fy           = dataElab.Fy(posLWCS:posRWCS);
    dataCS.alpha        = dataElab.alpha(posLWCS:posRWCS);
    % Calculating the Cornering Stiffness through interpolation
    p1                  = polyfit(dataCS.alpha,dataCS.Fy,2);
    f1                  = polyval(p1,dataCS.alpha);
    valueCS             = p1(2);
    % Print the cornering stiffness value to screen   
    disp(['The cornering stiffness value found from the fitting of Fy is of:',num2str(valueCS)])
end