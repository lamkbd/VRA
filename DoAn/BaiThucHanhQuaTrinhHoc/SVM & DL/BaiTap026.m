function BaiTap026
    [imgTrain,lblTrain]=loadData('train-images.idx3-ubyte','train-labels.idx1-ubyte');
    [imgTest,lblTest]=loadData('t10k-images.idx3-ubyte','t10k-labels.idx1-ubyte');
    %Dung model
    mdl=fitcecoc(imgTrain',lblTrain);
    %Ket qua du doan anh test
    lblResult=predict(mdl,imgTest');
    %Neu khop label
    nResult=(lblResult==lblTest);
    %Dem tong so label du doan dung
    nCount=sum(nResult);
    fprintf("So luong mau dung : %d",nCount);
end