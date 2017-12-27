function BaiTap025()
%     CreateDataTrain();
%     CreateDataTest();
    %Nap du lieu tap train
    rootFolder=fullfile('DataTrain');
    %     categories={'0','1','2','3','4','5','6','7','8','9'};
    categories={'0','1'};
    imds=imageDatastore(fullfile(rootFolder,categories),'LabelSource','foldernames');
    tbl01=countEachLabel(imds);
    
    minSetCount=min(tbl01{:,2});
    imds =splitEachLabel(imds,minSetCount,'randomize');
    tbl02=countEachLabel(imds);
    
    %Tao tui tu tu tap train
    bag = bagOfFeatures(imds)
    
    %Tinh vector tu
    img=readimage(imds,1);
    featureVector=encode(bag,img);
    
    figure;
    bar(featureVector);
    title('Visual word occurrences');
    xlabel('Visual word index');
    ylabel('Frequence word index');
    %Phan nhom tu
    categoryClassifier=trainImageCategoryClassifier(imds,bag);
    %Nap du lieu tap test
    rootFolder=fullfile('DataTest');
    %     categories={'0','1','2','3','4','5','6','7','8','9'};
    
    categories={'0','1'};
    imds=imageDatastore(fullfile(rootFolder,categories),'LabelSource','foldernames');
    tbl01=countEachLabel(imds);
    %Danh gia ket qua phan lop
    confMatrixTest=evaluate(categoryClassifier,imds);
    mean(diag(confMatrixTest));
end