CREATE OR REPLACE FUNCTION obtenerMateriasAbiertas() 
returns table (nombre_materia VARCHAR,nombre_docente TEXT,nivel CHAR,grupo CHAR) AS $func$
begin

return query

SELECT m.nombre_materia,
CONCAT(u.nombre,' ',u.apellido_p,' ',u.apellido_m) AS nombre_docente,
m.nivel, g.grupo FROM
(
    SELECT grupo_materia.grupo, grupo_materia.id_docente,grupo_materia.id_materia FROM grupo_materia WHERE estado = 'ABIERTA'
) g, materias as m, usuarios as u
WHERE u.id_user = g.id_docente AND g.id_materia = m.id_materia ORDER BY m.nivel;
    
end; $func$ LANGUAGE plpgsql;

