% Purpose:
%   (1) Plot all the PSM variations in a plane with annimation
%   (2) Plot PSM on mixed channel variations in 3D / Vertical direction
%   (3) Convert the local coordinates into the object-based frame
%   (4) Has the ability to disable particular PSM, to disable particular
%   observation time
% Input:
%   (1) PSM coordinates
%   (2) T4D excel file of PSM variation
%
% Output:
%   (1) 2D imagesc plot like ionospheric daily/seasonal variations
%   (2) Table summary about displacement in the month, average velocity,
%   statistic information of observation per month, per week
%   (3) 3D displacement, subsidence, velocity
%
% Analysis:
%   (1) Prediction
%   (2) Regression
%
% Version:
%   (1) 1.0.0 - Jun Wang, 08/06/2017
%   (2) 1.0.1 - Jun Wang, 12/06/2017, to add the background image
%   (3) 2.0.1 - Jun Wang, 07/07/2017, cancel the procedure of mannually
%   (4) 2.0.2 - Jun Wang, 01/08/2017, add the function  to check the monthly
%   data integrity to guarantte the accurate statistic information
%   selection of prisms on channel
%   (5) 3.0.0 - Jun Wang, 18/8/2017, skipping those steps of choose points
%   on the channel, using the default mixed liquid channel prism table
%   index


psm_excel_file = 'Points Coordinates.xlsx';
t4d_3d_per_day_file = 'C:\Users\jun.wang\Downloads\Mixed Liquor Channel by Day (11).xlsx';
pic_bkgd = 'background.png';
%% (1) Loading the pre-defined PSM coordinates and convert to channel-based frame
[psm_crd, psm_info] = read_psm(psm_excel_file);
psm_crd(:,[2 3]) = psm_crd(:,[3 2]);% Convert XY axis
psm_crd_new = pts_transform (psm_crd); %  330.547924 degree

%% (2) Select the corresponding points
psm_class_id = 3; % GUI selection
psm_info_new = pts_classify (psm_crd_new, psm_info,psm_class_id);

%% (3) Read the corresponding information, e.g., 3D displacement, subsidence,velocity
t4d_obs_id = 1; % Delta 3D
[obs_t4d,obs_idx] = read_t4d (t4d_3d_per_day_file,t4d_obs_id);

%% (4) Extract selected points information
psm_id_plan_selected = psm_info_new(find(psm_info_new(:,psm_class_id+1) == 1),1);
psm_id_obs_selected = obs_idx;
psm_id_com = intersect(psm_id_plan_selected,psm_id_obs_selected);
[~,idx_plan] = intersect(psm_info_new(:,1),psm_id_com);
[~,idx_obs] = intersect(psm_id_obs_selected,psm_id_com);
psm_crd_new = psm_crd_new(idx_plan,:);
psm_crd_new(:,2:3) = psm_crd_new(:,2:3) - repmat(min(psm_crd_new(:,2:3)),length(psm_crd_new(:,2:3)),1);
% Save the image into particular folder
epochs_n = size(obs_t4d,1);
psm_n = size(obs_idx,1);
[x_grid,y_grid] = meshgrid(min(psm_crd_new(:,2))-1:1:max(psm_crd_new(:,2)+1.5),min(psm_crd_new(:,3))-1:1:max(psm_crd_new(:,3))+1.2);
z_grid = griddata(psm_crd_new(:,2),psm_crd_new(:,3),psm_crd_new(:,4),x_grid,y_grid,'v4');
% Daily/Weekly/Monthly variations
beg_week_flag = 0;end_week_flag = 0;% Determine the beginning/end day of the week
beg_month_flag = 0;end_month_flag = 0; % Determine the beginning/end day of a month

