--- Pruebas de acciones de referencia

BEGIN;

INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (900400, 'Escuela Acciones Test', 'Calle Test Acciones 1', '6909900401', 'test400@acciones.com');
INSERT INTO Categorias (idCategoria, nombre, descripcion, nivel)
VALUES (900400, 'SUB14', 'Categoria Test Acciones', 'BASICO');
INSERT INTO Equipos (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
VALUES (900400, 'Equipo Acciones 400', 'ACTIVO', 900400, 900400);
INSERT INTO Entrenamientos (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (900400, DATE '2024-05-25', TIMESTAMP '2024-05-25 18:00:00', 'Cancha Test', 'PROGRAMADO', 900400);
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (900400, '9000000400', 'Test', 'Acciones', DATE '2010-05-10', '3909900402', 'test400@prueba.com');
INSERT INTO Inscripciones (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (900400, DATE '2024-04-01', 'ACTIVA', 900400, 900400);
INSERT INTO Participantes (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (900400, 900400, 'S', 'JUGADOR', 'Test participante');
INSERT INTO EquiposRecibenEntrenamientos (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (900400, 900400, 'S', 'Test recibe');
INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (900400, DATE '2024-04-01', 120000.00, 'PAGADO', 'EFECTIVO', 900400);

--- ACCION 1: Participante a Entrenamiento (CASCADE)
SAVEPOINT a1;
DELETE FROM Entrenamientos WHERE idEntrenamiento = 900400;
SELECT COUNT(*) AS "Participantes tras delete" FROM Participantes WHERE idEntrenamiento = 900400;
ROLLBACK TO a1;

--- ACCION 2: Recibe a Entrenamiento (CASCADE)
SAVEPOINT a2;
DELETE FROM Entrenamientos WHERE idEntrenamiento = 900400;
SELECT COUNT(*) AS "Recibe tras delete" FROM EquiposRecibenEntrenamientos WHERE idEntrenamiento = 900400;
ROLLBACK TO a2;

--- ACCION 3: Entrenamiento a Equipo (CASCADE)
SAVEPOINT a3;

DELETE FROM EquiposRecibenEntrenamientos WHERE idEquipo = 900400;
DELETE FROM Equipos WHERE idEquipo = 900400;
SELECT COUNT(*) AS "Entrenamientos tras delete" FROM Entrenamientos WHERE idEquipo = 900400;
ROLLBACK TO a3;

--- ACCION 4: Equipo a Escuela (CASCADE)
SAVEPOINT a4;
DELETE FROM EquiposRecibenEntrenamientos WHERE idEquipo = 900400;
DELETE FROM Pagos WHERE idPago = 900400;
DELETE FROM Inscripciones WHERE idInscripcion = 900400;
DELETE FROM Escuelas WHERE idEscuela = 900400;
SELECT COUNT(*) AS "Equipos tras delete" FROM Equipos WHERE idEscuela = 900400;
ROLLBACK TO a4;

--- ACCION 5: Pago a Inscripcion (SET NULL)
SAVEPOINT a5;
SELECT idPago, idInscripcion FROM Pagos WHERE idPago = 900400;
DELETE FROM Inscripciones WHERE idInscripcion = 900400;
SELECT idPago, idInscripcion FROM Pagos WHERE idPago = 900400;
ROLLBACK TO a5;

ROLLBACK;
