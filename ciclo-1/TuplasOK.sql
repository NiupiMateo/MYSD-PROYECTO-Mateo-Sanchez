--- Pruebas correctas de restricciones de tupla

BEGIN;

INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (900500, '9000000500', 'Test', 'Tuplas1', DATE '2010-05-10', '3909900010', 'test500@prueba.com');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (900501, '9000000501', 'Test', 'Tuplas2', DATE '2011-03-22', '3909900011', 'test501@prueba.com');
INSERT INTO Entrenamientos (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (900500, DATE '2024-05-26', TIMESTAMP '2024-05-26 16:00:00', 'Cancha Test', 'PROGRAMADO', 1);

--- TEST 1.1: Participante con asistencia S y observaciones (pasa)
INSERT INTO Participantes (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (900500, 900500, 'S', 'JUGADOR', 'Excelente asistencia');
SELECT * FROM Participantes WHERE idPersona = 900500 AND idEntrenamiento = 900500;

--- TEST 1.2: Participante con asistencia N y observaciones NULL (pasa)
INSERT INTO Participantes (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (900501, 900500, 'N', 'JUGADOR', NULL);
SELECT idPersona, asistencia, observaciones FROM Participantes WHERE idPersona = 900501 AND idEntrenamiento = 900500;

--- TEST 2.1: Recibe con asistencia S y observaciones (pasa)
INSERT INTO EquiposRecibenEntrenamientos (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (900500, 1, 'S', 'Equipo asistio correctamente');
SELECT * FROM EquiposRecibenEntrenamientos WHERE idEntrenamiento = 900500 AND idEquipo = 1;
DELETE FROM EquiposRecibenEntrenamientos WHERE idEntrenamiento = 900500 AND idEquipo = 1;

--- TEST 2.2: Recibe con asistencia N y observaciones NULL (pasa)
INSERT INTO EquiposRecibenEntrenamientos (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (900500, 1, 'N', NULL);
SELECT * FROM EquiposRecibenEntrenamientos WHERE idEntrenamiento = 900500 AND idEquipo = 1;

--- TEST 3.1: Pago PAGADO con monto > 0 (pasa)
INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (900500, CURRENT_DATE, 150000.00, 'PAGADO', 'TRANSFERENCIA', 1);
SELECT * FROM Pagos WHERE idPago = 900500;

--- TEST 3.2: Pago PENDIENTE con monto > 0 (pasa)
INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (900501, CURRENT_DATE, 100000.00, 'PENDIENTE', 'EFECTIVO', 1);
SELECT * FROM Pagos WHERE idPago = 900501;

--- TEST 3.3: Pago ANULADO con monto > 0 (pasa)
INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (900502, CURRENT_DATE, 50000.00, 'ANULADO', 'TARJETA', 1);
SELECT * FROM Pagos WHERE idPago = 900502;

ROLLBACK;
