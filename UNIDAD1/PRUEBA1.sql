VAR B_VAL_CARGA_FAMILIAR NUMBER;
VAR B_MONTO_MOVI NUMBER;
VAR B_FECHA_PROCESO VARCHAR2;
VAR B_VAL_TOPE_HABERES_ASIG_FAMILIAR NUMBER;
VAR B_PORC_COMISION_VENTAS NUMBER;
--
VAR B_VAL_TOPE_HABERES_ASIG_MOVI NUMBER;
EXEC :B_VAL_CARGA_FAMILIAR:= 6300;
EXEC :B_FECHA_PROCESO:= '12/2023';
EXEC :B_VAL_TOPE_HABERES_ASIG_FAMILIAR:= 405000;
EXEC :B_PORC_COMISION_VENTAS:= 40;
DECLARE
V_ID_VENDEDOR NUMBER(5);
V_RUT_VENDEDOR NUMBER(30);
V_SUELDO_BASE_VENDEDOR NUMBER;
V_ANNIOS_CONTRATADO NUMBER(9);
V_PORC_ANTIGUEDAD NUMBER(3);
V_BONIFICACION_ANTIGUEDAD NUMBER;
V_NUM_CARGAS_FAM NUMBER(3);
V_ASIG_CARGA_FAM NUMBER;
V_ANNIO_PROCESO NUMBER(4);
V_MES_PROCESO NUMBER;
V_MONTO_TOTAL_VENTAS NUMBER;
V_COMISION_VENTAS NUMBER;
V_CATEGORIA_VENDEDOR CHAR(1);
V_PORCENTAJE_CATEGORIA NUMBER(3);
V_BONO_CATEGORIA NUMBER;
V_ID_AFP NUMBER(3);
V_ID_SALUD NUMBER(3);
V_TOTAL_HABERES_FINAL NUMBER;
V_VENTAS_ANUALES NUMBER:= 0;
V_NUEVA_CATEGORIA CHAR(1);
V_MIN NUMBER;
V_MAX NUMBER;
V_OBSERVACION VARCHAR2(30);BEGIN
 EXECUTE IMMEDIATE('TRUNCATE TABLE HABER_MES_VENDEDOR');
 EXECUTE IMMEDIATE('TRUNCATE TABLE DETALLE_MODIF_CATEG_VENDEDOR');
 --MES Y ANNIO PROCESO
 V_ANNIO_PROCESO := SUBSTR(:B_FECHA_PROCESO, -4);
 V_MES_PROCESO := SUBSTR(:B_FECHA_PROCESO, 1, 2);
 
 
 --VALORES PARA BUCLE
 SELECT 
 MIN(ID_VENDEDOR),
 MAX(ID_VENDEDOR)
 INTO
 V_MIN,
 V_MAX
 FROM
 VENDEDOR;
 
 
 WHILE V_MIN <= V_MAX LOOP
 
 
 --OBTENCION DE DATOS BASICOS VENDEDOR
 SELECT
 ID_VENDEDOR,
 RUT_VENDEDOR,
 SUELDO_BASE,
 TRUNC(MONTHS_BETWEEN(SYSDATE,FEC_CONTRATO)/12),
 ID_AFP,
 ID_SALUD
 INTO
 V_ID_VENDEDOR,
 V_RUT_VENDEDOR,
 V_SUELDO_BASE_VENDEDOR,
 V_ANNIOS_CONTRATADO,
 V_ID_AFP,
 V_ID_SALUD
 FROM
 VENDEDOR
 WHERE
 ID_VENDEDOR = V_MIN; --CONTADOR
 
 --PORCENTAJE ASIG ANTIGUEDAD
 SELECT
 NVL(PORC_BONIF, 0)
 INTO
 V_PORC_ANTIGUEDAD
 FROM
 VENDEDOR V
 LEFT JOIN
 BONIFICACION_ANTIG B
 ON
 V_ANNIOS_CONTRATADO
 BETWEEN B.ANNO_TRAMO_INF AND B.ANNO_TRAMO_SUP
 
 WHERE
 ID_VENDEDOR = V_MIN; --CONTADOR
 
 --CALCULO PAGO POR CONCEPTO DE ANTIGUEDAD
 V_BONIFICACION_ANTIGUEDAD:= V_SUELDO_BASE_VENDEDOR * V_PORC_ANTIGUEDAD/100;
 --NUMERO DE CARGAS FAMILIARES
 SELECT
 NVL(COUNT(C.ID_VENDEDOR), 0)
 INTO
 V_NUM_CARGAS_FAM
 FROM
 VENDEDOR V
 LEFT JOIN
 CARGA_FAMILIAR C
 ON
 V.ID_VENDEDOR = C.ID_VENDEDOR
 
 WHERE
 C.ID_VENDEDOR = V_MIN; --CONTADOR
 
 --CALCULO ASIGNACION CARGA FAMILIAR
 V_ASIG_CARGA_FAM:= V_NUM_CARGAS_FAM * :B_VAL_CARGA_FAMILIAR;
 
 --OBTENCION DE MONTO TOTAL EN VENTAS PARA VENDEDOR EN FECHA PROCESO
 SELECT
 NVL(SUM(B.MONTO_VENTA), 0)
 INTO
 V_MONTO_TOTAL_VENTAS
 FROM
 VENDEDOR V
 LEFT JOIN
 BOLETA B
 ON
 V.ID_VENDEDOR = B.ID_VENDEDOR
 
 WHERE
 B.ID_VENDEDOR = V_MIN
 AND EXTRACT(YEAR FROM FECHA_VENTA) = V_ANNIO_PROCESO
 AND EXTRACT(MONTH FROM FECHA_VENTA) = V_MES_PROCESO; --CONTADOR
 
 --CALCULO DE COMISION PARA VENDEDOR
 V_COMISION_VENTAS:= V_MONTO_TOTAL_VENTAS * :B_PORC_COMISION_VENTAS /100;
 
 --OBTENCION DE CATEGORIA VENDEDOR
 SELECT
 NVL(C.ID_CATEGORIA,'D'),
 PORCENTAJE
 INTO
 V_CATEGORIA_VENDEDOR,
 V_PORCENTAJE_CATEGORIA
 FROM
 VENDEDOR V
 LEFT JOIN
 CATEGORIA C
 ON
 V.ID_CATEGORIA = C.ID_CATEGORIA
 WHERE
 V.ID_VENDEDOR = V_MIN
 ; --CONTADOR
  
 --PORCENTAJE BONO CATEGORIA
 IF V_CATEGORIA_VENDEDOR IN( 'A' , 'B' ) THEN
 V_BONO_CATEGORIA:= ROUND(V_COMISION_VENTAS * V_PORCENTAJE_CATEGORIA /100);
 ELSE
 V_BONO_CATEGORIA:=0;
 END IF;
 
 --TOTAL HABERES
 V_TOTAL_HABERES_FINAL:= V_SUELDO_BASE_VENDEDOR + V_BONIFICACION_ANTIGUEDAD + V_BONO_CATEGORIA
 + V_ASIG_CARGA_FAM + V_COMISION_VENTAS + V_BONO_CATEGORIA;
 
 
 --ACTUALIZAR CATEGORIA VENDEDOR
 --VENTAS EN AÑO PROCESO
 IF V_MES_PROCESO = 12 THEN
 
 SELECT
 SUM(MONTO_VENTA)
 INTO 
 V_VENTAS_ANUALES
 FROM
 BOLETA
 WHERE
 EXTRACT(YEAR FROM FECHA_VENTA) = V_ANNIO_PROCESO
 AND ID_VENDEDOR = V_MIN;
 
 --CATEGORIA EN BASE A TABLA CATEGORIA
 SELECT
 NVL( C.ID_CATEGORIA, 'D')
 INTO
 V_NUEVA_CATEGORIA
 FROM
 VENDEDOR V
 LEFT JOIN
 CATEGORIA C
 ON
 V_VENTAS_ANUALES BETWEEN MONTO_ANUAL_VENT_INF AND MONTO_ANUAL_VENTA_SUP
 WHERE
 ID_VENDEDOR = V_MIN;
 
 IF V_NUEVA_CATEGORIA != V_CATEGORIA_VENDEDOR THEN
 V_OBSERVACION:= ' CAMBIA DE CATEGORIA';
 
 UPDATE VENDEDOR
 SET
 ID_CATEGORIA = V_NUEVA_CATEGORIA
 WHERE
 ID_VENDEDOR = V_MIN;
  ELSE
 V_OBSERVACION:= ' MANTIENE CATEGORIA';
 END IF;
 
 
 INSERT INTO DETALLE_MODIF_CATEG_VENDEDOR
 (ID_VENDEDOR, NUMRUT_VENDEDOR, MES_PROCESO
 , ANNO_PROCESO, CATEGORIA_ANTERIOR, CATEGORIA_NUEVA,
 OBSERVACION)
 VALUES
 (V_ID_VENDEDOR, V_RUT_VENDEDOR, V_MES_PROCESO,
 V_ANNIO_PROCESO, V_CATEGORIA_VENDEDOR, V_NUEVA_CATEGORIA,
 V_OBSERVACION);
 
 END IF;
 