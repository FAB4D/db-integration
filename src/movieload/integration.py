import io, string, sys, math, os.path
import MySQLdb as db
import multiprocessing as mp

def integrate_movie(table):
	mov_rows = select("SELECT * FROM {0}".format(table),"integration")
	mov_rows = list(mov_rows)
	
	chunk_len = int(len(mov_rows)/1000)
	chunks = [mov_rows[x:x+chunk_len] for x in xrange(0,len(mov_rows),chunk_len)]
	ins_movie = []
	ins_online_media = []
	
	for chunk in chunks:
		ins_query_mov = "INSERT INTO movie (id,genre,title,origin) VALUES "
		ins_query_on_med = "INSERT INTO online_media (id,mid,price,type) VALUES "
		last_row = chunk.pop(-1)
		for row in chunk:	
			title = row["title"]
			title = title.replace("'","''")
			ins_tuple_mov = "({0},'{1}','{2}','{3}'),".format(row["id"],row["genre"],title,"ML")
			view_id = 2*row["id"] - 1
			ins_tuple_on_med_view = "({0},{1},{2},'{3}'),".format(view_id,row["id"],row["price_per_view"],"view")
			down_id = 2*row["id"]
			ins_tuple_on_med_down = "({0},{1},{2},'{3}'),".format(down_id,row["id"],row["price_per_download"],"download")
			ins_query_mov = "".join([ins_query_mov,ins_tuple_mov])
			ins_query_on_med = "".join([ins_query_on_med,ins_tuple_on_med_view,ins_tuple_on_med_down])
		title = last_row["title"]
		title = title.replace("'","''")
		last_tuple_mov = "({0},'{1}','{2}','{3}');".format(last_row["id"],last_row["genre"],title,"ML")
		view_id = 2*last_row["id"] - 1
		last_tuple_on_med_view = "({0},{1},{2},'{3}'),".format(view_id,last_row["id"],last_row["price_per_view"],"view")
		down_id = 2*last_row["id"]
		last_tuple_on_med_down = "({0},{1},{2},'{3}');".format(down_id,last_row["id"],last_row["price_per_download"],"download")
		ins_query_mov = "".join([ins_query_mov,last_tuple_mov])
		ins_query_on_med = "".join([ins_query_on_med,last_tuple_on_med_view,last_tuple_on_med_down])
		ins_movie.append(ins_query_mov)
		ins_online_media.append(ins_query_on_med)
	#print ins_movie[0]
	#print ins_online_media[0]
	insert_in_parallel(ins_movie)
	insert_in_parallel(ins_online_media)
		
def integrate_buy(table):
	buy_rows = select("SELECT * FROM {0}".format(table),"integration")
	buy_rows = list(buy_rows)
	chunk_len = int(len(buy_rows)/1000)
	chunks = [buy_rows[x:x+chunk_len] for x in xrange(0,len(buy_rows),chunk_len)]
	ins_queries = []
	for chunk in chunks:
		ins_query = "INSERT INTO online_sell (id, sell_date, omid, cid) VALUES "
		last_row = chunk.pop(-1)
		for row in chunk:
			omid = 2*row["mid"] # would be for download
			if row["type"] == "view":
				omid = 2*row["mid"] - 1 # 2*row["mid"] - 1 for view
			ins_tuple = "({0},'{1}',{2},{3}),".format(row["id"],row["date"],omid,row["cid"])
			ins_query = "".join([ins_query,ins_tuple])
		omid = 2*last_row["mid"]
		if last_row["type"] == "view":
			omid = 2*last_row["mid"] - 1
		ins_tuple = "({0},'{1}',{2},{3});".format(last_row["id"],last_row["date"],omid,last_row["cid"])
		ins_query = "".join([ins_query,ins_tuple])
		ins_queries.append(ins_query)
	
	#print ins_queries[0]
	insert_in_parallel(ins_queries)

def integrate_customer(table):
	cus_rows = select("select * from {0}".format(table),"integration")
	cus_rows = list(cus_rows)
	chunk_len = int(len(cus_rows)/1000)
	chunks = [cus_rows[x:x+chunk_len] for x in xrange(0,len(cus_rows),chunk_len)]
	ins_queries = []
	for chunk in chunks:
		ins_query = "INSERT INTO customer (id,firstname,lastname,birthday,street,city,gender,origin) VALUES "
		last_row = chunk.pop(-1)
		for row in chunk:
			splitted_name = row["name"].split()
			if len(splitted_name) > 2:
				print "mehr als 2 Vornamen"
			firstname = splitted_name[0]
			firstname = firstname.replace("'","''")
			lastname = splitted_name[1]
			lastname = lastname.replace("'","''")
			street = row["street"]
			street = street.replace("'","''")
			ins_tuple = "({0},'{1}','{2}','{3}','{4}','{5}','{6}','{7}'),".format(row["id"],firstname,lastname,row["birthday"],street,row["city"],row["gender"],"ML")
			ins_query = "".join([ins_query,ins_tuple])
		splitted_name = last_row["name"].split()
		firstname = splitted_name[0]
		firstname = firstname.replace("'","''")
		lastname = splitted_name[1]
		lastname = lastname.replace("'","''")
		street = row["street"]
		street = street.replace("'","''")
		last_tuple = "({0},'{1}','{2}','{3}','{4}','{5}','{6}','{7}');".format(last_row["id"],firstname,lastname,last_row["birthday"],street,last_row["city"],last_row["gender"],"ML")
		ins_query = "".join([ins_query,last_tuple])
		ins_queries.append(ins_query)
	insert_in_parallel(ins_queries)
	
def insert_in_parallel(ins_queries):
	pool = mp.Pool(10)
	chunk_len = int(len(ins_queries)/10)
	chunks = [ins_queries[x:x+chunk_len] for x in xrange(0,len(ins_queries),chunk_len)]
	for chunk in chunks:
		pool.apply_async(insert_queries, args=(chunk,))
	pool.close()
	pool.join()
		
def insert_queries(ins_queries):
	for ins_query in ins_queries:
		upd_or_ins(ins_query,"datawarehouse")
		
def upd_or_ins(query,dbname):
	try:
		con = db.connect("localhost","root","12345",dbname)
		cursor = con.cursor()
		cursor.execute(query)
		cursor.close()
		con.commit()
		con.close()
	except db.Error, e:
		print "Error %d: %s" % (e.args[0], e.args[1])
		sys.exit(1)
		
def select(query,dbname):
	try:
		con = db.connect("localhost","root","12345",dbname)
		# use dictcursor to return row as dictionary
		cursor = con.cursor(db.cursors.DictCursor)
		cursor.execute(query)
		rows = cursor.fetchall()
		cursor.close()
		con.commit()
		con.close()
		return rows
	except db.Error, e:
		print "Error %d: %s" % (e.args[0], e.args[1])
		sys.exit(1)

if __name__ == '__main__':
    integrate_customer("customer")
    integrate_movie("movie")
    integrate_buy("buy")
