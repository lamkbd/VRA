function [featuresData]=getFeatures_HOG_LBP(typeFeature,imgData,cellsize)
    img1D=imgData(:,1);
    img2D=reshape(img1D,28,28);
    switch typeFeature
       case 1%HOG            
            featuresVector=extractHOGFeatures(img2D,'CellSize',[cellsize cellsize]);
            nsizes=length(featuresVector);
            nData=size(imgData,2);
            featuresData=zeros(nsizes,nData);
            for i=1:nData
                img1D=imgData(:,i);
                img2D=reshape(img1D,28,28);
                featuresData(:,i)=extractHOGFeatures(img2D,'CellSize',[cellsize cellsize]);
            end
       case 2%LBP
            featuresVector=extractLBPFeatures(img2D,'CellSize',[cellsize cellsize]);
            nsizes=length(featuresVector);
            nData=size(imgData,2);
            featuresData=zeros(nsizes,nData);
            for i=1:nData
                img1D=imgData(:,i);
                img2D=reshape(img1D,28,28);
                featuresData(:,i)=extractLBPFeatures(img2D,'CellSize',[cellsize cellsize]);
            end          
    end
end