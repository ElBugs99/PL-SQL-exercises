--caso 1
DECLARE
CURSOR cur_pac_moroso IS
SELECT p.pac_run, p.dv_run,
       p.pnombre || ' ' || p.snombre || ' ' ||
       p.apaterno || ' ' || p.amaterno nombre_paciente,
       p.fecha_nacimiento,
       pa.ate_id, pa.fecha_venc_pago, pa.fecha_pago,
       pa.fecha_pago-pa.fecha_venc_pago dias_morosidad,
       e.nombre
FROM paciente p JOIN atencion a
  ON p.pac_run=a.pac_run
JOIN pago_atencion pa
  ON a.ate_id=pa.ate_id
JOIN especialidad e
ON a.esp_id=e.esp_id
WHERE EXTRACT(YEAR FROM pa.fecha_venc_pago) =
      EXTRACT(YEAR FROM SYSDATE)-1
  AND pa.fecha_pago-pa.fecha_venc_pago > 0
ORDER BY pa.fecha_venc_pago, p.apaterno;
-- DEFINICION VARRAY
TYPE tp_varray_multa IS VARRAY(7)
    OF NUMBER(5);
varray_multa tp_varray_multa;
v_valor_multa NUMBER(8);
v_annos NUMBER(2);
v_porc_descto NUMBER(3,2);
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE PAGO_MOROSO';
   varray_multa:=tp_varray_multa(1200,1300,1700,1900,1100,
                 2000,2300);
   FOR reg_pac_moroso IN cur_pac_moroso LOOP
       v_valor_multa:=0;
       v_annos:=ROUND(MONTHS_BETWEEN(SYSDATE,reg_pac_moroso.fecha_nacimiento)/12);
       -- CALCULO MULTA MOROSIDAD
       IF reg_pac_moroso.nombre IN('Cirug�a General','Dermatolog�a')  THEN
          v_valor_multa:=reg_pac_moroso.dias_morosidad*varray_multa(1);
       ELSIF reg_pac_moroso.nombre IN('Ortopedia','Traumatolog�a')  THEN
          v_valor_multa:=reg_pac_moroso.dias_morosidad*varray_multa(2);
       ELSIF reg_pac_moroso.nombre IN('Inmunolog�a','Otorrinolaringolog�a')  THEN
          v_valor_multa:=reg_pac_moroso.dias_morosidad*varray_multa(3);
       ELSIF reg_pac_moroso.nombre IN('Fisiatr�a','Medicina Interna')  THEN
          v_valor_multa:=reg_pac_moroso.dias_morosidad*varray_multa(4);    
       ELSIF reg_pac_moroso.nombre IN('Medicina General')  THEN
          v_valor_multa:=reg_pac_moroso.dias_morosidad*varray_multa(5);   
       ELSIF reg_pac_moroso.nombre IN('Psiquiatr�a Adultos')  THEN
          v_valor_multa:=reg_pac_moroso.dias_morosidad*varray_multa(6);  
       ELSIF reg_pac_moroso.nombre IN('Cirug�a Digestiva','Reumatolog�a')  THEN
          v_valor_multa:=reg_pac_moroso.dias_morosidad*varray_multa(7);  
       END IF;
       
       -- DESCUENTO MULTA PARA PACIENTES 3ERA EDAD
       IF v_annos >= 65 THEN
          SELECT porcentaje_descto/100
            INTO v_porc_descto
           FROM porc_descto_3ra_edad
           WHERE v_annos BETWEEN anno_ini AND anno_ter;
           v_valor_multa:=v_valor_multa - ROUND(v_valor_multa*v_porc_descto);
       END IF;

      INSERT INTO pago_moroso
      VALUES(reg_pac_moroso.pac_run, reg_pac_moroso.dv_run,
      reg_pac_moroso.nombre_paciente,reg_pac_moroso.ate_id,
      reg_pac_moroso.fecha_venc_pago,
      reg_pac_moroso.fecha_pago,
      reg_pac_moroso.dias_morosidad,
      reg_pac_moroso.nombre,
      v_valor_multa);
  END LOOP;
END;