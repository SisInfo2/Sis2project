CREATE TABLE usuarios (
  id_user SERIAL PRIMARY KEY,
  nombre VARCHAR(20) NOT NULL,
  apellido_p VARCHAR(25) NOT NULL,
  apellido_m VARCHAR(25),
  correo VARCHAR(40) NOT NULL,
  contrasena VARCHAR() NOT NULL DEFAULT md5('123456'::BYTEA),
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
  estado VARCHAR(15) NOT NULL DEFAULT 'PENDIENTE',
  CHECK(
    grupo IN ('A','B','C','D') AND
    gestion >= 2022 AND gestion <= EXTRACT(YEAR FROM NOW()) AND
    periodo_academico IN('Primer Semestre','Segundo Semestre','Verano','Invierno') AND
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
  nota_final INT DEFAULT 0,
  estado VARCHAR(20) DEFAULT 'CURSANDO' NOT NULL,
  CHECK (
    estado IN ('CURSANDO','ABANDONADO','APROBADO','REPROBADO') AND 
    nota_final >= 0 AND nota_final <= 100
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
                                                  ('Calculo Numerico','C'),
                                                  ('Teoria de Grafos','C'),
                                                  ('Probabilidad y Estadistica','D'),
                                                  ('Metodos de Programacion','D'),
                                                  ('Algoritmos Avanzados','D'),                                                  
                                                  ('Base de Datos I','D'),
                                                  ('Programacion Funcional','D'),
                                                  ('Sistemas de Informacion I','D'),
                                                  ('Taller de Sistemas Operativos','E'),
                                                  ('Graficacion por Computadoras','E'),
                                                  ('Sistemas de Informacion II','E'),
                                                  ('Base de Datos II','E');

INSERT INTO grupo_materia (id_materia,id_docente,grupo,gestion,periodo_academico) VALUES
(2,6,'A',2024,'Primer Semestre'),
(3,7,'B',2024,'Segundo Semestre'),
(4,8,'C',2024,'Invierno'),
(5,9,'D',2024,'Verano'),
(6,10,'A',2024,'Primer Semestre'),
(7,11,'B',2024,'Segundo Semestre'),
(8,6,'C',2024,'Invierno'),
(9,7,'D',2024,'Verano'),
(10,8,'A',2024,'Primer Semestre'),
(36,9,'B',2024,'Segundo Semestre'),
(37,10,'C',2024,'Invierno'),
(38,11,'D',2024,'Verano'),
(39,6,'A',2024,'Primer Semestre'),
(40,7,'B',2024,'Segundo Semestre'),
(41,8,'C',2024,'Invierno'),
(42,9,'D',2024,'Verano'),
(43,10,'A',2024,'Primer Semestre'),
(44,11,'B',2024,'Segundo Semestre'),
(45,6,'C',2024,'Invierno'),
(46,7,'D',2024,'Verano'),
(47,8,'A',2024,'Primer Semestre'),
(48,9,'B',2024,'Segundo Semestre'),
(49,10,'C',2024,'Invierno'),
(50,11,'D',2024,'Verano'),
(2,6,'A',2023,'Primer Semestre'),
(3,7,'B',2023,'Segundo Semestre'),
(4,8,'C',2023,'Invierno'),
(5,9,'D',2023,'Verano');	

UPDATE usuarios SET contrasena = md5(contrasena::bytea);

