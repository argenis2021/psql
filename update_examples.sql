UPDATE no_deseado
SET nombre = 'Pilar Velásco'
WHERE
   nombre = 'Pilar Velasco' 
RETURNING nombre;

UPDATE ventas_la_carlota
SET telefono = null
WHERE
   telefono = ' ' 
RETURNING Cliente,
	fecha,
	codcli
	telefono;