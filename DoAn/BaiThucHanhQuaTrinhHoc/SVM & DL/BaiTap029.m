function BaiTap029()
    %Nap du lieu tap train
    rootFolder=fullfile('BagOfWords\DataTrain');
    %     categories={'0','1','2','3','4','5','6','7','8','9'};
    categories={'0','1'};
    imdsDataTrain=imageDatastore(fullfile(rootFolder,categories),'LabelSource','foldernames');
    imdsDataTrain.ReadFcn=@(filename)readAndPreprocessImage(filename);
    %Dung deep learning de rut trich dac trung tren bo du lieu huan luyen
    net=alexnet();
    featureLayer='fc7';
    FeaturesDataTrain=activations(net,imdsDataTrain,featureLayer,'MiniBatchSize',32,'OutputAs','columns');
    lblDataTrain=imdsDataTrain.Labels;
    classifier=fitcecoc(FeaturesDataTrain,lblDataTrain,'Leaner','Linear','Coding','Onevsall','ObservationsIn','columns');
    
    %Nap du lieu tap test
    rootFolder=fullfile('BagOfWords\DataTest');
    %     categories={'0','1','2','3','4','5','6','7','8','9'};    
    categories={'0','1'};
    imdsDataTest=imageDatastore(fullfile(rootFolder,categories),'LabelSource','foldernames');
    imdsDataTest.ReadFcn=@(filename)readAndPreprocessImage(filename);
    %Dung deep learning de rut trich dac trung tren bo du lieu test
    net=alexnet();
    featureLayer='fc7';
    FeaturesDataTest=activations(net,imdsDataTest,featureLayer,'MiniBatchSize',32,'OutputAs','columns');
    lblDataTest=imdsDataTest.Labels;
    
    %Ket qua du doan anh test
    lblResult=predict(classifier,FeaturesDataTest');
    %Neu khop label
    nResult=(lblResult==lblDataTest);
    %Dem tong so label du doan dung
    nCount=sum(nResult);
    fprintf("So luong mau dung : %d",nCount);
end