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
