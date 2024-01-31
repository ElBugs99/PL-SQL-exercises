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

 INSERT INTO PRESTAMO_SOCIAL(nro_prestamo,id_empleado,valor_prestamo,fecha_prestamo,fecha_venc_prestamo)
SELECT SEQ_NRO_PRESTAMO_SOCIAL.NEXTVAL,employee_id, ROUND(salary*(SEQ_PRESTAMO_SOCIAL.NEXTVAL/100)) valor, SYSDATE, SYSDATE+60
    FROM employees
    WHERE department_id = 50;   
COMMIT; 

INSERT INTO PRODUCTO VALUES(1000, 'CAFE EN GRANO NESCAFÉ');
INSERT INTO PRODUCTO VALUES(2000, 'ACEITE DE MARAVILLA CHEF');
INSERT INTO PRODUCTO VALUES(2001, 'ACEITE VEGETAL MIRAFLORES');
INSERT INTO PRODUCTO VALUES(3000, 'ARROZ BANQUETE PREMIUM GRADO 1');

INSERT INTO STOCK VALUES(1000, 100, 200);
INSERT INTO STOCK VALUES(2000, 150, 300);
INSERT INTO STOCK VALUES(2001, 150, 150);
INSERT INTO STOCK VALUES(3000, 50, 20);

INSERT INTO BOLETA VALUES(97, '27/01/2018', 105000, 1111111);
INSERT INTO BOLETA VALUES(98, '28/01/2014', 134500, 3333333);
INSERT INTO BOLETA VALUES(99, '29/12/2017', 30000, 2222222);
INSERT INTO BOLETA VALUES(100, '01/02/2018', 89760, 1111111);
INSERT INTO BOLETA VALUES(101, '05/02/2018', 104000, 2222222);
INSERT INTO BOLETA VALUES(102, '05/02/2018', 80760, 2222222);
INSERT INTO BOLETA VALUES(103, '29/01/2018', 134500, 1111111);
INSERT INTO BOLETA VALUES(104, '29/12/2017', 65000, 2222222);

INSERT INTO DETALLE_BOLETA VALUES(97, 1000, 30, 3500, 105000);
INSERT INTO DETALLE_BOLETA VALUES(98, 1000, 12, 3500, 42000);
INSERT INTO DETALLE_BOLETA VALUES(98, 3000, 50, 1850, 92500);
INSERT INTO DETALLE_BOLETA VALUES(99, 2000, 20, 1500, 30000);
INSERT INTO DETALLE_BOLETA VALUES(100, 1000, 12, 1230, 14760);
INSERT INTO DETALLE_BOLETA VALUES(100, 2000, 20, 1500, 30000);
INSERT INTO DETALLE_BOLETA VALUES(100, 3000, 25, 1800, 45000);
INSERT INTO DETALLE_BOLETA VALUES(101, 2001, 80, 1300, 104000);
INSERT INTO DETALLE_BOLETA VALUES(102, 1000, 12, 1230, 14760);
INSERT INTO DETALLE_BOLETA VALUES(102, 2000, 20, 1500, 30000);
INSERT INTO DETALLE_BOLETA VALUES(102, 3000, 20, 1800, 36000);
INSERT INTO DETALLE_BOLETA VALUES(103, 1000, 12, 3500, 42000);
INSERT INTO DETALLE_BOLETA VALUES(103, 3000, 50, 1850, 92500);
INSERT INTO DETALLE_BOLETA VALUES(104, 2001, 50, 1300, 65000);

INSERT INTO TRAMO_PORC_COMISION VALUES(1,100,3000,0.015);
INSERT INTO TRAMO_PORC_COMISION VALUES(2,3001,6000,0.02);
INSERT INTO TRAMO_PORC_COMISION VALUES(3,6001,10000,0.025);
INSERT INTO TRAMO_PORC_COMISION VALUES(4,10001,30000,0.030);
COMMIT;

-- EJERCICIOS DESPUÉS DE LA CREACIÓN DE TODO LO ANTERIOR --

-- PRUEBAS DE TRIGGER --
1.- SE INGRESA UNA NUEVA COMPRA.
2.- PARA LA BOLETA 105 SE COMPRA 150 UNIDADES DEL PRODUCTO 2000.
    PARA LA FECHA DE BOLETA ASIGNAR LA FECHA DE LA BD.
    EL ID DEL VENDEDOR = 1111111
2.- SE ELIMINA LA BOLETA 101

3.- PARA LA BOLETA 100 SE ACTUALIZA LA CANTIDAD COMPRADA DEL PRODUCTO 3000.
    LA CANTIDAD SERÁ 10 (ANTES SE COMPRARON 25)

/*TRIGGER*/
CREATE OR REPLACE TRIGGER TRG_ACTUALIZA_STOCK
AFTER INSERT OR UPDATE OR DELETE ON DETALLE_BOLETA
FOR EACH ROW
BEGIN
    /**/
    IF INSERTING THEN
        UPDATE STOCK
        SET STOCK_ACTUAL = STOCK_ACTUAL - :NEW.CANTIDAD
        WHERE COD_PRODUCTO=:NEW.COD_PRODUCTO;
    /**/
    ELSIF DELETING THEN
        UPDATE STOCK
        SET STOCK_ACTUAL = STOCK_ACTUAL + :OLD.CANTIDAD
        WHERE COD_PRODUCTO=:OLD.COD_PRODUCTO;
        
    /*ACTUALIZAR STOCK*/
    ELSE
        UPDATE STOCK
        SET STOCK_ACTUAL = (STOCK_ACTUAL + :OLD.CANTIDAD) - :NEW.CANTIDAD
        WHERE COD_PRODUCTO=:NEW.COD_PRODUCTO;
    END IF;
END;
/*FIN TRIGGER*/
-- INSERSION EN LAS TABLAS --

INSERT INTO BOLETA
VALUES(
105,
SYSDATE,
225000,
1111111
);

    INSERT INTO DETALLE_BOLETA
    VALUES(  
    105,
    2000,
    150,
    1500,
    225000
    );
    COMMIT;

/* 2.- SE ELIMINA LA BOLETA 101 */
-- DELETE --
DELETE FROM DETALLE_BOLETA
WHERE NRO_BOLETA=101;
DELETE FROM BOLETA
WHERE NRO_BOLETA=101;
COMMIT;

UPDATE DETALLE_BOLETA