for i = 1:epochs_n
    % for i = 1:70
    date_mark = datestr(obs_t4d(i,1),29);
    [y_t,m_t,d_t] = ymd (date_mark);
    dow = weekday (date_mark);
    c_grid = griddata(psm_crd_new(:,2),psm_crd_new(:,3),obs_t4d(i,idx_obs+1)',x_grid,y_grid,'v4');
    % Daily variation pictures without background
    pic_top = plot_variation2d(x_grid,y_grid,z_grid,c_grid,date_mark,1);
    % Combination of background and variation images
    pic_with_bkgd = superimpose_img (pic_bkgd,pic_top,1);
    
    % Weekly variation pictures
    if dow == 1
        beg_week_flag = 1;
        end_week_flag = 0;
        c_grid_beg_dow = c_grid;
    end
    if dow == 7
        end_week_flag = 1;
        if beg_week_flag == 1
            c_grid_end_dow = c_grid;
            c_grid_dow_dif = c_grid_end_dow - c_grid_beg_dow;
            pic_top = plot_variation2d(x_grid,y_grid,z_grid,c_grid_dow_dif,date_mark,2);
            % Combination of background and variation images
            pic_with_bkgd = superimpose_img (pic_bkgd,pic_top,2);
        else
            beg_week_flag = 0;   end_week_flag = 0;
            fprintf('No weekly 3D variation image generation on %s \n',date_mark);
        end
    end
    % Monthly variation pictures
    if d_t == 1
        beg_month_flag = 1;
        end_month_flag = 0;
        c_grid_beg_dom = c_grid;
    end
    if d_t == eomday(y_t,m_t)
        end_month_flag = 1;
        if beg_month_flag == 1
            c_grid_end_dom = c_grid;
            c_grid_dom_dif = c_grid_end_dom - c_grid_beg_dom;
            pic_top = plot_variation2d(x_grid,y_grid,z_grid,c_grid_dow_dif,date_mark,3);
            % Combination of background and variation images
            pic_with_bkgd = superimpose_img (pic_bkgd,pic_top,3);
        else
            end_month_flag = 0;
            fprintf('No monthly 3D variation image generation on %s \n',date_mark);
        end
    end
    close all;
end

%
%% (5) Produce annimation
% The whole observation period
gif_mlc_3d_daily_fname = strcat('Pictures\Daily\','MLC_3D_daily_movement_bkgd.gif');
gif_mlc_3d_weekly_fname = strcat('Pictures\Weekly\','MLC_3D_weekly_movement_bkgd.gif');
gif_mlc_3d_monthly_fname = strcat('Pictures\Monthly\','MLC_3D_monthly_movement_bkgd.gif');
week_flag = 1;
month_flag = 1;
for i = 1:epochs_n
    date_mark = datestr(obs_t4d(i,1),29);
    [y_t,m_t,d_t] = ymd (date_mark);
    dow = weekday (date_mark);
    if t4d_obs_id == 1
        picname = strcat('Pictures\Daily\','BKGD_Daily_PSM_3D_',date_mark,'.png');
    end
    Img = imread(picname);
    figure;
    set(gcf,'outerposition',get(0,'screensize'));
    imshow(Img);
    frame = getframe;
    im = frame2im(frame);
    [I,map]=rgb2ind(im,256);
    if i == 1
        imwrite(I,map,gif_mlc_3d_daily_fname,'gif', 'Loopcount',inf, 'BackgroundColor',1,'DelayTime',0.7);%????????
    else
        imwrite(I,map,gif_mlc_3d_daily_fname,'gif','WriteMode','append','DelayTime',0.7);
    end;
    if dow == 7 % Weekly Annimation GIF
        picname_week = strcat('Pictures\Weekly\','BKGD_Weekly_PSM_3D_',date_mark,'.png');
        if (exist(picname_week, 'file')) == 2
            Img_week = imread(picname_week);
            figure;
            set(gcf,'outerposition',get(0,'screensize'));
            imshow(Img_week);
            frame_week = getframe;
            im_week = frame2im(frame_week);
            [I_week,map_week]=rgb2ind(im_week,256);
            if week_flag == 1
                imwrite(I_week,map_week,gif_mlc_3d_weekly_fname,'gif', 'Loopcount',inf, 'BackgroundColor',1,'DelayTime',0.7);
                week_flag = week_flag+1;
            else
                imwrite(I_week,map_week,gif_mlc_3d_weekly_fname,'gif','WriteMode','append','DelayTime',0.7);
            end;
        end
    end
    if d_t == eomday(y_t,m_t) % Monthly Annimation GIF
        picname_month = strcat('Pictures\Monthly\','BKGD_Monthly_PSM_3D_',date_mark,'.png');
        if (exist(picname_month, 'file')) == 2
            Img_month = imread(picname_month);
            figure;
            set(gcf,'outerposition',get(0,'screensize'));
            imshow(Img_month);
            frame_month = getframe;
            im_month = frame2im(frame_month);
            [I_month,map_month]=rgb2ind(im_month,256);
            if month_flag == 1
                imwrite(I_month,map_month,gif_mlc_3d_monthly_fname,'gif', 'Loopcount',inf, 'BackgroundColor',1,'DelayTime',0.7);
                month_flag = month_flag+1;
            else
                imwrite(I_month,map_month,gif_mlc_3d_monthly_fname,'gif','WriteMode','append','DelayTime',0.7);
            end;
        end
    end
    close all ;
end



%% (6) Generation of statistic informaton
obs_t4d_month = obs_t4d;
% ref_date_flag = 62;
% ref_duration = 28;
ref_date_flag = 14;
ref_duration = 17;
date_mark = datestr(obs_t4d(ref_duration+ref_date_flag,1),29);
% Fill the first row and the last row with the latest measurement
% information
[obs_t4d_month,zeros_arry] = data_array_integrity_check(obs_t4d_month);
variation_month = obs_t4d_month(ref_duration+ref_date_flag,2:end) - obs_t4d_month(ref_date_flag,2:end);
c_grid = griddata(psm_crd_new(:,2),psm_crd_new(:,3),variation_month',x_grid,y_grid,'v4');

% Daily variation pictures without background
pic_top = plot_variation2d(x_grid,y_grid,z_grid,c_grid,date_mark,3);
% Combination of background and variation images
pic_with_bkgd = superimpose_img (pic_bkgd,pic_top,3);
%
mean_month = mean(abs(variation_month))
[max_month, max_id] = max(abs(variation_month))
obs_idx(max_id)
std_month = std(abs(variation_month))
% Mean, Std, Min, Max, Median
% The daily statistic information

% The weekly statistic information

% The monthly statistic information

