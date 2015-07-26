/*point 2*/ 
	drop index title_genre_INDX on movie;
	create index title_genre_INDX on movie(title,genre,origin);

	select count(ml.id) as overlaps_in_movie/* number of overlaps in movie table */
	from movie ml 
	where ml.origin='ML' and exists ( /* is there a movie from WH with the same title and genre? */
			select * 
			from movie wh 
			where wh.title=ml.title and wh.genre=ml.genre and wh.origin='WH'
	) into outfile '/tmp/num_overlaps_in_mov.csv'; 
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
	) into outfile '/tmp/num_overlaps_in_offer.csv';
/*time: 0.18 sec */

	drop index title_genre_INDX on movie;
