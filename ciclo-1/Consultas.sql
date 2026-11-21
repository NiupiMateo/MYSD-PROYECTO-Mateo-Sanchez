--- Consultas SQL del proyecto

--- Consulta 1: Consultar total recaudado por escuela (Administrador)
SELECT
    e.idEscuela,
    e.nombre AS nombreEscuela,
    COALESCE(SUM(CASE WHEN p.estadoPago = 'PAGADO' THEN p.monto ELSE 0 END), 0) AS totalRecaudado
FROM Escuelas e
LEFT JOIN Inscripciones i
    ON e.idEscuela = i.idEscuela
LEFT JOIN Pagos p
    ON i.idInscripcion = p.idInscripcion
GROUP BY e.idEscuela, e.nombre
ORDER BY e.idEscuela;

--- Consulta 2: Consultar jugadores por equipo (Administrador)
SELECT DISTINCT
    eq.idEquipo,
    eq.nombre AS nombreEquipo,
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
WHERE pa.rol = 'JUGADOR'
ORDER BY eq.idEquipo, pe.apellido, pe.nombre;

--- Consulta 3: Consultar jugadores por categoría (Administrador)
SELECT DISTINCT
    pe.idPersona,
    pe.nombre,
    pe.apellido,
    c.nombre AS categoria,
    eq.nombre AS equipo,
    j.numeroCamiseta
FROM Categorias c
JOIN Equipos eq
    ON c.idCategoria = eq.idCategoria
JOIN Entrenamientos en
    ON eq.idEquipo = en.idEquipo
JOIN Participantes pa
    ON en.idEntrenamiento = pa.idEntrenamiento
JOIN Personas pe
    ON pa.idPersona = pe.idPersona
JOIN Jugadores j
    ON pe.idPersona = j.idJugador
WHERE pa.rol = 'JUGADOR'
ORDER BY c.nombre, eq.nombre, pe.apellido, pe.nombre;

--- Consulta 4: Consultar inscripciones con pagos pendientes (Administrador)
SELECT
    i.idInscripcion,
    i.idPersona,
    pe.nombre,
    pe.apellido,
    i.estadoInscripcion,
    COALESCE(SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto ELSE 0 END), 0) AS montoPendiente
FROM Inscripciones i
JOIN Personas pe
    ON i.idPersona = pe.idPersona
LEFT JOIN Pagos p
    ON i.idInscripcion = p.idInscripcion
GROUP BY i.idInscripcion, i.idPersona, pe.nombre, pe.apellido, i.estadoInscripcion
HAVING COALESCE(SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto ELSE 0 END), 0) > 0
ORDER BY i.idInscripcion;

--- Consulta 5: Consultar entrenamientos programados por equipo (Entrenador)
SELECT
    eq.idEquipo,
    eq.nombre AS nombreEquipo,
    en.idEntrenamiento,
    en.fecha,
    en.hora,
    en.lugar,
    en.estado
FROM Equipos eq
JOIN Entrenamientos en
    ON eq.idEquipo = en.idEquipo
WHERE en.estado = 'PROGRAMADO'
ORDER BY eq.idEquipo, en.fecha, en.hora;

--- Consulta 6: Consultar jugadores de mi equipo (Entrenador)
SELECT DISTINCT
    pe.idPersona,
    pe.nombre,
    pe.apellido,
    j.posicion,
    j.numeroCamiseta,
    eq.nombre AS nombreEquipo
FROM Equipos eq
JOIN Entrenamientos en
    ON eq.idEquipo = en.idEquipo
JOIN Participantes pa
    ON en.idEntrenamiento = pa.idEntrenamiento
JOIN Personas pe
    ON pa.idPersona = pe.idPersona
JOIN Jugadores j
    ON pe.idPersona = j.idJugador
WHERE pa.rol = 'JUGADOR'
ORDER BY pe.apellido, pe.nombre;
