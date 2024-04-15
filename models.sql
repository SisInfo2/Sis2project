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
    nota >= 100 AND nota <=100 AND
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
                                                

INSERT INTO dependencia_materia VALUES 
(6,3),(5,2),(7,4),(38,36),
(9,5),(8,38),(10,38),(46,6),
(40,8),(41,8),
(10,8),(49,8),(47,46),(48,8),(43,38),
(42,39),(50,40),(44,48),(45,43);


INSERT INTO tipo_periodo (tipo) VALUES ('Primer Semestre'),('Segundo Semestre'),('Verano'),('Invierno');

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

INSERT INTO periodo_academico (year,tipo) VALUES 
(2023,1),
(2023,2),
(2023,3),
(2023,4),
(2024,1),
(2024,2),
(2024,3),(2024,4);

INSERT INTO clase (id_estudiante,id_grupo_materia,estado,nota_final) VALUES
(2,59,'APROBADO',100),(2,56,'APROBADO',90),(2,57,'APROBADO',100),(2,58,'APROBADO',90);

INSERT INTO material (id_grupo_materia, titulo, descripcion)
VALUES
    (32, 'Funciones Cuadráticas', 'En este tema, exploraremos cómo determinar las coordenadas del vértice de una función cuadrática. Estas funciones se representan en la forma (f(x) = ax^2 + bx + c). El vértice es un punto crítico que tiene aplicaciones en física, economía y otras áreas. Aprenderemos a aplicar la fórmula del vértice y a interpretar su significado geométrico.'),
    (32, 'Sistemas de Ecuaciones', 'En esta consulta, abordaremos cómo resolver sistemas de ecuaciones lineales utilizando el método de sustitución. Este enfoque implica reemplazar una variable con una expresión equivalente en otra ecuación para encontrar los valores de las incógnitas. Exploraremos ejemplos prácticos y aplicaciones en situaciones del mundo real.'),
    (32, 'Matrices', 'Sumérgete en el mundo de las matrices y aprende cómo multiplicarlas. Las matrices son fundamentales en álgebra lineal y tienen aplicaciones en gráficos por computadora, análisis de datos y transformaciones geométricas. Descubriremos las reglas de la multiplicación de matrices y cómo se relaciona con la composición de transformaciones lineales.'),
    (32, 'Logaritmos', 'Exploraremos las propiedades de los logaritmos, como la regla del producto, la regla del cociente y la regla del cambio de base. Los logaritmos se utilizan para resolver ecuaciones exponenciales y modelar crecimiento y decaimiento. Veremos ejemplos prácticos y aplicaciones en ciencias e ingeniería.'),
    (32, 'Geometría Analítica', ' Calcula la distancia entre dos puntos en un plano utilizando la fórmula de distancia. Este concepto es esencial en geometría analítica y se aplica en navegación, diseño gráfico, posicionamiento GPS y más. Exploraremos ejemplos concretos y su relevancia en la vida cotidiana.'),
    (32, 'Funciones Trigonométricas', 'Sumérgete en el mundo de las funciones trigonométricas y descubre las identidades fundamentales. Exploraremos la identidad pitagórica, las identidades recíprocas y las identidades de suma y resta. Estas relaciones son útiles para simplificar expresiones trigonométricas y resolver problemas en física y astronomía.'),
    (32, 'Probabilidad', 'Comprende cómo la ley de los grandes números se relaciona con la convergencia de la media muestral a la media poblacional a medida que aumenta el tamaño de la muestra. Esto es crucial en estadísticas, teoría de la probabilidad y análisis de datos. Veremos ejemplos prácticos y aplicaciones en el mundo empresarial.'),
    (32, 'Álgebra de Conjuntos', ' Exploraremos las operaciones de intersección y unión entre conjuntos. Estas operaciones son esenciales para resolver problemas de probabilidad, lógica y teoría de conjuntos. Veremos ejemplos concretos y cómo se aplican en situaciones del mundo real.'),
    (32, 'Funciones Exponenciales', ' Investiga cómo las funciones exponenciales modelan el crecimiento acelerado. Comprenderemos conceptos como la base, la tasa de crecimiento y la función inversa logarítmica. Exploraremos aplicaciones en economía, biología y tecnología.'),
    (32, 'Álgebra Booleana', 'Sumérgete en el mundo de la álgebra booleana y explora las puertas lógicas AND, OR y NOT. Estas puertas son fundamentales en electrónica, programación y diseño de circuitos digitales. Veremos ejemplos prácticos y cómo se aplican en sistemas digitales.');


INSERT INTO material (id_grupo_materia, titulo, descripcion)
VALUES
    (33, 'Límites y Continuidad', 'En este tema, exploramos los conceptos de límites y continuidad en funciones. Aprendemos cómo calcular límites, identificar discontinuidades y comprender el comportamiento de una función cerca de un punto. Los límites son fundamentales para derivadas e integrales.'),
    (33, 'Derivadas e Interpretación Geométrica', 'Las derivadas miden la tasa de cambio de una función en un punto dado. Estudiamos cómo encontrar derivadas utilizando reglas como la regla del producto y la regla de la cadena. Además, exploramos la interpretación geométrica de la derivada como la pendiente de la tangente a una curva.'),
    (33, 'Integrales Definidas e Indefinidas', 'Las integrales nos permiten calcular áreas bajo curvas y acumulación de cantidades. Aprendemos a evaluar integrales definidas e indefinidas utilizando técnicas como sustitución y partes. Las integrales son esenciales en física, economía y estadística.'),
    (33, 'Teorema Fundamental del Cálculo', 'Este teorema establece una conexión entre derivadas e integrales. Nos dice que la integral de una función derivable es igual a la diferencia entre los valores de la función en los extremos del intervalo de integración. Es una herramienta poderosa para calcular áreas y resolver problemas de movimiento.'),
    (33, 'Aplicaciones del Cálculo', 'Exploramos cómo el cálculo se aplica en situaciones del mundo real. Desde la modelización de crecimiento poblacional hasta la optimización de costos en ingeniería, el cálculo es una herramienta versátil. Estudiamos ejemplos prácticos y cómo resolver problemas utilizando técnicas de cálculo.');

