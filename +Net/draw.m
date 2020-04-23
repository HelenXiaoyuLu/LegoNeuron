% Visualize the topology (nodes and connections) of a network
% Author:  Helen Lu, April 19th, 2020

function draw(Topology,varargin)
    c = colormap(lines);
    p = inputParser;
    p.addRequired('Topology', @isnumeric);
    p.addParameter('colormap',c,@isnumeric);
    p.addParameter('Weights', @isnumeric);
    p.parse(Topology,varargin{:})
    cmap = p.Results.colormap;
    Weights = p.Results.Weights; % Saved feature
    pointNames = cell(size(Topology,2),max(Topology));
    for i = 1:length(Topology)
        for j = 1:Topology(i)
            pointNames{i,j} = strcat('L',num2str(i),'N',num2str(j));
        end
    end    
    figure()
    colormap(cmap)
    hold on
    S = {};
    T = {};
    for i = 1:length(Topology)-1
        L1 = pointNames(i,:);
        L1 = L1(~cellfun('isempty',L1));
        L2 = pointNames(i+1,:);
        L2 = L2(~cellfun('isempty',L2));
        C1 = {};
        for j = 1:length(L1)
            C1 = cat(2,C1,repmat(string(L1{j}),1,length(L2)));
        end
        C2 = repmat(string(L2),1,length(L1));
        S = cat(2, S,C1);
        T = cat(2, T, C2);
    end
    G = graph(S,T);
    h = plot(G);
    X = zeros(1,sum(Topology)); Y = zeros(1,sum(Topology));
    for i = 1:sum(Topology)
        pos = split(string(h.NodeLabel(i)),["L","N"]);
        X(i) = pos(2); Y(i) = pos(3);
    end
    h.XData = X; h.YData = Y;
    set(gca,'xtick',[],'ytick',[],'box','off')
    axis off
end