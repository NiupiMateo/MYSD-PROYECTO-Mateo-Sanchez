--- CRUD

--- T2B: CRUD sobre las tablas

--- CRUD 1: Inscripciones y Pagos

BEGIN;

--- CREATE 1: persona nueva e inscripcion en la escuela 1
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (910001, '9100000001', 'Mateo', 'Sanchez', DATE '2012-04-15', '3910000001', 'mateo.sanchez910001@mail.com');

INSERT INTO Inscripciones (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (910001, CURRENT_DATE, 'PENDIENTE', 910001, 1);

SELECT idInscripcion, estadoInscripcion, idPersona, idEscuela FROM Inscripciones WHERE idInscripcion = 910001;

--- CREATE 2: pago PAGADO sin fecha
INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (910001, NULL, 150000.00, 'PAGADO', 'TRANSFERENCIA', 910001);

SELECT idPago, fechaPago, estadoPago FROM Pagos WHERE idPago = 910001;
SELECT idInscripcion, estadoInscripcion FROM Inscripciones WHERE idInscripcion = 910001;

--- READ 1: inscripciones con pagos pendientes de la escuela 1
SELECT i.idInscripcion, pe.nombre, pe.apellido, i.estadoInscripcion,
       COALESCE(SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto ELSE 0 END), 0) AS montoPendiente
FROM Inscripciones i
JOIN Personas pe ON i.idPersona = pe.idPersona
LEFT JOIN Pagos p ON i.idInscripcion = p.idInscripcion
WHERE i.idEscuela = 1
GROUP BY i.idInscripcion, pe.nombre, pe.apellido, i.estadoInscripcion
HAVING COALESCE(SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto ELSE 0 END), 0) > 0
ORDER BY montoPendiente DESC;

--- READ 2: inscripciones de la escuela 1
SELECT i.idInscripcion, pe.nombre, pe.apellido, i.fechaInscripcion, i.estadoInscripcion, e.nombre AS escuela
FROM Inscripciones i
JOIN Personas pe ON i.idPersona = pe.idPersona
JOIN Escuelas e ON i.idEscuela = e.idEscuela
WHERE i.idEscuela = 1
ORDER BY i.fechaInscripcion DESC;

--- READ 3: recaudo total de la escuela 1
SELECT e.nombre AS escuela,
       COUNT(p.idPago) AS totalPagos,
       COALESCE(SUM(CASE WHEN p.estadoPago = 'PAGADO' THEN p.monto END), 0) AS totalRecaudado,
       COALESCE(SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto END), 0) AS totalPendiente
FROM Escuelas e
LEFT JOIN Inscripciones i ON e.idEscuela = i.idEscuela
LEFT JOIN Pagos p ON i.idInscripcion = p.idInscripcion
WHERE e.idEscuela = 1
GROUP BY e.nombre;

--- UPDATE 1: cancelar la inscripcion
UPDATE Inscripciones SET estadoInscripcion = 'CANCELADA' WHERE idInscripcion = 910001;
SELECT idInscripcion, estadoInscripcion FROM Inscripciones WHERE idInscripcion = 910001;

--- UPDATE 2: reactivar la inscripcion
UPDATE Inscripciones SET estadoInscripcion = 'ACTIVA' WHERE idInscripcion = 910001;
SELECT idInscripcion, estadoInscripcion FROM Inscripciones WHERE idInscripcion = 910001;

--- UPDATE 3: estado invalido (DEBE FALLAR)
SAVEPOINT prueba_check;
UPDATE Inscripciones SET estadoInscripcion = 'SUSPENDIDA' WHERE idInscripcion = 910001;
ROLLBACK TO prueba_check;

--- DELETE: el pago queda con idInscripcion en NULL
DELETE FROM Inscripciones WHERE idInscripcion = 910001;
SELECT COUNT(*) AS inscripcionEliminada FROM Inscripciones WHERE idInscripcion = 910001;
SELECT idPago, monto, estadoPago, idInscripcion FROM Pagos WHERE idPago = 910001;

--- Limpiar
DELETE FROM Pagos WHERE idPago = 910001;
DELETE FROM Personas WHERE idPersona = 910001;

ROLLBACK;

--- CRUD 2: Entrenamientos y Participantes

BEGIN;

