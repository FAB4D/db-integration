/* point 4 */
        select round(sum(om.price),2) as rev_online_shop_tot /* revenue for online shop in total */
        from online_sell os, online_media om
        where os.omid = om.id;
/* time: 0.00sec */
	select round(sum(om.price),2) as rev_online_shop, extract(year from os.sell_date) as year /* revenue for online shop per year */
	from online_sell os, online_media om
	where os.omid=om.id 
	group by extract(year from os.sell_date);
/* time: 0.78sec */	
        select round(sum(pm.price),2) as rev_phy_shop_tot /* revenue for physical shop in total */
        from physical_sell ps, physical_media pm
        where ps.pmid = pm.id; 
/* time: 0.00sec */
        select round(sum(pm.price),2) as rev_phy_shop, extract(year from ps.sell_date) as year /* revenue for physical shop per year */
        from physical_sell ps, physical_media pm
        where ps.pmid = pm.id
	group by extract(year from ps.sell_date); 
/* time: 0.68sec */
        
/* for revenue in total (revenue ML + revenue WH): just sum up the two values */ 
