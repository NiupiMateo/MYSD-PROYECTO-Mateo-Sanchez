--- Actores

--- PA_ADMINISTRADOR

CREATE SCHEMA PA_ADMINISTRADOR;

--- Mantener Persona
CREATE OR REPLACE PROCEDURE PA_ADMINISTRADOR.personasAd(
    p_idPersona       INTEGER,
    p_documento       VARCHAR,
    p_nombre          VARCHAR,
    p_apellido        VARCHAR,
    p_fechaNacimiento DATE,
    p_telefono        VARCHAR,
    p_correo          VARCHAR
) AS $$
BEGIN
    CALL PC_PERSONA.AD_PERSONA(p_idPersona, p_documento, p_nombre, p_apellido, p_fechaNacimiento, p_telefono, p_correo);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE PROCEDURE PA_ADMINISTRADOR.personasMod(
    p_idPersona       INTEGER,
    p_documento       VARCHAR,
    p_nombre          VARCHAR,
    p_apellido        VARCHAR,
    p_fechaNacimiento DATE,
    p_telefono        VARCHAR,
    p_correo          VARCHAR
) AS $$
BEGIN
    CALL PC_PERSONA.MO_PERSONA(p_idPersona, p_documento, p_nombre, p_apellido, p_fechaNacimiento, p_telefono, p_correo);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE PROCEDURE PA_ADMINISTRADOR.personasEli(
    p_idPersona INTEGER
) AS $$
BEGIN
    CALL PC_PERSONA.EL_PERSONA(p_idPersona);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION PA_ADMINISTRADOR.personasC(
    p_idPersona INTEGER
) RETURNS SETOF Personas AS $$
    SELECT * FROM PC_PERSONA.CO_PERSONA(p_idPersona);
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Mantener Equipo
CREATE OR REPLACE PROCEDURE PA_ADMINISTRADOR.equiposAd(
    p_idEquipo    INTEGER,
    p_nombre      VARCHAR,
    p_idEscuela   INTEGER,
    p_idCategoria INTEGER
) AS $$
BEGIN
    CALL PC_EQUIPO.AD_EQUIPO(p_idEquipo, p_nombre, p_idEscuela, p_idCategoria);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE PROCEDURE PA_ADMINISTRADOR.equiposMod(
    p_idEquipo     INTEGER,
    p_nombre       VARCHAR,
    p_estadoEquipo VARCHAR,
    p_idEscuela    INTEGER,
    p_idCategoria  INTEGER
) AS $$
BEGIN
    CALL PC_EQUIPO.MO_EQUIPO(p_idEquipo, p_nombre, p_estadoEquipo, p_idEscuela, p_idCategoria);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE PROCEDURE PA_ADMINISTRADOR.equiposEli(
    p_idEquipo INTEGER
) AS $$
BEGIN
    CALL PC_EQUIPO.EL_EQUIPO(p_idEquipo);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION PA_ADMINISTRADOR.equiposC(
    p_idEscuela INTEGER
) RETURNS SETOF Equipos AS $$
    SELECT * FROM PC_EQUIPO.CO_EQUIPO(p_idEscuela);
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Registrar Inscripcion
CREATE OR REPLACE PROCEDURE PA_ADMINISTRADOR.inscripcionesAd(
    p_idInscripcion INTEGER,
    p_idPersona     INTEGER,
    p_idEscuela     INTEGER
) AS $$
BEGIN
    CALL PC_INSCRIPCION.AD_INSCRIPCION(p_idInscripcion, p_idPersona, p_idEscuela);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE PROCEDURE PA_ADMINISTRADOR.inscripcionesMod(
    p_idInscripcion     INTEGER,
    p_estadoInscripcion VARCHAR
) AS $$
BEGIN
    CALL PC_INSCRIPCION.MO_INSCRIPCION(p_idInscripcion, p_estadoInscripcion);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE PROCEDURE PA_ADMINISTRADOR.inscripcionesEli(
    p_idInscripcion INTEGER
) AS $$
BEGIN
    CALL PC_INSCRIPCION.EL_INSCRIPCION(p_idInscripcion);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION PA_ADMINISTRADOR.inscripcionesC(
    p_idEscuela INTEGER
) RETURNS SETOF Inscripciones AS $$
    SELECT * FROM PC_INSCRIPCION.CO_INSCRIPCION(p_idEscuela);
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Registrar pago
CREATE OR REPLACE PROCEDURE PA_ADMINISTRADOR.pagosAd(
    p_idPago        INTEGER,
    p_monto         NUMERIC,
    p_estadoPago    VARCHAR,
    p_metodoPago    VARCHAR,
    p_idInscripcion INTEGER
) AS $$
BEGIN
    CALL PC_PAGO.AD_PAGO(p_idPago, p_monto, p_estadoPago, p_metodoPago, p_idInscripcion);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE PROCEDURE PA_ADMINISTRADOR.pagosMod(
    p_idPago     INTEGER,
    p_monto      NUMERIC,
    p_estadoPago VARCHAR
) AS $$
BEGIN
    CALL PC_PAGO.MO_PAGO(p_idPago, p_monto, p_estadoPago);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE PROCEDURE PA_ADMINISTRADOR.pagosEli(
    p_idPago INTEGER
) AS $$
BEGIN
    CALL PC_PAGO.EL_PAGO(p_idPago);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION PA_ADMINISTRADOR.pagosC(
    p_idInscripcion INTEGER
) RETURNS SETOF Pagos AS $$
    SELECT * FROM PC_PAGO.CO_PAGO(p_idInscripcion);
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Consultar total recaudado por escuela
CREATE OR REPLACE FUNCTION PA_ADMINISTRADOR.recaudadoPorEscuela()
RETURNS SETOF vw_recaudos_por_escuela AS $$
    SELECT * FROM vw_recaudos_por_escuela ORDER BY idEscuela;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Consultar pagos pendientes
