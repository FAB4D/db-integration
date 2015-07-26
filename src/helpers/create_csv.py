import os
import sys
import csv
import database_handler as db

curr_dir = os.getcwd()
db_dir = curr_dir.replace("src/helpers", "db/")
integration = db.DatabaseHandler(db_dir, "db_deployment")

def nonblank_lines(f):
    for line in f:
        line = line.rstrip()
        if line:
            yield line#creates generator

def read_queries_from_file(sql_file):
    file_name = sql_file
    f = open(file_name, "rb")
    queries = []
    last_line = ""
    names = []
    for line in nonblank_lines(f):
        line = line.strip('\t')
        if "select" in line:
            query = line
            names.append(last_line)
            queries.append(query)
        #elif ";" in line:
        #    query.append(line)
        #    print query
        #    query = " ".join(query)
        #    print query
        #    queries.append(query)
        #else:
        #    query.append(line)
        #    print "do nought"

        last_line = line
        last_line = last_line.lstrip("/*")
        last_line = last_line.rstrip("*/")

    return [names, queries] 

def query_to_csv(query, filename): 
    rows = integration.select(query)
    csvf = ".".join([filename, "csv"])
    c = csv.writer(open(csvf, "wb"))
    for row in rows:
        c.writerow(row.values())

def main(sql_file, path):
    namesies = read_queries_from_file(sql_file)
    print path
    queries = namesies[1]
    names = namesies[0]
    i = 0
    for query in queries:
        filename = names[i]
        path_to_file = "/".join([path, filename])
        i += 1
        query_to_csv(query, path_to_file)

if __name__ == "__main__":
    main(*sys.argv[1:])
