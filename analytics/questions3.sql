/*
	ohne such-indizes
	INDIZES AUF EINZELNE VARIABLEN
*/

/*a)*/
/*question3a_pm*/
select count(mv.title) as num_copies, mv.genre, pm.type, DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(cus.birthday)), '%Y')+0 as age, cus.gender FROM customer cus, physical_sell ps, physical_media pm, movie mv WHERE cus.id = ps.cid AND ps.pmid = pm.id AND pm.mid = mv.id GROUP BY cus.gender, age, pm.type, mv.genre;
% 4.0368 sec

/*question3a_om*/
select count(mv.title) as num_movies, mv.genre, om.type, DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(cus.birthday)), '%Y')+0 as age, cus.gender FROM customer cus, online_sell os, online_media om, movie mv WHERE cus.id = os.cid AND os.omid = om.id AND om.mid = mv.id GROUP BY cus.gender, age, om.type, mv.genre;
% 3.2163 sec


/*b)*/
/*question3b_om*/
select count(mv.title) as num_views, DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(cus.birthday)), '%Y')+0 as age, cus.gender, mv.genre FROM customer cus, online_sell os, online_media om, movie mv WHERE cus.id = os.cid AND os.omid = om.id AND om.mid = mv.id GROUP BY mv.genre, cus.gender, age ORDER BY mv.genre ASC;
% 2.8042 sec

/*question3b_view*/
select count(mv.title) as num_views, DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(cus.birthday)), '%Y')+0 as age, cus.gender, mv.genre FROM customer cus, online_sell os, online_media om, movie mv WHERE cus.id = os.cid AND os.omid = om.id AND om.type = "view" AND om.mid = mv.id GROUP BY mv.genre, cus.gender, age ORDER BY mv.genre ASC;
% 2.5583 sec

/*question3b_download*/
select count(mv.title) as num_downloads, DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(cus.birthday)), '%Y')+0 as age, cus.gender, mv.genre FROM customer cus, online_sell os, online_media om, movie mv WHERE cus.id = os.cid AND os.omid = om.id AND om.type = "download" AND om.mid = mv.id GROUP BY mv.genre, cus.gender, age ORDER BY mv.genre ASC;
% 1.1490 sec

/*question3b_sold*/
select count(mv.title) as num_views, DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(cus.birthday)), '%Y')+0 as age, cus.gender, mv.genre FROM customer cus, physical_sell ps, physical_media pm, movie mv WHERE cus.id = ps.cid AND ps.pmid = pm.id AND pm.mid = mv.id GROUP BY mv.genre, cus.gender, age ORDER BY mv.genre ASC;
% 5.76 sec

/*c)*/
/*which shops sell more to whom (by age and sex)*/
/*question3c_pm*/
select count(mv.title) as num_copies, DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(cus.birthday)), '%Y')+0 as age, cus.gender FROM customer cus, physical_sell ps, physical_media pm, movie mv WHERE cus.id = ps.cid AND ps.pmid = pm.id AND pm.mid = mv.id GROUP BY cus.gender, age ORDER BY cus.gender ASC;
% 4.4362 sec

/*question3c_om*/
select count(mv.title) as num_movies, DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(cus.birthday)), '%Y')+0 as age, cus.gender FROM customer cus, online_sell os, online_media om, movie mv WHERE cus.id = os.cid AND os.omid = om.id AND om.mid = mv.id GROUP BY cus.gender, age ORDER BY cus.gender ASC;
% 2.6434 sec

/*d)*/
/*when should advertisment be intensified? 
=> During the summer months, especially in july where the least movies are sold*/
/*question3d_pm*/
select count(mv.title) as copies_sold, MONTH(ps.sell_date) as month, YEAR(ps.sell_date) AS year FROM movie mv, physical_media pm, physical_sell ps WHERE mv.id = pm.mid AND pm.id = ps.pmid GROUP BY year, month;
% 1.7065 Sec

