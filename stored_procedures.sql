CREATE OR REPLACE FUNCTION obtenerMateriasAbiertas() 
returns table (nombre_materia,nombre_docente,nivel,grupo) AS $func$
begin

return query

select id_user,username from Users where id_user IN(
    select id_user from docente
) ORDER by username;
    
end; $func$ LANGUAGE plpgsql;