%% 'filterData.m' function: filtering all selected data

function [dataFilt] = filterData(dataTest,analysing,comp)
    % Filtering process for all of the selected tests
    fn = fieldnames(analysing);
    for ii = 1:numel(fn)
        test            = analysing.(fn{ii});
        time            = (0:1/dataTest.fsamp:1/dataTest.fsamp*(size(test,1)-1))';    % Time vector of the test [s]
        timecomp        = (0:1/dataTest.fsamp:1/dataTest.fsamp*(size(comp,1)-1))';    % Time vector of the compensation test [s]
        test            = [time,test];
        comp            = [timecomp,comp];
        % Subtracting the zero values to the signals
        test(:,1)       = test(:,1);                                % Time [s]
        test(:,2)       = test(:,2) - mean(comp(:,2));              % Measured Watt Linkage force (1) [mV]
        test(:,3)       = test(:,3) - mean(comp(:,3));              % Measured Watt Linkage force (2) [mV]
        test(:,4)       = test(:,4) - mean(test(1:1000,4));         % Measured steering force [mV]
        test(:,5)       = test(:,5) - mean(comp(:,5));              % Measured vertical force [mV]
        test(:,6)       = test(:,6);                                % Measured slip angle [°]
        % Filtering the signals
        dataFiltered    = idfilt(test,4,dataTest.fcut*2/1612,'Noncausal');
        % Create the dataFilt struct, which stores all the data as
        % subfields of the struct fields which represent the analysed
        % tests.
        dataFilt.(fn{ii}).time   = dataFiltered(:,1);
        dataFilt.(fn{ii}).Fw1    = dataFiltered(:,2);
        dataFilt.(fn{ii}).Fw2    = dataFiltered(:,3);
        dataFilt.(fn{ii}).Fsteer = dataFiltered(:,4);
        dataFilt.(fn{ii}).Fz     = dataFiltered(:,5);
        dataFilt.(fn{ii}).alpha  = dataFiltered(:,6);
    end
end