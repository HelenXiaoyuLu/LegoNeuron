% Propagate a feed-forward network given the input, weights, thresholds 
% and activation function
% Author: Helen Lu, Updated April 18th, 2020

function [cacheR, NETstore, Ystore] = propagate(input, weights, theta, AcFcn,varargin)
    p = inputParser;
    p.addRequired('input', @isnumeric);
    p.addRequired('weights', @iscell);
    p.addRequired('theta', @iscell);
    p.addRequired('AcFcn', @ischar);
    p.addParameter('assistWeights', @isnumeric)
    p.addParameter('interNET', false, @(n) validateattributes(n, ...
        {'logical'},{'scalar'}));
    p.addParameter('ReedecTau', @isnumeric)    
    p.parse(input, weights, theta, AcFcn, varargin{:})  
    A = p.Results.assistWeights(1);
    B = p.Results.assistWeights(2); 
    interNET = p.Results.interNET;
    tau = p.Results.ReedecTau;
    if size(input,1)~= size(weights{1},1)-1
        error('Input dimension not right')
    else
        switch AcFcn
            case 'tanh'
                cacheR = input;
                NETstore = cell(size(weights));
                for i = 1:length(weights)
                    tempNET = weights{i}'*[cacheR;ones(1,size(cacheR,2))*theta{i}];
                    cacheR = tanh(tempNET);
                    if interNET
                        Ystore{i} = cacheR;
                        NETstore{i} = tempNET;
                    end
                end
            case 'relu'
                cacheR = input;
                NETstore = cell(size(weights));
                for i = 1:length(weights)
                    tempNET = weights{i}'*[cacheR;ones(1,size(cacheR,2))*theta{i}];
                    cacheR = relu(tempNET);
                    if interNET
                        Ystore{i} = cacheR;
                        NETstore{i} = tempNET;
                    end                    
                end
            case 'leakyrelu'
                cacheR = input;
                NETstore = cell(size(weights));
                for i = 1:length(weights)
                    tempNET = weights{i}'*[cacheR;ones(1,size(cacheR,2))*theta{i}];
                    cacheR = leakyrelu(tempNET);
                    if interNET
                        Ystore{i} = cacheR;
                        NETstore{i} = tempNET;
                    end                    
                end
            case 'sigmoid'
                cacheR = input;
                NETstore = cell(size(weights));
                for i = 1:length(weights)
                    tempNET = weights{i}'*[cacheR;ones(1,size(cacheR,2))*theta{i}];
                    cacheR = 1 ./ (1 + exp(-(tempNET)));
                    if interNET
                        Ystore{i} = cacheR;
                        NETstore{i} = tempNET;
                    end                    
                end
            case 'gaussian'
                cacheR = input;
                NETstore = cell(size(weights));
                for i = 1:length(weights)
                    tempNET = weights{i}'*[cacheR;ones(1,size(cacheR,2))*theta{i}];
                    cacheR = exp(-(tempNET).^2);
                    if interNET
                        Ystore{i} = cacheR;
                        NETstore{i} = tempNET;
                    end                     
                end
            case 'ReEDec'
                cacheR = input;
                NETstore = cell(size(weights));
                for i = 1:length(weights)
                    tempNET = weights{i}'*[cacheR;ones(1,size(cacheR,2))*theta{i}];
                    cacheR = Reedec(tempNET,tau);
                    if interNET
                        Ystore{i} = cacheR;
                        NETstore{i} = tempNET;
                    end                     
                end
            case 'ReEDec2D'
                cacheR = input;
                NETstore = cell(size(weights));
                for i = 1:length(weights)
                    tempNET = weights{i}'*[cacheR;ones(1,size(cacheR,2))*theta{i}];
                    cacheR = Reedec2D(tempNET,tau);
                    if interNET
                        Ystore{i} = cacheR;
                        NETstore{i} = tempNET;
                    end                     
                end
            case 'polynomial'
                cacheR = input;
                for i = 1:length(weights)
                    cacheR = (weights{i}'*[cacheR;ones(1,size(cacheR,2))*theta{i}]).*(A*(weights{i}'*[cacheR;ones(1,size(cacheR,2))*theta{i}])+B);
                end 
            otherwise
                disp('Activation function not available for now')
        end
    end
end

function output = relu(input) 
    output = zeros(size(input));
    for i = 1:size(input,1)
        for j = 1: size(input,2)
            if input(i,j) <= 0
                output(i,j) = 0;
            else
                output(i,j) = input(i,j);
            end
        end
    end
end
function output = leakyrelu(input) 
    output = zeros(size(input));
    for i = 1:size(input,1)
        for j = 1:size(input,2)
            if input(i,j) <= 0
                output(i,j) = 0.1*input(i,j);
            else
                output(i,j) = input(i,j);
            end
        end
    end
end
function output = Reedec(input,tau)
    output = zeros(size(input));
    for i = 1:size(input,1)
        for j = 1:size(input,2)
            if input(i,j) < 0
                output(i,j) = 0*input(i,j);
            else
                output(i,j) = exp(-input(i,j)/tau);
            end
        end
    end
end
function output = Reedec2D(input,tau)
    output = zeros(size(input));
    for i = 1:size(input,1)
        for j = 1:size(input,2)
            if input(i,j) < 0
                output(i,j) = exp(input(i,j)/tau);
            else
                output(i,j) = exp(-input(i,j)/tau);
            end
        end
    end
end

