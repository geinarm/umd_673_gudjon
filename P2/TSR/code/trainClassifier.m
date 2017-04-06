
TrainingData = '../input/Training/';
TestData = '../input/Testing/';

classes = [45, 21, 38, 35, 17, 1, 14, 19];
classes = classes +1; % label numbers start from 1
num_labels = length(classes);

if ~exist('Features', 'var')
    fprintf('Read Training Data\n')
    [Features, Labels] = readDataSet(TrainingData);
    
    sel = any(Labels == classes, 2);
    Features = Features(sel,:);
    Labels = Labels(sel);    
end

num_samples = numel(Labels);
%num_labels = numel(unique(Labels));

if ~exist('Models', 'var')
    fprintf('Train\n')
    Models = cell(num_labels, 1);
    k=1;
    for i = classes
        %sel = (Labels==i);
        %n = sum(sel);
        %F_i = Features(sel, :);
        %L_i = Labels(sel);
        %rsel = randperm(num_samples, ceil(num_samples*0.05));
        %Rf = Features(rsel, :);
        %Rl = Labels(rsel);

        %X = [F_i; Rf];
        %Y = ([L_i; Rl] == i);
        X = Features;
        Y = Labels==i;

        fprintf('Model %i\n', i);
        Models{i} = fitcsvm(X, Y);
        k = k+1;
    end
end

fprintf('Read Test Data\n')
[Tf, Tl] = readDataSet(TestData);

sel = any(Tl == classes, 2);
Tf = Tf(sel,:);
Tl = Tl(sel);

fprintf('Test\n')
correct = 0;
for k = 1:numel(Tl)
    %fprintf('Label %i\n', Tl(k));
    S = zeros(num_labels, 1);
    for i = classes
        Model = Models{i};
        [pred, score] = predict(Model, Tf(k, :));
        S(i) = score(2);
        %fprintf('L: %i  P: %i  S:(%.2f,%.2f)\n', i, pred, score(1), score(2));
    end
    [maxScore, maxI] = max(S);
    correct = correct + (maxI == Tl(k));
    %fprintf('L: %i  P: %i  score: %.2f\n', Tl(k), maxI, maxScore);
end

fprintf('Correct %.2f\n', correct/numel(Tl));
