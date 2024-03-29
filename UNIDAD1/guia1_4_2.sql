--CASO 1 CON WHILE LOOP
VAR b_annio_proceso number;
VAR b_run_emp number;
--comunas 117 118 119 120 121
--maría pinto, curacavi, talagante, el monte, buin
VAR B_COMUNA1 NUMBER;
VAR B_COMUNA2 NUMBER;
VAR B_COMUNA3 NUMBER;
VAR B_COMUNA4 NUMBER;
VAR B_COMUNA5 NUMBER;
VAR B_VALOR_COMUNA1 NUMBER;
VAR B_VALOR_COMUNA2 NUMBER;
VAR B_VALOR_COMUNA3 NUMBER;
VAR B_VALOR_COMUNA4 NUMBER;
VAR B_VALOR_COMUNA5 NUMBER;
--valores movilizacion adicional comunas
--run del empleado a procesar
EXEC :b_run_emp := 11846972; 
EXEC :b_COMUNA1 := 117;
EXEC :b_COMUNA2 := 118;
EXEC :b_COMUNA3 := 119;
EXEC :b_COMUNA4 := 120;
EXEC :b_COMUNA5 := 121;
EXEC :B_VALOR_COMUNA1:=20000;
EXEC :B_VALOR_COMUNA2:=25000;
EXEC :B_VALOR_COMUNA3:=30000;
EXEC :B_VALOR_COMUNA4:=35000;
EXEC :B_VALOR_COMUNA5:=40000;
EXEC :B_ANNIO_PROCESO:=EXTRACT(YEAR FROM SYSDATE);
DECLARE

    V_RUN NUMBER(15);
    V_DV_RUN VARCHAR2(50);
    V_NOMBRE VARCHAR(50);
    V_SUELDO_BASE NUMBER(15);
    V_PORC_MOVIL NUMBER(15);
    V_VALOR_MOVIL NUMBER(15);
    V_VALOR_MOVIL_ADICIONAL NUMBER(15);
    V_VALOR_TOTAL_MOVIL NUMBER(15);
    V_ANNIO_PROCESO NUMBER(15);
    V_TEST NUMBER(15);
    V_ID_COMUNA NUMBER(10);
    V_ID_EMP NUMBER;
    V_NOMBRE_COMUNA VARCHAR2(50);
    V_CONTADOR NUMBER:= 100;
