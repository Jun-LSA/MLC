function [obs_t4d,obs_idx,unit_idx] = read_t4d (t4d_excel_file,flag);
%READ_PSM:  Read pre-defined PSM coordinates and other information
%   READ_TILTMETER(psm_excel_file)
%
%   Input:
%       t4d_excel_file : The *.xlsx file records the 3D
%       displacement/subsidence/velocity within the predefined date range
%       flag : The mark id of different types of observation
%               Flag == 1, 3D Displacement
%
%   Output:
%       obs_t4d : observation file records, format as listed,
%        Time, PSM1, Obs1, PSM2, Obs2,...,PSMn,Obsn
%
%   Example:
%       psm_excel_file = 'Points Coordinates.xlsx';
%       psm_crd = read_psm(psm_excel_file);
%
%   Version:
%       1.0.0 - 6/7/2017
%   See also **
%
%   Copyright 2006-2017 The Land Solution Australia, Inc.
%   $Revision: 1.0.0 $  $Date: 2017/06/07 13:51:25 $

[~,~,raw_cell] = xlsread(t4d_excel_file);
epoch_n = size(raw_cell,1) - 2;
psm_n = (size(raw_cell,2) - 2)/3;
obs_t4d = zeros(epoch_n,psm_n+1);
obs_idx = zeros(psm_n,1);
%% 3D Displacement Per Day
if flag == 1
    obs_t4d(:,1) = datenum(raw_cell(3:end,2));
    obs_t4d(:,2:end) = cell2mat(raw_cell(3:end,3:3:end));
    for i = 1:psm_n
        temp_flag = raw_cell(1,3*i);
        mark_pos = cell2mat(regexp(temp_flag, ':'));
        temp_flag = char(temp_flag);
        obs_idx(i) = str2num(temp_flag(mark_pos+1:mark_pos+5));
    end
end
% To replace the nan value as the previous value
temp_idx = find(isnan(obs_t4d(1,2:end)));
obs_t4d(1,temp_idx+1) = 0;
for i = 2: epoch_n
    temp_idx = find(isnan(obs_t4d(i,1:end)));
    if isempty(temp_idx)
        continue;
    else
        obs_t4d(i,temp_idx) = obs_t4d(i-1,temp_idx);
    end
end