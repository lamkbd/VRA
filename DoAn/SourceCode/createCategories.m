function createCategories()  
    if ~exist('DataTrain', 'dir') 
        CreateDataTrain();
    end
    if ~exist('DataTest', 'dir')
        CreateDataTest();
    end
end