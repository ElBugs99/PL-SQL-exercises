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
