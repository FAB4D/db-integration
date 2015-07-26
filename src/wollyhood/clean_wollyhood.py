import string,io,sys, os.path
import multiprocessing as mp
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from helpers import database_handler
from helpers import string_matcher

import os
import string

def get_seq_from_row(row, cols):
    #sequence = ''.join(row[col].strip() for col in cols)
    #sequence = ''.join(sequence.split())
    
    # the uncommented lines are not needed
    # this is done in sting_matcher by c.isalnum()
    # otherwise it is done twice which is pretty unefficient
    # isalnum removes every character that is not a number or a letter
    
    sequence = ''.join(row[col] for col in cols)
    #sequence = sequence.upper()
    return sequence
        
def clean_media_type(clean_table):
    media_type = "media_type"
    query = "SELECT id, {0} FROM {1}".format(media_type, clean_table)

    rows = database_handler.select(query)

    gt = ["DVD","BLURAY","VHS"]
    gt_dict = dict()
    gt_dict[0] = gt[0]
    gt_dict[1] = gt[1]
    gt_dict[2] = gt[2]

    for row in rows:
        media_seq = get_seq_from_row(row, ["media_type"]) 

        best_matching_index = ""
        best_matching_type = "" 

        if not media_seq:
            best_matching_type = ""
        else:
            best_matching_index = string_matcher.get_matching_seq(media_seq, gt_dict)
            best_matching_type = gt_dict[best_matching_index]
            #print ' {0} {1} => {2} '.format(row["id"],row["media_type"],best_matching_type)
            update_query = "UPDATE {0} SET {1}='{2}' WHERE id={3}".format(clean_table, media_type, best_matching_type, row["id"])
        #database_handler.update(update_query)


def clean_customer(clean_table,nprocesses):
	query = "SELECT id, customer_firstname, customer_lastname, customer_street, customer_birthday, customer_gender FROM {0} where customer_birthday is not null".format(clean_table)
	rows = database_handler.select(query)
	gt_table = tables["gt_address"]
	pool = mp.Pool(nprocesses)
	rows = list(rows)
	chunk_len = int(len(rows)/nprocesses)
	chunks = [rows[x:x+chunk_len] for x in xrange(0,len(rows),chunk_len)]
	for chunk in chunks:
		pool.apply_async(clean_customer_in_parallel,args=(gt_table,chunk,clean_table,))
	pool.close()
	pool.join()
	
def clean_customer_in_parallel(gt_table,rows,clean_table):
	for row in rows:
		gt_query = "SELECT firstname, lastname, street, gender FROM {0} WHERE birth_date='{1}'".format(gt_table, row["customer_birthday"])
		gt_rows = database_handler.select(gt_query)
		cus_seq = ''.join(row[col] for col in ["customer_firstname", "customer_lastname", "customer_street", "customer_gender"])
		gt_seq_dict = dict()
		i = 0
		for gt_row in gt_rows:
			gt_seq_dict[i] = ''.join(gt_row[col] for col in ["firstname", "lastname", "street","gender"])
			i += 1
		best_matching_index = string_matcher.get_matching_seq(cus_seq, gt_seq_dict)
		best_matching_row = gt_rows[best_matching_index]
		firstname = best_matching_row["firstname"].replace("'", "''")
		lastname = best_matching_row["lastname"].replace("'", "''")
		street = best_matching_row["street"].replace("'", "''")
		gender = best_matching_row["gender"].replace("'", "''")
		#print '{0} {1} {2} {3} => {4} {5} {6} {7}'.format(row['customer_firstname'],row['customer_lastname'],row['customer_street'],row['customer_gender'],firstname,lastname,street,gender)
		update_query = "UPDATE {0} SET customer_firstname='{1}', customer_lastname='{2}', customer_street='{3}', customer_gender='{4}', customer_city='NEW YORK' WHERE id={5}".format(clean_table,firstname,lastname,street,gender,row["id"])
		database_handler.update(update_query)
        
def clean_movie_genre(cleanTable,nprocesses):
	gt_genres = database_handler.select("SELECT DISTINCT genre FROM groundtruth_movies ORDER BY genre")
	rows = database_handler.select("SELECT id, movie_genre FROM {0} where movie_genre <> '' ".format(cleanTable))
	gtGenresDict = dict()
	i=0
	for gt_genre in gt_genres:
		gtGenresDict[i] = gt_genre["genre"]
		i+=1
	pool = mp.Pool(nprocesses)
	rows = list(rows)
	chunk_len = int(len(rows)/nprocesses)
	chunks = [rows[x:x+chunk_len] for x in xrange(0,len(rows),chunk_len)]
	for chunk in chunks:
		pool.apply_async(clean_movie_genre_in_parallel,args=(gtGenresDict,chunk,cleanTable))
	pool.close()
	pool.join()		

