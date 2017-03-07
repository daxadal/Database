DROP TABLE Domicilios;
DROP TABLE Tel�fonos;
DROP TABLE empleados;
DROP TABLE "C�digos postales";


CREATE TABLE Empleados
  (
    Nombre CHAR(50) NOT NULL,
    DNI    CHAR(9) PRIMARY KEY ,
    Sueldo NUMBER(6,2),
    CHECK (Sueldo BETWEEN 645.30 AND 5000)
  );
CREATE TABLE "C�digos postales"
  (
    "C�digo postal" CHAR(5) PRIMARY KEY,
    Poblaci�n       CHAR(50),
    Provincia       CHAR(50)
  );
CREATE TABLE Domicilios
  (
    DNI             CHAR(9) REFERENCES Empleados(DNI) ON DELETE CASCADE,
    Calle           CHAR(50) ,
    "C�digo Postal" CHAR(5) REFERENCES "C�digos postales",
    PRIMARY KEY (DNI, Calle, "C�digo Postal")
  );
CREATE TABLE Tel�fonos
  (
    DNI      CHAR(9) REFERENCES Empleados(DNI) ON DELETE CASCADE,
    Tel�fono CHAR(9),
    PRIMARY KEY (DNI, Tel�fono)
  );

  

  