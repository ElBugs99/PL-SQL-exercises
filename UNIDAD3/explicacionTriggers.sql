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
