--- Indices

CREATE INDEX IInscripcionPersona ON Inscripciones (idPersona);
CREATE INDEX IInscripcionEscuela ON Inscripciones (idEscuela);
CREATE INDEX IInscripcion ON Inscripciones (estadoInscripcion);
CREATE INDEX IPagoInscripcion ON Pagos (idInscripcion);
CREATE INDEX IPago ON Pagos (estadoPago);
CREATE INDEX IEntrenamientoEquipo ON Entrenamientos (idEquipo);
CREATE INDEX IEntrenamiento ON Entrenamientos (estado);
CREATE INDEX IParticipante ON Participantes (idEntrenamiento);
CREATE INDEX IRecibe ON EquiposRecibenEntrenamientos (idEquipo);
CREATE INDEX IJugador ON Jugadores (numeroCamiseta);
