--- Llaves foraneas

ALTER TABLE Jugadores ADD CONSTRAINT fk_jugador_persona FOREIGN KEY (idJugador) REFERENCES Personas(idPersona);
ALTER TABLE Acudientes ADD CONSTRAINT fk_acudiente_persona FOREIGN KEY (idAcudiente) REFERENCES Personas(idPersona);
ALTER TABLE Administradores ADD CONSTRAINT fk_administrador_persona FOREIGN KEY (idAdministrador) REFERENCES Personas(idPersona);
ALTER TABLE Entrenadores ADD CONSTRAINT fk_entrenador_persona FOREIGN KEY (idEntrenador) REFERENCES Personas(idPersona);
ALTER TABLE Equipos ADD CONSTRAINT fk_equipo_escuela FOREIGN KEY (idEscuela) REFERENCES Escuelas(idEscuela);
ALTER TABLE Equipos ADD CONSTRAINT fk_equipo_categoria FOREIGN KEY (idCategoria) REFERENCES Categorias(idCategoria);
ALTER TABLE Inscripciones ADD CONSTRAINT fk_inscripcion_persona FOREIGN KEY (idPersona) REFERENCES Personas(idPersona);
ALTER TABLE Inscripciones ADD CONSTRAINT fk_inscripcion_escuela FOREIGN KEY (idEscuela) REFERENCES Escuelas(idEscuela);
ALTER TABLE Pagos ADD CONSTRAINT fk_pago_inscripcion FOREIGN KEY (idInscripcion) REFERENCES Inscripciones(idInscripcion);
ALTER TABLE Entrenamientos ADD CONSTRAINT fk_entrenamiento_equipo FOREIGN KEY (idEquipo) REFERENCES Equipos(idEquipo);
ALTER TABLE Participantes ADD CONSTRAINT fk_participante_persona FOREIGN KEY (idPersona) REFERENCES Personas(idPersona);
ALTER TABLE Participantes ADD CONSTRAINT fk_participante_entrenamiento FOREIGN KEY (idEntrenamiento) REFERENCES Entrenamientos(idEntrenamiento);
ALTER TABLE EquiposRecibenEntrenamientos ADD CONSTRAINT fk_recibe_entrenamiento FOREIGN KEY (idEntrenamiento) REFERENCES Entrenamientos(idEntrenamiento);
ALTER TABLE EquiposRecibenEntrenamientos ADD CONSTRAINT fk_recibe_equipo FOREIGN KEY (idEquipo) REFERENCES Equipos(idEquipo);
