import io
import sys
import ConfigParser
import config

import psycopg2 as pgdb

def select(query):
    try:
        conn = pgdb.connect(config._config["server"], config._config["user"], config._config["password"], config._config["name"])        
    except Exception as error:
        print "Unable to connect to database: %s"%error
    
    cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    try:
        cursor.execute(query)
    except pgdb.IntegrityError as error:
        print "Query execution failed: %s"%error

    rows = cursor.fetchall()
    conn.commit()
    cursor.close()
    conn.close()

    return rows

def upd_or_ins(query):
	try:
		conn = pgdb.connect("dbname='dwhouse' user='root' host='localhost' password='12345'")
		cursor = conn.cursor()
		cursor.execute(query)
		cursor.close()
		conn.commit()
		conn.close()
	except pgdb.IntegrityError as error:
		print "Query execution failed: %s"%error


