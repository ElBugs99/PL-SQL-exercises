CREATE OR REPLACE TRIGGER trg_calif_emp
AFTER INSERT ON detalle_haberes_mensual
FOR EACH ROW
DECLARE
v_total_haberes NUMBER(8);
v_calif VARCHAR2(80);
BEGIN
