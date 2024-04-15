CREATE OR REPLACE FUNCTION obtenerMateriasAbiertas(id_est INT) 
returns table (id_grupo_materia INT,nombre_materia VARCHAR,nombre_docente TEXT,nivel CHAR,grupo CHAR) AS $func$
begin

return query

SELECT g.id_grupo_materia, m.nombre_materia,
CONCAT(u.nombre,' ',u.apellido_p,' ',u.apellido_m) AS nombre_docente,
m.nivel, g.grupo FROM
(
    SELECT grupo_materia.id_grupo_materia,grupo_materia.grupo, grupo_materia.id_docente,grupo_materia.id_materia 
    FROM grupo_materia 
    WHERE 
        id_materia IN (
            SELECT id_materia FROM materias WHERE 
            (id_materia  NOT IN (
                SELECT id_materia FROM dependencia_materia  
            ) OR 
            id_materia IN (
                SELECT id_materia FROM dependencia_materia
                WHERE id_dependencia IN (
                    SELECT id_materia FROM obtenerMateriasAprobadas(id_est)
                )
            ))
			AND id_materia NOT IN(
				SELECT id_materia FROM obtenerMateriasEstudiante(id_est,'APROBADO')
			) AND id_materia NOT IN (
                SELECT id_materia from obtenerMateriasEstudiante(id_est,'CURSANDO')
            )
        ) AND periodo_academico = (
        SELECT id_periodo FROM periodo_academico WHERE activo = True 
    )
) g, materias as m, usuarios as u
WHERE u.id_user = g.id_docente AND g.id_materia = m.id_materia ORDER BY m.nivel;
    
end; $func$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE inscribirse(id_est INT,id_grupo INT)
LANGUAGE plpgsql as $$
begin

INSERT INTO clase (id_estudiante,id_grupo_materia) VALUES (id_est,id_grupo);
    
end;$$;


CREATE OR REPLACE PROCEDURE subirTarea(id_grupo INT,descript VARCHAR)
    LANGUAGE plpgsql as $$
    begin

    INSERT INTO tarea(id_clase,descripcion) 
	SELECT clase.id_clase, descript AS descripcion FROM tarea WHERE
	clase.id_grupo_materia = id_grupo;
      
end;$$;



CREATE OR REPLACE FUNCTION obtenerMateriasEstudiante(id_est INT, tipo TEXT) 
returns table (id_grupo_materia INT,nombre_materia VARCHAR,nivel CHAR,promedio INT) AS $func$
begin

return query

SELECT two.id_grupo_materia,m.nombre_materia, m.nivel,two.promedio 
FROM (
SELECT one.id_grupo_materia, id_materia,one.promedio
FROM (
    SELECT id_grupo_materia,nota_final AS promedio
	FROM clase 
    WHERE estado = tipo::varchar AND
    id_estudiante=id_est
)one, grupo_materia as g
WHERE one.id_grupo_materia = g.id_grupo_materia
) two, materias AS m
WHERE two.id_materia = m.id_materia;

end; $func$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION obtenerMaterial(id_grupo INT) 
returns table (titulo VARCHAR,descripcion VARCHAR) AS $func$
begin

return query

SELECT titulo,descripcion from material where id_grupo_materia = id_grupo;

end; $func$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION verTareas(id_class INT,tipo VARCHAR) 
returns table (id_tarea INT,descripcion VARCHAR) AS $func$
begin

return query

SELECT tarea.id_tarea,tarea.descripcion from tarea WHERE id_clase=id_class and estado=tipo;

end; $func$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE entregarTarea(id_tarea INT, archivo BYTEA){
    
}

