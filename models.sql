CREATE TABLE Usuarios (
  "id_user" SERIAL PRIMARY KEY,
  "nombre" VARCHAR(20) NOT NULL,
  "apellido_p" VARCHAR(25) NOT NULL,
  "apellido_m" VARCHAR(25),
  "correo" VARCHAR(25),
  "contrasena" VARCHAR(30) ,
	CHECK( 
		nombre ~ '[A-Z][a-z]+' AND
		apellido_p ~ '[A-Z][a-z]+' AND
		apellido_m ~ '[A-Z][a-z]+'
	)
);

CREATE TABLE Materias (
  "id_materia" SERIAL PRIMARY KEY,
  "nombre_materia" VARCHAR(30) UNIQUE NOT NULL,
  "nivel" CHAR NOT NULL,
  CHECK (
    nivel IN ('A','B','C','D','E','F','G','H','I')
  )
);

CREATE TABLE "Docentes" (
  "id_user" INT PRIMARY KEY
);


INSERT INTO usuarios (nombre,apellido_p,apellido_m) VALUES ('Kevin','Huayllas','Pinto');
INSERT INTO materias (nombre_materia,nivel) VALUES ('Algebra I','A');
