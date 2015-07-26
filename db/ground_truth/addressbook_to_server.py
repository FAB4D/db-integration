import io
from io import *
import MySQLdb
from MySQLdb import *
import sys

def convertDate(dateString):
    dateList = dateString.split('.')
    day = int(dateList[0])
    month = int(dateList[1])
    year = dateList[2]
    
    daystr = ""
    monthstr = ""
    if(day < 10):
        daystr = "0"+str(day)
    else:
        daystr = str(day)
    if(month < 10):
        monthstr = "0"+str(month)
    else:
        monthstr = str(month)
    
    return year+"-"+monthstr+"-"+daystr     

def parser(usr = 'root', pw = '12345', db_name = 'integration', filename = 'addressbook.txt'):
    f = open(filename, 'r')
    lines = f.readlines()
    for i in range(0,len(lines)):
        lines[i] = lines[i].rstrip('\n')
        splitLine  = lines[i].split(';')
        date = convertDate(splitLine[3]) 
        splitLine[3] = date
        lines[i] = splitLine

    insertSchema = "INSERT INTO addressbook (firstname, lastname, gender, birth_date, street, city) VALUES "
    insertTuples = []
    insertPart = []
    count = 0
    for line in lines:
        insertTuple = "(\"" + "\", \"".join(line)+"\")"
        insertPart.append(insertTuple)
        if count%1000 == 0:
            insertPart = ",\n".join(insertPart)
            insertPart.rstrip(",\n")
            insertPart = insertSchema+insertPart
            insertPart+=";"
            insertTuples.append(insertPart)
            insertPart = []
        count += 1

    print count 

    try:
	conn = MySQLdb.connect (host = "localhost", user = usr,passwd = pw, db = db_name)
        cursor = conn.cursor()
        cursor.execute ("""DROP TABLE IF EXISTS addressbook""")
        cursor.execute ("""
            CREATE TABLE addressbook
            (
                firstname VARCHAR(100),
                lastname VARCHAR(100),
                gender CHAR(1),
                birth_date DATE,
                street VARCHAR(100),
                city VARCHAR(100)
            )
        """)
        
        for tuples in insertTuples:
            cursor.execute ("" + tuples + "")

        cursor.close()
        conn.commit()
        conn.close()

    except MySQLdb.Error, e:
        print "Error %d: %s" % (e.args[0], e.args[1])
        sys.exit (1)


if __name__ == '__main__':
    parser()
    print "success baby"

    
