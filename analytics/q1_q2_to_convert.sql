/*num_hc_still_in_shop*/
select count(pm.id) as num_available_hard_copies from physical_media pm where pm.id not in ( select pmid from physical_sell ) into outfile '/tmp/num_hc_still_in_shop.csv';
/*num_onm_still_in_shop*/
select count(id) as num_available_online_mov from online_media into outfile '/tmp/num_onm_still_in_shop.csv';
/*num_cus_ML*/ 
select count(id) as num_cus__ML from customer where origin='ML' into outfile '/tmp/num_cus_ML.csv';
/*num_cus_WH*/
select count(id) as num_cus_WH from customer where origin='WH' into outfile '/tmp/num_cus_WH.csv';
/*num_cus_tot*/
select count(id) as num_cus__tot from customer into outfile '/tmp/num_cus_tot.csv';
/*num_down_n_view_tot*/
select count(id) as num_down_and_view_tot from online_sell into outfile '/tmp/num_down_n_view_tot.csv';
/*num_down_n_view_per_y*/
select count(id) as num_down_and_view, extract(year from sell_date) as year from online_sell group by extract(year from sell_date) into outfile '/tmp/num_down_n_view_per_y.csv';
/*num_down_tot*/
select count(os.id) as num_down_tot from online_sell os, online_media om where os.omid = om.id and om.type='download' into outfile '/tmp/num_down_tot.csv';
/*num_down_per_y*/
select count(os.id) as num_down, extract(year from os.sell_date) as year from online_sell os, online_media om where os.omid = om.id and om.type='download' group by extract(year from os.sell_date) into outfile '/tmp/num_down_per_y.csv';
/*num_view_tot*/
select count(os.id) as num_view_tot from online_sell os, online_media om where os.omid = om.id and om.type='view' into outfile '/tmp/num_view_tot.csv';
/*num_view_per_y*/
select count(os.id) as num_view, extract(year from os.sell_date) as year from online_sell os, online_media om where os.omid = om.id and om.type='view' group by extract(year from os.sell_date) into outfile '/tmp/num_view_per_y.csv';
/*num_phy_sales_tot*/ 
select count(id) as num_phy_sales_tot from physical_sell into outfile '/tmp/num_phy_sales_tot.csv';
/*num_phy_sales_per_y*/ 
select count(id) as num_phy_sales, extract(year from sell_date) as year from physical_sell group by extract(year from sell_date) into outfile '/tmp/num_phy_sales_per_y.csv';
/*rev_online_shop_tot*/
select round(sum(om.price),2) as rev_online_shop_tot from online_sell os, online_media om where os.omid = om.id into outfile '/tmp/rev_online_shop_tot.csv';
/*rev_online_shop_per_y*/
select round(sum(om.price),2) as rev_online_shop, extract(year from os.sell_date) as year from online_sell os, online_media om where os.omid=om.id group by extract(year from os.sell_date) into outfile '/tmp/rev_online_shop_per_y.csv';
/*rev_phy_shop_tot*/
select round(sum(pm.price),2) as rev_phy_shop_tot from physical_sell ps, physical_media pm where ps.pmid = pm.id into outfile '/tmp/rev_phy_shop_tot.csv';
/*rev_phy_shop_per_y*/
select round(sum(pm.price),2) as rev_phy_shop, extract(year from ps.sell_date) as year from physical_sell ps, physical_media pm where ps.pmid = pm.id group by extract(year from ps.sell_date) into outfile '/tmp/rev_phy_shop_per_y.csv';
/*avg_rev_online_shop_per_cus_tot*/
select round(avg(om.price),2) as avg_rev_online_shop, os.cid from online_sell os, online_media om where os.omid = om.id group by os.cid into outfile '/tmp/avg_rev_online_shop_per_cus_tot.csv';
/*avg_rev_online_shop_per_cus_per_y*/
select round(avg(om.price),2) as avg_rev_online_shop, os.cid, extract(year from os.sell_date) from online_sell os, online_media om where os.omid = om.id group by os.cid, extract(year from os.sell_date) into outfile '/tmp/avg_rev_online_shop_per_cus_per_y.csv';
/*avg_rev_phy_shop_per_cus_tot*/
select round(avg(pm.price),2) as avg_rev_phy_shop,ps.cid from physical_sell ps, physical_media pm where ps.pmid = pm.id group by ps.cid into outfile '/tmp/avg_rev_phy_shop_per_cus_tot.csv';
/*avg_rev_phy_shop_per_cus_per_y*/
select round(avg(pm.price),2) as avg_rev_phy_shop ,ps.cid,extract(year from ps.sell_date) from physical_sell ps, physical_media pm where ps.pmid = pm.id group by ps.cid, extract(year from ps.sell_date) into outfile '/tmp/avg_rev_phy_shop_per_cus_per_y.csv';
/*prof_on_down_n_view_tot*/
select round(sum(om.price - 0.3*om.price),2) from online_sell os, online_media om where os.omid=om.id and om.type='download' into outfile '/tmp/prof_on_down_n_view_tot.csv';
/*prof_on_down_n_view_per_y*/ 
select round(sum(om.price - 0.3*om.price),2),extract(year from os.sell_date) as year from online_sell os, online_media om where os.omid=om.id and om.type='download' group by extract(year from os.sell_date) into outfile '/tmp/prof_on_down_n_view_per_y.csv';
/*prof_on_view_tot*/
select round(sum(om.price - 0.25*om.price),2) from online_sell os, online_media om where os.omid=om.id and om.type='view' into outfile '/tmp/prof_on_view_tot.csv';
/*prof_on_view_per_y*/ 
select round(sum(om.price - 0.25*om.price),2) ,extract(year from os.sell_date) as year from online_sell os, online_media om where os.omid=om.id and om.type='view' group by extract(year from os.sell_date) into outfile '/tmp/prof_on_view_per_y.csv';
/*prof_phy_shop_tot*/
select round(sum(pm.price - pm.bought_price),2) from physical_sell ps, physical_media pm where ps.pmid=pm.id into outfile '/tmp/prof_phy_shop_tot.csv';
/*prof_phy_shop_per_y*/
select round(sum(pm.price - pm.bought_price),2), extract(year from ps.sell_date) from physical_sell ps, physical_media pm where ps.pmid=pm.id group by extract(year from ps.sell_date) into outfile '/tmp/prof_phy_shop_per_y.csv';
/*avg_prof_on_down_per_cus_tot*/
select round(avg(om.price - 0.3*om.price),2), os.cid from online_sell os, online_media om where os.omid=om.id and om.type='download' group by cid into outfile '/tmp/avg_prof_on_down_per_cus_tot.csv';
/*avg_prof_on_down_per_cus_per_y*/
select round(avg(om.price - 0.3*om.price),2), os.cid, extract(year from os.sell_date) as year from online_sell os, online_media om where os.omid=om.id and om.type='download' group by os.cid,extract(year from os.sell_date) into outfile '/tmp/avg_prof_on_down_per_cus_per_y.csv';
/*avg_prof_on_view_per_cus_tot*/
select round(avg(om.price - 0.25*om.price),2), os.cid from online_sell os, online_media om where os.omid=om.id and om.type='view' group by os.cid into outfile '/tmp/avg_prof_on_view_per_cus_tot.csv';
/*avg_prof_on_view_per_cus_per_y*/
select round(avg(om.price - 0.25*om.price),2), os.cid, extract(year from os.sell_date) as year from online_sell os, online_media om where os.omid=om.id and om.type='view' group by os.cid, extract(year from os.sell_date) into outfile '/tmp/avg_prof_on_view_per_cus_per_y.csv';
/*avg_prof_on_hc_per_cus_tot*/
select round(avg(pm.price-pm.bought_price),2), ps.cid from physical_sell ps, physical_media pm where ps.pmid=pm.id group by ps.cid into outfile '/tmp/avg_prof_on_hc_per_cus_tot.csv';
/*avg_prof_on_hc_per_cus_per_y*/
select round(avg(pm.price-pm.bought_price),2), ps.cid, extract(year from ps.sell_date) as year from physical_sell ps, physical_media pm where ps.pmid=pm.id group by ps.cid, extract(year from ps.sell_date) into outfile '/tmp/avg_prof_on_hc_per_cus_per_y.csv';

	select count(ps.id) as num_phy_sales, extract(year from sell_date) as year /* #of dvd sales per year */
	from physical_sell ps, physical_media pm 
	where ps.pmid=pm.id and pm.type='DVD'
	group by extract(year from sell_date) into outfile '/tmp/num_dvd_sales_per_y.csv';
