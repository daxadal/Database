SET SERVEROUTPUT ON SIZE (1000000);

--- Apartado 4 ----------------
CREATE OR REPLACE PROCEDURE ComprobarNulos
AS
  cp "C�digos postales I"."C�digo postal"%TYPE;
  pobl "C�digos postales I".poblaci�n%TYPE;
  prov "C�digos postales I".provincia%TYPE;
  CURSOR CPI
  IS
    SELECT "C�digo postal", poblaci�n, provincia  
    FROM "C�digos postales I" 
    WHERE "C�digo postal" IS NULL;
  excepcion_nulo EXCEPTION;
BEGIN
  OPEN CPI;
  FETCH CPI INTO cp, pobl, prov;
  IF CPI%FOUND THEN
      RAISE excepcion_nulo;
  END IF;
  CLOSE CPI;
EXCEPTION
WHEN excepcion_nulo THEN DBMS_OUTPUT.PUT_LINE ('C�digo postal nulo en la tupla: ' || cp || ', ' || pobl || ', ' || prov );
END;


--- Apartado 5 ----------------
CREATE OR REPLACE PROCEDURE ComprobarPK
AS
  cp "C�digos postales I"."C�digo postal"%TYPE;
  pobl "C�digos postales I".poblaci�n%TYPE;
  prov "C�digos postales I".provincia%TYPE;
  CURSOR CPI
  IS
    SELECT CPA."C�digo postal", CPA.poblaci�n, CPA.provincia 
    FROM "C�digos postales I"  CPA, "C�digos postales I"  CPB
    WHERE CPA."C�digo postal" = CPB."C�digo postal"
      AND (CPA.poblaci�n <> CPB.poblaci�n OR CPA.provincia <> CPB.provincia);
      
  excepcion_pk EXCEPTION;
  
BEGIN
  OPEN CPI;
  FETCH CPI INTO cp, pobl, prov;
  IF CPI%FOUND THEN
      RAISE excepcion_pk;
  END IF;
  CLOSE CPI;
EXCEPTION
WHEN excepcion_pk  THEN DBMS_OUTPUT.PUT_LINE ('C�digo postal repetido en la tupla: ' || cp || ', ' || pobl || ', ' || prov );
END;


--- Apartado 6 ----------------
CREATE OR REPLACE PROCEDURE ComprobarFD
AS
  cp "C�digos postales I"."C�digo postal"%TYPE;
  pobl "C�digos postales I".poblaci�n%TYPE;
  prov "C�digos postales I".provincia%TYPE;
  CURSOR CPI
  IS
    SELECT CPA."C�digo postal", CPA.poblaci�n, CPA.provincia 
    FROM "C�digos postales I" CPA, "C�digos postales I" CPB
    WHERE CPA.poblaci�n = CPB.poblaci�n
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
  cp "Domicilios I"."C�digo Postal"%TYPE;
  CURSOR DI
  IS
    SELECT DNI, calle, "C�digo Postal" 
    FROM "Domicilios I" D
    WHERE  NOT EXISTS
      (SELECT "C�digo postal" 
      FROM "C�digos postales I" 
      WHERE D."C�digo Postal" = "C�digo postal");
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
bloque an�nimo terminado
C�digo postal nulo en la tupla: , Arganda , Sevilla  

bloque an�nimo terminado
C�digo postal repetido en la tupla: 08050, Zaragoza , Zaragoza                                          

bloque an�nimo terminado
Dependencia funcional violada en la tupla: 28040, Arganda , Madrid                                            

bloque an�nimo terminado
Integridad referencial violada en la tupla: 12345678P, Carb�n , 14901