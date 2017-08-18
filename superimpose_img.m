function pic_new = superimpose_img (pic_bkgd,pic_top,dwm_flag)
%SUPERIMPOSE_IMG:  Superimpose two images and generate a new one
%   SUPERIMPOSE_IMG (img_bkgd,img_top)
%
%   Input:
%
%   Output:
%
%   Example:
%
%   Version:
%       1.0.0 - 6/13/2017
%   See also **
%
%   Copyright 2006-2017 The Land Solution Australia, Inc.
%   $Revision: 1.0.0 $  $Date: 2017/06/13 13:51:25 $

% pic_bkgd = 'background.png';
% pic_top = 'Daily_PSM_3D_2017-06-03.png';
date_flag = pic_top(end-13:end-4);

switch dwm_flag
    case 1
        dir_pic = 'Pictures\Daily\';
    case 2
        dir_pic = 'Pictures\Weekly\';
    case 3
        dir_pic = 'Pictures\Monthly\';
end
warning('off', 'Images:initSize:adjustingMag');
warning('off','MATLAB:hg:ColorSpec_None');

img_bkgd = imread(pic_bkgd);
img_bkgd = imrotate(img_bkgd,2,'nearest','loose'); % Rotate a little angle of raw image
img_bkgd = imcrop(img_bkgd,[17.5 86.5 1318 340]);% Manually crop those blackback ground color
figure; imagesc(img_bkgd);

set(gcf,'Position',[100,100,1346,510]);
axis off;
hold on;
img_top = imread(strcat(dir_pic,pic_top));
temp = size(img_bkgd);
img_top = imresize(img_top,temp(1:2));
h = imagesc(img_top);
set(h, 'AlphaData', 0.65);
% xpos = get(h , 'XData'); % ypos = get(h , 'YData');
set(h, 'XData', [70 1230]);% Manually configuration
set(h, 'YData', [45 300]);
cbar = colorbar('southoutside');
set(cbar,'XColor',[1,1,1]);

%
if dwm_flag == 1 % Daily variation
    caxis([0, 15]);
    str_temp = strcat('MLC Daily 3D Displacement (unit:mm)',' Date: ',date_flag);
end

if dwm_flag == 2 % Weekly variation
    caxis([0, 5]);
    str_temp = strcat('MLC Weekly 3D Displacement (unit:mm)',' Date: ',date_flag);
end

if dwm_flag == 3 % Monthly variation
    caxis([0, 5]);
    str_temp = strcat('MLC Monthly 3D Displacement (unit:mm)',' Date: ',date_flag);
end


MyBox = uicontrol('style','text');
set(MyBox,'String',str_temp);
set(MyBox,'Position',[500   476   429    27])
set(MyBox,'ForegroundColor',[1,1,1]);
set(MyBox,'BackgroundColor',[0,0,0]);
set(MyBox,'Fontsize',12);
%
% set(gcf,'color','none');
set(gcf, 'PaperPositionMode', 'auto');
pic_new = strcat(dir_pic,'BKGD_',pic_top);
export_fig(gcf,pic_new,'-transparent');
