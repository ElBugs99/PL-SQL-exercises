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

   
   
   --paso 2: abrir el cursor
    OPEN C_DATOS_VENDEDOR;

    --PASO 3: LEER CADA FILA DEL CURSOR
    --OPCION 1: LOOP SIMPLE

   LOOP
   --SE LEE CADA FILA DEL CURSOR
   FETCH C_DATOS_VENDEDOR
   INTO v_id_vendedor,
        v_rut_vend ,
        v_sueldo_base,
        v_id_categ,
        v_annos;
        
    --se debe indicar la condicion de salida del loop
    exit when C_DATOS_VENDEDOR%NOTFOUND;
    
     -- Se inicializan las variables
     v_asig_antig:=0;
     v_bono_categ:=0;
     v_asig_cargas:=0;
     -- Obtiene los datos básicos para el proceso
      
      -- Calcula bonificación por antiguedad
      IF v_annos > 0 THEN
           SELECT porc_bonif
             INTO v_porc_antig
             FROM bonificacion_antig
            WHERE v_annos BETWEEN anno_tramo_inf AND anno_tramo_sup;
            v_asig_antig:=ROUND(v_sueldo_base*(v_porc_antig/100));
      END IF;

     -- Cálculo monto de comisiones del mes y año de proceso   
     SELECT NVL(SUM(monto_venta),0) 
     INTO v_monto_mes_ventas
     FROM boleta
     WHERE id_vendedor = v_id_vendedor
       AND TO_CHAR(fecha_venta,'MM/YYYY')= SUBSTR(:b_fecha_proceso,4);
    v_com_ventas:=ROUND(v_monto_mes_ventas*:b_porc_com_ventas);

   /*Se obtiene el monto total de las ventas realizadas durante el año para actualizar la categoria
 del vendedor */
     SELECT NVL(SUM(monto_venta),0) 
     INTO v_monto_anual_ventas
     FROM boleta
     WHERE id_vendedor = v_id_vendedor
       AND TO_CHAR(fecha_venta,'YYYY')= SUBSTR(:b_fecha_proceso,7);

     -- Cálculo bono especial por categoría 
      IF v_id_categ IN ('A', 'B') THEN 
           SELECT porcentaje/100
             INTO v_porc_categ
             FROM categoria
            WHERE id_categoria = v_id_categ;
            v_bono_categ:=ROUND(v_com_ventas*v_porc_categ);
      END IF;

     /* Cálculo de asignación cargar familiares */
     -- Obtiene el total de haberes para calcular asignación familiar
     v_total_hab_cf:= v_sueldo_base + v_bono_categ + v_asig_antig;
     -- Si el total de haberes para cargas familiares es mayor al tope entonces el valor será cero
     IF v_total_hab_cf > :b_haber_tope_cf THEN
        v_asig_cargas:=0;
     ELSE
         -- Obtiene el numero de cargas y calcula la asignacion por cargas
         SELECT COUNT(*)
           INTO v_tot_cargas
           FROM carga_familiar
          WHERE id_vendedor = v_id_vendedor;
          -- calcula el valor de la asignación
          v_asig_cargas := ROUND(:b_valor_cf * v_tot_cargas);
     END IF;    

     -- Cálculo total de los haberes
     v_total_haberes := v_sueldo_base + v_asig_antig + v_asig_cargas + v_com_ventas + v_bono_categ;
                      
    -- INSERCIÓN DE LOS RESULTADOS EN LAS TABLAS    
    INSERT INTO haber_mes_vendedor
    VALUES(v_id_vendedor, v_rut_vend, SUBSTR(:b_fecha_proceso,4,2), 
           SUBSTR(:b_fecha_proceso,7),v_sueldo_base,
           v_asig_antig,v_asig_cargas, v_com_ventas, 
           v_bono_categ,v_total_haberes);

    IF SUBSTR(:b_fecha_proceso,4,2)=12 THEN
        SELECT id_categoria
             INTO v_nueva_categ
            FROM categoria
           WHERE v_monto_anual_ventas BETWEEN monto_anual_vent_inf AND monto_anual_venta_sup;
      

          UPDATE vendedor
                  SET id_categoria=v_nueva_categ
           WHERE id_vendedor=v_id_vendedor;
     
          IF v_nueva_categ = v_id_categ THEN
                v_obs:='El vendedor mantiene categoria';
          ELSE
                  v_obs:='El vendedor cambia categoria';
          END IF;
          INSERT INTO detalle_modif_categ_vendedor
          VALUES(v_id_vendedor, v_rut_vend, SUBSTR(:b_fecha_proceso,4,2), 
            SUBSTR(:b_fecha_proceso,7),v_id_categ, v_nueva_categ,v_obs);
    END IF;
    v_id_vendedor := v_id_vendedor + 10;      
   END LOOP;
   
   --PASO 4: CERRAR EL CURSOR
   CLOSE C_DATOS_VENDEDOR;
