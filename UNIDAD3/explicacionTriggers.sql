trigger
1. un programa plsql con nombre, que se debe asociar a una tabla. por lo tanto
si se elimina la tabla asociada al trigger automaticamente se elimina el trigger.

2. al estar asociado a una tabla se ejecutara cada vez que realice un insert / update y/o un delete
sobre las filas de la tabla

3 una tabla puede tener asociado mas de un trigger. pero hay que considerar que el
trigger hace que las sentencias dml sobre la tabla sean un poco mas lentas.

4 hay dos tipos de trigger:
    
    -que se activa para validar la sentencia dml que se ejecuta sobre la tabla.
    se conoce como trigger asociado a sentencia
    
    -que se activa por cada fila afectada por la sentencia dml que se ejecuta sobre la tabla (Examen).
    se conoce como trigger asociado a filas
    
5 para crear un trigger asociado a filas de la tabla:
    
    create or replace trigger trg_nombre
    before|after => el tiempo en que el trigger se va a ejecutar.
            before: el trigger se va a ejecutar entes de
            la sentencia dml que activo el trigger
            after: el trigger se va a ejecutar despues de la sentencia
            dml que activo el trigger
    insert or update or delete   => sentencia dml activara la ejecucion del trigger
    
    on nombre_tabla => a que tabla se asocia el trigger
    for each row => el trigger se va a ejecutar por cada fila de la tabla afectada
                    por la sentencia dml
    declare => es para definir variables en el trigger.
    declaracion de variables
    begin
        cuerpo_del_trigger
    exception
        sentencias plsql y/o sql;
    end trg_nombre;
    
6 los trigger a nivel de fila requieren trabajar con 2 estructuras de datos: old y new.
para referenciar las columnas de ambas estructuras en el trigger se debe hacer referencia a 
:old.columna
o
:new.columna

                                :old.columna = null
insert => solo tiene sentido usar :new.columna

                                :new.columna = null
delete => solo tiene sentido usar :old.columna


update => :new => tendra nuevo valor de las columnas que se actualizan + el valor de las otras columna
                    que no se actualizan
                    
            :old => conserva valores de antes
            
7 si se desea que el trigger realice acciones diferentes cuando se actualice, elimine o inserte una fila, entonces se deben usar
los predicadores: inserting, deleting y updating

/*SE CREA TRIGGER ASOCIADO A LA TABLA EMPLEADOS PARA QUE SE EJECUTE O SE ACTIVE CADA VEZ QUE SE RALICE
IN INSERT, UPDATE O DELETE SOBRE LA TABLA. EL TRIGGER VA A INSERTAR EN LA TABLA AUDIT_EMPLEADOS
LOS VALORES NUEVOS Y ANTIGUOS DE CADA FILA */

CREATE OR REPLACE TRIGGER TRG_AUDIT_EMPLEADOS
--TIEMPO EN QUE SE VA A ACTIVAR EL TRIGGER Y SOBRE QUE SENTENCIAS DML SE ACTIVARA EL TRIGGER
AFTER INSERT OR UPDATE OR DELETE ON EMPLEADOS
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_EMPLEADOS
    VALUES(:NEW.EMPLOYEE_ID, :OLD.EMPLOYEE_ID,
            :NEW.LAST_NAME, :OLD.LAST_NAME,
            :NEW.FIRST_NAME, :OLD.FIRST NAME,
            :NEW.SALARY, :OLD.SALARY,
            :NEW.EMAIL, :OLD.EMAIL,
            :NEW.DEPARTMENT_ID, :OLD.DEPARTMENT_ID
            :NEW.FECHA_MODIFICACION, :OLD.FECHA_MODIFICACION
            )

END;
 
 
 
 CREATE OR REPLACE TRIGGER TRG_AUDIT_EMPLEADOS
/* TIEMPO EN QUE SE VA A ACTIVAR EL TRIGGER Y SOBRE QUE SENTENCIAS
DML SE ACTIVARA EL TRIGGER */
AFTER INSERT OR UPDATE OR DELETE ON empleados
FOR EACH ROW
BEGIN
   INSERT INTO AUDIT_EMPLEADOS
   VALUES(:NEW.employee_id, :OLD.employee_id,:NEW.last_name,
          :OLD.last_name, :NEW.first_name, :OLD.first_name,
          :NEW.salary, :OLD.salary, :NEW.email, :OLD.email,
          :NEW.department_id, :OLD.department_id, SYSDATE);
END;


--INSERTAR EL EMPLEADO 999

INSERT INTO EMPLEADOS
VALUES(999, 'PEREZ', 'JUAN', 12500, 'JPPEREZ@GMAIL.COM', 70);

DELETE FROM EMPLEADOS
WHERE EMPLOYEE_ID IN(100, 101);


UPDATE EMPLEADOS
SET SALARY = ROUND(SALARY*1.25),
    EMAIL= 'JUANPEREZ@GMAIL.COM',
    DEPARTMENT_ID = 10
WHERE EMPLOYEE_ID = 999;
