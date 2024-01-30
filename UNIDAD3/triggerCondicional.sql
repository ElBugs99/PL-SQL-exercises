-- 23/01/2024 --
-- TRABAJANDO EN HR --
/* ----------------------------- CREAR ANTES ESTAS TABLAS   --------------------------------- */
CREATE TABLE empleados
AS SELECT employee_id, last_name, first_name,
   salary, email, department_id
   FROM employees;
   
CREATE TABLE AUDIT_EMPLEADOS
(new_employee_id NUMBER(3),
 old_employee_id NUMBER(3),
 new_last_name VARCHAR2(30),
 old_last_name VARCHAR2(30),
 new_first_name VARCHAR2(30),
 old_first_name VARCHAR2(30),
 new_salary NUMBER(8),
 old_salary NUMBER(8),
 new_email VARCHAR2(30),
 old_email VARCHAR2(30),
 new_department_id NUMBER(3),
 old_department_id NUMBER(3),
 fecha_modificacion DATE);

 CREATE OR REPLACE TRIGGER TRG_AUDIT_EMPLEADOS
/* TIEMPO EN QUE SE VA A ACTIVAR EL TRIGGER Y SOBRE QUE SENTENCIAS
DML SE ACTIVARA EL TRIGGER */
AFTER INSERT OR UPDATE OR DELETE ON empleados
FOR EACH ROW
BEGIN
   INSERT INTO AUDIT_EMPLEADOS
   VALUES(:NEW.employee_id, :OLD.employee_id,:NEW.last_name,
          :OLD.last_name, :NEW.first_name, :OLD.first_name,
          :NEW.salary, :OLD.salary, :NEW.email, :OLD.email,
          :NEW.department_id, :OLD.department_id, SYSDATE);
END;


/* ----------------------------- AHORA CREAR ESTAS TABLAS   --------------------------------- */
DROP TABLE EMPLEADOS;
DROP TABLE PRESTAMO_SOCIAL;
DROP TABLE AUDIT_EMP;
DROP TABLE DETALLE_BOLETA;
DROP TABLE BOLETA;
DROP TABLE STOCK;
DROP TABLE PRODUCTO;
DROP TABLE TRAMO_PORC_COMISION;
DROP TABLE ERROR_PROCESO;
DROP SEQUENCE SEQ_PRESTAMO_SOCIAL;
DROP SEQUENCE SEQ_NRO_PRESTAMO_SOCIAL;
DROP SEQUENCE SEQ_ERROR_PROC;

CREATE SEQUENCE SEQ_PRESTAMO_SOCIAL INCREMENT BY 10;
CREATE SEQUENCE SEQ_NRO_PRESTAMO_SOCIAL;
CREATE SEQUENCE SEQ_ERROR_PROC;

CREATE TABLE EMPLEADOS
AS SELECT * FROM employees;

CREATE TABLE PRESTAMO_SOCIAL
(nro_prestamo NUMBER(8) NOT NULL CONSTRAINT PK_PRESTAMO_SOCIAL PRIMARY KEY,
 id_empleado NUMBER(3) NOT NULL,
 valor_prestamo NUMBER(10) NOT NULL,
 fecha_prestamo DATE NOT NULL,
 fecha_venc_prestamo DATE NOT NULL,
 fecha_pago DATE DEFAULT NULL,
 multa NUMBER(5) DEFAULT 0,
 estado_pago VARCHAR2(200) DEFAULT NULL);

 CREATE TABLE audit_emp
(user_name        VARCHAR2(30), 
 old_employee_id  NUMBER(5),
 new_employee_id  NUMBER(5),
 old_last_name    VARCHAR2(30), 
 new_last_name    VARCHAR2(30), 
 old_job_id       VARCHAR2(10), 
 new_job_id       VARCHAR2(10), 
 old_salary       NUMBER(8,2), 
 new_salary       NUMBER(8,2));

 CREATE TABLE PRODUCTO 
(cod_producto NUMBER (5) CONSTRAINT PK_PRODUCTO PRIMARY KEY, 
 desc_producto VARCHAR2 (30)  NOT NULL);

CREATE TABLE STOCK 
(cod_producto NUMBER (5)  CONSTRAINT PK_STOCK PRIMARY KEY, 
 stock_minimo NUMBER (5)  NOT NULL , 
 stock_actual NUMBER (5)  NOT NULL,
 CONSTRAINT FK_STOCK_PRODUCTO FOREIGN KEY(cod_producto) REFERENCES PRODUCTO (cod_producto));

CREATE TABLE BOLETA 
(nro_boleta NUMBER (10) CONSTRAINT PK_BOLETA PRIMARY KEY, 
 fecha_boleta DATE  NOT NULL , 
 monto_boleta NUMBER (10)  NOT NULL , 
 id_vendedor NUMBER (10)  NOT NULL);

 CREATE TABLE DETALLE_BOLETA 
(nro_boleta NUMBER (10)  NOT NULL , 
 cod_producto NUMBER (5)  NOT NULL , 
 cantidad NUMBER  NOT NULL , 
 valor_unitario NUMBER (5)  NOT NULL , 
 valor_total NUMBER (8)  NOT NULL,
 CONSTRAINT PK_DETALLE_BOLETA PRIMARY KEY ( cod_producto, nro_boleta ),
 CONSTRAINT FK_DETALLE_BOLETA_BOLETA FOREIGN KEY(nro_boleta) REFERENCES BOLETA (nro_boleta),
 CONSTRAINT FK_DETALLE_BOLETA_PRODUCTO FOREIGN KEY(cod_producto) REFERENCES PRODUCTO (cod_producto));

CREATE TABLE TRAMO_PORC_COMISION
(NRO_TRAMO_PC NUMBER(2) NOT NULL CONSTRAINT PK_TRAMO_PORC_COMISION PRIMARY KEY, 
 RANGO_INF_PC NUMBER(8) NOT NULL, 
 RANGO_SUP_PC NUMBER(8) NOT NULL, 
 PORC_COM NUMBER(4,3) NOT NULL);

CREATE TABLE ERROR_PROCESO
(sec_error NUMBER(3) NOT NULL,
 rutina_error VARCHAR2(100) NOT NULL,
 mensaje_error VARCHAR2(250) NOT NULL);