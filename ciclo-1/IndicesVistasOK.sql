--- Consultas que requieren los indices y las vistas

--- INDICES

--- IInscripcionPersona: inscripciones de una persona
SELECT idInscripcion, fechaInscripcion, estadoInscripcion, idEscuela
FROM Inscripciones
WHERE idPersona = 1;

--- IInscripcionEscuela: inscripciones de una escuela
SELECT idInscripcion, idPersona, fechaInscripcion, estadoInscripcion
FROM Inscripciones
WHERE idEscuela = 7132
ORDER BY fechaInscripcion DESC;

--- IInscripcion: cantidad de inscripciones pendientes
SELECT COUNT(*) AS inscripcionesPendientes
FROM Inscripciones
WHERE estadoInscripcion = 'PENDIENTE';

--- IPagoInscripcion: pagos de una inscripcion
SELECT idPago, fechaPago, monto, estadoPago, metodoPago
FROM Pagos
WHERE idInscripcion = 3824;

--- IPago: total pendiente por cobrar
SELECT COUNT(*) AS pagosPendientes, SUM(monto) AS totalPendiente
FROM Pagos
WHERE estadoPago = 'PENDIENTE';

--- IEntrenamientoEquipo: entrenamientos de un equipo
SELECT idEntrenamiento, fecha, lugar, estado
FROM Entrenamientos
WHERE idEquipo = 6274
ORDER BY fecha;

--- IEntrenamiento: proximos entrenamientos programados
SELECT idEntrenamiento, fecha, hora, lugar, idEquipo
FROM Entrenamientos
WHERE estado = 'PROGRAMADO'
ORDER BY fecha, hora
LIMIT 10;

--- IParticipante: participantes de un entrenamiento
SELECT idPersona, rol, asistencia, observaciones
FROM Participantes
WHERE idEntrenamiento = 1;

--- IRecibe: entrenamientos recibidos por un equipo
SELECT idEntrenamiento, asistencia, observaciones
FROM EquiposRecibenEntrenamientos
WHERE idEquipo = 6274;

--- IJugador: jugadores con un numero de camiseta
SELECT j.idJugador, pe.nombre, pe.apellido, j.posicion
FROM Jugadores j
JOIN Personas pe ON j.idJugador = pe.idPersona
WHERE j.numeroCamiseta = 10
ORDER BY pe.apellido, pe.nombre
LIMIT 10;

--- VISTAS

--- vw_recaudos_por_escuela: las cinco escuelas con mayor recaudo
SELECT idEscuela, escuelaNombre, totalPagos, totalRecaudado, totalPendiente
FROM vw_recaudos_por_escuela
ORDER BY totalRecaudado DESC, idEscuela
LIMIT 5;

--- vw_inscripciones_pendientes: mayores deudas de inscripciones activas
SELECT idInscripcion, nombre, apellido, escuelaNombre, montoPendiente
FROM vw_inscripciones_pendientes
WHERE estadoInscripcion = 'ACTIVA'
ORDER BY montoPendiente DESC, idInscripcion
LIMIT 10;

--- vw_entrenamientos_programados: agenda del equipo con mas entrenamientos
SELECT idEntrenamiento, fecha, to_char(hora, 'HH24:MI') AS hora, lugar, equipoNombre
FROM vw_entrenamientos_programados
WHERE idEquipo = (SELECT idEquipo
                  FROM vw_entrenamientos_programados
                  GROUP BY idEquipo
                  ORDER BY COUNT(*) DESC, idEquipo
                  LIMIT 1)
ORDER BY fecha, hora;

--- vw_asistencia_entrenamientos: asistencia del entrenamiento 1
SELECT idPersona, nombre, apellido, rol, posicion, asistencia, observaciones
FROM vw_asistencia_entrenamientos
WHERE idEntrenamiento = 1
ORDER BY idPersona;

--- vw_jugadores_por_equipo: equipos con mas jugadores
SELECT idEquipo, equipoNombre, COUNT(*) AS jugadores
FROM vw_jugadores_por_equipo
GROUP BY idEquipo, equipoNombre
ORDER BY jugadores DESC, idEquipo
LIMIT 5;

--- vw_jugadores_categoria: categorias y jugadores por nivel
SELECT nivel, COUNT(*) AS categorias, SUM(cantidadJugadores) AS jugadores
FROM vw_jugadores_categoria
GROUP BY nivel
ORDER BY nivel;
