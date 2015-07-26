drop index cus_index on customer; 
drop index cus_concat_index on customer; 
drop index mov_index on movie; 
drop index mov_tg on movie; 

create index mov_index on movie(id); 
create index mov_tg on movie(title,genre);
create index cus_index on customer(id);
create index cus_concat_index on customer(birthday,name,street,gender);