INSERT INTO material (id_grupo_materia, titulo, descripcion)
VALUES
    (60, 'Límites y Continuidad', 'En este tema, exploramos los conceptos de límites y continuidad en funciones. Aprendemos cómo calcular límites, identificar discontinuidades y comprender el comportamiento de una función cerca de un punto. Los límites son fundamentales para derivadas e integrales.'),
    (60, 'Derivadas e Interpretación Geométrica', 'Las derivadas miden la tasa de cambio de una función en un punto dado. Estudiamos cómo encontrar derivadas utilizando reglas como la regla del producto y la regla de la cadena. Además, exploramos la interpretación geométrica de la derivada como la pendiente de la tangente a una curva.'),
    (60, 'Integrales Definidas e Indefinidas', 'Las integrales nos permiten calcular áreas bajo curvas y acumulación de cantidades. Aprendemos a evaluar integrales definidas e indefinidas utilizando técnicas como sustitución y partes. Las integrales son esenciales en física, economía y estadística.'),
    (60, 'Teorema Fundamental del Cálculo', 'Este teorema establece una conexión entre derivadas e integrales. Nos dice que la integral de una función derivable es igual a la diferencia entre los valores de la función en los extremos del intervalo de integración. Es una herramienta poderosa para calcular áreas y resolver problemas de movimiento.'),
    (60, 'Aplicaciones del Cálculo', 'Exploramos cómo el cálculo se aplica en situaciones del mundo real. Desde la modelización de crecimiento poblacional hasta la optimización de costos en ingeniería, el cálculo es una herramienta versátil. Estudiamos ejemplos prácticos y cómo resolver problemas utilizando técnicas de cálculo.');
INSERT INTO material (id_grupo_materia, titulo, descripcion)
VALUES
    (61, 'Límites y Continuidad', 'En este tema, exploramos los conceptos de límites y continuidad en funciones. Aprendemos cómo calcular límites, identificar discontinuidades y comprender el comportamiento de una función cerca de un punto. Los límites son fundamentales para derivadas e integrales.'),
    (61, 'Derivadas e Interpretación Geométrica', 'Las derivadas miden la tasa de cambio de una función en un punto dado. Estudiamos cómo encontrar derivadas utilizando reglas como la regla del producto y la regla de la cadena. Además, exploramos la interpretación geométrica de la derivada como la pendiente de la tangente a una curva.'),
    (61, 'Integrales Definidas e Indefinidas', 'Las integrales nos permiten calcular áreas bajo curvas y acumulación de cantidades. Aprendemos a evaluar integrales definidas e indefinidas utilizando técnicas como sustitución y partes. Las integrales son esenciales en física, economía y estadística.'),
    (61, 'Teorema Fundamental del Cálculo', 'Este teorema establece una conexión entre derivadas e integrales. Nos dice que la integral de una función derivable es igual a la diferencia entre los valores de la función en los extremos del intervalo de integración. Es una herramienta poderosa para calcular áreas y resolver problemas de movimiento.'),
    (61, 'Aplicaciones del Cálculo', 'Exploramos cómo el cálculo se aplica en situaciones del mundo real. Desde la modelización de crecimiento poblacional hasta la optimización de costos en ingeniería, el cálculo es una herramienta versátil. Estudiamos ejemplos prácticos y cómo resolver problemas utilizando técnicas de cálculo.');

INSERT INTO material (id_grupo_materia, titulo, descripcion)
VALUES
    (42, 'Mecánica de un sistema de partículas', 'Este tema aborda el principio de Galileo, las ecuaciones de Newton y los teoremas de conservación del impulso lineal, impulso angular y energía. También se estudia el movimiento en un campo de fuerzas centrales.'),
    (42, 'Ligaduras y ecuaciones de Lagrange', 'Explora las relaciones entre el hamiltoniano y la energía, así como la deducción variacional de las ecuaciones de Hamilton. También se introduce la teoría de Hamilton-Jacobi.'),
    (42, 'Electrostática:leyes de Coulomb', 'Aprende sobre la carga y la fuerza eléctrica (ley de Coulomb), el campo eléctrico y la energía potencial eléctrica. También se exploran conceptos como el potencial eléctrico y el voltaje.'),
    (42, 'Ondas electromagnéticas e interferencia', 'Introducción a las ondas electromagnéticas y estudio de la interferencia de ondas electromagnéticas. Estos conceptos son fundamentales en la óptica y las comunicaciones.'),
    (42, 'Fotones y átomos en la física cuántica', 'Explora la naturaleza cuántica de los fotones, los átomos y los electrones. Se abordan temas como los números cuánticos, los orbitales y los núcleos.');


call inscribirse(13,32);
call inscribirse(13,33);
call inscribirse(13,42);
call inscribirse(14,32);
call inscribirse(14,33);
call inscribirse(14,42);
call inscribirse(15,32);
call inscribirse(15,33);
call inscribirse(15,42);
call inscribirse(16,32);
call inscribirse(16,33);
call inscribirse(16,42);
call inscribirse(17,32);
call inscribirse(17,33);
call inscribirse(17,42);