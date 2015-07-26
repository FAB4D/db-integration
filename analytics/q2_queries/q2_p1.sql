/* point 1 */
/*drop index orig_INDX on movie;
	create index orig_INDX on movie(origin);*/

        select count(id) as num_cus__ML /* #customers of ML */ 
        from customer 
        where origin='ML';
/* time: 0.00sec */
        select count(id) as num_cus_WH/* #customers of WH*/
        from customer
        where origin='WH';
/* time: 0.00sec */
        select count(id) as num_cus__tot /* #customers in total */
        from customer;
/* time: 0.00sec */

