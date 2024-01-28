CREATE OR REPLACE TRIGGER trg_calif_emp
AFTER INSERT ON detalle_haberes_mensual
FOR EACH ROW
DECLARE
v_total_haberes NUMBER(8);
v_calif VARCHAR2(80);
BEGIN
v_total_haberes:=:NEW.sueldo_base +
:NEW.asig_colacion +
:NEW.asig_movilizacion +
:NEW.asig_especial_ant +
:NEW.asig_escolaridad +
:NEW.comision_ventas;
IF v_total_haberes BETWEEN 400000 AND 700000 THEN
v_calif:='Total de Haberes: ' || v_total_haberes ||
'. Califica como Empleado con Salario Bajo el Promedio';
ELSIF v_total_haberes BETWEEN 700001 AND 900000 THEN
v_calif:='Total de Haberes: ' || v_total_haberes ||
'. Califica como Empleado con Salario Promedio';
ELSE v_calif:='Total de Haberes: ' || v_total_haberes ||
'. Califica como Empleado con Salario Sobre el Promedio';
END IF;
INSERT INTO calificacion_mensual_empleado
VALUES(:NEW.mes, :NEW.anno, :NEW.run_empleado,v_total_haberes,v_calif);
END;
/
CREATE OR REPLACE PACKAGE PKG_CALCULO_HABERES AS
v_monto_ventas NUMBER(8) := 0;
FUNCTION F_OBT_MONTO_VENTAS (p_run VARCHAR2, p_fec VARCHAR2) RETURN NUMBER;
PROCEDURE P_GRABAR_ERROR(p_rutina_error VARCHAR2, p_mensaje_error VARCHAR2);
END PKG_CALCULO_HABERES;
5
/
CREATE OR REPLACE PACKAGE BODY PKG_CALCULO_HABERES AS
v_monto_ventas NUMBER(8) := 0;
FUNCTION F_OBT_MONTO_VENTAS(p_run VARCHAR2, p_fec VARCHAR2) RETURN NUMBER
AS
v_monto_ventas NUMBER(8);
BEGIN
SELECT SUM(monto_total_boleta)
INTO v_monto_ventas
FROM boleta
WHERE to_char(fecha, 'mm/yyyy') = p_fec
AND run_empleado = p_run;
RETURN v_monto_ventas;
END F_OBT_MONTO_VENTAS;
PROCEDURE P_GRABAR_ERROR(p_rutina_error VARCHAR2, p_mensaje_error VARCHAR2) IS
BEGIN
INSERT INTO ERROR_CALC
VALUES(seq_error.NEXTVAL, p_rutina_error, p_mensaje_error);
END P_GRABAR_ERROR;
END PKG_CALCULO_HABERES;
/
CREATE OR REPLACE FUNCTION FN_OBT_PORC_ANTIGUEDAD(
p_anti NUMBER, p_ventas NUMBER) RETURN NUMBER AS
v_pct NUMBER(5,3);
v_msg VARCHAR2(300);
BEGIN
SELECT porc_antiguedad/100
INTO v_pct
FROM porcentaje_antiguedad
WHERE p_anti BETWEEN annos_antiguedad_inf AND annos_antiguedad_sup;
RETURN v_pct;
EXCEPTION
WHEN OTHERS THEN
v_msg := sqlerrm;
PKG_CALCULO_HABERES.P_GRABAR_ERROR('Error en la función FN_OBT_PORC_ANTIGUEDAD al obtener el
porcentaje asociado a '
|| p_anti || ' años de antiguedad ', v_msg);
RETURN 0;
END FN_OBT_PORC_ANTIGUEDAD;
/
CREATE OR REPLACE FUNCTION FN_OBT_PORC_ESCOLARIDAD(p_cod_esc NUMBER) RETURN NUMBER
AS
v_porc_asig_esc NUMBER(5,3);
v_msg VARCHAR2(300);
BEGIN
SELECT porc_escolaridad/100
INTO v_porc_asig_esc
FROM porcentaje_escolaridad
WHERE cod_escolaridad = p_cod_esc;
RETURN v_porc_asig_esc;
EXCEPTION
WHEN OTHERS THEN
v_msg := sqlerrm;
PKG_CALCULO_HABERES.P_GRABAR_ERROR('Error en la función FN_OBT_PORC_ESCOLARIDAD al obtener el
porcentaje asociado al código escolaridad '
|| p_cod_esc , v_msg);
RETURN 0;
6
END FN_OBT_PORC_ESCOLARIDAD;
/
CREATE OR REPLACE PROCEDURE SP_CALCULA_HABERES(
p_fec VARCHAR2, p_colacion NUMBER, p_mov NUMBER) AS
CURSOR cur_emp IS
SELECT e.run_empleado,
e.nombre || ' ' || e.paterno || ' ' || e.materno nombre_emp,
e.sueldo_base, e.cod_escolaridad,
ROUND(MONTHS_BETWEEN(p_fec,e.fecha_contrato)/12) annos_cont
FROM empleado e
ORDER BY paterno, materno, nombre;
-- variables escalares
v_mov NUMBER(8) := 0;
v_asiespecial number(8) := 0;
v_asig_esc number(8) := 0;
v_pctcomis number;
v_comisventas number(8) := 0;
BEGIN
EXECUTE IMMEDIATE 'TRUNCATE TABLE DETALLE_HABERES_MENSUAL';
EXECUTE IMMEDIATE 'TRUNCATE TABLE ERROR_CALC';
EXECUTE IMMEDIATE 'TRUNCATE TABLE CALIFICACION_MENSUAL_EMPLEADO';
EXECUTE IMMEDIATE 'ALTER SEQUENCE SEQ_ERROR RESTART START WITH 1';
FOR reg_emp in cur_emp LOOP
v_mov := p_mov;
-- Cálculo monto ventas que realizó el empleado en el mes y año que se está procesando
PKG_CALCULO_HABERES.v_monto_ventas:=PKG_CALCULO_HABERES.F_OBT_MONTO_VENTAS(reg_emp.run_empl
eado, SUBSTR(p_fec,4));
