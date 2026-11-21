--- Componentes

--- PC_PERSONA

CREATE SCHEMA PC_PERSONA;

--- AD_PERSONA: documento unico, fecha de nacimiento pasada y correo valido
CREATE OR REPLACE PROCEDURE PC_PERSONA.AD_PERSONA(
    p_idPersona       INTEGER,
    p_documento       VARCHAR,
    p_nombre          VARCHAR,
    p_apellido        VARCHAR,
    p_fechaNacimiento DATE,
    p_telefono        VARCHAR,
    p_correo          VARCHAR
) AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Personas WHERE documento = p_documento) THEN
        RAISE EXCEPTION 'Ya existe una persona con el documento %.', p_documento USING ERRCODE = 'P0001';
    END IF;

    IF p_fechaNacimiento >= CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de nacimiento debe ser anterior a la fecha actual.' USING ERRCODE = 'P0001';
    END IF;

    IF p_correo !~ '^[^@ ]+@[^@ ]+[.][^@ ]+$' THEN
        RAISE EXCEPTION 'El correo % no tiene un formato valido.', p_correo USING ERRCODE = 'P0001';
    END IF;

    INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
    VALUES (p_idPersona, p_documento, p_nombre, p_apellido, p_fechaNacimiento, p_telefono, p_correo);
END;
$$ LANGUAGE plpgsql;

--- MO_PERSONA: las mismas validaciones sobre los datos nuevos
CREATE OR REPLACE PROCEDURE PC_PERSONA.MO_PERSONA(
    p_idPersona       INTEGER,
    p_documento       VARCHAR,
    p_nombre          VARCHAR,
    p_apellido        VARCHAR,
    p_fechaNacimiento DATE,
    p_telefono        VARCHAR,
    p_correo          VARCHAR
) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Personas WHERE idPersona = p_idPersona) THEN
        RAISE EXCEPTION 'La persona % no existe.', p_idPersona USING ERRCODE = 'P0001';
    END IF;

    IF EXISTS (SELECT 1 FROM Personas WHERE documento = p_documento AND idPersona <> p_idPersona) THEN
        RAISE EXCEPTION 'Ya existe otra persona con el documento %.', p_documento USING ERRCODE = 'P0001';
    END IF;

    IF p_fechaNacimiento >= CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de nacimiento debe ser anterior a la fecha actual.' USING ERRCODE = 'P0001';
    END IF;

    IF p_correo !~ '^[^@ ]+@[^@ ]+[.][^@ ]+$' THEN
        RAISE EXCEPTION 'El correo % no tiene un formato valido.', p_correo USING ERRCODE = 'P0001';
    END IF;

    UPDATE Personas
    SET documento = p_documento,
        nombre = p_nombre,
        apellido = p_apellido,
        fechaNacimiento = p_fechaNacimiento,
        telefono = p_telefono,
        correo = p_correo
    WHERE idPersona = p_idPersona;
END;
$$ LANGUAGE plpgsql;

--- EL_PERSONA: una persona con inscripciones no se elimina
CREATE OR REPLACE PROCEDURE PC_PERSONA.EL_PERSONA(
    p_idPersona INTEGER
) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Personas WHERE idPersona = p_idPersona) THEN
        RAISE EXCEPTION 'La persona % no existe.', p_idPersona USING ERRCODE = 'P0001';
    END IF;

    IF EXISTS (SELECT 1 FROM Inscripciones WHERE idPersona = p_idPersona) THEN
        RAISE EXCEPTION 'No se puede eliminar la persona % porque tiene inscripciones registradas.', p_idPersona
            USING ERRCODE = 'P0001';
    END IF;

    DELETE FROM Personas WHERE idPersona = p_idPersona;
END;
$$ LANGUAGE plpgsql;

--- CO_PERSONA: datos de una persona
CREATE OR REPLACE FUNCTION PC_PERSONA.CO_PERSONA(
    p_idPersona INTEGER
) RETURNS SETOF Personas AS $$
    SELECT *
    FROM Personas
    WHERE idPersona = p_idPersona;
$$ LANGUAGE sql STABLE;


--- PC_EQUIPO

CREATE SCHEMA PC_EQUIPO;

