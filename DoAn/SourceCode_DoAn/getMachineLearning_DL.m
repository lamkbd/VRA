function mdl=getMachineLearning_DL(featuresData,lblData)
%   mdl=fitcecoc(featuresData,lblData); 
	mdl=fitcecoc(featuresData,lblData,'Leaner','Linear','Coding','Onevsall','ObservationsIn','columns');
end