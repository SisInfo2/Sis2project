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


INSERT INTO Usuarios (nombre,apellido_p,apellido_m) VALUES ('Kevin','Huayllas','Pinto');