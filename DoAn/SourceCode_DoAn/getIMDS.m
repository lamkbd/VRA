function [imds]=getIMDS(folder,categories)
    rootFolder=fullfile(folder);
    imds=imageDatastore(fullfile(rootFolder,categories),'LabelSource','foldernames');    
end