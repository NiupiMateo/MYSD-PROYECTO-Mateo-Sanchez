--- Llaves primarias

ALTER TABLE Personas ADD CONSTRAINT pk_persona PRIMARY KEY (idPersona);
ALTER TABLE Jugadores ADD CONSTRAINT pk_jugador PRIMARY KEY (idJugador);
ALTER TABLE Acudientes ADD CONSTRAINT pk_acudiente PRIMARY KEY (idAcudiente);
ALTER TABLE Administradores ADD CONSTRAINT pk_administrador PRIMARY KEY (idAdministrador);
ALTER TABLE Entrenadores ADD CONSTRAINT pk_entrenador PRIMARY KEY (idEntrenador);
ALTER TABLE Escuelas ADD CONSTRAINT pk_escuela PRIMARY KEY (idEscuela);
ALTER TABLE Categorias ADD CONSTRAINT pk_categoria PRIMARY KEY (idCategoria);
ALTER TABLE Equipos ADD CONSTRAINT pk_equipo PRIMARY KEY (idEquipo);
ALTER TABLE Inscripciones ADD CONSTRAINT pk_inscripcion PRIMARY KEY (idInscripcion);
ALTER TABLE Pagos ADD CONSTRAINT pk_pago PRIMARY KEY (idPago);
ALTER TABLE Entrenamientos ADD CONSTRAINT pk_entrenamiento PRIMARY KEY (idEntrenamiento);
ALTER TABLE Participantes ADD CONSTRAINT pk_participante PRIMARY KEY (idPersona, idEntrenamiento);
ALTER TABLE EquiposRecibenEntrenamientos ADD CONSTRAINT pk_recibe PRIMARY KEY (idEntrenamiento, idEquipo);
