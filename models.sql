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

CREATE TABLE Dependencia_Materia (
  id_materia INT,
  id_dependencia INT,
  FOREIGN KEY (id_dependencia)
  REFERENCES Materias(id_materia),
  FOREIGN KEY (id_materia) REFERENCES Materias(id_materia),
  PRIMARY KEY(id_materia,id_dependencia)
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

CREATE TABLE tipo_periodo (
	id_tipo_periodo SERIAL PRIMARY KEY,
	tipo VARCHAR(30) NOT NULL,
	CHECK (
		tipo INT ('Primer Semestre', 'Segundo Semestre','Verano','Invierno')
	)
);


CREATE TABLE periodo_academico (
	id_periodo SERIAL PRIMARY KEY,
	year INT NOT NULL DEFAULT EXTRACT(YEAR FROM NOW()),
	tipo INT NOT NULL,
	activo BOOLEAN NOT NULL DEFAULT TRUE,
	CHECK (
	 	year >= 2022 AND year <= EXTRACT(YEAR FROM NOW())
	),
	FOREIGN KEY tipo REFERENCES tipo_periodo(id_tipo_periodo)
	
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
    nota_final >= 0 AND nota_final <= 100 AND
    id_grupo_materia IN (
      SELECT id_materia from obtenerMateriasAbiertas(id_estudiante)
    )
  ),
  PRIMARY KEY (id_clase,id_estudiante,id_grupo_materia),
  FOREIGN KEY (id_grupo_materia) REFERENCES grupo_materia(id_grupo_materia),
  FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_user),
  FOREIGN KEY (periodo_academico) REFERENCES periodo_academico(id_periodo)
);

CREATE TABLE Formato (
  id_formato SERIAL PRIMARY KEY,
  nombre_formato VARCHAR UNIQUE NOT NULL
);

CREATE TABLE Archivo (
  id_archivo SERIAL PRIMARY KEY,
  formato INT,
  nombre_archivo VARCHAR,
  Contenido BYTEA NOT NULL
);

CREATE TABLE Material (
  id_material SERIAL UNIQUE,
  id_grupo_materia INT,
  titulo VARCHAR(40) NOT NULL,
  descripcion VARCHAR,
  PRIMARY KEY (id_material,id_grupo_materia),
  FOREIGN KEY (id_grupo_materia) REFERENCES grupo_materia(id_grupo_materia)

);

CREATE TABLE material_archivo (
  id_material INT,
  id_archivo INT,
  FOREIGN KEY (id_material) REFERENCES Material(id_material),
  FOREIGN KEY (id_archivo) REFERENCES Archivo(id_archivo),
  PRIMARY KEY(id_material,id_archivo)
);

CREATE TABLE Tarea (
  id_tarea SERIAL UNIQUE,
  id_clase INT,
  nota INT NOT NULL,
  comentario_docente VARCHAR,
  estado VARCHAR NOT NULL DEFAULT 'SIN ENTREGAR', 
  descripcion VARCHAR,
  fecha_limite timestamp NOT NULL,
  CHECK(
    nota >= 0 AND nota <=100 AND
    estado IN ('SIN ENTREGAR','ENTREGADO','RETRASO')
  ),
  PRIMARY KEY (id_tarea,id_clase),
  FOREIGN KEY (id_clase) REFERENCES clase(id_clase)
);


CREATE TABLE Tarea_Archivo (
  id_tarea INT,
  id_archivo INT,
  FOREIGN KEY (id_tarea) REFERENCES Tarea(id_tarea),
  FOREIGN KEY (id_archivo) REFERENCES Archivo(id_archivo),
  PRIMARY KEY (id_tarea,id_archivo)
);


