--EJERCICIO 1
VAR B_NOM VARCHAR2(20);
VAR B_PORC_BON NUMBER;

EXEC :B_NOM := 'MARCO OGAZ VARAS';
EXEC :B_PORC_BON := 40;


DECLARE
    V_SUELDO_EMP NUMBER(20);
    V_BONO NUMBER(20);
    V_RUN NUMBER(20);
BEGIN

    SELECT
        SUELDO_EMP, SUELDO_EMP * :B_PORC_BON /100, NUMRUT_EMP
        INTO 
        V_SUELDO_EMP, V_BONO, V_RUN
    FROM
        EMPLEADO
    WHERE NOMBRE_EMP||' '||APPATERNO_EMP||' '||APMATERNO_EMP = :B_NOM;
    
    DBMS_OUTPUT.PUT_LINE('DATOS CALCULO BONIFICACION EXTRA DEL '||:B_PORC_BON||'% DEL SUELDO');
    DBMS_OUTPUT.PUT_LINE('NOMBRE EMPLEADO: '||:B_NOM);
    DBMS_OUTPUT.PUT_LINE('RUN: '||V_RUN);
    DBMS_OUTPUT.PUT_LINE('SUELDO: '||V_SUELDO_EMP);
    DBMS_OUTPUT.PUT_LINE('BONIFICACION EXTRA: '||V_BONO);

END;
/

SET SERVEROUTPUT ON;




--EJERCICIO 2
VAR B_RUN NUMBER;
VAR B_RENTA_MIN NUMBER;
EXEC :B_RUN := '12487147-9';

DECLARE
    V_NOMBRE VARCHAR2(150);
    V_RENTA NUMBER(20);
    V_EST_CIVIL VARCHAR(20);
    

BEGIN

    SELECT 
        CLI.NOMBRE_CLI||' '||CLI.APPATERNO_CLI||' '||CLI.APMATERNO_CLI, CLI.RENTA_CLI,
        DESC_ESTCIVIL
    INTO V_NOMBRE, 
         V_RENTA,
         V_EST_CIVIL
    FROM CLIENTE CLI
    JOIN ESTADO_CIVIL EC ON CLI.ID_ESTCIVIL = EC.ID_ESTCIVIL
    WHERE (CLI.ID_ESTCIVIL = 1 OR CLI.ID_ESTCIVIL IN(3, 4) AND RENTA_CLI >= :B_RENTA_MIN) AND CLI.NUMRUT_CLI||'-'||CLI.DVRUT_CLI = :B_RUN--BIND
    ;
    
    DBMS_OUTPUT.PUT_LINE('NOMBRES: '||V_NOMBRE);
    DBMS_OUTPUT.PUT_LINE('RUN: '||:B_RUN);
    DBMS_OUTPUT.PUT_LINE('ESTADO CIVIL: '||V_EST_CIVIL);
    DBMS_OUTPUT.PUT_LINE('RENTA: '||V_RENTA);

END;
/



--EJERCICIO 3
--2 VARIABLES BIND PARA PORCENTAJE?
VAR B_PORC_1 NUMBER; --8.5
VAR B_PORC_2 NUMBER;--20
VAR B_RUT VARCHAR2(20); --12260812-0 11999100-4
VAR B_RANGO_MIN NUMBER;--200000
VAR B_RANGO_MAX NUMBER;--400000

/*
EXEC :B_PORC_1 := 8.5;
EXEC :B_PORC_2 := NULL;
EXEC :B_RUT := '12260812-0';
*/

DECLARE
V_NOM VARCHAR2(150);
V_SUELDO NUMBER;
V_SUELDO_REAJUSTADO NUMBER;
V_REAJUSTE NUMBER;


BEGIN

    --informe 1
    SELECT 
        NOMBRE_EMP ||' '|| APPATERNO_EMP ||' '|| APMATERNO_EMP,
        SUELDO_EMP,
        ROUND(SUELDO_EMP + (SUELDO_EMP * :B_PORC_1 /100)),
        ROUND(SUELDO_EMP * :B_PORC_1 /100)
    INTO 
        V_NOM, 
        V_SUELDO,
        V_SUELDO_REAJUSTADO,
        V_REAJUSTE
    FROM
        EMPLEADO
    WHERE 
        NUMRUT_EMP||'-'||DVRUT_EMP = :B_RUT;
        
    DBMS_OUTPUT.PUT_LINE('=======================================');    
    DBMS_OUTPUT.PUT_LINE('NOMBRE DEL EMPLEADO: ' || V_NOM);
    DBMS_OUTPUT.PUT_LINE('RUN: ' || :B_RUT);
    DBMS_OUTPUT.PUT_LINE('SIMULACION 1: AUMENTAR EN ' || :B_PORC_1 || '% EL SALARIO DE TODOS LOS EMPLEADOS');
    DBMS_OUTPUT.PUT_LINE('SUELDO ACTUAL: ' || V_SUELDO);
    DBMS_OUTPUT.PUT_LINE('SUELDO REAJUSTADO: ' || V_SUELDO_REAJUSTADO);
    DBMS_OUTPUT.PUT_LINE('REAJUSTE: ' || V_REAJUSTE);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        --informe 2
    SELECT 
        ROUND(SUELDO_EMP + (SUELDO_EMP * :B_PORC_2 /100)),
        ROUND(SUELDO_EMP * :B_PORC_2 /100)
    INTO 
        V_SUELDO_REAJUSTADO,
        V_REAJUSTE
    FROM
        EMPLEADO
    WHERE 
        NUMRUT_EMP||'-'||DVRUT_EMP = :B_RUT AND SUELDO_EMP BETWEEN :B_RANGO_MIN AND :B_RANGO_MAX;

    DBMS_OUTPUT.PUT_LINE('SIMULACION 2: AUMENTAR EN ' || :B_PORC_2 || '% EL SALARIO DE TODOS LOS EMPLEADOS QUE POSEEN SALARIOS ENTRE '||:B_RANGO_MIN||' Y '||:B_RANGO_MAX );
    DBMS_OUTPUT.PUT_LINE('SUELDO ACTUAL: ' || V_SUELDO);
    DBMS_OUTPUT.PUT_LINE('SUELDO REAJUSTADO: ' || V_SUELDO_REAJUSTADO);
    DBMS_OUTPUT.PUT_LINE('REAJUSTE: ' || V_REAJUSTE);
    DBMS_OUTPUT.PUT_LINE('=======================================');
END;
/