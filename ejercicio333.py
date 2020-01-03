import psycopg2

conexion1 = psycopg2.connect(database="mydb", user="postgres", password="")
cursor1=conexion1.cursor()
sql="insert into articulos(descripción, precio) values (%s,%s)"
datos=("naranjas", 23.50)
cursor1.execute(sql, datos)
datos=("peras", 34)
cursor1.execute(sql, datos)
datos=("bananas", 25)
cursor1.execute(sql, datos)
conexion1.commit()
conexion1.close() 