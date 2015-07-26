/* point 7 */
	select round(avg(om.price - 0.3*om.price),2), os.cid /* avg profit on downloads per customer in total*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='download' 
	group by cid into outfile '/tmp/q2_p7_1.txt';
/*time : 0.19sec */
	select round(avg(om.price - 0.3*om.price),2), os.cid, extract(year from os.sell_date) as year /* avg profit on downloads per customer per year*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='download' 
	group by os.cid,extract(year from os.sell_date) into outfile '/tmp/q2_p7_2.txt';
/*time : 0.24sec */
	select round(avg(om.price - 0.25*om.price),2), os.cid /* avg profit on views per customer in total*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='view' 
	group by os.cid into outfile '/tmp/q2_p7_3.txt';
/*time : 0.90sec */
	select round(avg(om.price - 0.25*om.price),2), os.cid, extract(year from os.sell_date) as year/* avg profit on views per customer per year*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='view' 
	group by os.cid, extract(year from os.sell_date) into outfile '/tmp/q2_p7_4.txt';
/*time : 1.48sec */
	select round(avg(pm.price-pm.bought_price),2), ps.cid /* avg profit on hard copies per customer in total */
	from physical_sell ps, physical_media pm
	where ps.pmid=pm.id 
	group by ps.cid into outfile '/tmp/q2_p7_5.txt';
/*time : 0.91sec */
	select round(avg(pm.price-pm.bought_price),2), ps.cid, extract(year from ps.sell_date) as year/* avg profit on hard copies per customer per year */
	from physical_sell ps, physical_media pm
	where ps.pmid=pm.id 
	group by ps.cid, extract(year from ps.sell_date) into outfile '/tmp/q2_p7_6.txt';
/*time : 1.50sec */
