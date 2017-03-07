--Eric García de Ceca Elejoste - 3ºDG

/abolish
/multiline on

create or replace table programadores(dni string primary key, nombre string, dirección string, teléfono string);
insert into programadores values('1','Jacinto','Jazmín 4','91-8888888');
insert into programadores values('2','Herminia','Rosa 4','91-7777777');
insert into programadores values('3','Calixto','Clavel 3','91-1231231');
insert into programadores values('4','Teodora','Petunia 3','91-6666666');

create or replace table analistas(dni string primary key, nombre string, dirección string, teléfono string);
insert into analistas values('4','Teodora','Petunia 3','91-6666666');
insert into analistas values('5','Evaristo','Luna 1','91-1111111');
insert into analistas values('6','Luciana','Júpiter 2','91-8888888');
insert into analistas values('7','Nicodemo','Plutón 3',NULL);

create or replace table distribución(códigoPr string, dniEmp string, horas int, primary key (códigoPr, dniEmp));
insert into distribución values('P1','1',10);
insert into distribución values('P1','2',40);
insert into distribución values('P1','4',5);
insert into distribución values('P2','4',10);
insert into distribución values('P3','1',10);
insert into distribución values('P3','3',40);
insert into distribución values('P3','4',5);
insert into distribución values('P3','5',30);
insert into distribución values('P4','4',20);
insert into distribución values('P4','5',10);

create or replace table proyectos(código string primary key, descripción string, dniDir string);
insert into proyectos values('P1','Nómina','4');
insert into proyectos values('P2','Contabilidad','4');
insert into proyectos values('P3','Producción','5');
insert into proyectos values('P4','Clientes','5');
insert into proyectos values('P5','Ventas','6');

--Vista
create or replace view empleados as
	select * from programadores union select * from analistas;
create or replace view vista1 as
	select dni
	from empleados;
	
create or replace view vista2 as
	select dni
	from select * from programadores intersect select * from analistas;
	
create or replace view vista3 as
	select dni
		from empleados
	except
	select dni
		from empleados, distribución, proyectos
		where dni = dniEmp or dni = dniDir;
	
create or replace view vista4 as
	select código
		from proyectos
	except
	select códigoPr as código
		from distribución inner join analistas on dni = dniEmp;
		
create or replace view vista5 as
	select dni
		from proyectos inner join analistas on dni = dniDir
	except
	select dni
		from distribución inner join analistas on dni = dniEmp;
		
create or replace view vista6 as
	select descripción, nombre, horas
	from (proyectos inner join distribución on código = códigoPr) inner join programadores on dni = dniEmp;
	
create or replace view vista7 as
	select teléfono
	from empleados as E1, empleados as E2
	where E1.teléfono = E2.teléfono and E1.dni < E2.dni;
	
create or replace view vista8 as
	select dni
	from programadores natural inner join analistas;
	
create or replace view vista9 as
	select dniEmp as dni, sum(horas) as horas
	from distribución
	group by dniEmp;
	
create or replace view vista10 as
	select dni, nombre, códigoPr as proyecto
	from empleados left join distribución on dni = dniEmp;
	
create or replace view vista11 as
	select dni, nombre
	from empleados
	where teléfono is null;
	
create or replace view vista12Aux as
	select * 
	from (select dniEmp as dni,  sum(horas)/count(códigoPr) as horas
		from distribución
		group by dniEmp)
		,
		(select sum (horas)/count (dniEmp) as tope 
		from distribución
		group by códigoPr);
		
create or replace view vista12 as
	select dni
	from vista12Aux
	where horas < avg(tope);
	
create or replace view vista13 as
	select dni
	from distribución division 
		(select códigoPr
		from empleados, distribución
		where nombre = 'Evaristo' and dni= dniEmp);
	
create or replace view vista14 as
	select dniEmp as dni
	from distribución
	where códigoPr in
		(select códigoPr
		from empleados, distribución
		where nombre = 'Evaristo' and dni= dniEmp)
	group by dniEmp
	having count (distinct códigoPr) =
		(select count(distinct códigoPr)
		from empleados, distribución
		where nombre = 'Evaristo' and dni= dniEmp);
		
create or replace view vista15 as
	select códigoPr, dniEmp as dni, horas*1.2 as horas
	from distribución as dis
	where not exists
	(	(select códigoPr
		from distribución
		where dis.dniEmp = dniEmp)
		intersect
		(select códigoPr
		from empleados, distribución
		where nombre = 'Evaristo' and dni= dniEmp)
	);

create or replace view jefes as
	select dniDir as jefe, dniEmp as emp
	from distribución inner join proyectos on código = códigoPr;

create or replace view dep as
	with jefes_rec (jefe, emp) as (
		(select jefe, emp
		from jefes
		where jefe =
			(select dni
			from empleados
			where nombre= 'Evaristo')
		)
		union all
		(select j1.jefe, j2.emp
		from jefes_rec as j1, jefes as j2
		where j1.emp = j2.jefe)
	)	
	select emp
	from jefes_rec;
	
create or replace view vista16 as
	select nombre
	from empleados inner join dep on dni=emp;
		
	
--Mostrar vistas
select * from vista1;
select * from vista2;
select * from vista3;
select * from vista4;
select * from vista5;
select * from vista6;
select * from vista7;
select * from vista8;
select * from vista9;
select * from vista10;
select * from vista11;
select * from vista12;
select * from vista13;
select * from vista14;
select * from vista15;
select * from vista16;
