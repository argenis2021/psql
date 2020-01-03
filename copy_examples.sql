\copy ventas_la_carlota to '/tmp/ventas.csv' delimiter ',' csv header;
\copy ventas_la_carlota (Fecha,CodCli,Cliente,Telefono,Cantidad,Descripción,Precio,Locación,Semana) from '/tmp/ventas.csv.tmp' delimiter ',' csv header;
\copy (select telefono,cliente from tel60) to '/tmp/tel60.csv' delimiter ',' csv header;
\copy (select telefono,cliente from tel120) to '/tmp/tel120.csv' delimiter ',' csv header;
\copy (select telefono,cliente from tel_antiguos) to '/tmp/tel_antiguos.csv' delimiter ',' csv header;
\copy (select telefono,cliente from todos) to '/tmp/tel_todos.csv' delimiter ',' csv header;
\copy interesados_tmp from '/tmp/interesados.csv.' delimiter ',' csv header;
\copy interesados from '/tmp/interesados.csv' delimiter ',' csv header;
\copy (select telefono,nombre from interesados) to '/tmp/interesados.csv' delimiter ',' csv header;