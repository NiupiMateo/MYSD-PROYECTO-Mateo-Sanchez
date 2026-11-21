--- Ingreso de datos incorrectos

--- PRIMARY KEY duplicada
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (1, '9000000001', 'Prueba', 'Duplicada', DATE '2010-01-01', '3990000001', 'pk.duplicada@prueba.com');

--- UNIQUE documento
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (900901, (SELECT documento FROM Personas WHERE idPersona = 1), 'Prueba', 'Documento', DATE '2010-01-01', '3990000901', 'documento.901@prueba.com');

--- UNIQUE correo
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (900902, '9000000902', 'Prueba', 'Correo', DATE '2010-01-01', '3990000902', (SELECT correo FROM Personas WHERE idPersona = 1));

--- FOREIGN KEY: persona inexistente
INSERT INTO Acudientes (idAcudiente, parentesco)
VALUES (9999999, 'PADRE');

--- NOT NULL
INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (900901, DATE '2026-01-01', 50000, 'PAGADO', NULL, 1);

--- CHECK de valor positivo
INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (900902, DATE '2026-01-01', -1000, 'PAGADO', 'EFECTIVO', 1);

--- CHECK de dominio
INSERT INTO Entrenamientos (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (900901, DATE '2026-01-01', TIMESTAMP '2026-01-01 09:00:00', 'Cancha de prueba', 'APLAZADO', 1);

--- PK compuesta duplicada en Participantes
INSERT INTO Participantes (idPersona, idEntrenamiento, asistencia, rol, observaciones)
SELECT idPersona, idEntrenamiento, 'S', 'JUGADOR', 'Duplicado de prueba'
FROM Participantes
LIMIT 1;
