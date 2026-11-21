--- Pruebas incorrectas de disparadores

--- ERROR TRIGGER 1: trg_validar_edad_jugador
BEGIN;
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (900800, '9000000800', 'Nino', 'MuyPequeno', CURRENT_DATE - 365, '3908800001', 'nino800@prueba.com');
INSERT INTO Inscripciones (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (900800, DATE '2024-04-01', 'PENDIENTE', 900800, 1);
INSERT INTO Jugadores (idJugador, posicion, numeroCamiseta)
VALUES (900800, 'DELANTERO', 99);
ROLLBACK;

--- ERROR TRIGGER 2: trg_obs_participante
BEGIN;
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (900801, '9000000801', 'Test', 'Negativo2', DATE '2010-05-10', '3908800002', 'test801@prueba.com');
INSERT INTO Entrenamientos (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (900800, DATE '2024-05-27', TIMESTAMP '2024-05-27 17:00:00', 'Cancha Test', 'PROGRAMADO', 1);
INSERT INTO Participantes (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (900801, 900800, 'N', 'ROL_INVALIDO', NULL);
ROLLBACK;

--- ERROR TRIGGER 3: trg_obs_recibe
BEGIN;
INSERT INTO Entrenamientos (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (900801, DATE '2024-05-27', TIMESTAMP '2024-05-27 17:00:00', 'Cancha Test', 'PROGRAMADO', 1);
INSERT INTO EquiposRecibenEntrenamientos (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (900801, 1, 'X', NULL);
ROLLBACK;

--- ERROR TRIGGER 4: trg_validar_numero_camiseta_equipo
BEGIN;
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (900802, '9000000802', 'Otro', 'Jugador', DATE '2012-03-15', '3908800003', 'otro802@prueba.com');
INSERT INTO Inscripciones (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (900802, DATE '2024-04-01', 'PENDIENTE', 900802, 1);
INSERT INTO Jugadores (idJugador, posicion, numeroCamiseta)
SELECT 900802, 'DEFENSA', j.numeroCamiseta
FROM Jugadores j JOIN Inscripciones i ON i.idPersona = j.idJugador
WHERE i.idEscuela = 1
LIMIT 1;
ROLLBACK;

--- ERROR TRIGGER 5: trg_actualizar_estado_inscripcion
BEGIN;
INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (900800, DATE '2024-04-05', 120000.00, 'PAGADO', 'EFECTIVO', 9999999);
ROLLBACK;

--- ERROR TRIGGER 6: trg_fecha_pago_automatica
BEGIN;
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (900803, '9000000803', 'Test', 'Negativo6', DATE '2010-05-10', '3908800004', 'test803@prueba.com');
INSERT INTO Inscripciones (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (900803, DATE '2024-04-01', 'PENDIENTE', 900803, 1);
INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (900803, DATE '2024-04-06', -50000.00, 'PAGADO', 'TRANSFERENCIA', 900803);
ROLLBACK;
