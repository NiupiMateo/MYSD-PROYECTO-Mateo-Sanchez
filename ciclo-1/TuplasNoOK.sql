--- Pruebas incorrectas de restricciones de tupla

--- ERROR TEST 1: Participante con asistencia S pero sin observaciones (DEBE FALLAR)
BEGIN;
INSERT INTO Participantes (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (2, 1, 'S', 'JUGADOR', NULL);
ROLLBACK;

--- ERROR TEST 2: Recibe con asistencia S pero sin observaciones (DEBE FALLAR)
BEGIN;
INSERT INTO EquiposRecibenEntrenamientos (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (1, 2, 'S', NULL);
ROLLBACK;

--- ERROR TEST 3: Pago con monto negativo (DEBE FALLAR)
BEGIN;
INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (900999, DATE '2024-04-01', -50000.00, 'PAGADO', 'EFECTIVO', 1);
ROLLBACK;
