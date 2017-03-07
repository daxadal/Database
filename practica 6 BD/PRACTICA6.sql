DROP TABLE pedidos;
DROP TABLE contiene;
DROP TABLE auditor�a;

--Creaci�n de tablas

CREATE TABLE pedidos
  (
    c�digo   CHAR(6) PRIMARY KEY,
    fecha    CHAR(10),
    importe  NUMBER(6,2),
    clientes CHAR(20),
    notas    CHAR(1024)
  );
  
CREATE TABLE contiene
  (
    pedido   CHAR(6),
    plato    CHAR(20),
    precio   NUMBER(6,2),
    unidades NUMBER(2,0),
    PRIMARY KEY (pedido, plato)
  );
  
CREATE TABLE auditor�a
  (
    operaci�n CHAR(6),
    tabla     CHAR(50),
    fecha     CHAR(10),
    hora      CHAR(8)
  );
  
  
--Creaci�n de triggers

CREATE OR REPLACE TRIGGER trigger_pedidos AFTER
  INSERT OR
  DELETE OR
  UPDATE ON pedidos 
BEGIN 
IF inserting THEN
  INSERT
  INTO auditor�a VALUES
    (
      'INSERT',
      'pedidos',
      TO_CHAR(sysdate, 'dd/mm/yyyy'),
      TO_CHAR(sysdate, 'hh:mi:ss')
    );
ELSIF deleting THEN
  INSERT
  INTO auditor�a VALUES
    (
      'DELETE',
      'pedidos',
      TO_CHAR(sysdate, 'dd/mm/yyyy'),
      TO_CHAR(sysdate, 'hh:mi:ss')
    );
ELSIF updating THEN
  INSERT
  INTO auditor�a VALUES
    (
      'UPDATE',
      'pedidos',
      TO_CHAR(sysdate, 'dd/mm/yyyy'),
      TO_CHAR(sysdate, 'hh:mi:ss')
    );
END IF;
END; 


CREATE OR REPLACE TRIGGER trigger_contiene AFTER
  INSERT OR
  DELETE OR
  UPDATE ON contiene 
  FOR EACH row 
BEGIN 
IF inserting OR updating THEN
  UPDATE pedidos
  SET importe  = importe + :NEW.precio * :NEW.unidades
  WHERE c�digo = :NEW.pedido;
END IF;
IF deleting OR updating THEN
  UPDATE pedidos
  SET importe  = importe - :OLD.precio * :OLD.unidades
  WHERE c�digo = :OLD.pedido;
END IF;
END;

--Inserci�n de datos

INSERT
INTO pedidos VALUES
  (
    1,
    '48/13/6035',
    0,
    'Lucius Malfoy',
    'Sin comentarios'
  );
    
INSERT
INTO pedidos VALUES
  (
    2,
    '01/12/1035',
    0,
    'Sir Lancelot',
    'Sin comentarios'
  );
  
INSERT
INTO pedidos VALUES
  (
    3,
    '16/05/3014',
    0,
    'Philip J. Fry',
    'Sin comentarios'
  );
  
INSERT INTO contiene VALUES
  (2, 'Magdalenas de Moyano', 0.15, 99);
  
INSERT INTO contiene VALUES
  (3, 'Pizza con anchoas', 17.50, 5); 
  
INSERT INTO contiene VALUES
  (1, 'Chili del infierno', 6.66, 66); 














