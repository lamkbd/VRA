function [bag,imds]=getBag(imds)
    tbl=countEachLabel(imds);
    minSetCount=min(tbl{:,2});
    imds =splitEachLabel(imds,minSetCount,'randomize');
    %Tao tui tu tu tap train
    bag = bagOfFeatures(imds);  
end