CREATE OR REPLACE FUNCTION PA_ADMINISTRADOR.inscripcionesPendientes()
RETURNS SETOF vw_inscripciones_pendientes AS $$
    SELECT * FROM vw_inscripciones_pendientes ORDER BY idInscripcion;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Consultar jugadores por equipo
CREATE OR REPLACE FUNCTION PA_ADMINISTRADOR.jugadoresPorEquipo(
    p_idEquipo INTEGER
) RETURNS SETOF vw_jugadores_por_equipo AS $$
    SELECT * FROM vw_jugadores_por_equipo
    WHERE idEquipo = p_idEquipo
    ORDER BY apellido, nombre;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Consultar jugadores por categoria
CREATE OR REPLACE FUNCTION PA_ADMINISTRADOR.jugadoresPorCategoria(
    p_idCategoria INTEGER
) RETURNS SETOF vw_jugadores_categoria AS $$
    SELECT * FROM vw_jugadores_categoria
    WHERE idCategoria = p_idCategoria;
$$ LANGUAGE sql STABLE SECURITY DEFINER;


--- PA_ENTRENADOR

CREATE SCHEMA PA_ENTRENADOR;

--- Mantener Entrenamiento
CREATE OR REPLACE PROCEDURE PA_ENTRENADOR.entrenamientosAd(
    p_idEntrenamiento INTEGER,
    p_fecha           DATE,
    p_hora            TIME,
    p_lugar           VARCHAR,
    p_idEquipo        INTEGER
) AS $$
BEGIN
    CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(p_idEntrenamiento, p_fecha, p_hora, p_lugar, p_idEquipo);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE PROCEDURE PA_ENTRENADOR.entrenamientosMod(
    p_idEntrenamiento INTEGER,
    p_fecha           DATE,
    p_hora            TIME,
    p_lugar           VARCHAR,
    p_estado          VARCHAR
) AS $$
BEGIN
    CALL PC_ENTRENAMIENTO.MO_ENTRENAMIENTO(p_idEntrenamiento, p_fecha, p_hora, p_lugar, p_estado);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE PROCEDURE PA_ENTRENADOR.entrenamientosEli(
    p_idEntrenamiento INTEGER
) AS $$
BEGIN
    CALL PC_ENTRENAMIENTO.EL_ENTRENAMIENTO(p_idEntrenamiento);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION PA_ENTRENADOR.entrenamientosC(
    p_idEquipo INTEGER
) RETURNS SETOF Entrenamientos AS $$
    SELECT * FROM PC_ENTRENAMIENTO.CO_ENTRENAMIENTO(p_idEquipo);
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Consultar entrenamientos programados por equipo
CREATE OR REPLACE FUNCTION PA_ENTRENADOR.entrenamientosProgramadosC(
    p_idEquipo INTEGER
) RETURNS SETOF vw_entrenamientos_programados AS $$
    SELECT * FROM vw_entrenamientos_programados
    WHERE idEquipo = p_idEquipo
    ORDER BY fecha, hora;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Registrar asistencia
