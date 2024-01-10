-- EJERCICIO TIPO PRUEBA
VAR B_VAL_CARGA_FAMI NUMBER;
VAR B_MOV_ADICIONAL NUMBER;
VAR B_VAL_COLACION NUMBER;
VAR B_FECHA_PROCESO VARCHAR2;

EXEC :B_VAL_CARGA_FAMI:=4500;
EXEC :B_MOV_ADICIONAL:= 25000;
EXEC :B_VAL_COLACION:=40000;
EXEC :B_FECHA_PROCESO:='28/02/2023';

DECLARE
V_COD_EMP NUMBER;
V_NUMRUT_EMP NUMBER;
V_MES_PROCESO NUMBER;
V_ANNIO_PROCESO NUMBER;
V_VAL_SUELDO_BASE NUMBER;
V_ANNIOS_EMPLEADO NUMBER;
V_PORC_BONI_ANNIOS NUMBER;
V_ASIG_ANNOS NUMBER;
V_NUM_CARGAS_FAM NUMBER;
V_ASIG_CARGA_FAM NUMBER;
V_PORC_MOV NUMBER;
V_VAL_MOV NUMBER;
V_VALOR_COMISION_VENTA NUMBER;
V_PORC_ASIG_ESCOLARIDAD NUMBER;
V_VAL_ASIG_ESC NUMBER;
V_PORC_DESCTO_AFP NUMBER;
V_DESCUENTO_PREVISION_EMPLEADO NUMBER;
V_PORC_DESCTO_SALUD NUMBER;
V_VAL_SALUD NUMBER;
V_MIN NUMBER;
V_MAX NUMBER;

BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE HABER_CALC_MES';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DESCTO_CALC_MES';

    V_MES_PROCESO:= SUBSTR(:B_FECHA_PROCESO,-7,2);
    V_ANNIO_PROCESO:= SUBSTR(:B_FECHA_PROCESO,-4);
    
    SELECT
        MIN(COD_EMP),
        MAX(COD_EMP)
    INTO
        V_MIN,
        V_MAX
    FROM EMPLEADO;
        
    WHILE V_MIN <= V_MAX LOOP
    
        --INFO BASICA EMPLEADO
        SELECT
            COD_EMP,
            NUMRUT_EMP,
            SUELDO_BASE_EMP,
            TRUNC(MONTHS_BETWEEN(SYSDATE, FECING_EMP)/12), --ANNIOS
            NVL(PORC.PORC_BONIF,0),
            NVL(M.PORC_MOV,0)
        INTO
            V_COD_EMP,
            V_NUMRUT_EMP,
            V_VAL_SUELDO_BASE,
            V_ANNIOS_EMPLEADO,
            V_PORC_BONI_ANNIOS,
            V_PORC_MOV
        FROM
            EMPLEADO EMP
        LEFT JOIN
            PORC_BONIF_ANNOS_CONTRATO PORC
        ON 
            TRUNC(MONTHS_BETWEEN(SYSDATE, FECING_EMP)/12) 
            BETWEEN PORC.ANNOS_CONT_INF AND PORC.ANNOS_CONT_SUP
        LEFT JOIN
            PORC_MOVILIZACION M
        ON
            SUELDO_BASE_EMP BETWEEN SUELDO_BASE_INF AND SUELDO_BASE_SUP
        WHERE COD_EMP = V_MIN;--CONTADOR
        
        --VALOR ASIG_ANNOS
        V_ASIG_ANNOS:= ROUND(V_PORC_BONI_ANNIOS * V_VAL_SUELDO_BASE /100);
        
        --NUMERO ASIGNACION CARGA FAMILIAR
        SELECT
            COUNT(COD_EMP)
        INTO
            V_NUM_CARGAS_FAM
        FROM
            CARGA_FAMILIAR
        WHERE COD_EMP = V_MIN;--CONTADOR
        
        --VAL ASIGANCION CARGA FAMILIAR
        V_ASIG_CARGA_FAM:= V_NUM_CARGAS_FAM * :B_VAL_CARGA_FAMI;
        
        V_VAL_MOV := ROUND(V_PORC_MOV * V_VAL_SUELDO_BASE/100);
        
        --VALOR POR COMISION
        SELECT
            NVL(SUM(VALOR_COMISION), 0)
        INTO
            V_VALOR_COMISION_VENTA
        FROM
            BOLETA B 
        JOIN
            COMISION_VENTA C
        ON
            B.NRO_BOLETA = C.NRO_BOLETA
        WHERE 
            EXTRACT(YEAR FROM FECHA_BOLETA) = V_ANNIO_PROCESO
            AND EXTRACT(MONTH FROM FECHA_BOLETA) = V_MES_PROCESO
            AND B.COD_EMP = V_MIN; --CONTADOR  FECHA
            --OBTENCION DE PORCENTAJE DE ESCOLARIDAD
        SELECT
            PORC_ASIG_ESCOLARIDAD
        INTO
          v_PORC_ASIG_ESCOLARIDAD  
        FROM
            EMPLEADO EMP
        JOIN
            ASIG_ESCOLARIDAD A
        ON
            EMP.ID_ESCOLARIDAD = A.ID_ESCOLARIDAD
        WHERE COD_EMP = V_MIN;--CONTADOR
        
        --VALOR ASIGNACION ESCOLARIDAD
        V_VAL_ASIG_ESC:= round(v_PORC_ASIG_ESCOLARIDAD * V_VAL_SUELDO_BASE /100);
        
        --OBTENCION DE DESCUENTO PREVISION EMPLEADO
        SELECT
            PORC_DESCTO_AFP
        INTO
            V_PORC_DESCTO_AFP
        FROM
            EMPLEADO EMP
        JOIN
            AFP AFP
        ON
            EMP.COD_AFP = AFP.COD_AFP
        WHERE COD_EMP = V_MIN;--CONTADOR
        
        --DESCUENTO PREVISION EMPLEADO
        V_DESCUENTO_PREVISION_EMPLEADO := ROUND((V_VAL_SUELDO_BASE + V_VALOR_COMISION_VENTA 
        + V_ASIG_CARGA_FAM + V_VAL_ASIG_ESC) * V_PORC_DESCTO_AFP /100);
        
        --OBTENCION DE PORCENTAJE DE DESCUENTO SALUD
        SELECT
            PORC_DESCTO_SALUD
        INTO
            V_PORC_DESCTO_SALUD
        FROM
            EMPLEADO EMP
        JOIN
            SALUD S
        ON
            EMP.COD_SALUD = S.COD_SALUD
        WHERE COD_EMP = V_MIN;--CONTADOR
        
        V_VAL_SALUD:= ROUND(((V_VAL_SUELDO_BASE + V_ASIG_ANNOS + V_VAL_MOV) * V_PORC_DESCTO_SALUD)/100);
        --v_valor_salud := ROUND((v_sueldo_base_emp + v_valor_asig_annos + v_valor_mov) * v_por_descto_salud);
            