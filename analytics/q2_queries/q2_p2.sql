/* point 2 */

create index fname_lname_street_INDX on customer(firstname,lastname,street,origin);
create index cust_orig on customer(origin); 
select count(ml.id) as num_overlaps_cus  /* #overlaps in customer */
from customer ml 
where ml.origin='ML' and exists ( /* is there a customer from WH with same fname,lname,street */
		select * 
		from customer wh 
		where wh.firstname=ml.firstname and wh.lastname=ml.lastname 
		and wh.street=ml.street and wh.origin='WH'
) into outfile '/tmp/num_overlaps_cus.csv';
/* time: 0.63sec */

drop index fname_lname_street_INDX on customer;
drop index cust_orig on customer; 
