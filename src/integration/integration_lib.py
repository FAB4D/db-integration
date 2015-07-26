import io, string, sys, math, os.path
import multiprocessing as mp
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from helpers import database_handler as db
from helpers import pg_database_handler as pgdb
from helpers import string_matcher
import os
import re
#import abc

# Abstract Base class to unhandy
class Integration:

    def __init__(self, db_dir, clean_db, integration_db, sql_file):
        self.db_dir = db_dir
        self.integration = db.DatabaseHandler(db_dir, integration_db) 
        self.cleaned = db.DatabaseHandler(db_dir, clean_db) 
        self.integration_tables = self.integration.tables
        self.cleaned_tables = self.cleaned.tables
        self.cus_offset = 100000
        self.mov_offset = 25000 
        self.physical_sell = self.integration_tables["p_sell"]
        self.physical_media = self.integration_tables["p_media"]
        self.wh_sell = self.cleaned_tables["wh_sell"]
        #self.statements = self.read_sql_file(sql_file)

    '''
    def nonblank_lines(self, f):
        for line in f:
            line = line.rstrip()
            if line:
                yield line#creates generator

    def read_sql_file(self, sql_file):
        file_name = self.db_dir + sql_file
        f = open(file_name, "rb")
        statements = []
        statement = []
        for line in self.nonblank_lines(f):
            line = line.strip('\t')
            if "CREATE TABLE" in line:
                statement = []
                statement.append(line)
            elif ");" in line:
                statement.append(line)
                statement = " ".join(statement)
                statements.append(statement)
            else:
                statement.append(line)

        return statements 
    '''

    def get_sql_statement(self, table_name):
        check_table = table_name + " ("
        create_table_statement = [s for s in self.statements if check_table in s]
        return create_table_statement[0]
 
    def create_tables(self):
    # create tables customer and movie
    # implementation can be invoked by calling super
        mov_table = self.integration_tables["mov"]
        cus_table = self.integration_tables["cus"]

        '''
        drop_movie = "DROP TABLE IF EXISTS %s"%mov_table
        pgdb.select(drop_movie)
        drop_customer = "DROP TABLE IF EXISTS %s"%cus_table
        pgdb.select(drop_customer)
        '''

        create_cus_statement = get_sql_statement(cus_table)
        self.integration.execute(create_cus_statement)
 
        create_mov_statement = get_sql_statement(mov_table)
        self.integration.execute(create_cus_statement)
        
        return

    def populate_customer(self):
        ml_customer = self.cleaned_tables["ml_cus"]
        wh_sell = self.cleaned_tables["wh_sell"]

        self.cus_offset_query = "SELECT COUNT(*) FROM %s"%ml_customer
	    # we don't need the offset
        #self.cus_offset = db.select(cus_offset_query)
	
	    #new: cid, firstname, lastname, gender, birthday, street, city
	    #old: id, name, gender, birthday, street, city 
        """
        ml_cus_query = "SELECT name, gender, birthday, street, city FROM %s"%ml_customer 
	    ml_cus_rows = db.select(ml_cus_query) 
        insert_schema = "INSERT INTO {0} (name, gender, birthday, street, city) VALUES "
        insert_tuples = []
        for row in ml_cus_rows:
            insert_tuple = "(\"" + "\", \"".join(row)+"\")"
            insert_tuples.append(insert_tuple)
        insert_query = insert_schema+", ".join(insertTuples)+";"
        pgdb.execute(insert_query)
        """
        #old: customer_firstname, customer_lastname, customer_gender, customer_birthday, customer_street, customer_city 
        wh_cus_query = "SELECT DISTINCT customer_firstname, customer_lastname, customer_birthday, customer_street, customer_city, customer_gender FROM %s"%wh_sell
	
        int_customer = self.integration_tables["cus"]
        print int_customer
        print self.integration.tables
        print self.integration.config
        wh_rows = self.cleaned.select(wh_cus_query)
        insert_statem = "INSERT INTO %s (id, firstname, lastname, birthday, street, city, gender, origin) VALUES"%int_customer
        origin = "WH"
        print len(wh_rows)
        '''
        seen = set()
        new_wh_rows = []
        for d in wh_rows:
            t = tuple(d.items())
            if t not in seen:
                seen.add(t)
                new_wh_rows.append(d)
        print len(new_wh_rows)
        '''
        inserts = []
        i = 1 
        j = 1
        update_query = "UPDATE customer SET origin=\"ML, WH\" WHERE" 
        update_list = []
        for row in wh_rows:
            firstname = str(row.pop("customer_firstname"))
            lastname = str(row.pop("customer_lastname"))
            name = "\", \"".join([firstname, lastname])
            row_id = str(i + self.cus_offset)
            gender = str(row["customer_gender"]).upper()[0]
            city = str(row.pop("customer_city"))
            street = str(row.pop("customer_street"))
            birthday = str(row.pop("customer_birthday"))
            '''
            exists_cus_ml_query = "SELECT id FROM customer WHERE firstname=\"{0}\" AND lastname=\"{1}\" AND birthday=\"{2}\" AND origin=\"ML\"".format(firstname, lastname, birthday)
            results = self.integration.select(exists_cus_ml_query)
            if results:
                update_id = results[0].pop("id")
                update_entry = "OR id=\"%s\""%str(update_id)
                print update_entry
                update_list.append(update_entry)
                j += 1
                if j % 100 == 0:
                    updates_joined = "\n".join(update_list)
                    update_query = " ".join(update_query, updates_joined)
                    print update_query
                    self.integration.execute(update_query)
                    update_list = []                    
                    
                continue;
            '''
            '''
            exists_cus_wh_query = "SELECT id FROM customer WHERE firstname=\"{0}\" AND lastname=\"{1}\" AND birthday=\"{2}\" AND street=\"{3}\" AND origin=\"WH\" OR origin=\"ML, WH\"".format(firstname, lastname, birthday, street)
            results = self.integration.select(exists_cus_wh_query)
            if results:
                print "continuing"
                continue;
            '''

            insert_values = "(" + row_id + ", \""+"\", \"".join([name, birthday, street, city, gender, origin])+"\"),"
            inserts.append(insert_values)
            if i % 1000 == 0:
                inserts_joined = "\n".join(inserts)
                inserts_joined = inserts_joined.rstrip(',\n')
                inserts_joined += ";"
                print inserts_joined[-10:]
                insert_query = " ".join([insert_statem, inserts_joined])
                self.integration.execute(insert_query) 
                inserts = []
                print "%s rows inserted"%str(i)

            i = i+1
            print i

        inserts_joined = "\n".join(inserts)
        inserts_joined = inserts_joined.rstrip(',\n')
        inserts_joined += ";"
        print inserts_joined[-10:]
        insert_query = " ".join([insert_statem, inserts_joined])
        self.integration.execute(insert_query) 

        '''
        updates_joined = "\n".join(update_list)
        update_query = " ".join(update_query, updates_joined)
        self.integration.execute(update_query)
        '''

        return

    def populate_movie(self):
        ml_movie = self.cleaned_tables["ml_mov"]
        wh_sell = self.cleaned_tables["wh_sell"]  

        #mov_offset_query = "SELECT COUNT(*) FROM %s"%ml_movie
        #self.mov_offset = db.select(mov_offset_query)
        #goal: id, genre, title, origin
        wh_mov_query = "SELECT DISTINCT movie_genre, movie_title FROM %s"%wh_sell 
        wh_rows = self.cleaned.select(wh_mov_query)
        int_table = self.integration_tables["mov"] 
        insert_statem = "INSERT INTO %s VALUES"%int_table 
        inserts = []
        i = 1 
        print len(wh_rows)
        for row in wh_rows:
            if i <= 46000 - 25000:
                i+=1
                continue
                
            genre = row.pop("movie_genre")
            title = row.pop("movie_title")
            insert_values = "(\""+"\", \"".join([str(i+self.mov_offset), str(genre), str(title), "WH"])+"\"),"
            inserts.append(insert_values);
            if i % 1000 == 0:
                inserts_joined = "\n".join(inserts)
                inserts_joined = inserts_joined.rstrip(',\n')
                inserts_joined += ";"
                insert_query = " ".join([insert_statem, inserts_joined])
                self.integration.execute(insert_query) 
                inserts = []
                print "%s rows inserted"%str(i)

            i = i+1

        inserts_joined = "\n".join(inserts)
        inserts_joined = inserts_joined.rstrip(',\n')
        inserts_joined += ";"
        print inserts_joined[-10:]
        insert_query = " ".join([insert_statem, inserts_joined])
        self.integration.execute(insert_query) 

        return     


    def populate_physical_media(self): 
        #now: price, media_type, bought_data, bougth_price 
        select_sell = "SELECT price, media_type, bought_date, bought_price, movie_title, movie_genre FROM %s"%self.wh_sell 
        
        wh_rows = self.cleaned.select(select_sell)
       #goal: id, mid, price, type, bought_date, bought_price  
        insert_statem =  "INSERT INTO %s VALUES"%self.physical_media
        inserts = []
        i = 1 
        print len(wh_rows)
        for row in wh_rows:
            if i <= 459000:
                i += 1
                continue

            movie_title = row.pop("movie_title")
            movie_genre = row.pop("movie_genre")
            price = row.pop("price")
            mtype = row.pop("media_type")
            get_id_query = "SELECT id FROM movie WHERE title=\"{0}\" AND genre=\"{1}\" AND origin = \"WH\"".format(movie_title, movie_genre)
            movie_id = self.integration.select(get_id_query)
            row_list = [str(v) for v in row.values()]
            row_tuple = "( \""+"\", \"".join([str(i), str(price), str(mtype), "\", \"".join(row_list), str(movie_id[0]['id'])])+"\" ),"
            inserts.append(row_tuple)
            if i % 1000 == 0:
                inserts_joined = "\n".join(inserts)
                inserts_joined = inserts_joined.rstrip(',\n')
                inserts_joined += ";"
                print inserts_joined[-10:]
                insert_query = " ".join([insert_statem, inserts_joined])
                self.integration.execute(insert_query) 
                inserts = []
                print "%s rows inserted"%str(i)

            i=i+1

        print i
        inserts_joined = "\n".join(inserts)
        inserts_joined = inserts_joined.rstrip(',\n')
        inserts_joined += ";"
        print inserts_joined[-10:]
        insert_query = " ".join([insert_statem, inserts_joined])
        self.integration.execute(insert_query) 
            
        return
        
    def populate_physical_sell(self):
        #now: sell_date
        #goal: id, pmid, cid, sell_date
        select_sell_date = "SELECT sell_date, customer_firstname as cf, customer_lastname as cl, customer_birthday, customer_street, customer_gender, customer_city, price, bought_date, bought_price FROM %s WHERE customer_firstname IS NOT NULL AND customer_lastname IS NOT NULL AND customer_gender IS NOT NULL AND customer_street IS NOT NULL AND customer_birthday IS NOT NULL"%self.wh_sell
        wh_rows = self.cleaned.select(select_sell_date)

        insert_statem = "INSERT INTO %s VALUES"%self.physical_sell
        inserts = []
        i = 1 
        for row in wh_rows:

            print row
            cus_firstn = row.pop("cf")
            cus_lastn = row.pop("cl")
            cus_street = row.pop("customer_street")
            cus_birth = row.pop("customer_birthday")
            cus_gender = row.pop("customer_gender")
            cus_city = row.pop("customer_city")
            
            bought_date = row.pop("bought_date")
            bought_price = row.pop("bought_price")
            price = row.pop("price")

            sell_date = row.pop("sell_date")

            get_cid_query = "SELECT id FROM customer WHERE firstname = \"{0}\" AND lastname = \"{1}\" AND birthday = \"{2}\" AND street = \"{3}\" AND city = \"{4}\" AND origin = \"WH\"".format(cus_firstn, cus_lastn, cus_birth, cus_street, cus_city)
            cus_id = self.integration.select(get_cid_query)
            cus_id = str(cus_id[0]['id'])
            print cus_id
            # check if cus_id is an integer
            #get_pmid_query = "SELECT id FROM physical_media WHERE price=\"{0}\" AND bought_date=\"{1}\" AND bought_price=\"{2}\"".format(price, bought_date, bought_price)
            #pm_id = self.integration.select(get_pmid_query)
            #pm_id = str(pm_id[0]["id"])
            row_tuple = "( \""+"\", \"".join([str(i), str(sell_date), str(i), cus_id])+"\" ),"
            print row_tuple
            inserts.append(row_tuple)
            if i % 1000 == 0:
                inserts_joined = "\n".join(inserts)
                inserts_joined = inserts_joined.rstrip(',\n')
                inserts_joined += ";"
                print inserts_joined[-10:]
                insert_query = " ".join([insert_statem, inserts_joined])
                self.integration.execute(insert_query) 
                inserts = []
                print "%s rows inserted"%str(i)

            i=i+1

        if inserts:
            inserts_joined = "\n".join(inserts)
            inserts_joined = inserts_joined.rstrip(',\n')
            inserts_joined += ";"
            print inserts_joined[-10:]
            insert_query = " ".join([insert_statem, inserts_joined])
            self.integration.execute(insert_query) 

        return