--- AD_EQUIPO: inicia ACTIVO, con escuela y categoria existentes y nombre unico en la escuela
CREATE OR REPLACE PROCEDURE PC_EQUIPO.AD_EQUIPO(
    p_idEquipo    INTEGER,
    p_nombre      VARCHAR,
    p_idEscuela   INTEGER,
    p_idCategoria INTEGER
) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Escuelas WHERE idEscuela = p_idEscuela) THEN
        RAISE EXCEPTION 'El equipo debe estar asociado a una escuela existente.' USING ERRCODE = 'P0001';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Categorias WHERE idCategoria = p_idCategoria) THEN
        RAISE EXCEPTION 'El equipo debe pertenecer a una categoria existente.' USING ERRCODE = 'P0001';
    END IF;

    IF EXISTS (SELECT 1 FROM Equipos WHERE idEscuela = p_idEscuela AND nombre = p_nombre) THEN
        RAISE EXCEPTION 'Ya existe un equipo llamado % en la escuela %.', p_nombre, p_idEscuela USING ERRCODE = 'P0001';
    END IF;

    INSERT INTO Equipos (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
    VALUES (p_idEquipo, p_nombre, 'ACTIVO', p_idEscuela, p_idCategoria);
END;
$$ LANGUAGE plpgsql;

--- MO_EQUIPO: no cambia de escuela si ya tiene entrenamientos
CREATE OR REPLACE PROCEDURE PC_EQUIPO.MO_EQUIPO(
    p_idEquipo     INTEGER,
    p_nombre       VARCHAR,
    p_estadoEquipo VARCHAR,
    p_idEscuela    INTEGER,
    p_idCategoria  INTEGER
) AS $$
DECLARE
    v_idEscuela Equipos.idEscuela%TYPE;
BEGIN
    SELECT idEscuela INTO v_idEscuela
    FROM Equipos
    WHERE idEquipo = p_idEquipo;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El equipo % no existe.', p_idEquipo USING ERRCODE = 'P0001';
    END IF;

    IF p_idEscuela <> v_idEscuela AND EXISTS (SELECT 1 FROM Entrenamientos WHERE idEquipo = p_idEquipo) THEN
        RAISE EXCEPTION 'No se puede cambiar la escuela del equipo % porque ya tiene entrenamientos registrados.', p_idEquipo
            USING ERRCODE = 'P0001';
    END IF;

    IF EXISTS (SELECT 1 FROM Equipos
               WHERE idEscuela = p_idEscuela
                 AND nombre = p_nombre
                 AND idEquipo <> p_idEquipo) THEN
        RAISE EXCEPTION 'Ya existe un equipo llamado % en la escuela %.', p_nombre, p_idEscuela USING ERRCODE = 'P0001';
    END IF;

    UPDATE Equipos
    SET nombre = p_nombre,
        estadoEquipo = p_estadoEquipo,
        idEscuela = p_idEscuela,
        idCategoria = p_idCategoria
    WHERE idEquipo = p_idEquipo;
END;
$$ LANGUAGE plpgsql;

--- EL_EQUIPO: un equipo con entrenamientos no se elimina
CREATE OR REPLACE PROCEDURE PC_EQUIPO.EL_EQUIPO(
    p_idEquipo INTEGER
) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Equipos WHERE idEquipo = p_idEquipo) THEN
        RAISE EXCEPTION 'El equipo % no existe.', p_idEquipo USING ERRCODE = 'P0001';
    END IF;

    IF EXISTS (SELECT 1 FROM Entrenamientos WHERE idEquipo = p_idEquipo) THEN
        RAISE EXCEPTION 'No se puede eliminar el equipo % porque tiene entrenamientos asociados.', p_idEquipo
            USING ERRCODE = 'P0001';
    END IF;

    DELETE FROM Equipos WHERE idEquipo = p_idEquipo;
END;
$$ LANGUAGE plpgsql;

--- CO_EQUIPO: equipos de una escuela
CREATE OR REPLACE FUNCTION PC_EQUIPO.CO_EQUIPO(
    p_idEscuela INTEGER
) RETURNS SETOF Equipos AS $$
    SELECT *
    FROM Equipos
    WHERE idEscuela = p_idEscuela
    ORDER BY nombre, idEquipo;
$$ LANGUAGE sql STABLE;


--- PC_INSCRIPCION

CREATE SCHEMA PC_INSCRIPCION;

