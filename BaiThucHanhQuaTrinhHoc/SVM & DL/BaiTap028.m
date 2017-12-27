function BaiTap028
    [imgTrain,lblTrain]=loadData('train-images.idx3-ubyte','train-labels.idx1-ubyte');
    [imgTest,lblTest]=loadData('t10k-images.idx3-ubyte','t10k-labels.idx1-ubyte');
    %Lay dac trung anh train
    featuresDataTrain=ExtHOGFeatures(imgTrain);
    %Dung model
    mdl=fitcecoc(featuresDataTrain',lblTrain);
    %Lay dac trung anh test
    featuresDataTest=ExtHOGFeatures(imgTest);
    %Ket qua du doan anh test
    lblResult=predict(mdl,featuresDataTest');
    %Neu khop label
    nResult=(lblResult==lblTest);
    %Dem tong so label du doan dung
    nCount=sum(nResult);
    fprintf("So luong mau dung : %d",nCount);
end