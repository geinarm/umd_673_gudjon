

C1x = normrnd(10, 1, 100,1);
C1y = normrnd(9, 1, 100,1);

C2x = normrnd(7, 1.5, 100,1);
C2y = normrnd(5, 1.5, 100,1);


plot(C1x, C1y, '.', 'Color', 'red'); hold on
plot(C2x, C2y, '.', 'Color', 'blue');


X = [[C1x;C2x], [C1y;C2y]];
Y = [ones(100,1); ones(100,1)*2];

Model = fitcsvm(X, Y);

predict(Model, [10, 9])
predict(Model, [7, 5])