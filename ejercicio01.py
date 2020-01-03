#/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2
DSN = "dbname=mydb user=postgres"

def leer_datos():
    con = psycopg2.connect(DSN)
    cur = con.cursor()
    query = "SELECT * FROM articulos;"
    cur.execute(query)
    for descripción in cur.fetchall():
        print(descripción)
    cur.close()
    con.close()

if __name__== "__main__":
   leer_datos();