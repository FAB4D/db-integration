/* QUESTION 1 */
/*point 1*/
	drop index pmid_sell_INDX on physical_sell;
	create index pmid_sell_INDX on physical_sell(pmid); 

	select count(pm.id) as num_available_hard_copies /* number of copies in physical_media store that are still in the shop  */
        from physical_media pm 
	where pm.id not in ( /* id should not be in physical_sell */
			select pmid 
			from physical_sell
	) union 
/*time: 1.20 sec */	

	select count(id) as num_available_online_mov 
	from online_media; /* number of online movies that are still in the shop: half of it are view offers */ 
/*time: 0.01 sec */

/*point 2*/ 
	drop index title_genre_INDX on movie;
	create index title_genre_INDX on movie(title,genre,origin);

	select count(ml.id) as overlaps_in_movie/* number of overlaps in movie table */
	from movie ml 
	where ml.origin='ML' and exists ( /* is there a movie from WH with the same title and genre? */
			select * 
			from movie wh 
			where wh.title=ml.title and wh.genre=ml.genre and wh.origin='WH'
	); 
/*time: 0.09 sec */
	
	select count(ml.id) as overlaps_in_offer /* number of overlaps on offer */
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
/*time: 0.18 sec */

	drop index pmid_sell_INDX on physical_sell;
	drop index title_genre_INDX on movie;
