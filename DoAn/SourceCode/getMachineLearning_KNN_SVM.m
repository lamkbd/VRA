function mdl=getMachineLearning_KNN_SVM(typeML,featuresData,lblData)
    switch typeML
       case 1%KNN          
          mdl=fitcknn(featuresData',lblData);
       case 2%SVM
          mdl=fitcecoc(featuresData',lblData);     
    end
end