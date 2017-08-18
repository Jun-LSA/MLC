function psm_crd_new = pts_transform (psm_crd_old,tfm_param)
%PTS_TRANSFORM:  Transform points(psms) to new coordinate system
%
%   Input:
%       psm_crd: PSM id, coordinates
%       psm_info_old: old PSM attributes (fixed/not fixed)
%       flag_id: Different classificaion flag
%       condition: The corresponding classification condition
%
%   Output:
%       psm_info_new: PSM ID, Attribute 1, Attribute 2,..., Attribute n
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
%   $Revision: 1.0.0 $  $Date: 2017/06/07 12:21:25 $

if nargin < 2
    tfm_param = 0;
end

% (1) Minus the mean of all the data
psm_crd_old(:,2) = psm_crd_old(:,2) - mean(psm_crd_old(:,2));
psm_crd_old(:,3) = psm_crd_old(:,3) - mean(psm_crd_old(:,3));
psm_crd_old(:,4) = psm_crd_old(:,4) - mean(psm_crd_old(:,4));

% Option 1: Select one line based on 2D plot
figure;
plot( psm_crd_old(:,2),psm_crd_old(:,3),'.');
pts_selected2 = zeros(2,2);
for i = 1:2
    
%     dcm_obj = datacursormode(fig1);
%     set(dcm_obj,'DisplayStyle','datatip',...
%         'SnapToDataVertex','off','Enable','on');
%     waitforbuttonpress;
%     fprintf('Please select Point %d :\n',i); 
%     c_info = getCursorInfo(dcm_obj); 
%     pts_selected2(i,:) = c_info.Position(1:2); 
    fprintf('Please select Point %d :\n',i); 
    fprintf('Mouse left click to zoom in and mouse right click to select point!\n'); 
    pts_selected2(i,:) = ginput2(1);
    fprintf('Point %d  Selected!\n',i); 
end
fprintf(' The reference line is selected!\n');
close all;
delta_x = diff(pts_selected2(:,1));
delta_y = diff(pts_selected2(:,2));
% rot_angle = atan(delta_y/delta_x)-90*pi/180;   
% rot_angle = atan(delta_y/delta_x)+90*pi/180;   
rot_angle = atan(delta_x/delta_y) + pi*1.5;
Tram_mat = [ cos(rot_angle) -sin(rot_angle); sin(rot_angle) cos(rot_angle)];
psm_crd_new = psm_crd_old;
for i = 1: length(psm_crd_old(:,1))
   psm_crd_new(i,2:3) = Tram_mat* [psm_crd_old(i,2); psm_crd_old(i,3)];      
end
fprintf('The coordinates is transformed with rotation angle %f degree !\n', rot_angle*180/pi);

figure;
plot( psm_crd_new(:,2),psm_crd_new(:,3),'.');
hold on;plot( psm_crd_old(:,2),psm_crd_old(:,3),'r.');