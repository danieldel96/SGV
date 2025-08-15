last = 0;
changes = 0;

for i = 1:10000
cur = all_data(i,3);
if cur~=last
last = cur;
changes = changes+1;
end
end

sampling_rate = changes/t_e