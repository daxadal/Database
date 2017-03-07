SET SERVEROUTPUT ON SIZE (1000000);

--- Apartado 4 ----------------
CREATE OR REPLACE PROCEDURE ComprobarNulos
AS
  cp "Códigos postales I"."Código postal"%TYPE;
  pobl "Códigos postales I".población%TYPE;
  prov "Códigos postales I".provincia%TYPE;
  CURSOR CPI
  IS
    SELECT "Código postal", población, provincia  
    FROM "Códigos postales I" 
    WHERE "Código postal" IS NULL;
  excepcion_nulo EXCEPTION;
BEGIN
  OPEN CPI;
  FETCH CPI INTO cp, pobl, prov;
  IF CPI%FOUND THEN
      RAISE excepcion_nulo;
  END IF;
  CLOSE CPI;
EXCEPTION
WHEN excepcion_nulo THEN DBMS_OUTPUT.PUT_LINE ('Código postal nulo en la tupla: ' || cp || ', ' || pobl || ', ' || prov );
END;


--- Apartado 5 ----------------
CREATE OR REPLACE PROCEDURE ComprobarPK
AS
  cp "Códigos postales I"."Código postal"%TYPE;
  pobl "Códigos postales I".población%TYPE;
  prov "Códigos postales I".provincia%TYPE;
  CURSOR CPI
  IS
    SELECT CPA."Código postal", CPA.población, CPA.provincia 
    FROM "Códigos postales I"  CPA, "Códigos postales I"  CPB
    WHERE CPA."Código postal" = CPB."Código postal"
      AND (CPA.población <> CPB.población OR CPA.provincia <> CPB.provincia);
      
  excepcion_pk EXCEPTION;
  
BEGIN
  OPEN CPI;
  FETCH CPI INTO cp, pobl, prov;
  IF CPI%FOUND THEN
      RAISE excepcion_pk;
  END IF;
  CLOSE CPI;
EXCEPTION
WHEN excepcion_pk  THEN DBMS_OUTPUT.PUT_LINE ('Código postal repetido en la tupla: ' || cp || ', ' || pobl || ', ' || prov );
END;


--- Apartado 6 ----------------
CREATE OR REPLACE PROCEDURE ComprobarFD
AS
  cp "Códigos postales I"."Código postal"%TYPE;
  pobl "Códigos postales I".población%TYPE;
  prov "Códigos postales I".provincia%TYPE;
  CURSOR CPI
  IS
    SELECT CPA."Código postal", CPA.población, CPA.provincia 
    FROM "Códigos postales I" CPA, "Códigos postales I" CPB
    WHERE CPA.población = CPB.población
      AND CPA.provincia  <> CPB.provincia;
  excepcion_fd EXCEPTION;
BEGIN
  OPEN CPI;
  FETCH CPI INTO cp, pobl, prov;
  IF CPI%FOUND THEN
      RAISE excepcion_fd;
  END IF;
  CLOSE CPI;
EXCEPTION
WHEN excepcion_fd THEN DBMS_OUTPUT.PUT_LINE ('Dependencia funcional violada en la tupla: ' || cp || ', ' || pobl || ', ' || prov );
END;


--- Apartado 7 ----------------
CREATE OR REPLACE PROCEDURE ComprobarFK
AS
  nif "Domicilios I".DNI%TYPE;
  str "Domicilios I".calle%TYPE;
  cp "Domicilios I"."Código Postal"%TYPE;
  CURSOR DI
  IS
    SELECT DNI, calle, "Código Postal" 
    FROM "Domicilios I" D
    WHERE  NOT EXISTS
      (SELECT "Código postal" 
      FROM "Códigos postales I" 
      WHERE D."Código Postal" = "Código postal");
  excepcion_fk EXCEPTION;
BEGIN
 OPEN DI;
  FETCH DI INTO nif, str, cp;
  IF DI%FOUND THEN
      RAISE excepcion_fk;
  END IF;
  CLOSE DI;
EXCEPTION
WHEN excepcion_fk THEN DBMS_OUTPUT.PUT_LINE ('Integridad referencial violada en la tupla: ' || nif || ', ' || str || ', ' || cp );
END; 

EXECUTE ComprobarNulos();
EXECUTE ComprobarPK();
EXECUTE ComprobarFD();
EXECUTE ComprobarFK();

---------------------------
--Salida por consola
-------------------------
bloque anónimo terminado
Código postal nulo en la tupla: , Arganda , Sevilla  

bloque anónimo terminado
Código postal repetido en la tupla: 08050, Zaragoza , Zaragoza                                          

bloque anónimo terminado
Dependencia funcional violada en la tupla: 28040, Arganda , Madrid                                            

bloque anónimo terminado
Integridad referencial violada en la tupla: 12345678P, Carbón , 14901