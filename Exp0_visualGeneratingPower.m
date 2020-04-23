%%% Experimenting Neurons with non-monotonic activation function
%%% Experiemnt 0: Visualizing multilayer classi?cations 
%%% For better illustration try 2D first
%% Check output dimensions of different activation function
clear
Run = 4;
inputs = unifrnd(-1,1,[2,1000]);
Topo = [2,10,10,10,2];
W = [0,1];
theta = [0,1];
ActivationFcn = 'gaussian'; % 'tanh' 'relu' 'sigmoid' 'gaussian' 'polynomial' 'ReEDec' 'leakyrelu'
figure()
hold on
for i = 1:Run
    [weights, bias] = Net.initNet(Topo, W, theta,'drawNet',true);
    Output = Net.propagate(inputs, weights, bias, ActivationFcn,'assistWeights',[-0.3,0.3],'ReedecTau',1);
    subplot(1,4,i)
    colormap(Net.RWB);
    scatter(inputs(1,:),inputs(2,:),[],Output,'.')
    axis equal
    axis([-1 1 -1 1])
   % colorbar('eastoutside')
    title(strcat('Trial ',num2str(i)),'FontSize',10)
end
sgtitle(['Activation Function =', ' ', ActivationFcn, ', ','Topology =',' ' num2str(Topo)])
set(gcf, 'Position',  [100, 100, 800, 200])


