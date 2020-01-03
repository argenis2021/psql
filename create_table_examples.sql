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

create table interesados 
	(
		pk_interesados serial,
		nombre varchar(30),
		telefono varchar(30)
	);