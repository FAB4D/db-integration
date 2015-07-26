clear all;
clc;
close all;

% Q1 point1
num_hc = load('num_hc_still_in_shop.csv');
num_onm = load('num_onm_still_in_shop.csv');
num_med = [num_onm;num_hc;num_onm+num_hc];
num_dvd = 25208;
num_vhs = 29726;
num_br = 44772;

num_hc_types = [num_dvd;num_vhs;num_br;num_hc];
figure; bar(num_hc_types,0.4);
set(gca,'XTickLabel',{'DVD','VHS','BLURAY','total'});
ylabel('number');
title('wollyhood: movies in offer per media type');

figure; bar([num_onm/2; num_onm/2; num_onm],0.2);
set(gca,'XTickLabel',{'view','download','total'});
ylabel('number');
title('movieload: movies in offer per media type');

figure; bar(num_med,0.3);
set(gca,'XTickLabel',{'movieload','wollyhood','total'});
ylabel('number');
title('movies in offer per shop');


% Q1 point2 
overl_mov = load('num_overlaps_in_mov.csv');
overl_off = load('num_overlaps_in_offer.csv');

% Q2 point1
num_cus_tot = load('num_cus_tot.csv');
num_cus_ml = load('num_cus_ML.csv');
num_cus_wh = load('num_cus_WH.csv');
num_cus = [num_cus_wh,num_cus_ml,num_cus_tot];
figure; bars = bar(num_cus,0.5);
set(gca,'xticklabel',{'wollyhood','movieload','total'});
title('customers per shop');
ylabel('number');

% Q2 point2 + Q1 point 2
num_overlaps_cus = load('num_overlaps_cus.csv');
figure; bar([overl_mov,overl_off,num_overlaps_cus],0.5);
set(gca,'XTickLabel',{'movies','movies in offer','customers'});
ylabel('number');
title('overlaps between movieload and wollyhood');


% Q2 point3
num_d_v_tot = load('num_down_n_view_tot.csv');
num_d_tot = load('num_down_tot.csv');
num_v_tot = load('num_view_tot.csv'); 
figure; bar([num_d_tot,num_v_tot,num_d_v_tot],0.4);
ylabel('number');
set(gca,'xticklabel',{'download','view','total'});
title('movieload: sales per media type');

num_phy_s_tot = load('num_phy_sales_tot.csv');
num_dvd_s_tot = load('num_dvd_sales_tot.csv');
num_vhs_s_tot = load('num_vhs_sales_tot.csv');
num_br_s_tot = load('num_bluray_sales_tot.csv');
figure; bar([num_dvd_s_tot,num_vhs_s_tot,num_br_s_tot,num_phy_s_tot],0.4);
ylabel('number');
set(gca,'xticklabel',{'DVD','VHS','BLURAY','total'});
title('wollyhood: sales per media type');

num_dvd_p_y = load('num_dvd_sales_per_y.csv');
num_br_p_y = load('num_bluray_sales_per_y.csv');
num_vhs_p_y = load('num_vhs_sales_per_y.csv');
num_vhs_p_y = [0 2005;num_vhs_p_y];
figure; bar(num_dvd_p_y(:,2),[num_dvd_p_y(:,1),num_br_p_y(:,1),num_vhs_p_y(:,1)]);
legend('DVD','BLURAY','VHS'); ylabel('number');
title('wollyhood: sales per year and per media type');

num_down_p_y  = load('num_down_per_y.csv'); 
num_view_p_y = load('num_view_per_y.csv');
figure; bar(num_down_p_y(:,2),[num_down_p_y(:,1),num_view_p_y(:,1)]);
ylabel('number');
title('movieload: sales per year and per media type'); legend('download','view');

num_d_v_p_y = load('num_down_n_view_per_y.csv');
num_phy_s_p_y = load('num_phy_sales_per_y.csv');
figure; bar(num_d_v_p_y(:,2),[num_d_v_p_y(:,1),num_phy_s_p_y(:,1)]);
ylabel('number');
title('sales per year'); legend('movieload','wollyhood');

% Q2 point4
rev_onl_tot = load('rev_online_shop_tot.csv');
rev_onl_p_y = load('rev_online_shop_per_y.csv');

rev_phy_tot = load('rev_phy_shop_tot.csv'); 
rev_phy_p_y = load('rev_phy_shop_per_y.csv');


figure; bar(rev_onl_p_y(:,2),[rev_onl_p_y(:,1),rev_phy_p_y(:,1)]);
ylabel('USD');
title('revenue per year and per shop'); legend('movieload','wollyhood');

figure; bar([rev_onl_tot,rev_phy_tot,rev_onl_tot+rev_phy_tot],0.4);
set(gca,'xticklabel',{'movieload','wollyhood','total'});
ylabel('USD'); title('total revenue per shop');
% total rev for ML and WH: sum up


