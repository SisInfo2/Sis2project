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
  estado VARCHAR(15) NOT NULL,
  CHECK(
    estado IN ('REGULAR','IRREGULAR')
  ),
  FOREIGN KEY (id_user) REFERENCES usuarios(id_user)
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

INSERT INTO materias (nombre_materia,nivel) VALUES ('Algebra I','A');
