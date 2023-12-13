%% 'cuttingData.m' function: cutting the acquisition data to focus only on the interesting interval

function [dataCut] = cuttingData(dataF,slope)
    fn = fieldnames(dataF);
    for kk = 1:numel(fn)
        % Defining useful data
        dataFilt            = dataF.(fn{kk}); 
        alphaDot            = diff(dataFilt.alpha)./diff(dataFilt.time);
        alphaDot(end + 1)   = alphaDot(end);        
        n       = length(dataFilt.time);
        it      = 0;
        check1  = 0;
        check2  = 0;
        dataFilt.Fw      = dataFilt.Fw2 - dataFilt.Fw1;      
        % Getting the peak slip angle values position in the vector
        if slope > 0                % check on the slip angle signal slope
            while check1 < 2
                it = it + 1;
                if alphaDot(it) > 0.3 && check1 == 0
                    posLW   = it;
                    check1  = 1;
                elseif alphaDot(it) < 0 && check1 == 1
                    posRW   = it;
                    check1  = 2;
                end
            end
        elseif slope < 0        
            while check1 < 2
                it = it + 1;
                if alphaDot(it) < -0.3 && check1 == 0
                    tLW     = dataFilt.time(it);
                    posLW   = it;
                    check1   = 1;
                elseif alphaDot(it) > 0 && check1 == 1
                    tRW     = dataFilt.time(it);
                    posRW   = it;
                    check1   = 2;
                end
            end
        end        
        % Defining the cut vectors       
        dataCut.(fn{kk}).time    = dataFilt.time(posLW:posRW);
        dataCut.(fn{kk}).Fw1     = dataFilt.Fw1(posLW:posRW);
        dataCut.(fn{kk}).Fw2     = dataFilt.Fw2(posLW:posRW);
        dataCut.(fn{kk}).Fsteer  = dataFilt.Fsteer(posLW:posRW);
        dataCut.(fn{kk}).Fz      = dataFilt.Fz(posLW:posRW);
        dataCut.(fn{kk}).alpha   = dataFilt.alpha(posLW:posRW);
        dataCut.(fn{kk}).alphaog = dataFilt.alpha;
    end
end