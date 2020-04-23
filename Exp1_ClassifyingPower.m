%%% Experiemnt 1: Classifying non-linear-seperable data
%%% For better illustration try 2D first
%% Try backpropagation on training
% Initialize data
clc
clear
% Range = [0,1,0,1;-1,0,0,1; -1,0,-1,0; 0,1,-1,0];
% Range = [0,1,0,1;-1,0,0,1; -1,0,-1,0; 0,1,-1,0; 0,-1,1,2; 0,1,1,2; 1,2,1,2;1,2,0,1;1,2,-1,0];
Range = [0,1,0,1;-1,0,0,1; -2,0,-1,0; 0,1,-1,0; -2,0,1,2; 0,1,1,2; 1,2,1,3;...
    1,2,0,1;1,2,-1,0;-2,0,2,3;-2,-1,0,1;0,1,2,3];
dataRange = min(Range(:)):0.01:max(Range(:));
% Label = [1,2,1,2];
% Label = [1,2,1,2,1,2,1,2,1];
Label = [1,2,1,2,1,2,1,2,1,2,1,1];
Point = 100; 
cmap = [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980];
Data = Net.gen2D(Range,Label,Point,'figshow',true,'onehot',true,'colormap',cmap);
axis square
title('train','FontSize',20)
testData = Net.gen2D(Range,Label,Point,'figshow',true,'onehot',true,'colormap',cmap);
title('test','FontSize',20)
axis square

%% Initiate net
%close all
clearvars -except Label Data testData dataRange
cmap = [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980];
Topo = [max(Label),10,10,max(Label)]; % use One-hot encoding for output
W = [0,1];
theta = [0,1];
[weights, bias] = Net.initNet(Topo, W, theta,'drawNet',false);
ActivationFcn = 'ReEDec2D'; % 'tanh' 'relu' 'sigmoid' 'gaussian' 'polynomial' 'ReEDec' 'leakyrelu' 'ReEDec2D'
tau = 4;
% Initiate training
gamma = 0.01; % Gamma = Learning rate
K = 50;  % K = batch size
tol = 0.01;
%
MaxEpoch = 10000;

% Start training
errMSEMem=[];
errTest = [];
for t = 1:MaxEpoch
    % random permute training data set
    Sele = randperm(length(Data.input));
    TrainSet_x = Data.input(:,Sele(1:K));
    TrainSet_y = Data.label(:,Sele(1:K));
    % Forward propagate
    [Output, NETcache, Ycache] = Net.propagate(TrainSet_x, weights, bias, ActivationFcn,...
        'assistWeights',[-0.3,0.3],'interNET',true,'ReedecTau',tau);
    Err = TrainSet_y - Output;
    errMSEMem=[errMSEMem; mean(Err.^2,'all')];
    testOutput = Net.propagate(testData.input, weights, bias, ActivationFcn,...
        'assistWeights',[-0.3,0.3],'interNET',true,'ReedecTau',tau);
    testErr = sum(logical(Net.deOneHot(testOutput) - Net.deOneHot(testData.label)),'all')/length(testOutput);
    errTest = [errTest,testErr];
    % Back propagate with delta rule
    Ycache = [{TrainSet_x}, Ycache];
    dW = Net.backprop(gamma, Err, bias, weights, Output, NETcache, Ycache, ActivationFcn,'ReedecTau',tau);
    for i = 1:length(weights)
        weights{i} = weights{i} + dW{i};
    end
end
Output = Net.propagate(Data.input, weights, bias, ActivationFcn,'ReedecTau',tau);
figure()
subplot(1,2,1)
hold on
plot(errMSEMem)
plot(errTest)
ylim([0 inf])
xlim([0,MaxEpoch])
axis square
legend('train MSE','test error rate','location','northeast')
title(ActivationFcn)
subplot(1,2,2)
finalOutput = Net.deOneHot(Output);
scatter(Data.input(1,:),Data.input(2,:),50,cmap(finalOutput,:),'filled')
axis square
xlim([-2,2])
ylim([-1,3])
title({ ActivationFcn, ['Total Epoch =', ' ', num2str(MaxEpoch)]})

% Hyperplanes
[cR, Z] = Net.hyperplane([-2:0.01:2;-1:0.01:3], weights, bias, ActivationFcn,'ReedecTau',tau);
[xx,yy] = meshgrid(-2:0.01:2,-1:0.01:3);
xlim([-2,2])
ylim([-1,3])
savepath = 'D:\OneDrive - rice.edu\Course\ELEC615 Theoretical neuroscience\Project\XOR\Figures\Exp2';
%surf2stl(fullfile(savepath,'Gaussian2x10x10x2_5000Epc.stl'),xx,yy,Z);