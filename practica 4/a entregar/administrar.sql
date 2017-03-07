CREATE TABLESPACE empresadg06 datafile 'D:\oracle\empresadg06' size 5M autoextend OFF;
CREATE USER dg06 IDENTIFIED BY dg06 DEFAULT TABLESPACE empresadg06 TEMPORARY TABLESPACE temp quota unlimited ON empresadg06;
  GRANT
CREATE session,
  CREATE TABLE,
  DELETE ANY TABLE,
  SELECT ANY dictionary, CREATE ANY sequence TO dg06;