BEGIN

    
    WHILE V_CONTADOR <= 320 LOOP
        SELECT
            NUMRUN_EMP,
            DVRUN_EMP,
            PNOMBRE_EMP||' '||SNOMBRE_EMP||' '||APPATERNO_EMP||' '||APMATERNO_EMP,
            SUELDO_BASE,
            EMP.ID_COMUNA,
            ID_EMP,
            NOMBRE_COMUNA
        INTO
            V_RUN,
            V_DV_RUN,
            V_NOMBRE,
            V_SUELDO_BASE,
            V_ID_COMUNA,
            V_ID_EMP,
            V_NOMBRE_COMUNA
        FROM 
            EMPLEADO EMP
        JOIN 
            COMUNA CO
        ON
            CO.ID_COMUNA = EMP.ID_COMUNA
        WHERE 
            ID_EMP = V_CONTADOR; --BIND
        --PORCENTAJE
        V_PORC_MOVIL:= TRUNC(V_SUELDO_BASE /100000);
        --VALOR MOVILIZACION NORMAL
        V_VALOR_MOVIL:= V_SUELDO_BASE * V_PORC_MOVIL/100;
        
        --CALCULO DE MOVILIZACION EXTRA
        
        CASE
            WHEN V_ID_COMUNA = :b_COMUNA1 THEN V_VALOR_MOVIL_ADICIONAL:=:B_VALOR_COMUNA1;
            WHEN V_ID_COMUNA = :b_COMUNA2 THEN V_VALOR_MOVIL_ADICIONAL:=:B_VALOR_COMUNA2;
            WHEN V_ID_COMUNA = :b_COMUNA3 THEN V_VALOR_MOVIL_ADICIONAL:=:B_VALOR_COMUNA3;
            WHEN V_ID_COMUNA = :b_COMUNA4 THEN V_VALOR_MOVIL_ADICIONAL:=:B_VALOR_COMUNA4;
            WHEN V_ID_COMUNA = :b_COMUNA5 THEN V_VALOR_MOVIL_ADICIONAL:=:B_VALOR_COMUNA5;
        ELSE
            V_VALOR_MOVIL_ADICIONAL:=0;
        END CASE;
        
        V_VALOR_TOTAL_MOVIL := V_VALOR_MOVIL_ADICIONAL + V_VALOR_MOVIL;
        DBMS_OUTPUT.PUT_LINE('V_ANNIO_PROCESO: '||V_ANNIO_PROCESO);
        DBMS_OUTPUT.PUT_LINE('V_ID_EMP: '||V_ID_EMP);
        DBMS_OUTPUT.PUT_LINE('V_RUN: '||V_RUN);
        DBMS_OUTPUT.PUT_LINE('V_DV_RUN: '||V_DV_RUN);
        DBMS_OUTPUT.PUT_LINE('V_NOMBRE: '||V_NOMBRE);
        DBMS_OUTPUT.PUT_LINE('V_NOMBRE_COMUNA: '||V_NOMBRE_COMUNA);
        DBMS_OUTPUT.PUT_LINE('V_SUELDO_BASE: '||V_SUELDO_BASE);
        DBMS_OUTPUT.PUT_LINE('V_PORC_MOVIL: '||V_PORC_MOVIL);
        DBMS_OUTPUT.PUT_LINE('V_VALOR_MOVIL: '||V_VALOR_MOVIL);
        DBMS_OUTPUT.PUT_LINE('V_VALOR_MOVIL_ADICIONAL: '||V_VALOR_MOVIL_ADICIONAL);
        DBMS_OUTPUT.PUT_LINE('V_VALOR_TOTAL_MOVIL: '||V_VALOR_TOTAL_MOVIL);
        
    
        INSERT INTO PROY_MOVILIZACION
        
        (ANNO_PROCESO, ID_EMP, NUMRUN_EMP, DVRUN_EMP, 
        NOMBRE_EMPLEADO, NOMBRE_COMUNA, SUELDO_BASE, PORC_MOVIL_NORMAL,
        VALOR_MOVIL_NORMAL, VALOR_MOVIL_EXTRA, VALOR_TOTAL_MOVIL)
        
        VALUES(:B_ANNIO_PROCESO, V_ID_EMP, V_RUN, V_DV_RUN, V_NOMBRE, V_NOMBRE_COMUNA,
        V_SUELDO_BASE, V_PORC_MOVIL, V_VALOR_MOVIL, V_VALOR_MOVIL_ADICIONAL, V_VALOR_TOTAL_MOVIL);
       
       V_CONTADOR:= V_CONTADOR + 10;
    
    END LOOP;

END;






--CASO 1 CON LOOP SIMPLE

VAR b_annio_proceso number;
VAR b_run_emp number;
--comunas 117 118 119 120 121
--maría pinto, curacavi, talagante, el monte, buin
VAR B_COMUNA1 NUMBER;
VAR B_COMUNA2 NUMBER;
VAR B_COMUNA3 NUMBER;
VAR B_COMUNA4 NUMBER;
VAR B_COMUNA5 NUMBER;
VAR B_VALOR_COMUNA1 NUMBER;
VAR B_VALOR_COMUNA2 NUMBER;
VAR B_VALOR_COMUNA3 NUMBER;
VAR B_VALOR_COMUNA4 NUMBER;
VAR B_VALOR_COMUNA5 NUMBER;
--valores movilizacion adicional comunas
--run del empleado a procesar
EXEC :b_run_emp := 11846972; 
EXEC :b_COMUNA1 := 117;
EXEC :b_COMUNA2 := 118;
EXEC :b_COMUNA3 := 119;
EXEC :b_COMUNA4 := 120;
EXEC :b_COMUNA5 := 121;
EXEC :B_VALOR_COMUNA1:=20000;
EXEC :B_VALOR_COMUNA2:=25000;
EXEC :B_VALOR_COMUNA3:=30000;
EXEC :B_VALOR_COMUNA4:=35000;
EXEC :B_VALOR_COMUNA5:=40000;
EXEC :B_ANNIO_PROCESO:=EXTRACT(YEAR FROM SYSDATE);
DECLARE

    V_RUN NUMBER(15);
    V_DV_RUN VARCHAR2(50);
    V_NOMBRE VARCHAR(50);
    V_SUELDO_BASE NUMBER(15);
    V_PORC_MOVIL NUMBER(15);
    V_VALOR_MOVIL NUMBER(15);
    V_VALOR_MOVIL_ADICIONAL NUMBER(15);
    V_VALOR_TOTAL_MOVIL NUMBER(15);
    V_ANNIO_PROCESO NUMBER(15);
    V_TEST NUMBER(15);
    V_ID_COMUNA NUMBER(10);
    V_ID_EMP NUMBER;
    V_NOMBRE_COMUNA VARCHAR2(50);
    V_CONTADOR NUMBER:= 100;
    V_MAXIMO_EMPLEADOS NUMBER;

