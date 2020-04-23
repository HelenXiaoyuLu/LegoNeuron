%%% Experiemnt 3: Classifying data with higher internal dimension
%%% MNIST has 10-class & 4-dimentional 

%% Import train and test data
clear
[train.raw train.label] =readMNIST('train-images.idx3-ubyte','train-labels.idx1-ubyte',5000,0);
[test.raw test.label] =readMNIST('t10k-images.idx3-ubyte','t10k-labels.idx1-ubyte',1000,0);
[trainData.input,trainData.label] = Net.oneHot(train);
[testData.input,testData.label] = Net.oneHot(test);
figure()
imshow(reshape(testData.input(:,250),20,20),[])
testData.label(:,250)

%% Initiate net
clearvars -except trainData testData
Topo = [size(trainData.input,1),100,size(trainData.label,1)]; % use One-hot encoding for output
W = [0,1];
theta = [0,1];
[weights, bias] = Net.initNet(Topo, W, theta,'drawNet',false);
ActivationFcn = 'gaussian'; % 'tanh' 'relu' 'sigmoid' 'gaussian' 'polynomial'
% Initiate training
gamma = 0.01; % Gamma = Learning rate
K = 100;  % K = batch size
tol = 0.01; 
MaxEpoch = 5000;

% Start training
errMSEMem=[];
errTest = [];
for t = 1:MaxEpoch
    % random permute training data set
    Sele = randperm(length(trainData.input));
    TrainSet_x = trainData.input(:,Sele(1:K));
    TrainSet_y = trainData.label(:,Sele(1:K));
    % Forward propagate
    [Output, NETcache, Ycache] = Net.propagate(TrainSet_x, weights, bias, ActivationFcn,...
        'assistWeights',[-0.3,0.3],'interNET',true);
    Err = TrainSet_y - Output;
    errMSEMem=[errMSEMem; mean(Err.^2,'all')];
    testOutput = Net.propagate(testData.input, weights, bias, ActivationFcn,...
        'assistWeights',[-0.3,0.3],'interNET',true);
    testErr = sum(logical(Net.deOneHot(testOutput) - Net.deOneHot(testData.label)),'all')/length(testOutput);
    errTest = [errTest,testErr];
    % Back propagate with delta rule
    Ycache = [{TrainSet_x}, Ycache];
    dW = Net.backprop(gamma, Err, bias, weights, Output, NETcache, Ycache, ActivationFcn);
    for i = 1:length(weights)
        weights{i} = weights{i} + dW{i};
    end
end
Output = Net.propagate(trainData.input, weights, bias, ActivationFcn);
figure()
subplot(1,2,1)
hold on
plot(errMSEMem)
plot(errTest)
axis square
legend('train MSE','test error rate','location','northeast')
title(['Activation Function =', ' ', ActivationFcn])