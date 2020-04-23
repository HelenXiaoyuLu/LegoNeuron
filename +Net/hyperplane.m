% Draw hyperplane of the neural responses in output layer (for 2D output)
% USAGE
%   [cacheR,Z] = hyperplane(mgrid, weights, bias, AcFcn, 'colormap','spring')
% INPUT
%   mgrid: defines the range and precision of the 2-D meshgrid.
%          e.g. -1:0.01:1
%   weights: weights of the whole net in the format of a 1 x (N-1) cell, N
%          is the number of layers. 
%   bias: value of bias neurons of the net in the format of a 1 x (N-1) cell
%   AcFcn: Activation function
%   colormap (optional Name-Value pair): default colormap = parula
% OUTPUT
%   Draw the hyperplane of output (2D OneHot encoding) and 1D de-OneHot
%   encoding as 3D surfaces.
%   cacheR: OneHot encoded output
%   Z: decoded non-0neHot output, a matrix of class numbers.
%
% Author: Helen Lu, April 20th, 2020

function [cacheR,Z] = hyperplane(mgrid, weights, bias, AcFcn, varargin)
    p = inputParser;
    p.addRequired('mgrid', @isnumeric);
    p.addRequired('weights', @iscell);
    p.addRequired('bias', @iscell);
    p.addRequired('AcFcn', @ischar);
    p.addParameter('colormap', 'parula', @ischar); 
    p.addParameter('ReedecTau', @isnumeric)
    p.parse(mgrid,weights,bias,AcFcn,varargin{:});
    tau = p.Results.ReedecTau;
    c = p.Results.colormap;
    colormap(c)
    for i = 1:2
        [X(i).xval,X(i).yval] = meshgrid(mgrid(1,:),mgrid(2,:));
    end
    input = [reshape(X(1).xval,1,[]);reshape(X(1).yval,1,[])];
    cacheR = Net.propagate(input, weights, bias, AcFcn,'ReedecTau',tau);
    X(2).xval = reshape(cacheR(1,:),size(X(1).xval));
    X(2).yval = reshape(cacheR(2,:),size(X(1).xval));
    Z = zeros(size(X(i).xval));
    for i = 1:size(X(2).xval,1)
        for j = 1:size(X(2).xval,2)
            if X(2).xval(i,j) >= X(2).yval(i,j)
                Z(i,j) = 1;
            else
                Z(i,j) = 2;
            end
        end
    end
    figure()
    subplot(1,2,1)
    hold on
    surf(X(1).xval,X(1).yval,X(2).xval,'FaceAlpha',0.5,'EdgeColor','none')
    surf(X(1).xval,X(1).yval,X(2).yval,'FaceAlpha',0.5,'EdgeColor','none')
    title('hyperplane at output layer')
    axis square
    view(3)    
    
    subplot(1,2,2)
    hold on
    surf(X(1).xval,X(1).yval,Z,'FaceAlpha',0.5,'EdgeColor','none')
    axis square
    title('de-OneHot')
    view(3)   
end