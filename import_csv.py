#!/usr/bin/python

import psycopg2 #import the postgres library
from psycopg2 import Error

#connect to the database

try:
	conn = psycopg2.connect(host='localhost',
							dbname='mydb',
							user='postgres',
							password='')
#create a cursor object 
#cursor object is used to interact with the database
	cur = conn.cursor()

#drop table if exist 

	cur.execute("DROP TABLE IF EXISTS test")

#create table with same headers as csv file
	cur.execute('''create table test(name char(50), age char(50), height char(50));''')

#open the csv file using python standard file I/O
#copy file into the table just created 
	f = open('/tmp/file.csv','r')
	cur.copy_from(f, 'test', sep=',')
	f.close()

except (Exception, psycopg2.DatabaseError) as error :
	print ("Error while creating PostgreSQL table", error)



finally:
    #closing database connection.
	conn.commit()
	if(conn):
		conn.close()
		print("PostgreSQL connection is closed")