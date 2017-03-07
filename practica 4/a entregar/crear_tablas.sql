DROP TABLE Domicilios;
DROP TABLE Teléfonos;
DROP TABLE empleados;
DROP TABLE "Códigos postales";


CREATE TABLE Empleados
  (
    Nombre CHAR(50) NOT NULL,
    DNI    CHAR(9) PRIMARY KEY ,
    Sueldo NUMBER(6,2),
    CHECK (Sueldo BETWEEN 645.30 AND 5000)
  );
CREATE TABLE "Códigos postales"
  (
    "Código postal" CHAR(5) PRIMARY KEY,
    Población       CHAR(50),
    Provincia       CHAR(50)
  );
CREATE TABLE Domicilios
  (
    DNI             CHAR(9) REFERENCES Empleados(DNI) ON DELETE CASCADE,
    Calle           CHAR(50) ,
    "Código Postal" CHAR(5) REFERENCES "Códigos postales",
    PRIMARY KEY (DNI, Calle, "Código Postal")
  );
CREATE TABLE Teléfonos
  (
    DNI      CHAR(9) REFERENCES Empleados(DNI) ON DELETE CASCADE,
    Teléfono CHAR(9),
    PRIMARY KEY (DNI, Teléfono)
  );

  

  