/*question3d_om*/
select count(mv.title) as copies_sold, MONTH(os.sell_date) as month, YEAR(os.sell_date) AS year FROM movie mv, online_media om, online_sell os WHERE mv.id = om.mid AND om.id = os.omid GROUP BY year, month;
% 1.4529 Sec

/*e)*/
/*ranking of sales, views and downloads in the last month, year, 5 years*/
/*question3e_om_download_days*/
select count(mv.title) as copies_sold, DAY(os.sell_date) AS day FROM movie mv, online_media om, online_sell os WHERE mv.id = om.mid AND om.id = os.omid AND om.type = "download" AND DATE_SUB('2012-12-30', INTERVAL 1 MONTH) <= os.sell_date GROUP BY day ORDER BY copies_sold DESC

/*question3e_om_download_year*/
select count(mv.title) as copies_sold, MONTH(os.sell_date) AS month, YEAR(os.sell_date) AS year FROM movie mv, online_media om, online_sell os WHERE mv.id = om.mid AND om.id = os.omid AND om.type = "download" AND DATE_SUB(NOW(), INTERVAL 1 YEAR) <= os.sell_date GROUP BY year, month ORDER BY copies_sold DESC

/*question3e_om_download_years*/
select count(mv.title) as copies_sold, MONTH(os.sell_date) AS month, YEAR(os.sell_date) AS year FROM movie mv, online_media om, online_sell os WHERE mv.id = om.mid AND om.id = os.omid AND om.type = "download" AND DATE_SUB(NOW(), INTERVAL 5 YEAR) <= os.sell_date GROUP BY year, month ORDER BY copies_sold DESC

/*question3e_om_view_days*/
select count(mv.title) as copies_sold, DAY(os.sell_date) AS day FROM movie mv, online_media om, online_sell os WHERE mv.id = om.mid AND om.id = os.omid AND om.type = "view" AND DATE_SUB('2012-12-30', INTERVAL 1 MONTH) <= os.sell_date GROUP BY day ORDER BY copies_sold DESC

/*question3e_om_view_year*/
select count(mv.title) as copies_sold, MONTH(os.sell_date) AS month, YEAR(os.sell_date) AS year FROM movie mv, online_media om, online_sell os WHERE mv.id = om.mid AND om.id = os.omid AND om.type = "view" AND DATE_SUB(NOW(), INTERVAL 1 YEAR) <= os.sell_date GROUP BY year, month ORDER BY copies_sold DESC

/*question3e_om_view_years*/
select count(mv.title) as copies_sold, MONTH(os.sell_date) AS month, YEAR(os.sell_date) AS year FROM movie mv, online_media om, online_sell os WHERE mv.id = om.mid AND om.id = os.omid AND om.type = "view" AND DATE_SUB(NOW(), INTERVAL 5 YEAR) <= os.sell_date GROUP BY year, month ORDER BY copies_sold DESC

/*question3e_pm_days*/
select count(mv.title) as copies_sold, DAY(ps.sell_date) AS day FROM movie mv, physical_media pm, physical_sell ps WHERE mv.id = pm.mid AND pm.id = ps.pmid AND  DATE_SUB('2012-12-30', INTERVAL 1 MONTH) <= ps.sell_date GROUP BY day ORDER BY copies_sold DESC

/*question3e_pm_year*/
select count(mv.title) as copies_sold, MONTH(ps.sell_date) AS month, YEAR(ps.sell_date) AS year FROM movie mv, physical_media pm, physical_sell ps WHERE mv.id = pm.mid AND pm.id = ps.pmid AND  DATE_SUB(NOW(), INTERVAL 1 YEAR) <= ps.sell_date GROUP BY year, month ORDER BY copies_sold DESC

/*question3e_pm_years*/
select count(mv.title) as copies_sold, MONTH(ps.sell_date) AS month, YEAR(ps.sell_date) AS year FROM movie mv, physical_media pm, physical_sell ps WHERE mv.id = pm.mid AND pm.id = ps.pmid AND  DATE_SUB(NOW(), INTERVAL 5 YEAR) <= ps.sell_date GROUP BY year, month ORDER BY copies_sold DESC






