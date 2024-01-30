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