CREATE TABLE IF NOT EXISTS movie (
  id int primary key,
  genre varchar(50) NOT NULL,
  title varchar(200) NOT NULL,
  origin varchar(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS customer (
	id int primary key, 
	name varchar(100) NOT NULL,
	birthday date NOT NULL,
	street varchar(100) NOT NULL,
	city varchar(100) NOT NULL,
	gender varchar(1) NOT NULL,
	origin varchar(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS physical_media (
	id int primary key,
	price double precision NOT NULL,
	type varchar(50) NOT NULL,
	bought_date date NOT NULL,
	bought_price double precision NOT NULL,
	mid int NOT NULL,
	foreign key (mid) references movie(id)
);

CREATE TABLE IF NOT EXISTS online_media (
	id int primary key,
	price double precision NOT NULL,
	type varchar(10) NOT NULL,
	mid int NOT NULL,
	foreign key (mid) references movie(id)
);

CREATE TABLE IF NOT EXISTS online_sell (
	id int primary key,
	sell_date date NOT NULL,
	omid int NOT NULL,
	cid int NOT NULL,
	foreign key (omid) references online_media(id),
	foreign key (cid) references customer(id)
);

CREATE TABLE IF NOT EXISTS physical_sell (
	id int primary key,
	sell_date date NOT NULL,
	pmid int NOT NULL,
	cid int NOT NULL,
	foreign key (pmid) references physical_media(id),
	foreign key (cid) references customer(id)
);
