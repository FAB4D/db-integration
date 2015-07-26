import io, string, sys, math, os.path
import multiprocessing as mp
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from helpers import database_handler
from helpers import string_matcher
import os
      
def clean_customer(mode,nprocesses):
	customer = tables["ml_cus"]
	#if mode == "test":
	#	customer = tables["ml_cus_test"]
	query = "SELECT id, birthday, name, street, gender FROM {0}".format(customer)
	rows = database_handler.select(query)
	groundtruth = tables["gt_address"]
	pool = mp.Pool(nprocesses)
	rows = list(rows)
	chunk_len = int(len(rows)/nprocesses)
	chunks = [rows[x:x+chunk_len] for x in xrange(0,len(rows),chunk_len)]
	for chunk in chunks:
		pool.apply_async(clean_customer_in_parallel, args=(groundtruth,chunk,customer,))
	pool.close()
	pool.join()
        
def clean_customer_in_parallel(groundtruth,rows,customer):
	for row in rows:
			gt_query = "SELECT firstname, lastname, street, gender FROM {0} WHERE birth_date='{1}'".format(groundtruth, row["birthday"])
			groundtruth_rows = database_handler.select(gt_query)
			# avoid function call: replace get_seq_from_row with:
			cus_seq = ''.join(row[col] for col in ["name", "street", "gender"])
			gt_seq_dict = dict()
			i = 0
			for gt_row in groundtruth_rows:
				# avoid function call: replace get_seq_from_row with:
				gt_seq_dict[i] = ''.join(gt_row[col] for col in ["firstname", "lastname", "street", "gender"]) 
				i += 1
			best_matching_index = string_matcher.get_matching_seq(cus_seq, gt_seq_dict)
			best_matching_row = groundtruth_rows[best_matching_index]
			name = ' '.join([best_matching_row["firstname"],best_matching_row["lastname"]])
			name = name.replace("'", "''")
			street = best_matching_row["street"]
			street = street.replace("'", "''")
			gender = best_matching_row["gender"]
			gender = gender.replace("'","''")
			update_query = "UPDATE {0} SET name='{1}', street='{2}', city='{3}',gender='{4}' WHERE id={5}".format(customer, name, street,"NEW YORK", gender, row["id"])
			database_handler.update(update_query)
			#print '{0} {1} {4} => {2} {3} {5}'.format(row['name'], row['street'],name, street, row['gender'], gender)


def clean_movie(mode,nprocesses): 
	movie = tables["ml_mov"]
	#if mode == "test":
	#	movie = tables["ml_mov_test"]
	query = "SELECT * FROM {0}".format(movie)
	rows = database_handler.select(query)
	groundtruth = tables["gt_movies"]
	pool = mp.Pool(nprocesses)
	rows = list(rows)
	chunk_len = int(len(rows)/nprocesses)
	chunks = [rows[x:x+chunk_len] for x in xrange(0,len(rows),chunk_len)]
	for chunk in chunks:
		pool.apply_async(clean_movie_in_parallel, args=(groundtruth,chunk,movie,))
	pool.close()
	pool.join()

def clean_movie_in_parallel(groundtruth,rows,movie):
		for row in rows:
			select_query = "select * from {0} where genre='{1}'".format(groundtruth, row['genre']) 
			ground_truth_rows = database_handler.select(select_query)
			matching_seq = string_matcher.get_matching_mov_title(row['title'],ground_truth_rows,"title")
			id_as_string = str(row["id"])
			update_query = "update {0} set title='{1}' where id={2}".format(movie,matching_seq,id_as_string)
			database_handler.update(update_query)
			#print '{0} => {1}'.format(row['title'],matching_seq)
	
if __name__ == '__main__':
    # get db dir path
    curr_dir = os.getcwd()
    db_dir = curr_dir.replace("src/movieload", "db/")
    tables = database_handler.config.load_config(db_dir, "db_production")
    clean_customer("test",10)
    clean_movie("test",10)
