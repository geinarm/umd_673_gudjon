
x = ((1:2:100) + (rand(1,50)*2) * 1)';
y = (0.5 * (10+(1:2:100) + (rand(1,50)*10)))';


X = [ones(length(x), 1), x];
b = X\y;

scatter(x,y); hold on
yCalc2 = X*b;
plot(x,yCalc2,'--');
hold off