/* time: 1.88sec */
	select count(ps.id) as num_phy_sales /* #of dvd sales in total */
	from physical_sell ps, physical_media pm 
	where ps.pmid=pm.id and pm.type='DVD' into outfile '/tmp/num_dvd_sales_tot.csv';
/* time: 0.58sec */
	select count(ps.id) as num_phy_sales, extract(year from sell_date) as year /* #of vhs sales per year */	
	from physical_sell ps, physical_media pm 
	where ps.pmid=pm.id and pm.type='VHS'
	group by extract(year from sell_date) into outfile '/tmp/num_vhs_sales_per_y.csv';
/* time: 0.39sec */
	select count(ps.id) as num_phy_sales /* #of vhs sales in total */
	from physical_sell ps, physical_media pm 
	where ps.pmid=pm.id and pm.type='VHS' into outfile '/tmp/num_vhs_sales_tot.csv';
/* time: 0.36sec */
	select count(ps.id) as num_phy_sales, extract(year from sell_date) as year /* #of bluray sales per year */
	from physical_sell ps, physical_media pm 
	where ps.pmid=pm.id and pm.type='BLURAY'
	group by extract(year from sell_date) into outfile '/tmp/num_bluray_sales_per_y.csv';
/* time: 0.49sec */
	select count(ps.id) as num_phy_sales /* #of bluray sales in total */
	from physical_sell ps, physical_media pm 
	where ps.pmid=pm.id and pm.type='BLURAY' into outfile '/tmp/num_bluray_sales_tot.csv';
/* time: 0.39sec */
