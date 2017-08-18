function [psm_crd, psm_info] = read_psm (psm_excel_file);
%READ_PSM:  Read pre-defined PSM coordinates and other information
%   READ_TILTMETER(psm_excel_file) 
%
%   Input:
%       psm_excel_file - The .xlsx file of PSM recordings, assume the
%       format is as PointName	Northing	Easting	Elevation	IsFixed
%
%   Output:
%       psm_crd - PSM coordinates array 
%       psm_info - PSM information
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
%   $Revision: 1.0.0 $  $Date: 2017/06/07 10:51:25 $

[~,~,raw_cell] = xlsread(psm_excel_file);
psm_n = size(raw_cell,1) - 1;
psm_crd = zeros(psm_n,4);
psm_crd(:,1:4) = cell2mat(raw_cell(2:end,1:4)); 
psm_info = zeros(psm_n,2);
psm_info(:,1) = psm_crd(:,1);
fix_id = strcmp((raw_cell(2:45,5)) ,'YES');
idx = find(fix_id == 1);
psm_info(idx,2) = 1;
