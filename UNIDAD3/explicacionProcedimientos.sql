1. PARA QUE UN BLOQUE PLSQL PUEDA SER EJECUTADO DESDE OTRAS APLICACIONES Y/O DESDE OTROS PROCESOS PLSQL
EL BLOQUE DEBE ESTAR ALMACENADO EN LA BASE DE DATOS.

2. CUANDO UN BLOQUE PLSQL SE ALMACENA EN LA BASE DE DATOS SE LLAMA PROGRAMA PL/SQL
O BLOQUE PL/SQL CON NOMBRE

3. LOS PROGRAMAS PL/SQL O BLOQUES CON NOMBRE SON:

    -PROCEDIMIENTOS ALMACENADOS CUYO OBJETIVO ES PROCESAR INFORMACION MASIVA.
    POR LO TANTO DEBERIA TENER CURSORES EXPLICITOS, REALIZAR CALCULOS, OBTENER DATOS
    DE OTRAS TABLAS, INSERTAR RESULTADO DEL PROCESO. HAY UNA EXCEPCION A ESTO 
    Y ES CUANDO SE USA UN PROCEDIMIENTO PARA INSERTAR RESULTADO EN TABLAS
   
    -FUNCIONES ALMACENADAS: CUYO OBJETIVO ES QUE A PARTIR DE UNO O VARIOS PARAMETROS
    LA SENTENCIA OBTENGA UN VALOR Y LO RETORNE
    
    -PACKAGE: CUYO OBJETIVO ES AGRUPAR PROGRAMAS SQL PARA UN PROCESO. ESTO ES PORQUE LA EJECUCION ES 
    MAS RAPIDA. 
    
    -TRIGGER: CUYO OBJETIVO ES REALIZAR UNA ACCION DE ACUERDO A LA SENTENCIA SQL EJECUTADA EN 
    LA TABLA ASOCIADA AL TRIGGER.

    -PARA CREAR ESTOS PROGRAMAS:
    CREATE OR REPLACE TIPO_PROGRAMA NOMBRE_PROGRAMA(PARAMETROS) IS
    
    -PARA QUE EL USUARIO PUEDA CREAR ESTOS PROGRAMAS DEBE TENER EL PRIVILEGIO DE 
    CREATE TIPO_PROGRAMA
    
    -TODOS LOS PROGRAMAS DEPENDEN DE LOS OBJETOS A LOS QUE HACEN REFERENCIA, SI EL O LOS
    OBJETOS QUE SE REFERENCIAN NO EXISTEN EL PROGRAMA SE DESCOMPILA Y NO SE PUEDE EJECUTAR,
    
    
PROCEDIMIENtO ALMACENADO:

1. PARA CREAR UN PROCEDIMIENTO
    CREATE (OR REPLACE) PROCEDURE SP_NOMBRE(PARAMETRO [MODO] TIPO_DATO,
                                            PARAMETRO2 [MODO] TIPO_DATO,...) IS
    DECLARACION_VARIABLES, CURSORES, TIPOS
    
    BEGIN
    
    
    EXCEPTION
    
    
    END;

2. MODO DE LOS PARAMETROS:
    2.1 IN (MODO POR DEFECTO): SE LE DEBE ASIGNAR UN VALOR A ESE PARAMETRO.
    2.2 OUT: SE DEBE ESPECIFICAR, A TRAVES DE ESTE PARAMETRO SE RETORNA UN VALOR
    2.3 IN OUT: SE DEBE ESPECIFICAR, SE LE DEBE ASIGNAR UN VALOR Y ADEMAS SE USA 
    PARA RETORNAR UN VALOR. ES DECIR A ESTE PARAMETRO SE LE PUEDE MODIFICAR SU VALOR ENTRE
    EL BEGIN Y EL END
    
FUNCION ALMACENADA
1. DEBE TENER A LO MENOS 2 CLAUSULAS RETURN. UNA EN EL ENCABEZADO DE LA FUNCION Y LA OTRA ENTRE EL BEGIN 
Y END. AUNQUE EN EL BEGIN Y END SE PODRIAN TENER MAS DE UNA CLAUSULA RETURN

2. EL TIPO DE DATO DEFINIDO EN LA CLAUSULA RETURN DEL ENCABEZADO INDICA EL TIPO DE DATO OBLIGATORIO
QUE DEBEN RETORNAR LAS CLAUSULAS RETURN DEFINIDAS ENTRE EL BEGIN Y END

3. SE PUEDEN EJECUTAR: DESDE UN PROCEDIMIENTO ALMACENADO, DESDE UNA SENTENCIA SELECT DE UNA APLICACION CONSTRUIDA EN OTRO LENGUAJE
Y DESDE UNA SENTENCIA SELECT NORMAL.

4. PARA CREAR UNA FUNCION ALMACENADA
    CREATE OR REPLACE FUNCTION NOMBRE_FUNCION(PARAMETRO1 TIPO_DATO, PARAMETRO2 TIPO_DATO, ...) RETURN TIPO_DATO IS
    DECLARACION_VARIABLES (OJALA NUNCA CURSORES), TIPOS, ETC
    BEGIN
        SENTENCIAS SQL PL/SQL;
    RETURN VALOR_RETORNAR
    
    EXCEPTION
        SENTENCIAS;
        RETURN VALOR_RETORNAR
        
    END NOMBRE_FUNCION;
    
    
--CREAR FUNCION QUE RETORNE
CREATE OR REPLACE FUNCTION FN_OBT_DESC_ESCOL(P_ID_ESC NUMBER)
RETURN VARCHAR2
IS
V_DESC_ESC VARCHAR2(60);
BEGIN

    SELECT DESC_ESCOLARIDAD
    INTO V_DESC_ESC
    FROM ASIG_ESCOLARIDAD
    WHERE ID_ESCOLARIDAD = P_ID_ESC;

    RETURN V_DESC_ESC;

END;

--SE EJECUTA FUNCION DESDE UNA SENTENCIA SELECT
SELECT
    NUMRUN_EMP,
    NOMBRE_EMP||' '||APPATERNO_EMP NOMBRE_EMPLEADO,
    TO_CHAR(SUELDO_BASE_EMP, 'FML99G999G999') "SUELDO BASE",
    FN_OBT_DESC_ESCOL(ID_ESCOLARIDAD ) "DESC ESCOLARIDAD"
    --AE.DESC_ESCOLARIDAD
FROM EMPLEADO E
--JOIN ASIG_ESCOLARIDAD AE
--ON E.ID_ESCOLARIDAD = AE.ID_ESCOLARIDAD
ORDER BY APPATERNO_EMP;


--CREAR LA FUNCION
CREATE OR REPLACE FUNCTION FN_OBT_TOT_CF(
P_NUMRUN_EMP NUMBER
)
RETURN NUMBER
IS
v_cant_cargas_fam NUMBER;
BEGIN

        SELECT COUNT(*) 
          INTO v_cant_cargas_fam
          FROM carga_familiar
         WHERE numrun_emp = P_NUMRUN_EMP;
         
         RETURN v_cant_cargas_fam;
END;

--SE PRUEBA FUNCION ALMACENADA
SELECT NUMRUN_EMP,
        FN_OBT_TOT_CF(NUMRUN_EMP)
FROM EMPLEADO;
