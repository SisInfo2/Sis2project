CREATE OR REPLACE TRIGGER revisarEstudianteValido
BEFORE INSERT ON clase
FOR EACH ROW EXECUTE PROCEDURE revisarEstudianteValido();

CREATE OR REPLACE FUNCTION revisarEstudianteValido()
RETURNS TRIGGER AS $$ 
DECLARE
	checkMateria INT := 0;
BEGIN

SELECT COUNT(id_materia) INTO checkMateria FROM (
	SELECT m.id_materia FROM materias AS m WHERE
	m.nombre_materia IN (
		SELECT nombre_materia FROM 
		obtenerMateriasAbiertas(2)
	)
);

IF checkMateria > 0 THEN
RAISE EXCEPTION 'El estudiante no puede cursar esta materia';
END IF;

RETURN NEW;


END;$$ LANGUAGE plpgsql;
