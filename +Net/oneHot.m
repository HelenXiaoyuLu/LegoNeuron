% Make a vectorized label into one hot encoding
% Author: Helen Lu, April 20th, 2020

function [input,label] = oneHot(Data)
    if isfield(Data,{'x','y'})
        nGroup = size(Data(1).x,2);
        numData = length(Data)*nGroup;
        input = zeros(2,numData);
        label = zeros(2,numData);
        for i = 1:length(Data)
            input(:,100*(i-1)+1:100*i) = [Data(i).x;Data(i).y];
            label(:,100*(i-1)+1:100*i) = full(ind2vec(ones(1,nGroup)*Data(i).label,2));
        end
    elseif isfield(Data,{'raw'})
        dim = numel(Data(1).raw(:,:,1));
        nData = length(Data.raw);
        nClass= max(Data.label+1);
        input = zeros(dim, nData);
        label = zeros(nClass,nData);
        for i = 1:length(Data.label)
            input(:,i) = reshape(Data.raw(:,:,i),dim,1);
            label(:,i) = full(ind2vec(Data.label(i)+1,nClass));
        end     
    end       
end
