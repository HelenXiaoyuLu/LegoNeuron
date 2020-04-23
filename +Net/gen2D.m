% Generate 2D data with label for neuro network
% USAGE
%   Data = gen2D(gRange,gLabel,nPoint,'figshow',false)
% INPUT
% 	gRange: The X & Y ranges of N groups
%           e.g.[0,1,0,1;-1,0,0,1; -1,0,-1,0; 0,1,-1,0]; % 4 group in 4 phase
% 	gLabel: The class that each group belongs to
%           e.g. [1,2,1,2];
% 	nPoint: number of data points per group; 
% 	figshow(optional name-value pair): show scatter plot of points. 
%           default = true
%   onehot: merge all data and make the output one-hot encoding
% OUTPUT
%   1 x N Data struct with 3 fields 'x' 'y' and 'label'
%   (alternative) one-hot: 1 x 1 Data struct with fields 'input' and 'label'
%
% Author: Helen Lu, Updated April 17th, 2020

function Data = gen2D(gRange,gLabel, nPoint, varargin)
    c = colormap(lines);
    p = inputParser;
    p.addRequired('gRange', @isnumeric);
    p.addRequired('gLabel', @(n) validateattributes(n,{'numeric'},{'vector'}));
    p.addRequired('nPoint', @(n) validateattributes(n, ...
        {'numeric'},{'nonnegative', 'integer'}));
    p.addParameter('figshow', true, @(n) validateattributes(n, ...
        {'logical'},{'scalar'}));
    p.addParameter('onehot', false, @(n) validateattributes(n, ...
        {'logical'},{'scalar'}));
    p.addParameter('colormap', c, @isnumeric);
    p.parse(gRange,gLabel,nPoint,varargin{:})
    figshow = p.Results.figshow; 
    onehot = p.Results.onehot; 
    cmap = p.Results.colormap;
    Data = struct;
    for i = 1:size(gRange,1)
        Data(i).x = (gRange(i,2)-gRange(i,1)).*rand(1,nPoint) + gRange(i,1);
        Data(i).y = (gRange(i,4)-gRange(i,3)).*rand(1,nPoint) + gRange(i,3);
        Data(i).label = gLabel(i);        
    end
    if figshow
       figure()
        hold on
        for i = 1:size(gRange,1)
            scatter(Data(i).x, Data(i).y, 50, ones(nPoint,1)*cmap(Data(i).label,:),'filled')
        end
        axis square
    end   
    if onehot
        [in, out] = Net.oneHot(Data);
        Data = struct;
        Data.input = in;
        Data.label = out;
    end
end





