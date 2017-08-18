function [obs_t4d_month_new,zeros_arry] = data_array_integrity_check(obs_t4d_month)

% This function is to gurantee that those missing points in particular time
% to filled with the latest available information to improve the
% statistical accuracy.
%
% Assuming the first column of obs_t4d_month is the date information;
%
% Version 1.0.1 - Jun Wang, 01/08/2017, this version assumes that all the prisms should have non-zero displacement
%     
obs_t4d_month_new = obs_t4d_month;
[m,n] = size(obs_t4d_month);
zeros_arry = zeros(n,1);
for i = 1:n
    if sum(obs_t4d_month(:,i)) == 0
        zeros_arry(i,1) = 1;
		continue;
	end 
	temp_array = find(obs_t4d_month(:,i) ~= 0);
	if obs_t4d_month(1,i) == 0
		obs_t4d_month_new(1,i) = obs_t4d_month(temp_array(1),i);
	end
	if obs_t4d_month(m,i) == 0 
		obs_t4d_month_new(m,i) = obs_t4d_month(temp_array(m),i);
	end
end 