--- AD_INSCRIPCION: inicia PENDIENTE con la fecha actual
CREATE OR REPLACE PROCEDURE PC_INSCRIPCION.AD_INSCRIPCION(
    p_idInscripcion INTEGER,
    p_idPersona     INTEGER,
    p_idEscuela     INTEGER
) AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Inscripciones
               WHERE idPersona = p_idPersona
                 AND idEscuela = p_idEscuela
                 AND estadoInscripcion IN ('ACTIVA', 'PENDIENTE')) THEN
        RAISE EXCEPTION 'La persona % ya tiene una inscripcion vigente en la escuela %.', p_idPersona, p_idEscuela
            USING ERRCODE = 'P0001';
    END IF;

    INSERT INTO Inscripciones (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
    VALUES (p_idInscripcion, CURRENT_DATE, 'PENDIENTE', p_idPersona, p_idEscuela);
END;
$$ LANGUAGE plpgsql;

--- MO_INSCRIPCION: solo cambia el estado si no hay pagos pendientes
CREATE OR REPLACE PROCEDURE PC_INSCRIPCION.MO_INSCRIPCION(
    p_idInscripcion     INTEGER,
    p_estadoInscripcion VARCHAR
) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Inscripciones WHERE idInscripcion = p_idInscripcion) THEN
        RAISE EXCEPTION 'La inscripcion % no existe.', p_idInscripcion USING ERRCODE = 'P0001';
    END IF;

    IF EXISTS (SELECT 1 FROM Pagos
               WHERE idInscripcion = p_idInscripcion
                 AND estadoPago = 'PENDIENTE') THEN
        RAISE EXCEPTION 'No se puede modificar el estado de la inscripcion % porque tiene pagos pendientes.', p_idInscripcion
            USING ERRCODE = 'P0001';
    END IF;

    UPDATE Inscripciones
    SET estadoInscripcion = p_estadoInscripcion
    WHERE idInscripcion = p_idInscripcion;
END;
$$ LANGUAGE plpgsql;

--- EL_INSCRIPCION: con pagos solo se puede cancelar
CREATE OR REPLACE PROCEDURE PC_INSCRIPCION.EL_INSCRIPCION(
    p_idInscripcion INTEGER
) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Inscripciones WHERE idInscripcion = p_idInscripcion) THEN
        RAISE EXCEPTION 'La inscripcion % no existe.', p_idInscripcion USING ERRCODE = 'P0001';
    END IF;

    IF EXISTS (SELECT 1 FROM Pagos WHERE idInscripcion = p_idInscripcion) THEN
        RAISE EXCEPTION 'No se puede eliminar la inscripcion % porque tiene pagos registrados; solo puede ser cancelada.', p_idInscripcion
            USING ERRCODE = 'P0001';
    END IF;

    DELETE FROM Inscripciones WHERE idInscripcion = p_idInscripcion;
END;
$$ LANGUAGE plpgsql;

--- CO_INSCRIPCION: inscripciones de una escuela
CREATE OR REPLACE FUNCTION PC_INSCRIPCION.CO_INSCRIPCION(
    p_idEscuela INTEGER
) RETURNS SETOF Inscripciones AS $$
    SELECT *
    FROM Inscripciones
    WHERE idEscuela = p_idEscuela
    ORDER BY fechaInscripcion DESC, idInscripcion;
$$ LANGUAGE sql STABLE;

--- PC_PAGO

CREATE SCHEMA PC_PAGO;

--- AD_PAGO: fecha actual sobre una inscripcion vigente
CREATE OR REPLACE PROCEDURE PC_PAGO.AD_PAGO(
    p_idPago        INTEGER,
    p_monto         NUMERIC,
    p_estadoPago    VARCHAR,
    p_metodoPago    VARCHAR,
    p_idInscripcion INTEGER
) AS $$
DECLARE
    v_estado Inscripciones.estadoInscripcion%TYPE;