BEGIN

    SELECT MAX(ID_EMP) INTO V_MAXIMO_EMPLEADOS FROM EMPLEADO ;
    
    LOOP
        SELECT
            NUMRUN_EMP,
            DVRUN_EMP,
            PNOMBRE_EMP||' '||SNOMBRE_EMP||' '||APPATERNO_EMP||' '||APMATERNO_EMP,
            SUELDO_BASE,
            EMP.ID_COMUNA,
            ID_EMP,
            NOMBRE_COMUNA
        INTO
            V_RUN,
            V_DV_RUN,
            V_NOMBRE,
            V_SUELDO_BASE,
            V_ID_COMUNA,
            V_ID_EMP,
            V_NOMBRE_COMUNA
        FROM 
            EMPLEADO EMP
        JOIN 
            COMUNA CO
        ON
            CO.ID_COMUNA = EMP.ID_COMUNA
        WHERE 
            ID_EMP = V_CONTADOR; --BIND
        --PORCENTAJE
        V_PORC_MOVIL:= TRUNC(V_SUELDO_BASE /100000);
        --VALOR MOVILIZACION NORMAL
        V_VALOR_MOVIL:= V_SUELDO_BASE * V_PORC_MOVIL/100;
        
        --CALCULO DE MOVILIZACION EXTRA
        
        CASE
            WHEN V_ID_COMUNA = :b_COMUNA1 THEN V_VALOR_MOVIL_ADICIONAL:=:B_VALOR_COMUNA1;
            WHEN V_ID_COMUNA = :b_COMUNA2 THEN V_VALOR_MOVIL_ADICIONAL:=:B_VALOR_COMUNA2;
            WHEN V_ID_COMUNA = :b_COMUNA3 THEN V_VALOR_MOVIL_ADICIONAL:=:B_VALOR_COMUNA3;
            WHEN V_ID_COMUNA = :b_COMUNA4 THEN V_VALOR_MOVIL_ADICIONAL:=:B_VALOR_COMUNA4;
            WHEN V_ID_COMUNA = :b_COMUNA5 THEN V_VALOR_MOVIL_ADICIONAL:=:B_VALOR_COMUNA5;
        ELSE
            V_VALOR_MOVIL_ADICIONAL:=0;
        END CASE;
        
        V_VALOR_TOTAL_MOVIL := V_VALOR_MOVIL_ADICIONAL + V_VALOR_MOVIL;
       /* 
        DBMS_OUTPUT.PUT_LINE('V_ANNIO_PROCESO: '||V_ANNIO_PROCESO);
        DBMS_OUTPUT.PUT_LINE('V_ID_EMP: '||V_ID_EMP);
        DBMS_OUTPUT.PUT_LINE('V_RUN: '||V_RUN);
        DBMS_OUTPUT.PUT_LINE('V_DV_RUN: '||V_DV_RUN);
        DBMS_OUTPUT.PUT_LINE('V_NOMBRE: '||V_NOMBRE);
        DBMS_OUTPUT.PUT_LINE('V_NOMBRE_COMUNA: '||V_NOMBRE_COMUNA);
        DBMS_OUTPUT.PUT_LINE('V_SUELDO_BASE: '||V_SUELDO_BASE);
        DBMS_OUTPUT.PUT_LINE('V_PORC_MOVIL: '||V_PORC_MOVIL);
        DBMS_OUTPUT.PUT_LINE('V_VALOR_MOVIL: '||V_VALOR_MOVIL);
        DBMS_OUTPUT.PUT_LINE('V_VALOR_MOVIL_ADICIONAL: '||V_VALOR_MOVIL_ADICIONAL);
        DBMS_OUTPUT.PUT_LINE('V_VALOR_TOTAL_MOVIL: '||V_VALOR_TOTAL_MOVIL);
        */
    
        INSERT INTO PROY_MOVILIZACION
        
        (ANNO_PROCESO, ID_EMP, NUMRUN_EMP, DVRUN_EMP, 
        NOMBRE_EMPLEADO, NOMBRE_COMUNA, SUELDO_BASE, PORC_MOVIL_NORMAL,
        VALOR_MOVIL_NORMAL, VALOR_MOVIL_EXTRA, VALOR_TOTAL_MOVIL)
        
        VALUES(:B_ANNIO_PROCESO, V_ID_EMP, V_RUN, V_DV_RUN, V_NOMBRE, V_NOMBRE_COMUNA,
        V_SUELDO_BASE, V_PORC_MOVIL, V_VALOR_MOVIL, V_VALOR_MOVIL_ADICIONAL, V_VALOR_TOTAL_MOVIL);
       
       V_CONTADOR:= V_CONTADOR + 10;
       DBMS_OUTPUT.PUT_LINE('V_CONTADOR: '||V_CONTADOR);

    
    EXIT WHEN V_CONTADOR > V_MAXIMO_EMPLEADOS;
    END LOOP;

