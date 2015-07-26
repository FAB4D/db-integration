/*--customer (cid, firstname, lastname, gender, birthday, street, city)
--online_sell (osid, cid, omid, sell_date)
--online_media (omid, mid, price, type)
--movie (mid, title, genre)
--physical_media (pmid, mid, price, type, bought_date, bought_price)
--physical_sell (psid, cid, pmid, sell_date)*/

/* QUESTION 1 */
/*point 1*/
	drop index pmid_sell_INDX on physical_sell;
	create index pmid_sell_INDX on physical_sell(pmid); 

	select count(pm.id) /* number of copies in physical_media store that are still in the shop  */
        from physical_media pm 
	where pm.id not in ( /* id should not be in physical_sell */
			select pmid 
			from physical_sell
	);	

	select count(id) from online_media; /* number of online movies that are still in the shop: half of it are view offers */

/*point 2*/ 
	drop index title_genre_INDX on movie;
	create index title_genre_INDX on movie(title,genre,origin);

	select count(ml.id) /* number of overlaps in movie table */
	from movie ml 
	where ml.origin='ML' and exists ( /* is there a movie from WH with the same title and genre? */
			select * 
			from movie wh 
			where wh.title=ml.title and wh.genre=ml.genre and wh.origin='WH'
	);
	
	select count(ml.id) /* number of overlaps on offer */
	from movie ml /* every movie from ML that is in table "movie" is always on offer */
	where ml.origin='ML' and exists (
			select * 
			from movie wh, physical_media pm
			where wh.title=ml.title and wh.genre=ml.genre and wh.origin='WH' and wh.id=pm.mid
			and pm.id not in( /* check if media containing the movie is in the offer */ 
				select ps.pmid 
				from physical_sell ps
			)
	);

	drop index pmid_sell_INDX on physical_sell;
	drop index title_genre_INDX on movie;

/* QUESTION 2 */
/* point 1 */
	drop index orig_INDX on movie;
	create index orig_INDX on movie(origin);

        select count(id) /* #customers of ML */ 
        from customer 
        where origin='ML';
        select count(id) /* #customers of WH*/
        from customer
        where origin='WH';
        select count(id) /* #customers in total */
        from customer;

	drop index orig_INDX on movie;

/* point 2 */
        drop index fname_lname_street_INDX on customer;
	create index fname_lname_street_INDX on customer(firstname,lastname,street,origin);
/* 	drop index cust_orig on customer;
	create index cust_orig on customer(origin); */

	select count(ml.id) /* #overlaps in customer */
	from customer ml 
	where ml.origin='ML' and exists ( /* is there a customer from WH with same fname,lname,street */
			select * 
			from customer wh 
			where wh.firstname=ml.firstname and wh.lastname=ml.lastname 
			and wh.street=ml.street and wh.origin='WH'
	);

	drop index fname_lname_street_INDX on customer;
/*drop index cust_orig on customer; */

/* point 3 */
        select count(id) /* #of downloads and views in total */
        from online_sell;
	select count(id), extract(year from sell_date) as year /* #of downloads and views per year */
	from online_sell
	group by extract(year from sell_date);

        select count(os.id) /* #of downloads in total */
        from online_sell os, online_media om
        where os.omid = om.id and om.type='download';
        select count(os.id), extract(year from os.sell_date) as year /* #of downloads per year */
        from online_sell os, online_media om
        where os.omid = om.id and om.type='download'
	group by extract(year from os.sell_date);

        select count(os.id) /* #of views in total */
        from online_sell os, online_media om
        where os.omid = om.id and om.type='view';
	select count(os.id), extract(year from os.sell_date) as year /* #of views per year */
	from online_sell os, online_media om
	where os.omid = om.id and om.type='view'
	group by extract(year from os.sell_date);

        select count(id) /* #of physical sales in total */ 
        from physical_sell;
	select count(id), extract(year from sell_date) as year /* #of physical sales per year */
	from physical_sell
	group by extract(year from sell_date);