BEGIN
    SELECT estadoInscripcion INTO v_estado
    FROM Inscripciones
    WHERE idInscripcion = p_idInscripcion;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El pago debe estar asociado a una inscripcion existente.' USING ERRCODE = 'P0001';
    END IF;

    IF v_estado = 'CANCELADA' THEN
        RAISE EXCEPTION 'No se pueden registrar pagos sobre la inscripcion % porque esta cancelada.', p_idInscripcion
            USING ERRCODE = 'P0001';
    END IF;

    INSERT INTO Pagos (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
    VALUES (p_idPago, CURRENT_DATE, p_monto, p_estadoPago, p_metodoPago, p_idInscripcion);
END;
$$ LANGUAGE plpgsql;

--- MO_PAGO: un pago PAGADO no se modifica
CREATE OR REPLACE PROCEDURE PC_PAGO.MO_PAGO(
    p_idPago     INTEGER,
    p_monto      NUMERIC,
    p_estadoPago VARCHAR
) AS $$
DECLARE
    v_estado        Pagos.estadoPago%TYPE;
    v_idInscripcion Pagos.idInscripcion%TYPE;
BEGIN
    SELECT estadoPago, idInscripcion INTO v_estado, v_idInscripcion
    FROM Pagos
    WHERE idPago = p_idPago;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El pago % no existe.', p_idPago USING ERRCODE = 'P0001';
    END IF;

    IF v_estado = 'PAGADO' THEN
        RAISE EXCEPTION 'No se puede modificar el pago % porque ya fue confirmado.', p_idPago
            USING ERRCODE = 'P0001';
    END IF;

    UPDATE Pagos
    SET monto = p_monto,
        estadoPago = p_estadoPago,
        fechaPago = CURRENT_DATE
    WHERE idPago = p_idPago;

    --- Pago confirmado activa la inscripcion
    IF p_estadoPago = 'PAGADO' THEN
        UPDATE Inscripciones
        SET estadoInscripcion = 'ACTIVA'
        WHERE idInscripcion = v_idInscripcion;
    END IF;
END;
$$ LANGUAGE plpgsql;

--- EL_PAGO: un pago PAGADO no se elimina
CREATE OR REPLACE PROCEDURE PC_PAGO.EL_PAGO(
    p_idPago INTEGER
) AS $$
DECLARE
    v_estado Pagos.estadoPago%TYPE;
BEGIN
    SELECT estadoPago INTO v_estado
    FROM Pagos
    WHERE idPago = p_idPago;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El pago % no existe.', p_idPago USING ERRCODE = 'P0001';
    END IF;

    IF v_estado = 'PAGADO' THEN
        RAISE EXCEPTION 'No se puede eliminar el pago % porque ya fue confirmado.', p_idPago
            USING ERRCODE = 'P0001';
    END IF;

    DELETE FROM Pagos WHERE idPago = p_idPago;
END;
$$ LANGUAGE plpgsql;

--- CO_PAGO: pagos de una inscripcion
CREATE OR REPLACE FUNCTION PC_PAGO.CO_PAGO(
    p_idInscripcion INTEGER
) RETURNS SETOF Pagos AS $$
    SELECT *
    FROM Pagos
    WHERE idInscripcion = p_idInscripcion
    ORDER BY fechaPago DESC, idPago;
$$ LANGUAGE sql STABLE;


--- PC_ENTRENAMIENTO

CREATE SCHEMA PC_ENTRENAMIENTO;

--- AD_ENTRENAMIENTO: inicia PROGRAMADO y no puede ser en el pasado
CREATE OR REPLACE PROCEDURE PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(
    p_idEntrenamiento INTEGER,
    p_fecha           DATE,
    p_hora            TIME,
    p_lugar           VARCHAR,
    p_idEquipo        INTEGER
) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Equipos WHERE idEquipo = p_idEquipo) THEN
        RAISE EXCEPTION 'El entrenamiento debe estar asociado a un equipo existente.' USING ERRCODE = 'P0001';
    END IF;

    IF p_fecha < CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha del entrenamiento no puede ser anterior a la fecha actual.' USING ERRCODE = 'P0001';
    END IF;

    INSERT INTO Entrenamientos (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
    VALUES (p_idEntrenamiento, p_fecha, p_fecha + p_hora, p_lugar, 'PROGRAMADO', p_idEquipo);
END;
$$ LANGUAGE plpgsql;

--- MO_ENTRENAMIENTO: no se modifica si ya fue realizado ni la fecha si tiene asistencias
CREATE OR REPLACE PROCEDURE PC_ENTRENAMIENTO.MO_ENTRENAMIENTO(
    p_idEntrenamiento INTEGER,
    p_fecha           DATE,
    p_hora            TIME,
    p_lugar           VARCHAR,
    p_estado          VARCHAR
) AS $$
DECLARE
    v_fecha  Entrenamientos.fecha%TYPE;
    v_estado Entrenamientos.estado%TYPE;
BEGIN
    SELECT fecha, estado INTO v_fecha, v_estado
    FROM Entrenamientos
    WHERE idEntrenamiento = p_idEntrenamiento;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El entrenamiento % no existe.', p_idEntrenamiento USING ERRCODE = 'P0001';
    END IF;

    IF v_estado = 'REALIZADO' THEN
        RAISE EXCEPTION 'No se puede modificar el entrenamiento % porque ya fue realizado.', p_idEntrenamiento
            USING ERRCODE = 'P0001';
    END IF;

    IF p_fecha <> v_fecha THEN
        IF EXISTS (SELECT 1 FROM Participantes WHERE idEntrenamiento = p_idEntrenamiento) THEN
            RAISE EXCEPTION 'No se puede modificar la fecha del entrenamiento % porque ya tiene asistencias registradas.', p_idEntrenamiento
                USING ERRCODE = 'P0001';
        END IF;

        IF p_fecha < CURRENT_DATE THEN
            RAISE EXCEPTION 'La fecha del entrenamiento no puede ser anterior a la fecha actual.' USING ERRCODE = 'P0001';
        END IF;
    END IF;

    UPDATE Entrenamientos
    SET fecha = p_fecha,
        hora = p_fecha + p_hora,
        lugar = p_lugar,
        estado = p_estado
    WHERE idEntrenamiento = p_idEntrenamiento;
END;
$$ LANGUAGE plpgsql;

--- EL_ENTRENAMIENTO: realizado o con asistencias no se elimina
CREATE OR REPLACE PROCEDURE PC_ENTRENAMIENTO.EL_ENTRENAMIENTO(
    p_idEntrenamiento INTEGER
) AS $$
DECLARE
    v_estado Entrenamientos.estado%TYPE;
BEGIN
    SELECT estado INTO v_estado
    FROM Entrenamientos
    WHERE idEntrenamiento = p_idEntrenamiento;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El entrenamiento % no existe.', p_idEntrenamiento USING ERRCODE = 'P0001';
    END IF;

    IF v_estado = 'REALIZADO' THEN
        RAISE EXCEPTION 'No se puede eliminar el entrenamiento % porque ya fue realizado.', p_idEntrenamiento
            USING ERRCODE = 'P0001';
    END IF;

    IF EXISTS (SELECT 1 FROM Participantes WHERE idEntrenamiento = p_idEntrenamiento) THEN
        RAISE EXCEPTION 'No se puede eliminar el entrenamiento % porque tiene asistencias registradas; solo puede ser cancelado.', p_idEntrenamiento
            USING ERRCODE = 'P0001';
    END IF;

    DELETE FROM Entrenamientos WHERE idEntrenamiento = p_idEntrenamiento;
END;
$$ LANGUAGE plpgsql;

--- CO_ENTRENAMIENTO: entrenamientos de un equipo
CREATE OR REPLACE FUNCTION PC_ENTRENAMIENTO.CO_ENTRENAMIENTO(
    p_idEquipo INTEGER
) RETURNS SETOF Entrenamientos AS $$
    SELECT *
    FROM Entrenamientos
    WHERE idEquipo = p_idEquipo
    ORDER BY fecha, hora, idEntrenamiento;
$$ LANGUAGE sql STABLE;

--- PC_ASISTENCIA

CREATE SCHEMA PC_ASISTENCIA;

--- AD_ASISTENCIA: entrenamiento programado y jugador inscrito en la escuela
CREATE OR REPLACE PROCEDURE PC_ASISTENCIA.AD_ASISTENCIA(
    p_idPersona       INTEGER,
    p_idEntrenamiento INTEGER,
    p_asistencia      CHAR,
    p_rol             VARCHAR,
    p_observaciones   VARCHAR
) AS $$
DECLARE
    v_estado    Entrenamientos.estado%TYPE;
    v_idEscuela Equipos.idEscuela%TYPE;
BEGIN
    SELECT en.estado, eq.idEscuela INTO v_estado, v_idEscuela
    FROM Entrenamientos en
    JOIN Equipos eq ON en.idEquipo = eq.idEquipo
    WHERE en.idEntrenamiento = p_idEntrenamiento;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El entrenamiento % no existe.', p_idEntrenamiento USING ERRCODE = 'P0001';
    END IF;

    IF v_estado <> 'PROGRAMADO' THEN
        RAISE EXCEPTION 'Solo se puede registrar asistencia en un entrenamiento programado.' USING ERRCODE = 'P0001';
    END IF;

    IF EXISTS (SELECT 1 FROM Participantes
               WHERE idPersona = p_idPersona
                 AND idEntrenamiento = p_idEntrenamiento) THEN
        RAISE EXCEPTION 'La persona % ya tiene asistencia registrada en el entrenamiento %.', p_idPersona, p_idEntrenamiento
            USING ERRCODE = 'P0001';
    END IF;

    IF p_rol = 'JUGADOR' AND NOT EXISTS (SELECT 1
                                         FROM Jugadores j
                                         JOIN Inscripciones i ON j.idJugador = i.idPersona
                                         WHERE j.idJugador = p_idPersona
                                           AND i.idEscuela = v_idEscuela
                                           AND i.estadoInscripcion <> 'CANCELADA') THEN
        RAISE EXCEPTION 'El jugador % no esta inscrito en la escuela del equipo que entrena.', p_idPersona
            USING ERRCODE = 'P0001';
    END IF;

    INSERT INTO Participantes (idPersona, idEntrenamiento, asistencia, rol, observaciones)
    VALUES (p_idPersona, p_idEntrenamiento, p_asistencia, p_rol, p_observaciones);
END;
$$ LANGUAGE plpgsql;

--- MO_ASISTENCIA: no aplica si el entrenamiento esta cancelado
CREATE OR REPLACE PROCEDURE PC_ASISTENCIA.MO_ASISTENCIA(
    p_idPersona       INTEGER,
    p_idEntrenamiento INTEGER,
    p_asistencia      CHAR,
    p_observaciones   VARCHAR
) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Participantes
                   WHERE idPersona = p_idPersona
                     AND idEntrenamiento = p_idEntrenamiento) THEN
        RAISE EXCEPTION 'La persona % no tiene asistencia registrada en el entrenamiento %.', p_idPersona, p_idEntrenamiento
            USING ERRCODE = 'P0001';
    END IF;

    IF EXISTS (SELECT 1 FROM Entrenamientos
               WHERE idEntrenamiento = p_idEntrenamiento
                 AND estado = 'CANCELADO') THEN
        RAISE EXCEPTION 'No se puede modificar la asistencia de un entrenamiento cancelado.' USING ERRCODE = 'P0001';
    END IF;

    UPDATE Participantes
    SET asistencia = p_asistencia,
        observaciones = p_observaciones
    WHERE idPersona = p_idPersona
      AND idEntrenamiento = p_idEntrenamiento;
