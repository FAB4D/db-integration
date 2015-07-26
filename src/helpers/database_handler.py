import io
import sys
import ConfigParser
import string
import config

import MySQLdb as db

'''
_core_options = ['server', 'name', 'user', 'password']

def loadconfig.config(db_dir, config_section):
    global config.config
    cp = ConfigParser.ConfigParser()
    config_fn = db_dir + "/dbconfig.config.ini"
    print config_fn
    cp.read(config_fn)
    if config_section in cp.sections():
        for opt in cp.options(config_section):
            config.config[opt] = string.strip(cp.get(config_section, opt))

    tables = dict() 
    for key in config.config:
        if key not in _core_options:
            tables[key] = config.config[key]

    return tables
'''

class DatabaseHandler:

    def __init__(self, db_dir, database):
        self.call_load_config(db_dir, database)        

    def call_load_config(self, db_dir, database):
        res = config.load_config(db_dir, database)
        self.tables = res.pop()
        self.config = res.pop() 
        print self.config

    def select(self, query):
        try:
            con = db.connect(self.config["server"], self.config["user"], self.config["password"], self.config["name"])
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


    def execute(self, query):
        try:
            con = db.connect(self.config["server"], self.config["user"], self.config["password"], self.config["name"])
            cursor = con.cursor()
            cursor.execute(query)
            cursor.close()
            con.commit()
            con.close()
        except db.Error, e:
            print "Error %d: %s" % (e.args[0], e.args[1])
            sys.exit(1)


    def delete(self, query):
        try:
            con = db.connect(self.config["server"], self.config["user"], self.config["password"], self.config["name"])
            cursor = con.cursor(db.cursors.DictCursor)
            cursor.execute(query)
            cursor.close()
            con.commit()
            con.close()
        except db.Error, e:
            print "Error %d: %s" % (e.args[0], e.args[1])
            sys.exit(1)





