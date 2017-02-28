function [ I ] = labelTags( Tags, I )
%Draws anotations on an image

imshow(I); hold on;
for i = 1:length(Tags)
    t = Tags{i};
    scatter(t.Points(1,:), t.Points(2,:), 20, [1 0 0;0 1 0;0 0 1;1 1 0], 'filled');
    text(t.Points(1,1), t.Points(2,1)-20, ['T',int2str(t.Id)], 'Color', 'red');
end
hold off;

F = getframe(gcf);
[I, ~] = frame2im(F);

end

