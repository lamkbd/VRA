function BaiTap027
    imgTrainAll=loadMNISTImages('train-images.idx3-ubyte');    
    lblTrainAll=loadMNISTLabels('train-labels.idx1-ubyte');
    
    imgTestAll=loadMNISTImages('t10k-images.idx3-ubyte');    
    lblTestAll=loadMNISTLabels('t10k-labels.idx1-ubyte');
    
    nBins=256;
    numImgTrain=size(imgTrainAll,2);
    imgTrainAll_hist=zeros(nBins,numImgTrain);
    
    numImgTest=size(imgTestAll,2);
    imgTestAll_hist=zeros(nBins,numImgTest);
    
    for i=1:numImgTrain
        imgTrainAll_hist(:,i)=imhist(imgTrainAll(:,i),nBins);
    end
    for i=1:numImgTest
        imgTestAll_hist(:,i)=imhist(imgTestAll(:,i),nBins);
    end
    %Dung model
    mdl=fitcecoc(imgTrainAll_hist',lblTrainAll);
    %Ket qua du doan anh test
    lblResult=predict(mdl,imgTestAll_hist');
    %Neu khop label
    nResult=(lblResult==lblTestAll);
    %Dem tong so label du doan dung
    nCount=sum(nResult);
    fprintf("So luong mau dung : %d",nCount);
end