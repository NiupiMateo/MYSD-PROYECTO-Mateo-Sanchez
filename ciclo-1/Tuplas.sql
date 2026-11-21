--- Restricciones de tupla

ALTER TABLE Participantes
ADD CONSTRAINT ck_participante_asistencia_obs
CHECK (
    (asistencia = 'S' AND observaciones IS NOT NULL)
    OR
    (asistencia = 'N')
);

ALTER TABLE EquiposRecibenEntrenamientos
ADD CONSTRAINT ck_recibe_asistencia_obs
CHECK (
    (asistencia = 'S' AND observaciones IS NOT NULL)
    OR
    (asistencia = 'N')
);

ALTER TABLE Pagos
ADD CONSTRAINT ck_pago_estado_monto
CHECK (
    (estadoPago IN ('PAGADO', 'PENDIENTE', 'ANULADO'))
    AND monto > 0
);
