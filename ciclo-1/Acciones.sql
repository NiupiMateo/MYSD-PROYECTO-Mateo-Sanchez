--- Acciones de referencia

--- ACCION 1
ALTER TABLE Participantes DROP CONSTRAINT fk_participante_entrenamiento;
ALTER TABLE Participantes
    ADD CONSTRAINT fk_participante_entrenamiento
    FOREIGN KEY (idEntrenamiento)
    REFERENCES Entrenamientos(idEntrenamiento)
    ON DELETE CASCADE;

--- ACCION 2
ALTER TABLE EquiposRecibenEntrenamientos DROP CONSTRAINT fk_recibe_entrenamiento;
ALTER TABLE EquiposRecibenEntrenamientos
    ADD CONSTRAINT fk_recibe_entrenamiento
    FOREIGN KEY (idEntrenamiento)
    REFERENCES Entrenamientos(idEntrenamiento)
    ON DELETE CASCADE;

--- ACCION 3
ALTER TABLE Entrenamientos DROP CONSTRAINT fk_entrenamiento_equipo;
ALTER TABLE Entrenamientos
    ADD CONSTRAINT fk_entrenamiento_equipo
    FOREIGN KEY (idEquipo)
    REFERENCES Equipos(idEquipo)
    ON DELETE CASCADE;

--- ACCION 4
ALTER TABLE Equipos DROP CONSTRAINT fk_equipo_escuela;
ALTER TABLE Equipos
    ADD CONSTRAINT fk_equipo_escuela
    FOREIGN KEY (idEscuela)
    REFERENCES Escuelas(idEscuela)
    ON DELETE CASCADE;

--- ACCION 5
ALTER TABLE Pagos ALTER COLUMN idInscripcion DROP NOT NULL;
ALTER TABLE Pagos DROP CONSTRAINT fk_pago_inscripcion;
ALTER TABLE Pagos
    ADD CONSTRAINT fk_pago_inscripcion
    FOREIGN KEY (idInscripcion)
    REFERENCES Inscripciones(idInscripcion)
    ON DELETE SET NULL;
