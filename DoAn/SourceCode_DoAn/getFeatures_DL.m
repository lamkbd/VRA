function [featuresData,lblData]=getFeatures_DL(folder,categories)
    rootFolder=fullfile(folder);
    imdsData=imageDatastore(fullfile(rootFolder,categories),'LabelSource','foldernames');
    imdsData.ReadFcn=@(filename)readAndPreprocessImage(filename);
    %Dung deep learning de rut trich dac trung 
    %Install AlexNet Network support package
    net=alexnet();
    featureLayer='fc7';
    featuresData=activations(net,imdsData,featureLayer);
    %featuresData=activations(net,imdsData,featureLayer,'MiniBatchSize',32,'OutputAs','columns');  
    lblData=imdsData.Labels;        
end