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

#telefono_cliente
create view telefono_cliente as
Select row_number() over (order by cliente) as item, cliente, telefono
from ventas_la_carlota
where telefono is not null
group by cliente, telefono;