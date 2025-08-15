% a = [1; 2; 3; 4; 5; 6; 7; 8]
% b = [9; 10; 11; 12]
% % disp(a)
% % disp(b(1))
% 
% %index = size(b,1) + 1:size(a, 1);
% %disp(index)
% %new_a = a(index);       
% %a = [new_a;b]
% 
% %disp(a)
% % data_arrayEMG = [index;data];
% 
% c = [a;b]
% c(1:length(b),:) = [];
% c = c * 100;
% c
% size(c)
% temp = reshape(c,2,[]);
% temp = transpose(temp)

publish = [2 0 0 0];
disp(publish);
publish_2 = double(publish);
disp(publish_2);
publish_3 = single(publish);
disp(publish_3);