/* point 4 */
        select sum(om.price) /* revenue for online shop in total */
        from online_sell os, online_media om
        where os.omid = om.id;
	select sum(om.price), extract(year from os.sell_date) as year /* revenue for online shop per year */
	from online_sell os, online_media om
	where os.omid=om.id 
	group by extract(year from os.sell_date);
	
        select sum(pm.price) /* revenue for physical shop in total */
        from physical_sell ps, physical_media pm
        where ps.pmid = pm.id; 
        select sum(pm.price), extract(year from ps.sell_date) as year /* revenue for physical shop per year */
        from physical_sell ps, physical_media pm
        where ps.pmid = pm.id
	group by extract(year from ps.sell_date); 
        
/* for revenue in total (revenue ML + revenue WH): just sum up the two values */ 

/* point 5 */     
        select avg(om.price), os.cid /* avg revenue per customer for online shop in total */
        from online_sell os, online_media om
        where os.omid = om.id 
        group by os.cid;
        select avg(om.price), os.cid, extract(year from os.sell_date) /* avg revenue per customer for online shop per year */
        from online_sell os, online_media om
        where os.omid = om.id 
        group by os.cid, extract(year from os.sell_date);

        select avg(pm.price),ps.cid /* avg revenue per customer for physcial shop in total */
        from physical_sell ps, physical_media pm
        where ps.pmid = pm.id
        group by ps.cid; 
        select avg(pm.price),ps.cid,extract(year from ps.sell_date) /* avg revenue per customer for physcial shop per year */
        from physical_sell ps, physical_media pm
        where ps.pmid = pm.id
        group by ps.cid, extract(year from ps.sell_date);
/* still missing: for customer that appear in both shops */

/*point 6*/
/* net profit: revenue - expendure -> bought_price for hard copies */
/* net profit: revenue - expednure -> 30% of income per download, 25% of income per view */

	select sum(om.price - 0.3*om.price) /* profit on downloads for online shop in total*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='download'; 
	select sum(om.price - 0.3*om.price),extract(year from os.sell_date) as year /* profit on downloads for online shop per year*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='download'
	group by extract(year from os.sell_date);
 
	select sum(om.price - 0.25*om.price) /* profit on views for online shop in total*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='view'; 
	select sum(om.price - 0.25*om.price),extract(year from os.sell_date) as year /* profit on views for online shop per year*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='view'
	group by extract(year from os.sell_date);

/* for online shop profit in total: sum up the values */

	select sum(pm.price - pm.bought_price) /* profit for physical shop in total */
	from physical_sell ps, physical_media pm
	where ps.pmid=pm.id;
	select sum(pm.price - pm.bought_price), extract(year from ps.sell_date) /* profit for physical shop per year*/
	from physical_sell ps, physical_media pm
	where ps.pmid=pm.id
	group by extract(year from ps.sell_date);

/* for profit in total: sum up total profit of the two shops */

/* point 7 */
	
	select avg(om.price - 0.3*om.price), os.cid /* avg profit on downloads per customer in total*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='download' 
	group by cid;
	select avg(om.price - 0.3*om.price), os.cid, extract(year from os.sell_date) as year /* avg profit on downloads per customer per year*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='download' 
	group by cid,extract(year from os.sell_date);

	select avg(om.price - 0.25*om.price), os.cid, /* avg profit on views per customer in total*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='view' 
	group by cid;
	select avg(om.price - 0.25*om.price), os.cid, extract(year from os.sell_date) as year/* avg profit on views per customer per year*/
	from online_sell os, online_media om
	where os.omid=om.id and om.type='view' 
	group by cid, extract(year from os.sell_date);

	
	select avg(pm.price-pm.bought_price), ps.cid /* avg profit on hard copies per customer in total */
	from physical_sell ps, physical_media pm
	where ps.pmid=pm.id 
	group by ps.cid;
	select avg(pm.price-pm.bought_price), ps.cid, extract(year from ps.sell_date) as year/* avg profit on hard copies per customer per year */
	from physical_sell ps, physical_media pm
	where ps.pmid=pm.id 
	group by ps.cid, extract(year from ps.sell_date);



 
        
         
