import io, sys, os
import MySQLdb as db

def dup_eli(table,attrs_to_match,rel_tables,fk_attrs):
	
	# DOCUMENATION:
	# function requires a table which has an attribute named 'id':
	# 'id' should be a primary key and a foreign key in related_table
	# table: primary table with duplicates
	# attrs_to_match: attributes which have the same value for every duplicate
	# rel_tables: related tables which have a foreign key referencing the primary table
	# fk_attrs: foreign key attributes to clean up after detecting duplicates. 
	# 			only one foreign key attribute per related table possible
	
	attr_match = get_attr_match(attrs_to_match)
	
	# query returns the first id's of entries which have duplicates e.g it returns the 'original' entries
	orig_query = "SELECT orig.id FROM {0} orig WHERE EXISTS( SELECT * FROM {0} dup WHERE {1} AND dup.id > orig.id ) AND NOT EXISTS ( SELECT * FROM {0} dup WHERE {1} AND dup.id < orig.id) ORDER BY orig.id".format(table,attr_match)
	orig_rows = list(select(orig_query))
	print "number of tuples that have duplicates in {0}: {1}".format(table,len(orig_rows))
	
	dup_rows_query = "SELECT orig.id FROM {0} orig WHERE EXISTS( SELECT * FROM {0} dup WHERE {1} AND dup.id <> orig.id ) AND orig.id NOT IN( {2} ) ORDER BY orig.id".format(table,attr_match,orig_query)
	dup_rows = list(select(dup_rows_query))
	print "number of duplicates in {0}: {1}".format(table,len(dup_rows))
	
	# update foreign key in related tables
	for orig_row in orig_rows: # could parallelize that too => depends on size of orig_rows
		i = 0
		print "updating original ", orig_row["id"]
		for rel_table in rel_tables:
			upd_query = "UPDATE {0} SET {1}={2} WHERE {1} IN ( SELECT dup.id FROM {3} orig, {3} dup WHERE {4} AND orig.id={2} AND dup.id<>orig.id )".format(rel_table,fk_attrs[i],str(orig_row["id"]),table,attr_match)
			#del_or_upd(upd_query)
			upd_or_del(upd_query)
			i+=1

	# delete duplicate entries
	del_query = "DELETE FROM {0} WHERE id = ".format(table)
	for dup_row in dup_rows:
		print "deleting entry ",dup_row["id"]
		tmp_del_query = ''.join([del_query,str(dup_row["id"])])
		#del_or_upd(tmp_del_query)
		upd_or_del(tmp_del_query)

	

def get_attr_match(attrs_to_match):
	last_attr = attrs_to_match.pop(-1)
	attr_match = ""
	for attr in attrs_to_match:
		left = "dup.{0}".format(attr)
		right = "orig.{0} AND ".format(attr)
		tmp_attr_match = "=".join([left,right])
		attr_match = ''.join([attr_match,tmp_attr_match])
	last_left = "dup.{0}".format(last_attr)
	last_right = "orig.{0}".format(last_attr)
	last_attr_match = "=".join([last_left,last_right])
	attr_match = "".join([attr_match,last_attr_match])
	return attr_match

def select(query):
	try:
		con = db.connect("localhost","root","12345", "integration")
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
		
def upd_or_del(query):
	try:
		con = db.connect("localhost","root","12345", "integration")
		cursor = con.cursor()
		cursor.execute(query)
		cursor.close()
		con.commit()
		con.close()
	except db.Error, e:
		print "Error %d: %s" % (e.args[0], e.args[1])
		sys.exit(1)