CREATE OR REPLACE PROCEDURE PA_ENTRENADOR.asistenciaReg(
    p_idPersona       INTEGER,
    p_idEntrenamiento INTEGER,
    p_asistencia      CHAR,
    p_rol             VARCHAR,
    p_observaciones   VARCHAR
) AS $$
BEGIN
    CALL PC_ASISTENCIA.AD_ASISTENCIA(p_idPersona, p_idEntrenamiento, p_asistencia, p_rol, p_observaciones);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE PROCEDURE PA_ENTRENADOR.asistenciaMod(
    p_idPersona       INTEGER,
    p_idEntrenamiento INTEGER,
    p_asistencia      CHAR,
    p_observaciones   VARCHAR
) AS $$
BEGIN
    CALL PC_ASISTENCIA.MO_ASISTENCIA(p_idPersona, p_idEntrenamiento, p_asistencia, p_observaciones);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE PROCEDURE PA_ENTRENADOR.asistenciaEli(
    p_idPersona       INTEGER,
    p_idEntrenamiento INTEGER
) AS $$
BEGIN
    CALL PC_ASISTENCIA.EL_ASISTENCIA(p_idPersona, p_idEntrenamiento);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION PA_ENTRENADOR.asistenciaC(
    p_idEntrenamiento INTEGER
) RETURNS SETOF vw_asistencia_entrenamientos AS $$
    SELECT * FROM vw_asistencia_entrenamientos
    WHERE idEntrenamiento = p_idEntrenamiento
    ORDER BY idPersona;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Consultar jugadores de mi equipo
CREATE OR REPLACE FUNCTION PA_ENTRENADOR.jugadoresEquipoC(
    p_idEquipo INTEGER
) RETURNS SETOF vw_jugadores_por_equipo AS $$
    SELECT * FROM vw_jugadores_por_equipo
    WHERE idEquipo = p_idEquipo
    ORDER BY apellido, nombre;
$$ LANGUAGE sql STABLE SECURITY DEFINER;


--- PA_GERENTE

CREATE SCHEMA PA_GERENTE;

--- Consultar total jugadores inscritos en la escuela
CREATE OR REPLACE FUNCTION PA_GERENTE.jugadoresPorEscuela()
RETURNS TABLE (idEscuela INTEGER, escuelaNombre VARCHAR, totalJugadores BIGINT) AS $$
    SELECT e.idEscuela, e.nombre, COUNT(DISTINCT j.idJugador)
    FROM Escuelas e
    LEFT JOIN Inscripciones i
        ON e.idEscuela = i.idEscuela
       AND i.estadoInscripcion <> 'CANCELADA'
    LEFT JOIN Jugadores j
        ON i.idPersona = j.idJugador
    GROUP BY e.idEscuela, e.nombre
    ORDER BY e.idEscuela;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Consultar pagos en cada estado
CREATE OR REPLACE FUNCTION PA_GERENTE.pagosPorEstado()
RETURNS TABLE (estadoPago VARCHAR, cantidadPagos BIGINT, montoTotal NUMERIC) AS $$
    SELECT p.estadoPago, COUNT(*), SUM(p.monto)
    FROM Pagos p
    GROUP BY p.estadoPago
    ORDER BY p.estadoPago;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Consultar jugadores por entrenamiento
CREATE OR REPLACE FUNCTION PA_GERENTE.promedioJugadoresPorEntrenamiento()
RETURNS TABLE (totalEntrenamientos BIGINT, totalJugadores BIGINT, promedioJugadores NUMERIC) AS $$
    SELECT COUNT(*), COALESCE(SUM(t.jugadores), 0), ROUND(COALESCE(AVG(t.jugadores), 0), 2)
    FROM (SELECT en.idEntrenamiento, COUNT(pa.idPersona) AS jugadores
          FROM Entrenamientos en
          LEFT JOIN Participantes pa
              ON en.idEntrenamiento = pa.idEntrenamiento
             AND pa.rol = 'JUGADOR'
          GROUP BY en.idEntrenamiento) t;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Consultar escuelas con mayor inscritos
CREATE OR REPLACE FUNCTION PA_GERENTE.escuelasConMayorDemanda()
RETURNS TABLE (idEscuela INTEGER, escuelaNombre VARCHAR, totalInscritos BIGINT) AS $$
    SELECT e.idEscuela, e.nombre, COUNT(i.idInscripcion)
    FROM Escuelas e
    JOIN Inscripciones i
        ON e.idEscuela = i.idEscuela
    GROUP BY e.idEscuela, e.nombre
    ORDER BY COUNT(i.idInscripcion) DESC, e.idEscuela
    LIMIT 10;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

--- Consultar entrenamientos por equipo
CREATE OR REPLACE FUNCTION PA_GERENTE.entrenamientosPorEquipo()
RETURNS TABLE (idEquipo INTEGER, equipoNombre VARCHAR, totalEntrenamientos BIGINT) AS $$
    SELECT eq.idEquipo, eq.nombre, COUNT(en.idEntrenamiento)
    FROM Equipos eq
    LEFT JOIN Entrenamientos en
        ON eq.idEquipo = en.idEquipo
    GROUP BY eq.idEquipo, eq.nombre
    ORDER BY COUNT(en.idEntrenamiento) DESC, eq.idEquipo;
$$ LANGUAGE sql STABLE SECURITY DEFINER;