def clean_movie_genre_in_parallel(gt_genres_dict,rows,clean_table):
	for row in rows: 
		best_matching_index = string_matcher.get_matching_seq(row["movie_genre"], gt_genres_dict)
		best_matching_genre = gt_genres_dict[best_matching_index]
		#print " {0} {1} => {2} ".format(row["id"],row["movie_genre"],best_matching_genre)
		database_handler.update("UPDATE {0} SET movie_genre='{1}' WHERE id={2}".format(clean_table,best_matching_genre,row["id"]))			
        
def clean_media_type(cleanTable,nprocesses):
	query = "SELECT id, media_type FROM {0} where media_type <> '' ".format(cleanTable)
	rows = database_handler.select(query)
	gt = ["DVD","BLURAY","VHS"]
	gtDict = dict()
	gtDict[0] = gt[0]
	gtDict[1] = gt[1]
	gtDict[2] = gt[2]
	pool = mp.Pool(nprocesses)
	rows = list(rows)
	chunk_len = int(len(rows)/nprocesses)
	chunks = [rows[x:x+chunk_len] for x in xrange(0,len(rows),chunk_len)]
	for chunk in chunks:
		#print len(chunk)
		pool.apply_async(clean_media_type_parallel,args=(gtDict,chunk,cleanTable))
	pool.close()
	pool.join()
	
def clean_media_type_parallel(gt_dict,rows,clean_table):
	for row in rows:
		best_matching_index = string_matcher.get_matching_seq(row["media_type"],gt_dict)
		best_matching_type = gt_dict[best_matching_index]
		query = "UPDATE {0} SET media_type='{1}' WHERE id={2}".format(clean_table,best_matching_type,row["id"])
		#print " {0} {1} => {2} ".format(row["id"],row["media_type"],best_matching_type)
		database_handler.update(query)

def clean_movie(clean_table,nprocesses): # if mode is set to "test", use corresponding test table 
	title_attr = "movie_title"
	genre_attr = "movie_genre"
	clean_select = "SELECT {0}, {1}, {2} FROM {3}".format("id", title_attr, genre_attr, clean_table)
	rows = database_handler.select(clean_select)
	gt_table = tables["gt_movies"]
	gt_select = "SELECT id, title, genre FROM {0}".format(gt_table)
	gt_rows = database_handler.select(gt_select)
	gt_seq_dict = dict()
	i = 0
	for gt_row in gt_rows:
		gt_seq_dict[i] = "".join(gt_row[col] for col in ["title", "genre"])
		i += 1
	pool = mp.Pool(nprocesses)
	rows = list(rows)
	chunk_len = int(len(rows)/nprocesses)
	chunks = [rows[x:x+chunk_len] for x in xrange(0,len(rows),chunk_len)]
	for chunk in chunks:
		pool.apply_async(clean_movie_in_parallel,args=(gt_seq_dict,gt_rows,chunk,clean_table,title_attr,genre_attr,))
	pool.close()
	pool.join()


def clean_movie_in_parallel(gt_seq_dict,gt_rows,rows,clean_table,title_attr,genre_attr):
	for row in rows:
		mv_seq = ''.join(row[col] for col in ["movie_title", "movie_genre"])
		best_matching_index = string_matcher.get_matching_seq(mv_seq, gt_seq_dict)
		best_row = gt_rows[best_matching_index]
		title_update = best_row["title"]
		genre_update = best_row["genre"]
		#print " {0} {1} => {2} {3} ".format(row["movie_title"],row["movie_genre"],title_update,genre_update)
		clean_update = "UPDATE {0} SET {1}='{2}', {3}='{4}' WHERE id={5}".format(clean_table, title_attr, title_update, genre_attr, genre_update, row["id"])
		database_handler.update(clean_update)

if __name__ == '__main__':
    # get db dir path1
    curr_dir = os.getcwd()
    db_dir = curr_dir.replace("src/wollyhood", "db/")
    tables = database_handler.config.load_config(db_dir, "db_production")
    clean_table = tables["wh_sell"]
    clean_customer(clean_table,10)
    clean_media_type(clean_table,10)
    clean_movie_genre(clean_table,10)

