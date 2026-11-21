--- Eliminacion de vistas e indices

DROP VIEW IF EXISTS vw_jugadores_categoria;
DROP VIEW IF EXISTS vw_jugadores_por_equipo;
DROP VIEW IF EXISTS vw_asistencia_entrenamientos;
DROP VIEW IF EXISTS vw_entrenamientos_programados;
DROP VIEW IF EXISTS vw_inscripciones_pendientes;
DROP VIEW IF EXISTS vw_recaudos_por_escuela;

DROP INDEX IF EXISTS IJugador;
DROP INDEX IF EXISTS IRecibe;
DROP INDEX IF EXISTS IParticipante;
DROP INDEX IF EXISTS IEntrenamiento;
DROP INDEX IF EXISTS IEntrenamientoEquipo;
DROP INDEX IF EXISTS IPago;
DROP INDEX IF EXISTS IPagoInscripcion;
DROP INDEX IF EXISTS IInscripcion;
DROP INDEX IF EXISTS IInscripcionEscuela;
DROP INDEX IF EXISTS IInscripcionPersona;
