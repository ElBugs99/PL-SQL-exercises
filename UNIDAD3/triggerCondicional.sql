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