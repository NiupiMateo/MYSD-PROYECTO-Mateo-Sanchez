--- Intento de uso no autorizado de los servicios de los actores

--- ERROR 1: el entrenador registra un pago (DEBE FALLAR)
BEGIN;
SET LOCAL ROLE rol_entrenador;
CALL PA_ADMINISTRADOR.pagosAd(940900, 50000.00, 'PAGADO', 'EFECTIVO', 1);
ROLLBACK;

--- ERROR 2: el entrenador consulta el recaudo (DEBE FALLAR)
BEGIN;
SET LOCAL ROLE rol_entrenador;
SELECT * FROM PA_ADMINISTRADOR.recaudadoPorEscuela();
ROLLBACK;

--- ERROR 3: el administrador programa un entrenamiento (DEBE FALLAR)
BEGIN;
SET LOCAL ROLE rol_administrador;
CALL PA_ENTRENADOR.entrenamientosAd(940900, CURRENT_DATE + 5, TIME '15:00', 'Cancha Test', 1);
ROLLBACK;

--- ERROR 4: el administrador usa consultas del gerente (DEBE FALLAR)
BEGIN;
SET LOCAL ROLE rol_administrador;
SELECT * FROM PA_GERENTE.pagosPorEstado();
ROLLBACK;

--- ERROR 5: el gerente cancela una inscripcion (DEBE FALLAR)
BEGIN;
SET LOCAL ROLE rol_gerente;
CALL PA_ADMINISTRADOR.inscripcionesMod(1, 'CANCELADA');
ROLLBACK;

--- ERROR 6: el gerente registra asistencia (DEBE FALLAR)
BEGIN;
SET LOCAL ROLE rol_gerente;
CALL PA_ENTRENADOR.asistenciaReg(1, 1, 'S', 'JUGADOR', 'Sin permiso');
ROLLBACK;

--- ERROR 7: el administrador usa el componente directo (DEBE FALLAR)
BEGIN;
SET LOCAL ROLE rol_administrador;
CALL PC_PAGO.EL_PAGO(1);
ROLLBACK;

--- ERROR 8: el entrenador lee la tabla Pagos (DEBE FALLAR)
BEGIN;
SET LOCAL ROLE rol_entrenador;
SELECT * FROM Pagos;
ROLLBACK;

--- ERROR 9: el gerente modifica la tabla Pagos (DEBE FALLAR)
BEGIN;
SET LOCAL ROLE rol_gerente;
UPDATE Pagos SET estadoPago = 'PAGADO' WHERE idPago = 1;
ROLLBACK;

--- ERROR 10: el administrador borra Entrenamientos (DEBE FALLAR)
BEGIN;
SET LOCAL ROLE rol_administrador;
DELETE FROM Entrenamientos;
ROLLBACK;
