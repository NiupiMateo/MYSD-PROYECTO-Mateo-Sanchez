--- Pruebas correctas de disparadores

BEGIN;

INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (900600, '9000000600', 'Test', 'Disparador1', DATE '2015-05-10', '3909900020', 'test600@prueba.com');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (900601, '9000000601', 'Test', 'Disparador2', DATE '2014-03-22', '3909900021', 'test601@prueba.com');
INSERT INTO Inscripciones (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (900600, DATE '2024-04-01', 'PENDIENTE', 900600, 1);
INSERT INTO Inscripciones (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (900601, DATE '2024-04-01', 'PENDIENTE', 900601, 1);
INSERT INTO Entrenamientos (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (900600, DATE '2024-05-27', TIMESTAMP '2024-05-27 17:00:00', 'Cancha Test', 'PROGRAMADO', 1);

--- TRIGGER 1: trg_validar_edad_jugador
INSERT INTO Jugadores (idJugador, posicion, numeroCamiseta)
VALUES (900600, 'DELANTERO', 77);
SELECT * FROM Jugadores WHERE idJugador = 900600;

--- TRIGGER 2: trg_obs_participante
INSERT INTO Participantes (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (900600, 900600, 'N', 'JUGADOR', NULL);
SELECT observaciones FROM Participantes WHERE idPersona = 900600 AND idEntrenamiento = 900600;

--- TRIGGER 3: trg_obs_recibe
INSERT INTO EquiposRecibenEntrenamientos (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (900600, 1, 'N', NULL);
SELECT observaciones FROM EquiposRecibenEntrenamientos WHERE idEntrenamiento = 900600 AND idEquipo = 1;

--- TRIGGER 4: trg_actualizar_estado_inscripcion
INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (900600, CURRENT_DATE, 120000.00, 'PAGADO', 'EFECTIVO', 900600);
SELECT estadoInscripcion FROM Inscripciones WHERE idInscripcion = 900600;

--- TRIGGER 5: trg_validar_numero_camiseta_equipo
INSERT INTO Jugadores (idJugador, posicion, numeroCamiseta)
VALUES (900601, 'DEFENSA', 88);
SELECT * FROM Jugadores WHERE idJugador = 900601;

--- TRIGGER 6: trg_fecha_pago_automatica
INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (900601, NULL, 150000.00, 'PAGADO', 'TRANSFERENCIA', 900601);
SELECT fechaPago FROM Pagos WHERE idPago = 900601;

ROLLBACK;
