--- Eliminacion de disparadores

DROP TRIGGER IF EXISTS trg_validar_edad_jugador ON Jugadores;
DROP TRIGGER IF EXISTS trg_obs_participante ON Participantes;
DROP TRIGGER IF EXISTS trg_obs_recibe ON EquiposRecibenEntrenamientos;
DROP TRIGGER IF EXISTS trg_actualizar_estado_inscripcion ON Pagos;
DROP TRIGGER IF EXISTS trg_validar_numero_camiseta_equipo ON Jugadores;
DROP TRIGGER IF EXISTS trg_fecha_pago_automatica ON Pagos;

DROP FUNCTION IF EXISTS fn_validar_edad_jugador();
DROP FUNCTION IF EXISTS fn_obs_participante();
DROP FUNCTION IF EXISTS fn_obs_recibe();
DROP FUNCTION IF EXISTS fn_actualizar_estado_inscripcion();
DROP FUNCTION IF EXISTS fn_validar_numero_camiseta_equipo();
DROP FUNCTION IF EXISTS fn_fecha_pago_automatica();