class Movieload(Integration):

    def __init__(self, integration_tables, cleaned_tables):
        self.integration_tables = integration_tables
        self.cleaned_tables = cleaned_tables
        return

    def create_tables(self):
        online_sell = self.integration_tables["o_sell"]
        online_media = self.integration_tables["o_media"] 

        create_online_media = get_sql_statement(online_media)
        pgdb.execute(create_online_media)
       
        create_online_sell = get_sql_statement(online_sell)
        pgdb.execute(create_online_sell)

        return

    def populate_online_media(self):
        return
    def populate_online_sell(self):
        return



# subclass for wollyhood insertion
class Wollyhood(Integration):

    def __init__(self):
        return
    '''
    def __init__(self, self.base, integration_tables, cleaned_tables):
        self.integration_tables = integration_tables
        self.cleaned_tables = cleaned_tables
        self.physical_sell = self.integration_tables["p_sell"]
        self.physical_media = self.integration_tables["p_media"]

        self.wh_sell = self.cleaned_tables["wh_sell"]
        return
        
    def create_tables(self):
        create_physical_media = self.get_sql_statement(self.physical_media)
        pgdb.execute(create_online_media)
       
        create_physical_sell = self.get_sql_statement(self.physical_sell)
        pgdb.execute(create_physical_sell)

        return
    '''

