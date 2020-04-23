% This function defines a blue-white-red colormap
% Returns a 5x3 matrix\
% Helen Lu, Feb 14th, 2020

function C = RWB(val)
    % From red[1 0 0] to white[1 1 1] to blue[0 0 1];
    r = [1, 1, 1, 1, 1, 0.75, 0.5, 0.25, 0]';
    g = [0, 0.25, 0.5, 0.75, 1, 0.75, 0.5, 0.25, 0]';
    b = [0, 0.25, 0.5, 0.75, 1,1, 1, 1,1]';
%     r = [1, 1,  0]';
%     g = [0,  1, 0]';
%     b = [0,  1,1]';
    C = [r g b]; 
end