% Q2 point 5: for plotting choose first 100 and last 100
avg_rev_os_per_c_tot = load('avg_rev_online_shop_per_cus_tot.csv'); % done
figure; bar(avg_rev_os_per_c_tot(1:100,1));
ylabel('USD'); xlabel('customer');
title('movieload: average revenue per customer (1-100)');
axis([0 101 0 18]);

avg_rev_os_per_c_per_y = load('avg_rev_online_shop_per_cus_per_y.csv'); % done
I = find(avg_rev_os_per_c_per_y(:,2)<=50); % first 50 
data = to3dCusData(avg_rev_os_per_c_per_y(I,:),1,50);
figure; bar3(data);
set(gca,'xticklabel',[]);
zlabel('USD'); ylabel('customer'); 
legend('2005','2006','2007','2008','2009','2010','2011','2012');
title('movieload: average revenue per customer (per year)');

avg_rev_ps_per_c_tot = load('avg_rev_phy_shop_per_cus_tot.csv'); % done
figure; bar(avg_rev_ps_per_c_tot(1:100,1));
ylabel('USD'); xlabel('customer ID');
title('wollyhood: average revenue per customer (1-100)');
axis([0 101 0 40]);

avg_rev_ps_per_c_per_y = load('avg_rev_phy_shop_per_cus_per_y.csv'); % not done
I = find(avg_rev_ps_per_c_per_y(:,2)<=100050); % first 50 
data = to3dCusData(avg_rev_ps_per_c_per_y(I,:),100001,100050);
figure; bar3(data,'detached');
set(gca,'xticklabel',[]);
zlabel('USD'); ylabel('customer');
legend('2005','2006','2007','2008','2009','2010','2011','2012');
title('wollyhood: average revenue per customer (per year)');

% Q2 point 6
prof_d_n_v_tot = load('prof_on_down_n_view_tot.csv'); % done
prof_d_n_v_p_y = load('prof_on_down_n_view_per_y.csv');%done

prof_phy_tot = load('prof_phy_shop_tot.csv'); % done
prof_phy_p_y = load('prof_phy_shop_per_y.csv'); % done

figure; bar([prof_d_n_v_tot,prof_phy_tot,prof_d_n_v_tot+prof_phy_tot]);
ylabel('USD'); set(gca,'xticklabel',{'movieload','wollyhood','total'});
title('net profit per shop and in total');

figure; bar(prof_phy_p_y(:,2),[prof_d_n_v_p_y(:,1),prof_phy_p_y(:,1),prof_d_n_v_p_y(:,1)+prof_phy_p_y(:,1)]);
ylabel('USD'); xlabel('year'); legend('movieload','wollyhood','total');
title('net profit per shop and in total (per year)');

% Q2 point7
avg_prof_d_per_cus_tot = load('avg_prof_on_down_per_cus_tot.csv');
avg_prof_v_per_cus_tot = load('avg_prof_on_view_per_cus_tot.csv');
Iv = find(avg_prof_d_per_cus_tot(:,2)<=100); % problem
Id = find(avg_prof_v_per_cus_tot(:,2)<=100);
vdata = avg_prof_v_per_cus_tot(Iv,:);
ddata = avg_prof_d_per_cus_tot(Id,:);
data = mergeViewDown(vdata,ddata,100);
figure; bar(data(:,1)); 
ylabel('USD'); xlabel('customer'); title('movieload: average net profit per customer in total (1-100)');

avg_prof_hc_per_cus_tot = load('avg_prof_on_hc_per_cus_tot.csv');
figure;bar(avg_prof_hc_per_cus_tot(1:100,1));
ylabel('USD');xlabel('customer');title('wollyhood: average net profit per customer in total (1-100)');

avg_prof_d_per_cus_p_y = load('avg_prof_on_down_per_cus_per_y.csv');
avg_prof_v_per_cus_p_y = load('avg_prof_on_view_per_cus_per_y.csv');
I = find(avg_prof_d_per_cus_p_y(:,2)<=50); % first 50 
data_d = to3dCusData(avg_prof_d_per_cus_p_y(I,:),1,50);
I = find(avg_prof_v_per_cus_p_y(:,2)<=50); % first 50 
data_v = to3dCusData(avg_prof_v_per_cus_p_y(I,:),1,50);
data = data_d+data_v
figure; bar3(data,'detached');
set(gca,'xticklabel',[]);
zlabel('USD'); ylabel('customer');
legend('2005','2006','2007','2008','2009','2010','2011','2012');
title('movieload: average net profit per customer (per year)');

avg_prof_hc_per_cus_per_y = load('avg_prof_on_hc_per_cus_per_y.csv');
I = find(avg_prof_hc_per_cus_per_y(:,2)<=100050); % first 50 
data = to3dCusData(avg_prof_hc_per_cus_per_y(I,:),100001,100050);
figure; bar3(data,'detached');
set(gca,'xticklabel',[]);
zlabel('USD'); ylabel('customer');
legend('2005','2006','2007','2008','2009','2010','2011','2012');
title('wollyhood: average net profit per customer (per year)');
 