END;




--CASO 5
--PORCENTAJES DE COLACION
VAR B_PORC_COLACION NUMBER;

--COMUNAS QUE NECESITAN MONTO ADICIONAL
--DE MOVILIZACION
VAR B_MARIA_PINTO NUMBER;
VAR B_CURACAVI NUMBER;
VAR B_TALAGANTE NUMBER;
VAR B_EL_MONTE NUMBER;
VAR B_BUIN NUMBER;

--PORC MOVILIZACION NORMAL Y ADICIONAL
VAR B_PORC_MOV_NORMAL NUMBER;
VAR B_PORC_MARIA_PINTO NUMBER;
VAR B_PORC_CURACAVI NUMBER;
VAR B_PORC_TALAGANTE NUMBER;
VAR B_PORC_EL_MONTE NUMBER;
VAR B_PORC_BUIN NUMBER;
--PORCENTAJE BONOS
VAR B_PORC_BONO_ARRIENDO NUMBER;
VAR B_PORC_BONO_BIENESTAR NUMBER

--VALORES VARIABLES BIND
EXEC :B_PORC_COLACION := 20;
EXEC :B_MARIA_PINTO := 117;
EXEC :B_CURACAVI := 118;
EXEC :B_TALAGANTE := 119;
EXEC :B_EL_MONTE := 120;
EXEC :B_BUIN := 121;
EXEC :B_PORC_MOV_NORMAL := 20;
EXEC :B_PORC_MARIA_PINTO := 20;
EXEC :B_PORC_CURACAVI := 25;
EXEC :B_PORC_TALAGANTE :=30;
EXEC :B_PORC_EL_MONTE := 35;
EXEC :B_PORC_BUIN := 40;
EXEC :B_PORC_BONO_ARRIENDO := 5;
EXEC :B_PORC_BONO_BIENESTAR := 12;

