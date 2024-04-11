CREATE TABLE usuarios (
  id_user SERIAL PRIMARY KEY,
  nombre VARCHAR(20) NOT NULL,
  apellido_p VARCHAR(25) NOT NULL,
  apellido_m VARCHAR(25),
  correo VARCHAR(40),
  contrasena VARCHAR(30) DEFAULT '123456' ,
	CHECK( 
		nombre ~ '[A-Z][a-z]+' AND
		apellido_p ~ '[A-Z][a-z]+' AND
		apellido_m ~ '[A-Z][a-z]+'
	)
);

CREATE TABLE materias (
  id_materia SERIAL PRIMARY KEY,
  nombre_materia VARCHAR(30) UNIQUE NOT NULL,
  nivel CHAR NOT NULL,
  CHECK (
    nivel IN ('A','B','C','D','E','F','G','H','I')
  )
);

CREATE TABLE docentes (
  id_user INT PRIMARY KEY,
  FOREIGN KEY (id_user) REFERENCES usuarios(id_user)
);

CREATE TABLE estudiantes (
  id_user INT PRIMARY KEY,
  estado VARCHAR(15) NOT NULL DEFAULT 'REGULAR',
  CHECK(
    estado IN ('REGULAR','IRREGULAR')
  ),
  FOREIGN KEY (id_user) REFERENCES usuarios(id_user)
);

CREATE TABLE grupo_materia (
  id_materia INT,
  id_docente INT,
  id_grupo_materia SERIAL UNIQUE,
  grupo CHAR NOT NULL,
  gestion INT NOT NULL DEFAULT EXTRACT(YEAR FROM NOW()),
  periodo_academico VARCHAR(20),
  nota_final INT NOT NULL DEFAULT 0,
  estado VARCHAR(15) NOT NULL DEFAULT 'PENDIENTE',
  CHECK(
    grupo IN ('A','B','C','D') AND
    gestion >= 2022 AND gestion <= EXTRACT(YEAR FROM NOW()) AND
    periodo_academico IN('Primer Semestre','Segundo Semestre','Verano','Invierno') AND
    nota_final >= 0 AND nota_final <= 100 AND
    estado IN ('PENDIENTE','ABIERTA','EN CURSO', 'FINALIZADA')
  ),
  PRIMARY KEY (id_materia,id_docente,id_grupo_materia),
  FOREIGN KEY (id_materia) REFERENCES materias(id_materia),
  FOREIGN KEY (id_docente) REFERENCES docentes(id_user)
);

CREATE TABLE Clase (
  id_clase SERIAL UNIQUE,
  id_estudiante INT,
  id_grupo_materia INT ,
  estado VARCHAR(20) DEFAULT 'CURSANDO' NOT NULL,
  CHECK (
    estado IN ('CURSANDO','ABANDONADO','APROBADO','REPROBADO')
  ),
  PRIMARY KEY (id_clase,id_estudiante,id_grupo_materia),
  FOREIGN KEY (id_grupo_materia) REFERENCES grupo_materia(id_grupo_materia),
  FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_user)
);




INSERT INTO usuarios (nombre,apellido_p,apellido_m) VALUES ('Kevin','Huayllas','Pinto');
INSERT INTO usuarios (nombre, apellido_p, apellido_m, correo)
VALUES
    ('Ana', 'Garcia', 'Rodriguez', 'AnaGarcia@gmail.com'),
    ('Juan', 'Perez', 'Lopez', 'JuanPerez@gmail.com'),
    ('Maria', 'Martinez', 'Gonzalez', 'MariaMartinez@gmail.com'),
    ('Carlos', 'Sanchez', 'Fernandez', 'CarlosSanchez@gmail.com'),
    ('Laura', 'Torres', 'Ramirez', 'LauraTorres@gmail.com'),
    ('Pedro', 'Jimenez', 'Ruiz', 'PedroJimenez@gmail.com'),
    ('Sofia', 'Moreno', 'Herrera', 'SofiaMoreno@gmail.com'),
    ('Diego', 'Castro', 'Ortega', 'DiegoCastro@gmail.com'),
    ('Valentina', 'Medina', 'Vargas', 'ValentinaMedina@gmail.com'),
    ('Andres', 'Silva', 'Rivas', 'AndresSilva@gmail.com'),
    ('Camila', 'Fernandez', 'Torres', 'CamilaFernandez@gmail.com'),
    ('Alejandro', 'Gonzalez', 'Sanchez', 'AlejandroGonzalez@gmail.com'),
    ('Lucia', 'Perez', 'Lopez', 'LuciaPerez@gmail.com'),
    ('Martin', 'Ramirez', 'Jimenez', 'MartinRamirez@gmail.com'),
    ('Isabella', 'Ruiz', 'Moreno', 'IsabellaRuiz@gmail.com'),
    ('Daniel', 'Herrera', 'Castro', 'DanielHerrera@gmail.com'),
    ('Gabriela', 'Ortega', 'Medina', 'GabrielaOrtega@gmail.com'),
    ('Manuel', 'Vargas', 'Silva', 'ManuelVargas@gmail.com'),
    ('Natalia', 'Silva', 'Rivas', 'NataliaSilva@gmail.com'),
    ('Felipe', 'Rivas', 'Silva', 'FelipeRivas@gmail.com');

