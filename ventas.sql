#Volumen
select *
from
	(
		select cliente, sum(cantidad) as suma, current_date-max(fecha) as dia 
		from ventas_la_carlota
		group by cliente
	) as foo
where foo.suma is not null and foo.cliente <>'Desconocido'
order by foo.suma
desc;

#Cantidad
select 
    qry1.cliente,
    count(qry1.fecha) as compras,
    current_date-max(qry1.fecha) as dias,
    count(qry1.fecha)/(current_date-min(qry1.fecha)):: double PRECISION *30  as comprasXmes
from
	(
		select cliente, fecha
		from ventas_la_carlota
		where cliente <>'Desconocido'
		group by fecha, cliente
	) as qry1
group by qry1.cliente
order by compras
desc;


#frecuencia
select 
    qry1.cliente,
    count(qry1.fecha) as compras,
    current_date-max(qry1.fecha) as dias,
    count(qry1.fecha)/(current_date-min(qry1.fecha)):: double PRECISION *30  as comprasXmes
from
	(
		select cliente, fecha
		from ventas_la_carlota
		where cliente <>'Desconocido'
		group by fecha, cliente
	) as qry1
group by qry1.cliente
having count(qry1.fecha) > count(qry1.fecha)/(current_date-min(qry1.fecha)):: double PRECISION *30 and count(qry1.fecha)/(current_date-min(qry1.fecha)):: double PRECISION *30 >2
order by comprasXmes
desc;


#mes
select to_char(qry1.fecha, 'MM') as mes, count(qry1.cliente)
from 
	(
		select cliente, max(fecha) as fecha
		from ventas_la_carlota
		group by cliente
		order by cliente
	) as qry1 
group by mes
order by mes
asc;

select cliente, max(fecha) as fecha
from ventas_la_carlota
where cliente like '%Nativi%'
group by cliente
order by cliente;

select cliente, max(fecha) as fecha
from ventas_la_carlota
where cliente like '%Rosa%'
group by cliente
order by cliente;


#Estrellas
SELECT
    volumen.cliente,
    volumen.suma/cantidad.compras as promedio,
    volumen.suma as litros,
    cantidad.compras,
    cantidad.dias
FROM
    volumen
INNER JOIN cantidad ON volumen.cliente = cantidad.cliente
where (cantidad.compras >3 or volumen.suma >10) and cantidad.dias<61 and volumen.suma/cantidad.compras >4
order by promedio
desc;


#Ultimos 60 dias

select row_number() over (order by foo.suma desc) as item, *
from
	(
		select cliente, sum(cantidad) as suma, current_date-max(fecha) as dia 
		from ventas_la_carlota
		group by cliente
	) as foo
where foo.suma is not null and foo.cliente <>'Desconocido' and dia <60
order by foo.suma
desc;

#Entre 61 y 120

select row_number() over (order by foo.suma desc) as item, *
from
	(
		select cliente, sum(cantidad) as suma, current_date-max(fecha) as dia 
		from ventas_la_carlota
		group by cliente
	) as foo
where foo.suma is not null and foo.cliente <>'Desconocido' and dia >61 and dia <121
order by foo.suma
desc;


#Mayor 121

select row_number() over (order by foo.suma desc) as item, *
from
	(
		select cliente, sum(cantidad) as suma, current_date-max(fecha) as dia 
		from ventas_la_carlota
		group by cliente
	) as foo
where foo.suma is not null and foo.cliente <>'Desconocido' and dia >120
order by foo.suma
desc;


#telefono 60
SELECT
    row_number() over (order by sesenta.cliente) as item,
    sesenta.cliente,
    telefono_cliente.telefono
FROM
    telefono_cliente
INNER JOIN sesenta ON telefono_cliente.cliente = sesenta.cliente
LEFT JOIN no_deseado ON telefono_cliente.cliente = no_deseado.nombre
where no_deseado.nombre is null;

#telefono 120
SELECT
    row_number() over (order by cientoveinte.cliente) as item,
    cientoveinte.cliente,
    telefono_cliente.telefono
FROM
    telefono_cliente
INNER JOIN cientoveinte ON telefono_cliente.cliente = cientoveinte.cliente
LEFT JOIN no_deseado ON telefono_cliente.cliente = no_deseado.nombre
where no_deseado.nombre is null;

#telefono antiguos
SELECT
    row_number() over (order by antiguos.cliente) as item,
    antiguos.cliente,
    telefono_cliente.telefono
FROM
    telefono_cliente
INNER JOIN antiguos ON telefono_cliente.cliente = antiguos.cliente
LEFT JOIN no_deseado ON telefono_cliente.cliente = no_deseado.nombre
where no_deseado.nombre is null;

#telefono todos
SELECT
    row_number() over (order by telefono_cliente.cliente) as item,
    telefono_cliente.cliente,
    telefono_cliente.telefono
FROM
    telefono_cliente
LEFT JOIN no_deseado ON telefono_cliente.cliente = no_deseado.nombre
where no_deseado.nombre is null;


#cantidad por producto

SELECT
    Descripción,
    sum(cantidad) AS cantidad
FROM
    ventas_la_carlota
where descripción is not null and descripción <> 'Desconocido' and fecha between '28/12/2019' and '28/12/2019'
group by descripción
order by cantidad
desc;

#Cantidad por presentación
SELECT
    descripción,
    cantidad,
    count(cantidad) AS total
FROM
    ventas_la_carlota
where descripción is not null and descripción <> 'Desconocido' and fecha between '11/12/2019' and '11/12/2019' and cantidad ='2'
group by cantidad,descripción
order by descripción, total
desc;

#Obtención de interesado
SELECT
    row_number() over (order by interesados_tmp.nombre) as item,
    interesados_tmp.nombre,
    interesados_tmp.telefono
FROM
    interesados_tmp
LEFT JOIN telefono_cliente ON interesados_tmp.nombre = telefono_cliente.cliente
where telefono_cliente is null;

#telefonos estrellas
SELECT
    row_number() over (order by estrellas.cliente) as item,
    estrellas.cliente,
    telefono_cliente.telefono
FROM
    estrellas
inner JOIN telefono_cliente ON estrellas.cliente = telefono_cliente.cliente
where telefono_cliente is not null;
