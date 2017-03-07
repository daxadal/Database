LOAD DATA
INFILE 'Códigos postales I.txt'
APPEND
INTO TABLE "Códigos postales I"
FIELDS TERMINATED BY ';'
 ("Código postal",
    Población,
    Provincia) 