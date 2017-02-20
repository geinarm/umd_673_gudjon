
s1 = 0.35;
i1 = 0.55;

s2 = 0.95;
i2 = 0.22;

d = s1 - s2;
x = (i2 - i1)/d;
y = (s1*i2 - s2*i1)/d;

refline(s1, i1); hold on;
refline(s2, i2);
scatter(x, y, '.');
ylim([0,1]);
xlim([0,1]);