%%% Experiemnt 2: Classifying data with higher internal dimension
%%% IRIS has 3-class & 4-dimentional 
%%% The output (3 classes of the iris species) are encoded as
%%% (1 0 0) for class 1 (Setosa), (0 1 0 ) for class 2 (Versacolor) 
%%% and (0 0 1) for class 3 (Virginica).
%% Import train and test data
clear
train = readtable('iris-train.txt');
test = readtable('iris-test.txt');
trainData.input = [train.Sep_L,train.Sep_W,train.Pet_L,train.Pet_W]';
trainData.label = [train.Setosa,train.Versacolor,train.Virginica]';
testData.input = [test.Sep_L,test.Sep_W,test.Pet_L,test.Pet_W]';
testData.label = [test.Setosa,test.Versacolor,test.Virginica]';

%% Initiate net
close all
Topo = [size(trainData.input,1),10,size(trainData.label,1)]; % use One-hot encoding for output
W = [0,1];
theta = [0,1];
ActivationFcn ={'tanh', 'sigmoid', 'leakyrelu', 'gaussian', 'ReEDec', 'ReEDec2D'}; % 'relu', 'ReEDec','polynomial',
tau = 4;

for AF = 1:length(ActivationFcn)
% Initiate training
[weights, bias] = Net.initNet(Topo, W, theta,'drawNet',true);
gamma = 0.01; % Gamma = Learning rate
K = 25;  % K = batch size
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
    [Output, NETcache, Ycache] = Net.propagate(TrainSet_x, weights, bias, ActivationFcn{AF},...
        'assistWeights',[-0.3,0.3],'interNET',true,'ReedecTau',tau);
    Err = TrainSet_y - Output;
    errMSEMem=[errMSEMem; mean(Err.^2,'all')];
    testOutput = Net.propagate(testData.input, weights, bias, ActivationFcn{AF},...
        'assistWeights',[-0.3,0.3],'interNET',true,'ReedecTau',tau);
    testErr = sum(logical(Net.deOneHot(testOutput) - Net.deOneHot(testData.label)),'all')/length(testOutput);
    errTest = [errTest,testErr];
    % Back propagate with delta rule
    Ycache = [{TrainSet_x}, Ycache];
    dW = Net.backprop(gamma, Err, bias, weights, Output, NETcache, Ycache, ActivationFcn{AF},'ReedecTau',tau);
    for i = 1:length(weights)
        weights{i} = weights{i} + dW{i};
    end
end
Output = Net.propagate(trainData.input, weights, bias, ActivationFcn{AF},'ReedecTau',tau);
figure(1)
subplot(1,2,1)
hold on
plot(errMSEMem)
axis([0 MaxEpoch 0 0.5])
axis square
%legend('train MSE','test error rate','location','northeast')
%title(['Activation Function =', ' ', ActivationFcn,', topology =',' ', num2str(Topo)])
title('Train MSE','FontSize',14)
xlabel('Epoch')
subplot(1,2,2)
hold on
plot(errTest)
axis([0 MaxEpoch 0 1])
axis square
title('Test Error Rate','FontSize',14)
xlabel('Epoch')
sgtitle(['Topology = ',' ',num2str(Topo)],'FontSize',16)
end
legend(ActivationFcn,'location','eastoutside')