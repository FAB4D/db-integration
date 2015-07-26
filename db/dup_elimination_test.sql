drop table testf;
drop table test;

create table test (
	id int primary key,
	data int
);

create table testf (
	id int primary key,
	tid int,
	foreign key (tid) references test(id)
);

insert into test values
(1,1000),
(2,3000),
(3,1000),
(4,1000),
(5,3000),
(6,3000),
(7,1000),
(8,5000),
(9,1000),
(10,5000),
(11,1000),
(12,3000),
(13,5000),
(14,10000);

insert into testf values 
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,10);

select o.id from test o where exists(select * from test d where d.data = o.data and d.id > o.id) and not exists(select * from test d where d.data = o.data and d.id < o.id); 

select id from test o where exists(select * from test d where d.data = o.data and d.id <> o.id) and id not in(select id from test o where exists(select * from test d where d.data = o.data and d.id > o.id) and not exists(select * from test d2 where d2.data = o.data and d2.id < o.id));

/*delete from test t where t.id not in(select id from test o where exists(select * from test d where d.data = o.data and d.id > o.id) and not exists(select * from test d2 where d2.data = o.data and d2.id < o.id));
select * from test; */


