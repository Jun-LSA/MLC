function [y,m,d] = ymd(date_mark);
% YMD :  Get the day of week, day of month,
%   PLOT_VARIATION2D (x_grid,y_grid,z_grid,psm_crd_new,obs_t4d,idx_plan,idx_obs,i,plot_flag)
%
%   Input: 
%
%   Output: 
%
%   Example: 
%
%   Version:
%       1.0.0 - 6/12/2017
%   See also **
%
%   Copyright 2006-2017 The Land Solution Australia, Inc.
%   $Revision: 1.0.0 $  $Date: 2017/06/12 10:51:25 $

[d] = day(date_mark);
[m] = month(date_mark);
[y] = year(date_mark);