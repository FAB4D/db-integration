import io
import sys
import ConfigParser
import config
import psycopg2 as pgdb

_config = dict()

def call_load_config(db_dir, database):
    res = config.load_config(db_dir, database)
    tables = res.pop()
    _config = res.pop()
    return tables

def select(query):
    try:
        conn = pgdb.connect(_config["server"], _config["user"], _config["password"], _config["name"])        
    
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
    except Exception as error:
        print "Unable to connect to database: %s"%error


def execute(query):
    try:
        conn = pgdb.connect(_config["server"], _config["user"], _config["password"], _config["name"])        
    
        cursor = conn.cursor()

        try:
            cursor.execute(query)
        except pgdb.IntegrityError as error:
            print "Query execution failed: %s"%error

        cursor.close()
        conn.commit()
        conn.close()

    except Exception as error:
        print "Unable to connect to database: %s"%error