INSERT INTO docentes VALUES (5),(6),(7),(8),(9),(10),(11);

INSERT INTO estudiantes VALUES (12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23),(24);

INSERT INTO materias(nombre_materia,nivel) VALUES ('Algebra I','A');
INSERT INTO materias(nombre_materia,nivel) VALUES ('Calculo I','A'),
                                                  ('Ingles I','A'),
                                                  ('Fisica','A'),
                                                  ('Introduccion a la programacion','A'),
                                                  ('Algebra II','B'),
                                                  ('Calculo II','B'),
                                                  ('Ingles II','B'),
                                                  ('Elementos de Programacion','B'),
                                                  ('Arquitectura de Computadoras','B'),
                                                  ('Programacion','C'),
                                                  ('Logica','C'),
                                                  ('Teoria de Grafos','C'),
                                                  ('Base de Datos I','D'),
                                                  ('Programacion Funcional','D'),
												                          ('Taller de Sistemas Operativos','E'),
                                                  ('Sistemas de Informacion I','D'),
                                                  ('Graficacion por Computadoras','E'),
                                                  ('Sistemas de Informacion II','E'),
												                          ('Calculo Numerico','C'),
                                                  ('Probabilidad y Estadistica','D'),
                                                  ('Metodos de Programacion','D'),
                                                  ('Algoritmos Avanzados','D'),
                                                  ('Base de Datos II','E');

INSERT INTO grupo_materia (id_materia,id_docente,grupo,periodo_academico) VALUES (2,5,'A','Primer Semestre');
INSERT INTO grupo_materia (id_materia, id_docente, grupo, periodo_academico)
VALUES
    (2, 5, 'A', 'Primer Semestre'),
    (3, 6, 'B', 'Segundo Semestre'),
    (4, 7, 'C', 'Verano'),
    (5, 8, 'D', 'Invierno'),
    (6, 9, 'A', 'Primer Semestre'),
    (7, 10, 'B', 'Segundo Semestre'),
    (8, 11, 'C', 'Verano'),
    (9, 5, 'D', 'Invierno'),
    (10, 6, 'A', 'Primer Semestre'),
    (2, 7, 'B', 'Segundo Semestre'),
    (2, 8, 'C', 'Verano'),
    (3, 9, 'D', 'Invierno'),
    (4, 10, 'A', 'Primer Semestre'),
    (5, 11, 'B', 'Segundo Semestre'),
    (6, 5, 'C', 'Verano'),
    (7, 6, 'D', 'Invierno'),
    (8, 7, 'A', 'Primer Semestre'),
    (9, 8, 'B', 'Segundo Semestre'),
    (10, 9, 'C', 'Verano'),
    (2, 10, 'D', 'Invierno'),
    (10, 11, 'A', 'Primer Semestre'),
    (3, 5, 'B', 'Segundo Semestre'),
    (4, 6, 'C', 'Verano'),
    (5, 7, 'D', 'Invierno'),
    (6, 8, 'A', 'Primer Semestre'),
    (7, 9, 'B', 'Segundo Semestre'),
    (8, 10, 'C', 'Verano'),
    (9, 11, 'D', 'Invierno'),
    (10, 5, 'A', 'Primer Semestre');

