/*point 1*/
/*	drop index pmid_sell_INDX on physical_sell;
	create index pmid_sell_INDX on physical_sell(pmid); */

	select count(pm.id) as num_available_hard_copies /* number of copies in physical_media store that are still in the shop  */
        from physical_media pm 
	where pm.id not in ( /* id should not be in physical_sell */
			select pmid 
			from physical_sell
	);
/*time: 1.20 sec */	
	select count(pm.id) as num_avail_dvd from physical_media pm where pm.type = 'DVD' and pm.id not in(select pmid from physical_sell);
/*time: 1.7sec*/
	select count(pm.id) as num_avail_dvd
	from physical_media pm
	where pm.type = 'VHS' and pm.id not in(
			select pmid
			from physical_sell
	);
/*time: 1.7sec*/
	select count(pm.id) as num_avail_dvd
	from physical_media pm
	where pm.type = 'BLURAY' and pm.id not in(
			select pmid
			from physical_sell
	);
/*time: 1.7sec*/

	select count(id) as num_available_online_mov 
	from online_media; /* number of online movies that are still in the shop: half of it are view offers */ 
/*time: 0.01 sec */
