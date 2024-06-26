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
returns table (id_grupo_materia INT,
              id_materia INT,
              nombre_materia VARCHAR,
              nivel CHAR,
              promedio INT,
              nombre_docente TEXT ) 
AS $func$
begin

return query

SELECT three.id_grupo_materia,
three.id_materia,
three.nombre_materia, 
three.nivel,three.promedio,
CONCAT(u.nombre,' ',u.apellido_p,' ',u.apellido_m) AS nombre_docente
FROM (
    SELECT two.id_grupo_materia, two.id_materia,two.promedio,two.id_docente,m.nivel,m.nombre_materia
    FROM(
        SELECT one.id_grupo_materia, g.id_materia,one.promedio,g.id_docente
        FROM (
            SELECT clase.id_grupo_materia,clase.nota_final AS promedio
            FROM clase 
            WHERE estado = tipo::varchar AND
            id_estudiante=id_est
        )one, grupo_materia as g
        WHERE one.id_grupo_materia = g.id_grupo_materia
        ) two, materias AS m
    WHERE two.id_materia = m.id_materia
    )three, usuarios as u
    WHERE three.id_docente = u.id_user;

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


CREATE OR REPLACE PROCEDURE entregarTarea(id_tarea INT,nombre VARCHAR, content BYTEA)
    LANGUAGE plpgsql as $$
    DECLARE 
    id_arch INT
    begin
    INSERT INTO archivo (nombre_archivo, contenido) VALUES (nombre,content) 
    RETURNING id_archivo INTO id_arch;

    INSERT INTO tarea_archivo VALUES(id_tarea,id_arch);  
end;$$;

