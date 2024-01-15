Cursor explicito:
1. es una sentencia select que requiere retornar mas de una fila 
para que sea procesada cada una de ellas en el loop.

2. La sentencia select se debe declarar como un cursor en la seccion de
definicion de variable. este select ya no usa la clausula into.

3. Cada fila que retorna el select del cursor  explicito se procesa
en un loop en la seccion de ejecucion del bloque

4.las filas que retorna el select del cursor, tecnicamente se llama set activo


Para trabajar con cursores explicitos se deben seguir los siguientes pasos:
1. declarar el cursor (DECLARE)
La base de  datos asigna el nombre al cursor en memoria y reserva ese espacio
para las filas que va a retornar el cursor
El select del cursor puede ser simple, puede contener join de tablas,
subconsultas

2. abrir el cursor (begin-end)
-La bd ejecuta el select del cursor.
-identifica el set activo
-posiciona un puntero en la primera fila del cursor

3. leer cada fila del cursor (loop begin-end)
-bd recupera la fila actual
-bd avanza el puntero a la siguiente fila del cursor

4 cerrar el cursor (begin-end)
-bd libera el area de memoria reservada para las filas que retorno el selec
del cursor



--MODIFICACION PRUEBA 1 PARA TRABAJAR CON CURSOR EXPLICITO SIMPLE
--EXPLICITO SIMPLE. PARA LEER TODAS LAS FILAS DEL CURSOR USANDO WHILE LOOP
VARIABLE b_fecha_proceso VARCHAR2(10);
VAR b_valor_cf NUMBER;
VAR b_haber_tope_cf NUMBER;
VAR b_porc_com_ventas NUMBER;
VAR b_monto_mov NUMBER;
EXEC :b_fecha_proceso:='31/12/2023';
EXEC :b_valor_cf:=6300;
EXEC :b_haber_tope_cf:=405000;
EXEC :b_porc_com_ventas:=.40;
DECLARE
--PASO 1 SE DECLARA EL CURSOR EXPLICITO
CURSOR C_DATOS_VENDEDOR IS
    --DATOS BASICOS DE TODOS LOS VENDEDORES
    SELECT v.id_vendedor, v.rut_vendedor, v.sueldo_base, v.id_categoria, 
        TRUNC(MONTHS_BETWEEN(:b_fecha_proceso,v.fec_contrato)/12)
          FROM vendedor v 
          ORDER BY v.rut_vendedor;
      

v_id_vendedor number;
v_rut_vend NUMBER(10);
v_sueldo_base NUMBER(8);
v_id_categ VARCHAR2(2);
v_annos NUMBER;
v_nueva_categ VARCHAR2(2);
v_porc_antig NUMBER(2);
v_porc_categ NUMBER(4,3);

v_tot_cargas NUMBER;
v_asig_antig NUMBER(8):=0;
v_bono_categ NUMBER(8):=0;
v_asig_cargas NUMBER(8):=0;
v_com_ventas  NUMBER(8);
v_total_hab_cf NUMBER(10);
v_total_haberes NUMBER(10) := 0;
v_monto_anual_ventas NUMBER(10) := 0;
v_monto_mes_ventas NUMBER(10) := 0;
v_obs VARCHAR2(30);
BEGIN
   -- Se TRUNCAN la tabla para facilitar la ejecución del bloque
   EXECUTE IMMEDIATE('TRUNCATE TABLE HABER_MES_VENDEDOR');
   EXECUTE IMMEDIATE('TRUNCATE TABLE DETALLE_MODIF_CATEG_VENDEDOR');

   -- Se obtienen las id mínima y máxima para recorrer la tabla vendedor
