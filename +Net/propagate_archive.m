% Propagate a feed-forward network given the input, weights, thresholds 
% and activation function
% Helen Lu, Updated April 17th, 2020

function cacheR = propagate(input, weights, theta, AcFcn,varargin)
    p = inputParser;
    p.addRequired('input', @isnumeric);
    p.addRequired('weights', @iscell);
    p.addRequired('theta', @iscell);
    p.addRequired('AcFcn', @ischar);
    p.addParameter('assistWeights', @isnumeric)
    p.parse(input, weights, theta, AcFcn, varargin{:})  
    A = p.Results.assistWeights(1);
    B = p.Results.assistWeights(2); 
    if size(input,1)~= size(weights{1},1)
        error('Input dimension not right')
    else
        switch AcFcn
            case 'tanh'
                cacheR = input;
                for i = 1:length(weights)
                    cacheR = tanh(weights{i}'*cacheR - theta{i});
                end
            case 'relu'
                cacheR = input;
                for i = 1:length(weights)
                    cacheR = relu(weights{i}'*cacheR - theta{i});
                end
            case 'gaussian'
                cacheR = input;
                for i = 1:length(weights)
                    cacheR = exp(-(weights{i}'*cacheR - theta{i}).^2);
                end                
            case 'polynomial'
                cacheR = input;
                for i = 1:length(weights)
                    cacheR = (weights{i}'*cacheR - theta{i}).*(A*(weights{i}'*cacheR)+B);
                end                 
            otherwise
                disp('Activation function not available for now')
        end
    end
end

% input should always be a 1-D vector
function output = relu(input) 
    output = zeros(size(input));
    for i = 1:length(input)
        if input(i) <= 0
            output(i) = 0;
        else
            output(i) = input(i);
        end
    end
end