END;







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
   
   
   --paso 2: abrir el cursor
    OPEN C_DATOS_VENDEDOR;

    --PASO 3: LEER CADA FILA DEL CURSOR
    --OPCION 1: WHILE SIMPLE
    FETCH C_DATOS_VENDEDOR
   INTO v_id_vendedor,
        v_rut_vend ,
        v_sueldo_base,
        v_id_categ,
        v_annos;
    

   WHILE C_DATOS_VENDEDO%FOUND LOOP 
   --SE LEE CADA FILA DEL CURSOR
   
        
    --se debe indicar la condicion de salida del loop
    exit when C_DATOS_VENDEDOR%NOTFOUND;
    
     -- Se inicializan las variables
     v_asig_antig:=0;
     v_bono_categ:=0;
     v_asig_cargas:=0;
     -- Obtiene los datos básicos para el proceso
      
      -- Calcula bonificación por antiguedad
      IF v_annos > 0 THEN
           SELECT porc_bonif
             INTO v_porc_antig
             FROM bonificacion_antig
            WHERE v_annos BETWEEN anno_tramo_inf AND anno_tramo_sup;
            v_asig_antig:=ROUND(v_sueldo_base*(v_porc_antig/100));
      END IF;

     -- Cálculo monto de comisiones del mes y año de proceso   
     SELECT NVL(SUM(monto_venta),0) 
     INTO v_monto_mes_ventas
     FROM boleta
     WHERE id_vendedor = v_id_vendedor
       AND TO_CHAR(fecha_venta,'MM/YYYY')= SUBSTR(:b_fecha_proceso,4);
    v_com_ventas:=ROUND(v_monto_mes_ventas*:b_porc_com_ventas);

   /*Se obtiene el monto total de las ventas realizadas durante el año para actualizar la categoria
 del vendedor */
     SELECT NVL(SUM(monto_venta),0) 
     INTO v_monto_anual_ventas
     FROM boleta
     WHERE id_vendedor = v_id_vendedor
       AND TO_CHAR(fecha_venta,'YYYY')= SUBSTR(:b_fecha_proceso,7);

     -- Cálculo bono especial por categoría 
      IF v_id_categ IN ('A', 'B') THEN 
           SELECT porcentaje/100
             INTO v_porc_categ
             FROM categoria
            WHERE id_categoria = v_id_categ;
            v_bono_categ:=ROUND(v_com_ventas*v_porc_categ);
      END IF;

     /* Cálculo de asignación cargar familiares */
     -- Obtiene el total de haberes para calcular asignación familiar
     v_total_hab_cf:= v_sueldo_base + v_bono_categ + v_asig_antig;
     -- Si el total de haberes para cargas familiares es mayor al tope entonces el valor será cero
     IF v_total_hab_cf > :b_haber_tope_cf THEN
        v_asig_cargas:=0;
     ELSE
         -- Obtiene el numero de cargas y calcula la asignacion por cargas
         SELECT COUNT(*)
           INTO v_tot_cargas
           FROM carga_familiar
          WHERE id_vendedor = v_id_vendedor;
          -- calcula el valor de la asignación
          v_asig_cargas := ROUND(:b_valor_cf * v_tot_cargas);
     END IF;    

     -- Cálculo total de los haberes
     v_total_haberes := v_sueldo_base + v_asig_antig + v_asig_cargas + v_com_ventas + v_bono_categ;
                      
    -- INSERCIÓN DE LOS RESULTADOS EN LAS TABLAS    
    INSERT INTO haber_mes_vendedor
    VALUES(v_id_vendedor, v_rut_vend, SUBSTR(:b_fecha_proceso,4,2), 
           SUBSTR(:b_fecha_proceso,7),v_sueldo_base,
           v_asig_antig,v_asig_cargas, v_com_ventas, 
           v_bono_categ,v_total_haberes);

    IF SUBSTR(:b_fecha_proceso,4,2)=12 THEN
        SELECT id_categoria
             INTO v_nueva_categ
            FROM categoria
           WHERE v_monto_anual_ventas BETWEEN monto_anual_vent_inf AND monto_anual_venta_sup;
      

          UPDATE vendedor
                  SET id_categoria=v_nueva_categ
           WHERE id_vendedor=v_id_vendedor;
     
          IF v_nueva_categ = v_id_categ THEN
                v_obs:='El vendedor mantiene categoria';
          ELSE
                  v_obs:='El vendedor cambia categoria';
          END IF;
          INSERT INTO detalle_modif_categ_vendedor
          VALUES(v_id_vendedor, v_rut_vend, SUBSTR(:b_fecha_proceso,4,2), 
            SUBSTR(:b_fecha_proceso,7),v_id_categ, v_nueva_categ,v_obs);
    END IF;
    
    FETCH C_DATOS_VENDEDOR
   INTO v_id_vendedor,
        v_rut_vend ,
        v_sueldo_base,
        v_id_categ,
        v_annos;
   END LOOP;
   
   --PASO 4: CERRAR EL CURSOR
   CLOSE C_DATOS_VENDEDOR;
END;


