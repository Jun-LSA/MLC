function picname = plot_variation2d(x_grid,y_grid,z_grid,c_grid,date_mark,dwm_flag)
%PLOT_VARIATION2D:  Plot the 2D variation of mixed liquid chanel
%   PLOT_VARIATION2D (x_grid,y_grid,z_grid,psm_crd_new,obs_t4d,idx_plan,idx_obs,i,plot_flag)
%
%   Input:
%
%   Output:
%
%   Example:
%
%   Version:
%       1.1.0 - 6/13/2017
%   See also **
%
%   Copyright 2006-2017 The Land Solution Australia, Inc.
%   $Revision: 1.0.0 $  $Date: 2017/06/07 13:51:25 $

% Default background image size
img_x = 1345; img_y = 510;
dir_daily = 'Pictures\Daily\';
dir_weekly = 'Pictures\Weekly\';
dir_monthly = 'Pictures\Monthly\';
hFig = figure;
set(hFig,'Position',[0,0,img_x,img_y]);
% c_grid = griddata(psm_crd_new(:,2),psm_crd_new(:,3),obs_t4d(i,idx_obs+1)',x_grid,y_grid,'v4');
% hold on;
% scatter3(psm_crd_new(:,2),psm_crd_new(:,3),psm_crd_new(:,4),'filled','d');
surf(x_grid,y_grid,z_grid,c_grid,'EdgeColor','none');
set(gca,'xlim',[-0.5,56]); set(gca,'ylim',[-0.5,13]);
set(hFig,'Position',[0,0,img_x-60,img_y]);
view([-0.05 90]);
axis off;

% date_mark = datestr(obs_t4d(i,1),29); 

warning('off','MATLAB:hg:ColorSpec_None')
set(gcf,'color','none');
set(gcf, 'PaperPositionMode', 'auto');
if dwm_flag == 1
    caxis([0, 15]) % Daily
    %     colorbar('SouthOutside' );
    %     title({'Mixed liquid channel Daily 3D displacement (unit:mm)', strcat('Date:{ }',date_mark)});
    picname = strcat('Daily_PSM_3D_',date_mark,'.png');
    export_fig(gcf,strcat(dir_daily,picname),'-transparent');
end
if dwm_flag == 2 % Weekly
    caxis([0, 5]) 
    picname = strcat('Weekly_PSM_3D_',date_mark,'.png'); 
    export_fig(gcf,strcat(dir_weekly,picname),'-transparent');
end
if dwm_flag == 3 % Monthly
    caxis([0, 10]) 
    picname = strcat('Monthly_PSM_3D_',date_mark,'.png'); 
    export_fig(gcf,strcat(dir_monthly,picname),'-transparent');
end
% close;

%% Version 1.0 12-06-2017
% PLOT_VARIATION2D (x_grid,y_grid,z_grid,psm_crd_new,obs_t4d,idx_plan,idx_obs,i,plot_flag)
% % Default background image size
% img_x = 1345;
% img_y = 510;
% hFig = figure;
% set(hFig,'Position',[0,0,img_x,img_y]);
% % set(gcf,'PaperSize',[img_x img_y]);
% surf(x_grid,y_grid,z_grid);
% set(gca,'xlim',[-0.5,56]);
% set(gca,'ylim',[-0.5,13.1]);
% set(hFig,'Position',[0,0,img_x-140,img_y]);
%
% hold on;
% % Alternative option: plot the channel line
% scatter3(psm_crd_new(:,2),psm_crd_new(:,3),obs_t4d(i,idx_obs+1),'filled','d');
% view([-0.05 90]);
% date_mark = datestr(obs_t4d(i,1),29);
% xlabel('Channel Length'); ylabel('Chanel Width');
%
% if plot_flag == 1
%     caxis([0, 15]) % Daily
%     colorbar('SouthOutside' );
%     title({'Mixed liquid channel Daily 3D displacement (unit:mm)', strcat('Date:{ }',date_mark)});
% %     picname = strcat('Pictures\Daily\','Daily_PSM_3D_',date_mark,'.png');
%     picname = strcat('Daily_PSM_3D_',date_mark,'.png');
%
%     set(hFig,'Position',[0,0,img_x-50,img_y]);
%     warning('off','MATLAB:hg:ColorSpec_None')
%     set(gcf,'color','none');
%     set(gcf, 'PaperPositionMode', 'auto');
%     saveas(gcf,picname);
% %     saveas(gcf,picname,'PaperPositionMode', 'auto');
% %     export_fig(gcf,picname,'-transparent');
% end
% if plot_flag == 2 % Weekly
%     caxis([0, 5])
%     colorbar;
%     title({'Mixed liquid channel Weekly 3D displacement (unit:mm)', strcat('Date:{ }',date_mark)});
%     picname = strcat('Pictures\Weekly\','Weekly_PSM_3D_',date_mark,'.png');
%     saveas(gcf,picname);
% end
% if plot_flag == 3 % Monthly
%     caxis([0, 10])
%     colorbar;
%     title({'Mixed liquid channel Monthly 3D displacement (unit:mm)', strcat('Date:{ }',date_mark)});
%     picname = strcat('Pictures\Monthly\','Monthly_PSM_3D_',date_mark,'.png');
%     saveas(gcf,picname);
% end
% % close;