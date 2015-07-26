/*point 6*/
/* net profit: revenue - expendure -> bought_price for hard copies */
/* net profit: revenue - expednure -> 30% of income per download, 25% of income per view */

	select round(sum(om.price - 0.3*om.price),2) /* profit on downloads for online shop in total*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='download'; 
/*time:0.00sec*/
	select round(sum(om.price - 0.3*om.price),2),extract(year from os.sell_date) as year /* profit on downloads for online shop per year*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='download'
	group by extract(year from os.sell_date);
/*time:0.00sec*/
 
	select round(sum(om.price - 0.25*om.price),2) /* profit on views for online shop in total*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='view'; 
/*time:0.00sec*/
	select round(sum(om.price - 0.25*om.price),2) ,extract(year from os.sell_date) as year /* profit on views for online shop per year*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='view'
	group by extract(year from os.sell_date);
/*time:0.00sec*/
/* for online shop profit in total: sum up the values */

	select round(sum(pm.price - pm.bought_price),2) /* profit for physical shop in total */
	from physical_sell ps, physical_media pm
	where ps.pmid=pm.id;
/*time:0.00sec*/
	select round(sum(pm.price - pm.bought_price),2), extract(year from ps.sell_date) /* profit for physical shop per year*/
	from physical_sell ps, physical_media pm
	where ps.pmid=pm.id
	group by extract(year from ps.sell_date);
/*time:0.00sec*/
/* for profit in total: sum up total profit of the two shops */

