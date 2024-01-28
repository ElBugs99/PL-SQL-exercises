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
