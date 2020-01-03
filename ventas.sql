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

#Vista Volumen
create view volumen as
	*
	from
		(
			select cliente, sum(cantidad) as suma, current_date-max(fecha) as dias 
			from ventas_la_carlota
			group by cliente
		) as qry_volumen
	where qry_volumen.suma is not null and qry_volumen.cliente <>'Desconocido'
	order by qry_volumen.suma
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

#Vista Cantidad
    create view cantidad as
    select 	qry1.cliente,
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

\copy ventas_la_carlota to '/tmp/ventas.csv' delimiter ',' csv header;
\copy ventas_la_carlota (Fecha,CodCli,Cliente,Telefono,Cantidad,Descripción,Precio,Locación,Semana) from '/tmp/ventas.csv.tmp' delimiter ',' csv header;


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

#telefono_cliente
create view telefono_cliente as
Select row_number() over (order by cliente) as item, cliente, telefono
from ventas_la_carlota
where telefono is not null
group by cliente, telefono;

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

\copy (select telefono,cliente from tel60) to '/tmp/tel60.csv' delimiter ',' csv header;
\copy (select telefono,cliente from tel120) to '/tmp/tel120.csv' delimiter ',' csv header;
\copy (select telefono,cliente from tel_antiguos) to '/tmp/tel_antiguos.csv' delimiter ',' csv header;
\copy (select telefono,cliente from todos) to '/tmp/tel_todos.csv' delimiter ',' csv header;

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


create table no_deseado 
	(
		pk_no_deseado serial,
		nombre varchar(30)	
	);

create table interesados_tmp 
	(
		nombre varchar(30),
		telefono varchar(30)
	);

create table envases 
	(
		pk_envases serial,
		nombre varchar(30),
		telefono varchar(30)
	);

\copy interesados_tmp from '/tmp/interesados.csv.' delimiter ',' csv header;

create table interesados 
	(
		pk_interesados serial,
		nombre varchar(30),
		telefono varchar(30)
	);

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

\copy interesados from '/tmp/interesados.csv' delimiter ',' csv header;
\copy (select telefono,nombre from interesados) to '/tmp/interesados.csv' delimiter ',' csv header;