/* point 5 */     
        select round(avg(om.price),2) as avg_rev_online_shop, os.cid /* avg revenue per customer for online shop in total */
        from online_sell os, online_media om
        where os.omid = om.id 
        group by os.cid into outfile '/tmp/avg_rev_online_shop_per_cus_tot.txt';
/* time: 0.93sec */
        select round(avg(om.price),2) as avg_rev_online_shop, os.cid, extract(year from os.sell_date) /* avg revenue per customer for online shop per year */
        from online_sell os, online_media om
        where os.omid = om.id 
        group by os.cid, extract(year from os.sell_date) into outfile '/tmp/avg_rev_online_shop_per_cus_per_y.txt';
/* time: 1.55sec */
        select round(avg(pm.price),2) as avg_rev_phy_shop,ps.cid /* avg revenue per customer for physcial shop in total */
        from physical_sell ps, physical_media pm
        where ps.pmid = pm.id
        group by ps.cid into outfile '/tmp/avg_rev_phy_shop_per_cus_tot.txt';
/* time: 0.79sec */
        select round(avg(pm.price),2) as avg_rev_phy_shop ,ps.cid,extract(year from ps.sell_date) /* avg revenue per customer for physcial shop per year */
        from physical_sell ps, physical_media pm
        where ps.pmid = pm.id
        group by ps.cid, extract(year from ps.sell_date) into outfile '/tmp/avg_rev_phy_shop_per_cus_per_y.txt';
/* time: 0.41sec */
/* still missing: for customer that appear in both shops */