DECLARE
V_ANNIO_TRIBUTARIO NUMBER;
V_ID_EMP NUMBER;
V_RUT_EMP VARCHAR2(20);
V_NOMBRE_EMP VARCHAR2(150);
V_ARRIENDOS_EMP NUMBER(9);
V_CARGO_EMP VARCHAR2(100);
V_MESES_TRABAJADOS NUMBER;
V_ANNIOS_TRABAJADOS NUMBER;
V_SUELDO_BASE_MENSUAL NUMBER;
V_SUELDO_BASE_ANUAL NUMBER;
V_PORC_ANNIOS_ANTIGUEDAD NUMBER;
V_BONO_ANNIOS_ANTIGUEDAD NUMBER;
V_BONO_ESPECIAL_ANUAL NUMBER;
V_ID_COMUNA NUMBER;
V_MOV_ANUAL NUMBER;
V_COLACION_ANUAL NUMBER;
V_PORC_DESC_AFP NUMBER;
V_DESCUENTO_AFP NUMBER;
V_PORC_DESC_SALUD NUMBER;
V_DESCUENTO_SALUD NUMBER;
V_DESCUENTOS_LEGALES NUMBER;
V_SUELDO_BRUTO NUMBER;
v_RENTA_IMPONIBLE NUMBER;
V_CONTADOR NUMBER := 100;
BEGIN
    
    WHILE V_CONTADOR <= 320 LOOP
    
        --CALCULO ANNIO TRIBUTARIO
        V_ANNIO_TRIBUTARIO := EXTRACT(YEAR FROM SYSDATE);
        
        --INFORMACION BASICA EMPLEADO
        SELECT 
            ID_EMP,
            TO_CHAR(NUMRUN_EMP, '99G999G999')||'-'||DVRUN_EMP,
            PNOMBRE_EMP||' '||SNOMBRE_EMP||' '||APPATERNO_EMP||' '||APMATERNO_EMP,
            SUELDO_BASE,
            ID_COMUNA
        INTO
            V_ID_EMP,
            V_RUT_EMP,
            V_NOMBRE_EMP,
            V_SUELDO_BASE_MENSUAL,
            V_ID_COMUNA
        FROM
            EMPLEADO
        WHERE
            ID_EMP = V_CONTADOR;--CONTADOR
    
    
        --VERIFICAR CARGO DE EMPLEADO CON TABLA DE CAMION
        SELECT COUNT(ID_EMP) INTO V_ARRIENDOS_EMP FROM CAMION WHERE ID_EMP = 120;--CONTADOR
        
        IF V_ARRIENDOS_EMP > 0 THEN 
            V_CARGO_EMP := 'Encargado de Arriendos';
        ELSE
            V_CARGO_EMP := 'Labores Administrativas';
        END IF;
            
        --CANTIDAD DE MESES QUE EMP TRABAJO EN EL ANNIO
        SELECT 
            trunc(MONTHS_BETWEEN(sysdate, FECHA_CONTRATO)),
            trunc(MONTHS_BETWEEN(sysdate, FECHA_CONTRATO) /12)
        INTO
            V_MESES_TRABAJADOS,
            V_ANNIOS_TRABAJADOS
        FROM 
            EMPLEADO
        WHERE ID_EMP = V_CONTADOR; --CONTADOR
            
        IF V_MESES_TRABAJADOS >= 12 THEN
            V_MESES_TRABAJADOS:= 12;
        END IF;
        
        --CALCULO SUELDO ANUAL
        V_SUELDO_BASE_ANUAL:= V_SUELDO_BASE_MENSUAL * 12;
        
    
        --PORCENTAJE BONO ANNIOS ANTIGUEDAD
        SELECT
            NVL(TA.PORCENTAJE, 0)
        INTO
            V_PORC_ANNIOS_ANTIGUEDAD
        FROM
            EMPLEADO EMP
        LEFT JOIN 
            TRAMO_ANTIGUEDAD TA
        ON 
            trunc(MONTHS_BETWEEN(sysdate, EMP.FECHA_CONTRATO) /12) BETWEEN TA.TRAMO_INF AND TA.TRAMO_SUP
            AND EXTRACT(YEAR FROM SYSDATE)-1 = ANNO_VIG
        WHERE
        ID_EMP = V_CONTADOR;--CONTADOR
        
        --BONO POR ANNIOS TRABAJADOS
        V_BONO_ANNIOS_ANTIGUEDAD:= ROUND(V_SUELDO_BASE_ANUAL * V_PORC_ANNIOS_ANTIGUEDAD / 100, 0);
        
        --BONO CAMIONES O BIENESTAR
        IF V_ARRIENDOS_EMP > 0 THEN 
            V_BONO_ESPECIAL_ANUAL := ((V_ARRIENDOS_EMP * :B_PORC_BONO_ARRIENDO) * V_SUELDO_BASE_ANUAL) /100;
        ELSE
            V_BONO_ESPECIAL_ANUAL := V_SUELDO_BASE_ANUAL * :B_PORC_BONO_BIENESTAR /100;
        END IF;
        
        --MOVILIZACION ANUAL
        IF V_ID_COMUNA = :B_MARIA_PINTO THEN
            V_MOV_ANUAL := ROUND((:B_PORC_MARIA_PINTO * V_SUELDO_BASE_ANUAL /100) + (12 * V_SUELDO_BASE_ANUAL /100),1);
            
        ELSIF V_ID_COMUNA = :B_CURACAVI THEN
                V_MOV_ANUAL := ROUND((:B_PORC_CURACAVI * V_SUELDO_BASE_ANUAL /100) + (12 * V_SUELDO_BASE_ANUAL /100),1);
                
        ELSIF V_ID_COMUNA = :B_TALAGANTE THEN
                V_MOV_ANUAL := ROUND((:B_PORC_TALAGANTE * V_SUELDO_BASE_ANUAL /100) + (12 * V_SUELDO_BASE_ANUAL /100),1);
                
        ELSIF V_ID_COMUNA = :B_EL_MONTE THEN
                V_MOV_ANUAL := ROUND((:B_PORC_EL_MONTE * V_SUELDO_BASE_ANUAL /100) + (12 * V_SUELDO_BASE_ANUAL /100),1);
                
        ELSIF V_ID_COMUNA = :B_BUIN THEN
                V_MOV_ANUAL := ROUND((:B_PORC_BUIN * V_SUELDO_BASE_ANUAL /100) + (12 * V_SUELDO_BASE_ANUAL /100),1);
        ELSE
            V_MOV_ANUAL := ROUND((12 * V_SUELDO_BASE_ANUAL /100));
        END IF;
        
        --COLACION
        V_COLACION_ANUAL := V_SUELDO_BASE_ANUAL * :B_PORC_COLACION /100;
        
        --DESCUENTOS LEGALES
        --DESCUENTO AFP
        SELECT 
            PORC_DESCTO_AFP
        INTO
            V_PORC_DESC_AFP
        FROM 
            EMPLEADO EMP
        JOIN
            AFP AFP
        ON 
            AFP.COD_AFP = EMP.COD_AFP
        WHERE 
            ID_EMP = V_CONTADOR;--CONTADOR
        
        --CALCULO DESCUENTO AFP
        V_DESCUENTO_AFP := V_PORC_DESC_AFP * V_SUELDO_BASE_ANUAL /100;
        
        --PORC TIPO SALUD
        SELECT 
            PORC_DESCTO_SALUD
        INTO
            V_PORC_DESC_SALUD
        FROM 
            EMPLEADO EMP
        JOIN
            TIPO_SALUD TS
        ON 
            TS.COD_TIPO_SAL = EMP.COD_TIPO_SAL
        WHERE ID_EMP = V_CONTADOR;--CONTADOR
        
        V_DESCUENTO_SALUD := V_PORC_DESC_SALUD * V_SUELDO_BASE_ANUAL /100;
        
        --CALCULO DESCUENTOS LEGALES
        V_DESCUENTOS_LEGALES := V_DESCUENTO_SALUD + V_DESCUENTO_AFP;
        
        --CALCULO SUELDO BRUTO ANUAL
        V_SUELDO_BRUTO := V_SUELDO_BASE_ANUAL + V_BONO_ANNIOS_ANTIGUEDAD + V_MOV_ANUAL + V_COLACION_ANUAL;
        
        --RENTA IMPONIBLE
        v_RENTA_IMPONIBLE := V_SUELDO_BASE_MENSUAL + V_BONO_ANNIOS_ANTIGUEDAD + (V_MOV_ANUAL /12) + V_BONO_ESPECIAL_ANUAL - V_DESCUENTOS_LEGALES;
        
        --ENCRIPTACION
        
        --INSERCION DE DATOS A LA TABLA INFO_SII
        INSERT INTO INFO_SII 
        (ANNO_TRIBUTARIO, ID_EMP, RUN_EMPLEADO,
        NOMBRE_EMPLEADO, CARGO, MESES_TRABAJADOS,
        ANNOS_TRABAJADOS, SUELDO_BASE_MENSUAL, SUELDO_BASE_ANUAL,
        BONO_ANNOS_ANUAL, BONO_ESPECIAL_ANUAL, MOVILIZACION_ANUAL,
        COLACION_ANUAL, DESCTOS_LEGALES, SUELDO_BRUTO_ANUAL,
        RENTA_IMPONIBLE_ANUAL)
        
        VALUES(V_ANNIO_TRIBUTARIO, V_ID_EMP, V_RUT_EMP,
        V_NOMBRE_EMP, V_CARGO_EMP, V_MESES_TRABAJADOS,
        V_ANNIOS_TRABAJADOS, V_SUELDO_BASE_MENSUAL,V_SUELDO_BASE_ANUAL,
        V_BONO_ANNIOS_ANTIGUEDAD, V_BONO_ESPECIAL_ANUAL, V_MOV_ANUAL,
        V_COLACION_ANUAL, V_DESCUENTOS_LEGALES, V_SUELDO_BRUTO,
        v_RENTA_IMPONIBLE);
        
        
        
        DBMS_OUTPUT.PUT_LINE('V_ANNIO_TRIBUTARIO: '||V_ANNIO_TRIBUTARIO);
        DBMS_OUTPUT.PUT_LINE('V_ID_EMP: '||V_ID_EMP);
        DBMS_OUTPUT.PUT_LINE('V_RUT_EMP: '||V_RUT_EMP);
        DBMS_OUTPUT.PUT_LINE('V_NOMBRE_EMP: '||V_NOMBRE_EMP);
        DBMS_OUTPUT.PUT_LINE('V_CARGO_EMP: '||V_CARGO_EMP);
        DBMS_OUTPUT.PUT_LINE('V_MESES_TRABAJADOS: '||V_MESES_TRABAJADOS);
        DBMS_OUTPUT.PUT_LINE('V_ANNIOS_TRABAJADOS: '||V_ANNIOS_TRABAJADOS);
        DBMS_OUTPUT.PUT_LINE('V_SUELDO_BASE_MENSUAL: '||V_SUELDO_BASE_MENSUAL);
        DBMS_OUTPUT.PUT_LINE('V_SUELDO_BASE_ANUAL: '||V_SUELDO_BASE_ANUAL);
        DBMS_OUTPUT.PUT_LINE('V_BONO_ANNIOS_ANTIGUEDAD: '||V_BONO_ANNIOS_ANTIGUEDAD);
        DBMS_OUTPUT.PUT_LINE('V_BONO_ESPECIAL_ANUAL: '||V_BONO_ESPECIAL_ANUAL);
        DBMS_OUTPUT.PUT_LINE('V_MOV_ANUAL: '||V_MOV_ANUAL);
        DBMS_OUTPUT.PUT_LINE('V_COLACION_ANUAL: '||V_COLACION_ANUAL);
        DBMS_OUTPUT.PUT_LINE('V_DESCUENTOS_LEGALES: '||V_DESCUENTOS_LEGALES);
        DBMS_OUTPUT.PUT_LINE('V_SUELDO_BRUTO: '||V_SUELDO_BRUTO);
        DBMS_OUTPUT.PUT_LINE('v_RENTA_IMPONIBLE: '||v_RENTA_IMPONIBLE);
        
        V_CONTADOR:= V_CONTADOR + 10;
    
    END LOOP;
    
END;
/

DELETE FROM INFO_SII;

rollback;
