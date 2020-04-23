% Establish a fully connected neuronet with specified topology and values
% (and activation function)
% USAGE
%   [weights,thresholds] = Net.initNet(Topo, W, theta,'drawNet',true);
% INPUT
%   Topo: 1xN matrix specifying the number of neurons in each layer,
%         including input and output layer. e.g, [2,3,4,1] defined a net
%         with 2 input neurons, 2 hidden layers and 1 output neuron.
%   W: The mean and variance of normal distribution where weights are draw
%         from. e.g. [0,1] -> W ~ N(0,1)     
%   theta: The mean and variance of normal distribution where threshold are
%         draw from. e.g. [0,1] -> Theta ~ N(0,1)
%   drawNet (optional Name-value pair): display the topology of network. 
%         default = false
% OUTPUT
%   Two 1x(N-1) cell specifying the weight between adjacent layers and the
%   thresholds of neurons in the first N-1 layer. 
%   Helen Lu, Updated April 17th, 2020

function [weights,thresholds] = initNet(Topo, W, theta, varargin)
    p = inputParser;
    p.addRequired('Topo', @isnumeric);
    p.addRequired('W', @isnumeric);
    p.addRequired('theta', @isnumeric);
    p.addParameter('AcFcn', 'relu', @ischar);
    p.addParameter('drawNet', false, @(n) validateattributes(n, ...
        {'logical'},{'scalar'}))
    p.parse(Topo, W, theta, varargin{:})
    AcFcn = p.Results.AcFcn; % Save for future
    drawNet = p.Results.drawNet; 
    weights = cell(1,length(Topo)-1);
    thresholds = cell(1,length(Topo)-1);
    for i = 1: length(Topo)-1
        weights{i} = normrnd(W(1), sqrt(W(2)),[Topo(i),Topo(i+1)]);
        thresholds{i} = normrnd(theta(1), sqrt(theta(2)),[Topo(i+1),1]);
    end 
    if drawNet
        draw(Topo)
    end
end
