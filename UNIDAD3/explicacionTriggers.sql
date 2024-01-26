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
    
