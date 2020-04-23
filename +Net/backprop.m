% back propagate a feed-forward network given the input, weights, thresholds 
% and activation function
% 
% Author: Helen Lu, April 20th, 2020

function deltaW = backprop(gamma, error, bias, weights, output, NETcache, Ycache, AcFcn, varargin)
    p = inputParser;
    p.addRequired('gamma', @isnumeric);
    p.addRequired('error', @isnumeric);
    p.addRequired('bias', @iscell);
    p.addRequired('weights', @iscell);
    p.addRequired('output', @isnumeric);
    p.addRequired('NETcache', @iscell);
    p.addRequired('Ycache', @iscell);
    p.addRequired('AcFcn', @ischar);
    p.addParameter('ReedecTau', @isnumeric)
    p.parse(gamma, error, bias, weights, output, NETcache, Ycache, AcFcn, varargin{:});
    tau = p.Results.ReedecTau;
    deltaW = cell(size(weights));
    for i = 1:length(NETcache)
        ly = length(NETcache)-i+1;
        delta = error.*derivative(NETcache{ly},AcFcn,'Tau',tau);
        deltaW{ly} = gamma*[Ycache{ly};...
            ones(1,size(Ycache{ly},2))*bias{ly}]*delta'; 
        error = weights{ly}(1:end-1,:)*delta;
    end    
end

function drv = derivative(NET, AcFcn, varargin)
    p = inputParser;
    p.addRequired('NET', @isnumeric);
    p.addRequired('AcFcn', @ischar);
    p.addParameter('Tau', @isnumeric)
    p.parse(NET,AcFcn,varargin{:})
    tau = p.Results.Tau;
    switch AcFcn
        case 'tanh'
            drv = 1 - tanh(NET).^2;
        case 'relu'
            drv = double(NET > 0);
        case 'leakyrelu'
            drv = double(NET > 0);
            drv(drv == 0) = 0.1;
        case 'sigmoid' 
            drv = 1./(1+exp(-NET)).*(1-1./(1+exp(-NET)));
        case 'gaussian'
            drv = -2.*NET.*exp(-(NET).^2);
        case 'ReEDec'
            drv = zeros(size(NET));
            for i = 1:size(NET,1)
                for j = 1:size(NET,2)
                    if NET(i,j) < 0
                        drv(i,j) = 0;
                    else
                        drv(i,j) = -1/tau*exp(-NET(i,j)/tau);
                    end
                end
            end
        case 'ReEDec2D'
            drv = zeros(size(NET));
            for i = 1:size(NET,1)
                for j = 1:size(NET,2)
                    if NET(i,j) < 0
                        drv(i,j) = 1/tau*(exp(NET(i,j)/tau));
                    else
                        drv(i,j) = -1/tau*(exp(-NET(i,j)/tau));
                    end
                end
            end
        otherwise
            disp('Activation function not available for now')
    end
end