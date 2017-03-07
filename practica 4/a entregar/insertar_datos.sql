--Fallo 1
INSERT INTO empleados VALUES
  ('Pepe', 1, 2000
  );
INSERT INTO empleados VALUES
  ('Juan', 1, 3200
  );
/*
Informe de error:
Error SQL: ORA-00001: restricción única (DG06.SYS_C0027224) violada
00001. 00000 -  "unique constraint (%s.%s) violated"
*Cause:    An UPDATE or INSERT statement attempted to insert a duplicate key.
For Trusted Oracle configured in DBMS MAC mode, you may see
this message if a duplicate entry exists at a different level.
*Action:   Either remove the unique restriction or do not insert the key.
*/


--Fallo 2
INSERT INTO empleados VALUES
  ( 'Eva', NULL, 1000
  );
/*
Informe de error:
Error SQL: ORA-01400: no se puede realizar una inserción NULL en ("DG06"."EMPLEADOS"."DNI")
01400. 00000 -  "cannot insert NULL into (%s)"
*/


--Fallo 3
INSERT INTO empleados VALUES
  ( 'Juana', 2, 100
  );
/*
Informe de error:
Error SQL: ORA-02290: restricción de control (DG06.SYS_C0027223) violada
02290. 00000 -  "check constraint (%s.%s) violated"
*Cause:    The values being inserted do not satisfy the named check
           
*Action:   do not insert values that violate the constraint.
*/


--Fallo 4
INSERT INTO teléfonos VALUES
  ( 3, 916667778
  ) ;
/*
Informe de error:
Error SQL: ORA-02291: restricción de integridad (DG06.SYS_C0027242) violada - clave principal no encontrada
02291. 00000 - "integrity constraint (%s.%s) violated - parent key not found"
*Cause:    A foreign key value has no matching primary key value.
*Action:   Delete the foreign key or add a matching primary key.
*/


--Fallo 5
INSERT INTO "Códigos postales" VALUES
  (01234, 'Las Rosas', 'Madrid'
  );
INSERT INTO domicilios VALUES
  (1, 'Calle Alabastro 5', 01234
  );
DELETE FROM "Códigos postales" WHERE "Código postal" = 01234;
/*
Informe de error:
Error SQL: ORA-02292: restricción de integridad (DG06.SYS_C0027266) violada - registro secundario encontrado
02292. 00000 - "integrity constraint (%s.%s) violated - child record found"
*Cause:    attempted to delete a parent key value that had a foreign
           dependency.
*Action:   delete dependencies first then parent or disable constraint.
*/

--Fallo 6
INSERT INTO empleados VALUES
  ( 'Ambrosio', 5, 1234 
  );
INSERT INTO domicilios VALUES
  ( 5, 'Calle Zeus 12', 01234
  );
DELETE FROM EMPLEADOS WHERE nombre = 'Ambrosio';
/*
Se borra tanto el empleado como el domicilio
*/

--Fallo 7
DROP TABLE Teléfonos;
CREATE TABLE Teléfonos
  (
    DNI      CHAR(9) REFERENCES Empleados(DNI) ON DELETE SET NULL,
    Teléfono CHAR(9),
    PRIMARY KEY (DNI, Teléfono)
  );
INSERT INTO TELÉFONOS VALUES
  (1, 913335557
  );
DELETE FROM EMPLEADOS WHERE dni = 5;
/*
Error que empieza en la línea 103 del comando:
DELETE FROM EMPLEADOS WHERE nombre = 'Ambrosio'
Informe de error:
Error SQL: ORA-01407: no se puede actualizar ("DG06"."TELÉFONOS"."DNI") a un valor NULL
01407. 00000 -  "cannot update (%s) to NULL"
*Cause:    
*Action:
*/