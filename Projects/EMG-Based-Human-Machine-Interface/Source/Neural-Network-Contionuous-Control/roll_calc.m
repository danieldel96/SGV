roll = zeros(5000,1);
normalVec = [all_data(:,6) all_data(:,7) all_data(:,8)];
negY = [zeros(5000,1) -1*ones(5000,1) zeros(5000,1)];
for i = 1:5000
    roll(i) = dot(negY(i,:),normalVec(i,:))/(norm(negY(i,:))*norm(normalVec(i,:)));
end
plot(roll)