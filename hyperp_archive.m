% Hyperplane archive: 2 interneurons
[X,Y] = meshgrid(-1:0.01:1,-1:0.01:1);
[X1,Y1] = meshgrid(-1:0.01:1,-1:0.01:1);
[X2,Y2] = meshgrid(-1:0.01:1,-1:0.01:1);
Z = zeros(size(X));
for i = 1:size(X,1)
    for j = 1:size(X,2)  
       A =exp(-(weights{1}'* [X(i,j);Y(i,j);bias{1}]).^2);
%         A = tanh(weights{1}'* [X(i,j);Y(i,j);bias{1}]);
        X1(i,j) = A(1);
        Y1(i,j) = A(2);
    end
end
for i = 1:size(X1,1)
    for j = 1:size(X1,2)
        A = exp(-(weights{2}'*[X1(i,j);Y1(i,j);bias{2}]).^2);
%         A = tanh(weights{1}'* [X(i,j);Y(i,j);bias{1}]);
        X2(i,j) = A(1);
        Y2(i,j) = A(2); 
        if X2(i,j) >= Y2(i,j)
            Z(i,j) = 1;
        else
            Z(i,j) = 2;
        end
    end
end
figure()
cmap = colormap(parula);

subplot(1,3,1)
hold on
surf(X,Y,X1,'FaceAlpha',0.5,'EdgeColor','none')
surf(X,Y,Y1,'FaceAlpha',0.5,'EdgeColor','none')
axis square
view(3)
subplot(1,3,2)
hold on
surf(X,Y,X2,'FaceAlpha',0.5,'EdgeColor','none')
surf(X,Y,Y2,'FaceAlpha',0.5,'EdgeColor','none')
axis square
view(3)
subplot(1,3,3)
hold on
surf(X,Y,Z,'FaceAlpha',0.5,'EdgeColor','none')
axis square
view(3)