--- CREATE 1: nuevo entrenamiento para el equipo 1
INSERT INTO Entrenamientos (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (910001, DATE '2026-11-15', TIMESTAMP '2026-11-15 10:00:00', 'Cancha Principal Norte', 'PROGRAMADO', 1);

SELECT * FROM Entrenamientos WHERE idEntrenamiento = 910001;

--- CREATE 2: asistencia N sin observacion
INSERT INTO Participantes (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (1, 910001, 'N', 'JUGADOR', NULL);

SELECT idPersona, asistencia, observaciones FROM Participantes WHERE idPersona = 1 AND idEntrenamiento = 910001;

--- CREATE 3: asistencia S con observacion
INSERT INTO Participantes (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (2, 910001, 'S', 'JUGADOR', 'Excelente sesion de tactica');

--- CREATE 4: equipo con asistencia N sin observacion
INSERT INTO EquiposRecibenEntrenamientos (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (910001, 1, 'N', NULL);

SELECT * FROM EquiposRecibenEntrenamientos WHERE idEntrenamiento = 910001;

--- CREATE 5: asistencia S sin observacion (DEBE FALLAR)
SAVEPOINT prueba_tupla;
INSERT INTO Participantes (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (3, 910001, 'S', 'JUGADOR', NULL);
ROLLBACK TO prueba_tupla;

--- READ 1: entrenamientos programados del equipo 1
SELECT eq.nombre AS equipo, en.idEntrenamiento,
       to_char(en.fecha, 'DD/MM/YYYY') AS fecha,
       to_char(en.hora, 'HH24:MI') AS hora,
       en.lugar, en.estado
FROM Equipos eq
JOIN Entrenamientos en ON eq.idEquipo = en.idEquipo
WHERE en.estado = 'PROGRAMADO' AND eq.idEquipo = 1
ORDER BY en.fecha, en.hora;

--- READ 2: asistencia del entrenamiento 910001
SELECT pe.nombre, pe.apellido, pa.rol, pa.asistencia, pa.observaciones
FROM Participantes pa
JOIN Personas pe ON pa.idPersona = pe.idPersona
WHERE pa.idEntrenamiento = 910001
ORDER BY pe.idPersona;

--- READ 3: estadistica de asistencia del entrenamiento 910001
SELECT COUNT(*) AS totalParticipantes,
       SUM(CASE WHEN asistencia = 'S' THEN 1 ELSE 0 END) AS asistentes,
       SUM(CASE WHEN asistencia = 'N' THEN 1 ELSE 0 END) AS inasistentes,
       ROUND(100.0 * SUM(CASE WHEN asistencia = 'S' THEN 1 ELSE 0 END) / COUNT(*), 2) AS porcentajeAsistencia
FROM Participantes
WHERE idEntrenamiento = 910001;

--- READ 4: jugadores del equipo 1
SELECT DISTINCT pe.idPersona, pe.nombre, pe.apellido, j.posicion, j.numeroCamiseta
FROM Equipos eq
JOIN Entrenamientos en ON eq.idEquipo = en.idEquipo
JOIN Participantes pa ON en.idEntrenamiento = pa.idEntrenamiento
JOIN Personas pe ON pa.idPersona = pe.idPersona
JOIN Jugadores j ON pe.idPersona = j.idJugador
WHERE pa.rol = 'JUGADOR' AND eq.idEquipo = 1
ORDER BY pe.apellido, pe.nombre;

--- UPDATE 1: de N a S con observacion
UPDATE Participantes
SET asistencia = 'S', observaciones = 'Llego tarde pero participo activamente'
WHERE idPersona = 1 AND idEntrenamiento = 910001;
SELECT idPersona, asistencia, observaciones FROM Participantes WHERE idPersona = 1 AND idEntrenamiento = 910001;

--- UPDATE 2: pasar a S sin observacion (DEBE FALLAR)
SAVEPOINT prueba_update;
UPDATE Participantes SET asistencia = 'S', observaciones = NULL
WHERE idPersona = 2 AND idEntrenamiento = 910001;
ROLLBACK TO prueba_update;

--- UPDATE 3: el entrenamiento pasa a REALIZADO
UPDATE Entrenamientos SET estado = 'REALIZADO' WHERE idEntrenamiento = 910001;
SELECT idEntrenamiento, estado FROM Entrenamientos WHERE idEntrenamiento = 910001;

--- DELETE: borra en cascada participantes y recibe
SELECT (SELECT COUNT(*) FROM Participantes WHERE idEntrenamiento = 910001) AS participantesAntes,
       (SELECT COUNT(*) FROM EquiposRecibenEntrenamientos WHERE idEntrenamiento = 910001) AS recibeAntes;

DELETE FROM Entrenamientos WHERE idEntrenamiento = 910001;

SELECT (SELECT COUNT(*) FROM Entrenamientos WHERE idEntrenamiento = 910001) AS entrenamiento,
       (SELECT COUNT(*) FROM Participantes WHERE idEntrenamiento = 910001) AS participantesCascade,
       (SELECT COUNT(*) FROM EquiposRecibenEntrenamientos WHERE idEntrenamiento = 910001) AS recibeCascade;

ROLLBACK;

--- T3A: CRUD con componentes

--- CRUD 1: PC_INSCRIPCION

BEGIN;

--- Datos base
INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (920001, 'Escuela CRUD Componentes', 'Calle CRUD 1', '6920001001', 'crud920001@escuela.com');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (920001, '9200010001', 'Mateo', 'Sanchez', DATE '2012-04-15', '3920001001', 'mateo.sanchez920001@mail.com');

--- CREATE 1: AD_INSCRIPCION, queda PENDIENTE con la fecha de hoy
CALL PC_INSCRIPCION.AD_INSCRIPCION(920001, 920001, 920001);

--- CREATE 2: segunda inscripcion vigente en la misma escuela (DEBE FALLAR)
SAVEPOINT crear_duplicada;
CALL PC_INSCRIPCION.AD_INSCRIPCION(920002, 920001, 920001);
ROLLBACK TO crear_duplicada;

--- READ: CO_INSCRIPCION, inscripciones de la escuela
SELECT * FROM PC_INSCRIPCION.CO_INSCRIPCION(920001);

--- UPDATE 1: cancelar con un pago pendiente (DEBE FALLAR)
CALL PC_PAGO.AD_PAGO(920001, 150000.00, 'PENDIENTE', 'EFECTIVO', 920001);
SAVEPOINT cancelar_con_pendiente;
CALL PC_INSCRIPCION.MO_INSCRIPCION(920001, 'CANCELADA');
ROLLBACK TO cancelar_con_pendiente;

--- UPDATE 2: MO_INSCRIPCION, sin pagos pendientes se cancela
CALL PC_PAGO.MO_PAGO(920001, 150000.00, 'PAGADO');
CALL PC_INSCRIPCION.MO_INSCRIPCION(920001, 'CANCELADA');
SELECT idInscripcion, estadoInscripcion FROM PC_INSCRIPCION.CO_INSCRIPCION(920001);

--- DELETE 1: eliminar una inscripcion con pagos (DEBE FALLAR)
SAVEPOINT eliminar_con_pagos;
CALL PC_INSCRIPCION.EL_INSCRIPCION(920001);
ROLLBACK TO eliminar_con_pagos;

--- DELETE 2: EL_INSCRIPCION, sin pagos se elimina
CALL PC_INSCRIPCION.AD_INSCRIPCION(920003, 920001, 920001);
CALL PC_INSCRIPCION.EL_INSCRIPCION(920003);
SELECT idInscripcion, estadoInscripcion FROM PC_INSCRIPCION.CO_INSCRIPCION(920001);

ROLLBACK;

--- CRUD 2: PC_ENTRENAMIENTO

BEGIN;

--- Datos base
INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (920100, 'Escuela CRUD Componentes 2', 'Calle CRUD 2', '6920100001', 'crud920100@escuela.com');
INSERT INTO Categorias (idCategoria, nombre, descripcion, nivel)
VALUES (920100, 'SUB12', 'Categoria CRUD', 'BASICO');
INSERT INTO Equipos (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
VALUES (920100, 'Equipo CRUD', 'ACTIVO', 920100, 920100);
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (920100, '9201000001', 'Carlos', 'Rojas', DATE '1990-01-15', '3920100001', 'carlos.rojas920100@mail.com');

--- CREATE 1: AD_ENTRENAMIENTO, queda PROGRAMADO
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(920100, CURRENT_DATE + 7, TIME '16:00', 'Cancha Principal', 920100);

--- CREATE 2: entrenamiento con fecha pasada (DEBE FALLAR)
SAVEPOINT crear_pasado;
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(920101, CURRENT_DATE - 1, TIME '16:00', 'Cancha Principal', 920100);
ROLLBACK TO crear_pasado;

--- READ: CO_ENTRENAMIENTO, entrenamientos del equipo
SELECT * FROM PC_ENTRENAMIENTO.CO_ENTRENAMIENTO(920100);

--- UPDATE 1: MO_ENTRENAMIENTO, sin asistencias se reprograma
CALL PC_ENTRENAMIENTO.MO_ENTRENAMIENTO(920100, CURRENT_DATE + 8, TIME '17:30', 'Cancha Sintetica', 'PROGRAMADO');
SELECT idEntrenamiento, fecha, hora, lugar, estado FROM PC_ENTRENAMIENTO.CO_ENTRENAMIENTO(920100);

--- UPDATE 2: cambiar la fecha con asistencias registradas (DEBE FALLAR)
CALL PC_ASISTENCIA.AD_ASISTENCIA(920100, 920100, 'S', 'ENTRENADOR', 'Dirigio la sesion');
SAVEPOINT mover_con_asistencias;
CALL PC_ENTRENAMIENTO.MO_ENTRENAMIENTO(920100, CURRENT_DATE + 15, TIME '17:30', 'Cancha Sintetica', 'PROGRAMADO');
ROLLBACK TO mover_con_asistencias;

--- DELETE 1: eliminar un entrenamiento con asistencias (DEBE FALLAR)
SAVEPOINT eliminar_con_asistencias;
CALL PC_ENTRENAMIENTO.EL_ENTRENAMIENTO(920100);
ROLLBACK TO eliminar_con_asistencias;

--- DELETE 2: EL_ENTRENAMIENTO, sin asistencias se elimina
CALL PC_ASISTENCIA.EL_ASISTENCIA(920100, 920100);
CALL PC_ENTRENAMIENTO.EL_ENTRENAMIENTO(920100);
SELECT COUNT(*) AS entrenamientos FROM PC_ENTRENAMIENTO.CO_ENTRENAMIENTO(920100);

ROLLBACK;
