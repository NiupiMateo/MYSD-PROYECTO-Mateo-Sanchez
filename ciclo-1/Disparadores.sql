--- Disparadores

CREATE OR REPLACE FUNCTION fn_validar_edad_jugador() RETURNS trigger AS $$
DECLARE
    v_fecha DATE;
    v_edad  INTEGER;
BEGIN
    SELECT fechaNacimiento INTO v_fecha
    FROM Personas
    WHERE idPersona = NEW.idJugador;

    v_edad := DATE_PART('year', AGE(CURRENT_DATE, v_fecha));

    IF v_edad < 5 THEN
        RAISE EXCEPTION 'El jugador debe tener al menos 5 anos.' USING ERRCODE = 'P0001';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_edad_jugador
BEFORE INSERT ON Jugadores
FOR EACH ROW EXECUTE FUNCTION fn_validar_edad_jugador();

CREATE OR REPLACE FUNCTION fn_obs_participante() RETURNS trigger AS $$
BEGIN
    IF NEW.asistencia = 'N' AND NEW.observaciones IS NULL THEN
        NEW.observaciones := 'No asistio al entrenamiento';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_obs_participante
BEFORE INSERT ON Participantes
FOR EACH ROW EXECUTE FUNCTION fn_obs_participante();

CREATE OR REPLACE FUNCTION fn_obs_recibe() RETURNS trigger AS $$
BEGIN
    IF NEW.asistencia = 'N' AND NEW.observaciones IS NULL THEN
        NEW.observaciones := 'Equipo no asistio al entrenamiento';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_obs_recibe
BEFORE INSERT ON EquiposRecibenEntrenamientos
FOR EACH ROW EXECUTE FUNCTION fn_obs_recibe();

CREATE OR REPLACE FUNCTION fn_actualizar_estado_inscripcion() RETURNS trigger AS $$
BEGIN
    IF NEW.estadoPago = 'PAGADO' THEN
        UPDATE Inscripciones
        SET estadoInscripcion = 'ACTIVA'
        WHERE idInscripcion = NEW.idInscripcion;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_estado_inscripcion
AFTER INSERT ON Pagos
FOR EACH ROW EXECUTE FUNCTION fn_actualizar_estado_inscripcion();

CREATE OR REPLACE FUNCTION fn_validar_numero_camiseta_equipo() RETURNS trigger AS $$
DECLARE
    v_existe     INTEGER;
    v_id_escuela INTEGER;
BEGIN
    
    SELECT idEscuela INTO v_id_escuela
    FROM Inscripciones
    WHERE idPersona = NEW.idJugador
    LIMIT 1;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El jugador debe tener una inscripcion antes de ser registrado como jugador.'
            USING ERRCODE = 'P0001';
    END IF;

    
    SELECT COUNT(*) INTO v_existe
    FROM Jugadores j
    JOIN Inscripciones i ON j.idJugador = i.idPersona
    WHERE j.numeroCamiseta = NEW.numeroCamiseta
      AND i.idEscuela = v_id_escuela
      AND j.idJugador <> NEW.idJugador;

    IF v_existe > 0 THEN
        RAISE EXCEPTION 'El numero de camiseta ya existe en esta escuela.' USING ERRCODE = 'P0001';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_numero_camiseta_equipo
BEFORE INSERT ON Jugadores
FOR EACH ROW EXECUTE FUNCTION fn_validar_numero_camiseta_equipo();

CREATE OR REPLACE FUNCTION fn_fecha_pago_automatica() RETURNS trigger AS $$
BEGIN
    IF NEW.estadoPago = 'PAGADO' AND NEW.fechaPago IS NULL THEN
        NEW.fechaPago := CURRENT_DATE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_fecha_pago_automatica
BEFORE INSERT ON Pagos
FOR EACH ROW EXECUTE FUNCTION fn_fecha_pago_automatica();
