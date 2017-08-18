function psm_info_new = pts_classify (psm_crd, psm_info_fix,flag_id,condition)
%PTS_CLASSIFY:  Classify points(psms) with different conditions
%   Comments:
%   Default, all the plots are 2D plot
%
%   Input:
%       psm_crd: PSM id, coordinates
%       psm_info_old: old PSM attributes (fixed/not fixed)
%       flag_id: Different classificaion flag
%               Flag ==3 --- GUI Selected
%       condition: The corresponding classification condition
%
%   Output:
%       psm_info_new: PSM ID, Attribute 1, Attribute 2,..., Attribute n
%               Attribute 1 - Fixed or not
%               Attribute 2 - Distance with centre point (On the channel or
%               not)
%               Attribute 3 - GUI Selected or not
%               Attribute 4 - Elevation
%               Attribute 5 - Specific requirement
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
%   $Revision: 1.0.0 $  $Date: 2017/06/07 11:51:25 $

if nargin<2
    psm_info_old = nan ;
end
if nargin<3
    flag_id = 0;
end
if nargin<4
    condition = 0;
end
psm_info_new = zeros(length(psm_crd),6);
psm_info_new(:,1) = psm_crd(:,1);

%% PSM Attribute 1 : Fixed or not
psm_info_new(:,2) = psm_info_fix(:,2);

%% PSM Attribute 2 : Distance within Center Points

%% PSM Attribute 3 : GUI Selected
if flag_id == 3
    figure;
    plot(psm_crd(:,2),psm_crd(:,3),'.');
    fprintf('Please select those points that are interested by brush!\n');
    idx3 = selectdata('selectionmode','brush','BrushSize',0.025,'Verify','on');
    psm_info_new(idx3,4) = 1;
    fprintf('%d points are selected ! \n', length(idx3));
    hold on;plot(psm_crd(idx3,2),psm_crd(idx3,3),'ro');
    close all;
end

%% PSM Attribute 4 : Rectangle
if flag_id == 4
    figure;
    plot(psm_crd(:,2),psm_crd(:,3),'.');
    fprintf('Please select those points that are interested with a rectangle!\n');
    idx4 = selectdata('selectionmode','Rect','Verify','on');
    psm_info_new(idx4,4) = 1;
    fprintf('%d points are selected ! \n', length(idx3));
    hold on;plot(psm_crd(idx4,2),psm_crd(idx4,3),'ro');
    close all;
end
%% PSM Attribute 5 : Elevation




