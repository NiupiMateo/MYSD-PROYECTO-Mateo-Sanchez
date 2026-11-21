--- Restricciones de atributo

ALTER TABLE Jugadores
    ADD CONSTRAINT ck_jugador_numero_camiseta CHECK (numeroCamiseta > 0);

ALTER TABLE Pagos
    ADD CONSTRAINT ck_pago_monto CHECK (monto > 0);
ALTER TABLE Pagos
    ADD CONSTRAINT ck_pago_estado CHECK (estadoPago IN ('PENDIENTE', 'PAGADO', 'ANULADO'));
ALTER TABLE Pagos
    ADD CONSTRAINT ck_pago_metodo CHECK (metodoPago IN ('EFECTIVO', 'TRANSFERENCIA', 'TARJETA'));

ALTER TABLE Inscripciones
    ADD CONSTRAINT ck_inscripcion_estado CHECK (estadoInscripcion IN ('ACTIVA', 'PENDIENTE', 'CANCELADA'));

ALTER TABLE Equipos
    ADD CONSTRAINT ck_equipo_estado CHECK (estadoEquipo IN ('ACTIVO', 'INACTIVO'));

ALTER TABLE Entrenamientos
    ADD CONSTRAINT ck_entrenamiento_estado CHECK (estado IN ('PROGRAMADO', 'REALIZADO', 'CANCELADO'));

ALTER TABLE Categorias
    ADD CONSTRAINT ck_categoria_nivel CHECK (nivel IN ('BASICO', 'INTERMEDIO', 'AVANZADO'));

ALTER TABLE Participantes
    ADD CONSTRAINT ck_participante_asistencia CHECK (asistencia IN ('S', 'N'));
ALTER TABLE Participantes
    ADD CONSTRAINT ck_participante_rol CHECK (rol IN ('JUGADOR', 'ACUDIENTE', 'ENTRENADOR', 'ADMINISTRADOR'));

ALTER TABLE EquiposRecibenEntrenamientos
    ADD CONSTRAINT ck_recibe_asistencia CHECK (asistencia IN ('S', 'N'));
