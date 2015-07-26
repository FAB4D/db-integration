/* point 3 */
        select count(id) as num_down_and_view_tot/* #of downloads and views in total */
        from online_sell;
/* time: 0.00sec */
	select count(id) as num_down_and_view, extract(year from sell_date) as year /* #of downloads and views per year */
	from online_sell
	group by extract(year from sell_date);
/* time: 0.00sec */
        select count(os.id) as num_down_tot/* #of downloads in total */
        from online_sell os, online_media om
        where os.omid = om.id and om.type='download';
        select count(os.id) as num_down, extract(year from os.sell_date) as year /* #of downloads per year */
        from online_sell os, online_media om
        where os.omid = om.id and om.type='download'
	group by extract(year from os.sell_date);
/* time: 0.00sec */
        select count(os.id) as num_view_tot /* #of views in total */
        from online_sell os, online_media om
        where os.omid = om.id and om.type='view';
	select count(os.id) as num_view, extract(year from os.sell_date) as year /* #of views per year */
	from online_sell os, online_media om
	where os.omid = om.id and om.type='view'
	group by extract(year from os.sell_date);
/* time: 0.00sec */
        select count(id) as num_phy_sales_tot /* #of physical sales in total */ 
        from physical_sell;
	select count(id) as num_phy_sales, extract(year from sell_date) as year /* #of physical sales per year */
	from physical_sell
	group by extract(year from sell_date);
/* time: 0.00sec */

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
	
