%% 'averagingData.m' function: averaging the selected tests (if 'Average' analysis type is chosen) 

function [averaged] = averagingData(dataCut,dataTest)
    % Built a new overall time vector
    fn          = fieldnames(dataCut);
    maxlength   = 0;
    for mm = 1:numel(fn)
        newLength = length(dataCut.(fn{mm}).time);
        if newLength > maxlength
            maxlength   = newLength;
        end
        averaged.time = (0:1/dataTest.fsamp:1/dataTest.fsamp*(maxlength - 1))';
    end
    % Defines vectors
    toAverage.Fw1       = [];
    toAverage.Fw2       = [];
    toAverage.Fsteer    = [];
    toAverage.Fz        = [];
    toAverage.alpha     = [];    
    % Making all the tests of the same length
    for mm = 1:numel(fn)
        evalLength = length(dataCut.(fn{mm}).time);
        if evalLength < maxlength
            deltalength             = maxlength - evalLength;           
            toAdd.Fw1               = dataCut.(fn{mm}).Fw1(end).*ones(1,deltalength)';
            dataCut.(fn{mm}).Fw1    = [dataCut.(fn{mm}).Fw1; toAdd.Fw1];
            toAdd.Fw2               = dataCut.(fn{mm}).Fw2(end).*ones(1,deltalength)';
            dataCut.(fn{mm}).Fw2    = [dataCut.(fn{mm}).Fw2; toAdd.Fw2];          
            toAdd.Fsteer            = dataCut.(fn{mm}).Fsteer(end).*ones(1,deltalength)';
            dataCut.(fn{mm}).Fsteer = [dataCut.(fn{mm}).Fsteer; toAdd.Fsteer];            
            toAdd.Fz                = dataCut.(fn{mm}).Fz(end).*ones(1,deltalength)';
            dataCut.(fn{mm}).Fz     = [dataCut.(fn{mm}).Fz; toAdd.Fz];
            toAdd.alpha             = dataCut.(fn{mm}).alpha(end).*ones(1,deltalength)';
            dataCut.(fn{mm}).alpha  = [dataCut.(fn{mm}).alpha; toAdd.alpha];
        end
        toAverage.Fw1       = [toAverage.Fw1; dataCut.(fn{mm}).Fw1]; 
        toAverage.Fw2       = [toAverage.Fw2; dataCut.(fn{mm}).Fw2]; 
        toAverage.Fsteer    = [toAverage.Fsteer; dataCut.(fn{mm}).Fsteer]; 
        toAverage.Fz        = [toAverage.Fz; dataCut.(fn{mm}).Fz];
        toAverage.alpha     = [toAverage.alpha; dataCut.(fn{mm}).alpha];
    end
    % Performing the average
    for oo = 1:maxlength
        averaged.Fw1(oo,1)       = mean(toAverage.Fw1(oo,:)); 
        averaged.Fw2(oo,1)       = mean(toAverage.Fw2(oo,:)); 
        averaged.Fsteer(oo,1)    = mean(toAverage.Fsteer(oo,:)); 
        averaged.Fz(oo,1)        = mean(toAverage.Fz(oo,:));
        averaged.alpha(oo,1)     = mean(toAverage.alpha(oo,:));
    end
end