END;
$$ LANGUAGE plpgsql;

--- EL_ASISTENCIA: solo en entrenamientos programados
CREATE OR REPLACE PROCEDURE PC_ASISTENCIA.EL_ASISTENCIA(
    p_idPersona       INTEGER,
    p_idEntrenamiento INTEGER
) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Participantes
                   WHERE idPersona = p_idPersona
                     AND idEntrenamiento = p_idEntrenamiento) THEN
        RAISE EXCEPTION 'La persona % no tiene asistencia registrada en el entrenamiento %.', p_idPersona, p_idEntrenamiento
            USING ERRCODE = 'P0001';
    END IF;

    IF EXISTS (SELECT 1 FROM Entrenamientos
               WHERE idEntrenamiento = p_idEntrenamiento
                 AND estado <> 'PROGRAMADO') THEN
        RAISE EXCEPTION 'Solo se puede eliminar la asistencia de un entrenamiento programado.' USING ERRCODE = 'P0001';
    END IF;

    DELETE FROM Participantes
    WHERE idPersona = p_idPersona
      AND idEntrenamiento = p_idEntrenamiento;
END;
$$ LANGUAGE plpgsql;

--- CO_ASISTENCIA: participantes de un entrenamiento
CREATE OR REPLACE FUNCTION PC_ASISTENCIA.CO_ASISTENCIA(
    p_idEntrenamiento INTEGER
) RETURNS SETOF Participantes AS $$
    SELECT *
    FROM Participantes
    WHERE idEntrenamiento = p_idEntrenamiento
    ORDER BY idPersona;
$$ LANGUAGE sql STABLE;
