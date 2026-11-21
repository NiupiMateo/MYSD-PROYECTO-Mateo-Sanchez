--- Vistas

--- Vista 1: recaudo por escuela
CREATE VIEW vw_recaudos_por_escuela AS
SELECT
    e.idEscuela,
    e.nombre AS escuelaNombre,
    COUNT(p.idPago) AS totalPagos,
    COALESCE(SUM(CASE WHEN p.estadoPago = 'PAGADO' THEN p.monto END), 0) AS totalRecaudado,
    COALESCE(SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto END), 0) AS totalPendiente
FROM Escuelas e
LEFT JOIN Inscripciones i
    ON e.idEscuela = i.idEscuela
LEFT JOIN Pagos p
    ON i.idInscripcion = p.idInscripcion
GROUP BY e.idEscuela, e.nombre;

--- Vista 2: inscripciones con pagos pendientes
CREATE VIEW vw_inscripciones_pendientes AS
SELECT
    i.idInscripcion,
    pe.idPersona,
    pe.nombre,
    pe.apellido,
    e.idEscuela,
    e.nombre AS escuelaNombre,
    i.estadoInscripcion,
    SUM(p.monto) AS montoPendiente
FROM Inscripciones i
JOIN Personas pe
    ON i.idPersona = pe.idPersona
JOIN Escuelas e
    ON i.idEscuela = e.idEscuela
JOIN Pagos p
    ON i.idInscripcion = p.idInscripcion
WHERE p.estadoPago = 'PENDIENTE'
GROUP BY i.idInscripcion, pe.idPersona, pe.nombre, pe.apellido, e.idEscuela, e.nombre, i.estadoInscripcion;

--- Vista 3: entrenamientos programados
CREATE VIEW vw_entrenamientos_programados AS
SELECT
    en.idEntrenamiento,
    en.fecha,
    en.hora,
    en.lugar,
    en.estado,
    eq.idEquipo,
    eq.nombre AS equipoNombre
FROM Entrenamientos en
JOIN Equipos eq
    ON en.idEquipo = eq.idEquipo
WHERE en.estado = 'PROGRAMADO';

--- Vista 4: asistencia a los entrenamientos
CREATE VIEW vw_asistencia_entrenamientos AS
SELECT
    en.idEntrenamiento,
    en.fecha,
    pe.idPersona,
    pe.nombre,
    pe.apellido,
    j.posicion,
    pa.asistencia,
    pa.rol,
    pa.observaciones
FROM Participantes pa
JOIN Entrenamientos en
    ON pa.idEntrenamiento = en.idEntrenamiento
JOIN Personas pe
    ON pa.idPersona = pe.idPersona
LEFT JOIN Jugadores j
    ON pe.idPersona = j.idJugador;

--- Vista 5: jugadores por equipo
CREATE VIEW vw_jugadores_por_equipo AS
SELECT DISTINCT
    eq.idEquipo,
    eq.nombre AS equipoNombre,
    pe.idPersona,
    pe.nombre,
    pe.apellido,
    j.posicion,
    j.numeroCamiseta
FROM Equipos eq
JOIN Entrenamientos en
    ON eq.idEquipo = en.idEquipo
JOIN Participantes pa
    ON en.idEntrenamiento = pa.idEntrenamiento
JOIN Personas pe
    ON pa.idPersona = pe.idPersona
JOIN Jugadores j
    ON pe.idPersona = j.idJugador
WHERE pa.rol = 'JUGADOR';

--- Vista 6: cantidad de jugadores por categoria
CREATE VIEW vw_jugadores_categoria AS
SELECT
    c.idCategoria,
    c.nombre AS categoriaNombre,
    c.nivel,
    COUNT(DISTINCT pa.idPersona) AS cantidadJugadores
FROM Categorias c
LEFT JOIN Equipos eq
    ON c.idCategoria = eq.idCategoria
LEFT JOIN Entrenamientos en
    ON eq.idEquipo = en.idEquipo
LEFT JOIN Participantes pa
    ON en.idEntrenamiento = pa.idEntrenamiento
   AND pa.rol = 'JUGADOR'
GROUP BY c.idCategoria, c.nombre, c.nivel;
