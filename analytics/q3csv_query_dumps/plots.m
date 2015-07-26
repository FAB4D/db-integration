
% question 3e view
om_view_days = load('question3e_om_view_days.csv');
s_om_view_days = sortrows(om_view_days,1);
figure; bar(s_om_view_days(:,2)); xlabel('days'); ylabel('number');
title('movieload: movie views per day'); axis([0 32 0 520]);
% top 5
om_v_d5 = om_view_days(1:5,:);
figure; bar(om_v_d5(:,1),om_v_d5(:,2));
xlabel('day'); ylabel('number'); axis([0 32 0 520]);
title('movieload: top 5 days (view)');

om_view_years = load('question3e_om_view_years.csv');
data = yearsToPlottable(om_view_years);
figure; bar3(data','detached');
zlabel('number');ylabel('month');set(gca,'xticklabel',[]);
legend('2008','2009','2010','2011','2012');
title('movieload: movie views per month and year');
% top 5
om_v_ys5 = om_view_years(1:5,:);
data = yearsToPlottable(om_v_ys5);
figure; bar3(data','detached');
zlabel('number');ylabel('month');set(gca,'xticklabel',[]);
legend('2008','2009','2010','2011','2012');
title('movieload: top 5 per month and year (view)');

om_view_year = load('question3e_om_view_year.csv');
data = yearToPlottable(om_view_year);
figure; bar(data); xlabel('month'); ylabel('number'); 
title('movieload: movie views per month in 2012');
% top 5
om_v_y5 = om_view_year(1:5,:);
figure; bar(om_v_y5(:,1),om_v_y5(:,3));
xlabel('months'); ylabel('number'); axis([0 13 0 10500]);
title('movieload: top 5 months in 2012 (view)');


% question 3e download
om_down_days = load('question3e_om_download_days.csv');
s_om_down_days = sortrows(om_down_days,1);
figure; bar(s_om_down_days(:,2)); xlabel('days'); ylabel('number');
title('movieload: movie downloads per day'); axis([0 32 0 55]);
% top 5
om_d_d5 = om_down_days(1:5,:);
figure; bar(om_d_d5(:,1),om_d_d5(:,2));
xlabel('day'); ylabel('number'); axis([0 32 0 60]);
title('movieload: top 5 days (download)');

om_down_years = load('question3e_om_download_years.csv');
data = yearsToPlottable(om_down_years);
figure; bar3(data','detached');
zlabel('number');ylabel('month');set(gca,'xticklabel',[]);
legend('2008','2009','2010','2011','2012');
title('movieload: movie downloads per month and year');
% top 5
om_d_ys5 = om_down_years(1:5,:);
data = yearsToPlottable(om_d_ys5);
figure; bar3(data','detached');
zlabel('number');ylabel('month');set(gca,'xticklabel',[]);
legend('2008','2009','2010','2011','2012');
title('movieload: top 5 per month and year (download)');

om_down_year = load('question3e_om_download_year.csv');
data = yearToPlottable(om_down_year);
figure; bar(data); xlabel('month'); ylabel('number'); 
title('movieload: movie downloads per month in 2012');
% top 5
om_d_y5 = om_down_year(1:5,:);
figure; bar(om_d_y5(:,1),om_d_y5(:,3));
xlabel('months'); ylabel('number'); axis([0 13 0 1200]);
title('movieload: top 5 months in 2012 (download)');

% question 3e hard copies
pm_days = load('question3e_pm_days.csv');
s_pm_days = sortrows(pm_days,1);
figure; bar(s_pm_days(:,2)); xlabel('days'); ylabel('number');
title('wollyhood: movies sold per day'); axis([0 32 0 800]);
% top 5
pm_d5 = pm_days(1:5,:);
figure; bar(pm_d5(:,1),pm_d5(:,2));
xlabel('day'); ylabel('number'); axis([0 32 0 800]);
title('wollyhood: top 5 days (hard copies)');

pm_years = load('question3e_pm_years.csv');
data = yearsToPlottable(pm_years);
figure; bar3(data','detached');
zlabel('number');ylabel('month');set(gca,'xticklabel',[]);
legend('2008','2009','2010','2011','2012');
title('wollyhood: movies sold per month and year');
% top 5
pm_ys5 = pm_years(1:5,:);
data = yearsToPlottable(pm_ys5);
figure; bar3(data','detached');
zlabel('number');ylabel('month');set(gca,'xticklabel',[]);
legend('2008','2009','2010','2011','2012');
title('wollyhood: top 5 per month and year (hardcopies)');

pm_year = load('question3e_pm_year.csv');
data = yearToPlottable(pm_year);
figure; bar(data); xlabel('month'); ylabel('number'); 
title('wollyhood: movies sold per month in 2012');
% top 5
pm_y5 = pm_year(1:5,:);
figure; bar(pm_y5(:,1),pm_y5(:,3));
xlabel('months'); ylabel('number'); axis([0 13 0 15000]);
title('wollyhood: top 5 months in 2012 (hard copies)');

% question 3d
om = load('question3d_om.csv');
pm = load('question3d_pm.csv');
om_data = yearsToPlottable(om);
pm_data = yearsToPlottable(pm);

figure;
subplot(1,2,1);
bar3(om_data','detached'); zlabel('number');ylabel('month'); set(gca,'xticklabel',[]);
title('movieload: movie views and downloads per month and year');
subplot(1,2,2);
bar3(pm_data','detached'); zlabel('number');ylabel('month'); set(gca,'xticklabel',[]);
title('wollyhood: movies sold per month and year');
legend('2008','2009','2010','2011','2012');



