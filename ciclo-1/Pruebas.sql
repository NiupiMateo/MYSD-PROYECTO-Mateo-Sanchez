--- Pruebas de aceptacion: dos historias complementarias de Formando Campeones (Mateo Sanchez)
---
--- Historia 1: la matricula de Samuel (la vive el administrador).
--- Historia 2: el primer entrenamiento de Samuel (lo vive el entrenador).
--- Cierre: el gerente mira lo que dejaron las dos historias y, al final, se muestra
---         que las acciones de referencia siguen protegiendo los datos.
---
--- Las dos historias usan los tres actores (PA_ADMINISTRADOR, PA_ENTRENADOR y PA_GERENTE),
--- los seis componentes (PC_PERSONA, PC_EQUIPO, PC_INSCRIPCION, PC_PAGO, PC_ENTRENAMIENTO
--- y PC_ASISTENCIA), las vistas, los disparadores y las restricciones de tupla.
--- Cada paso que DEBE FALLAR esta protegido con un SAVEPOINT para poder seguir la historia.
--- Todo ocurre dentro de una transaccion que termina en ROLLBACK: la base queda como estaba.

BEGIN;

--- PREPARACION (la hace el dueno de la base, antes de que empiece la historia)
--- La escuela Semillero del Norte abre la categoria SUB12 y contrata al entrenador Carlos Rojas.
INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (950100, 'Escuela Semillero del Norte', 'Carrera 45 # 170-20', '6950100001', 'contacto@semillerodelnorte.com');
INSERT INTO Categorias (idCategoria, nombre, descripcion, nivel)
VALUES (950100, 'SUB12', 'Formacion inicial en fundamentos tecnicos', 'BASICO');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (950101, '9501000002', 'Carlos', 'Rojas', DATE '1985-09-30', '3950100002', 'carlos.rojas950101@mail.com');
INSERT INTO Entrenadores (idEntrenador, especialidad, experiencia)
VALUES (950101, 'Formacion infantil', '10 anos en divisiones menores');


--- ============================================================
--- HISTORIA 1 (Mateo Sanchez): el administrador matricula a Samuel
--- ============================================================
--- Samuel Sanchez tiene 12 anos y quiere jugar en la Escuela Semillero del Norte.
--- Su papa llega a la oficina y el administrador atiende el tramite completo.
SET LOCAL ROLE rol_administrador;

--- 0. Antes de recibir a Samuel, el administrador crea el equipo SUB12 de la escuela
---    y registra a Samuel como persona.
CALL PA_ADMINISTRADOR.equiposAd(950100, 'Semillero SUB12', 950100, 950100);
CALL PA_ADMINISTRADOR.personasAd(950100, '9501000001', 'Samuel', 'Sanchez', DATE '2014-03-12', '3950100001', 'samuel.sanchez950100@mail.com');
SELECT idPersona, nombre, apellido, fechaNacimiento FROM PA_ADMINISTRADOR.personasC(950100);

--- 1. Inscribe a Samuel en la escuela. La inscripcion nace PENDIENTE porque aun no hay pago.
CALL PA_ADMINISTRADOR.inscripcionesAd(950100, 950100, 950100);
SELECT idInscripcion, fechaInscripcion, estadoInscripcion FROM PA_ADMINISTRADOR.inscripcionesC(950100);

--- 2. El papa pregunta si Samuel puede inscribirse otra vez para tener un cupo extra.
---    El sistema no lo permite: solo una inscripcion vigente por persona y escuela (DEBE FALLAR).
SAVEPOINT h1_duplicada;
CALL PA_ADMINISTRADOR.inscripcionesAd(950101, 950100, 950100);
ROLLBACK TO h1_duplicada;

--- 3. El papa dice que pagara por transferencia: el administrador registra la matricula
---    como pago PENDIENTE de 180.000 pesos.
CALL PA_ADMINISTRADOR.pagosAd(950100, 180000.00, 'PENDIENTE', 'TRANSFERENCIA', 950100);

--- 4. Ese mismo dia el administrador revisa quien debe plata: Samuel aparece con su monto pendiente.
SELECT idInscripcion, nombre, apellido, escuelaNombre, estadoInscripcion, montoPendiente
FROM PA_ADMINISTRADOR.inscripcionesPendientes()
WHERE idEscuela = 950100;

--- 5. El papa se arrepiente y pide cancelar, pero el pago pendiente lo impide:
---    hay que resolver el pago antes de cambiar la inscripcion (DEBE FALLAR).
SAVEPOINT h1_cancelar;
CALL PA_ADMINISTRADOR.inscripcionesMod(950100, 'CANCELADA');
ROLLBACK TO h1_cancelar;

--- 6. Al final decide seguir: llega la transferencia y el administrador confirma el pago.
---    El disparador pone la fecha de hoy y la inscripcion de Samuel pasa sola a ACTIVA.
CALL PA_ADMINISTRADOR.pagosMod(950100, 180000.00, 'PAGADO');
SELECT idPago, fechaPago, monto, estadoPago, metodoPago FROM PA_ADMINISTRADOR.pagosC(950100);
SELECT idInscripcion, estadoInscripcion FROM PA_ADMINISTRADOR.inscripcionesC(950100);

--- 7. El papa pide que se baje el valor porque ya "habia pagado menos" (DEBE FALLAR):
---    un pago confirmado no se modifica.
SAVEPOINT h1_monto;
CALL PA_ADMINISTRADOR.pagosMod(950100, 100000.00, 'PAGADO');
ROLLBACK TO h1_monto;

--- 8. Cuando el papa se va, el administrador comprueba que Samuel ya no esta entre los pendientes
---    y que la escuela recibio la plata.
SELECT COUNT(*) AS inscripcionesConPendientes
FROM PA_ADMINISTRADOR.inscripcionesPendientes()
WHERE idEscuela = 950100;
SELECT * FROM PA_ADMINISTRADOR.recaudadoPorEscuela() WHERE idEscuela = 950100;

--- 9. El administrador intenta ayudarse leyendo la tabla de pagos directamente, pero su rol
---    solo puede usar sus servicios, no las tablas (DEBE FALLAR).
SAVEPOINT h1_tabla;
SELECT * FROM Pagos WHERE idPago = 950100;
ROLLBACK TO h1_tabla;

RESET ROLE;

--- Samuel recibe su camiseta: queda registrado como jugador delantero con el numero 9.
INSERT INTO Jugadores (idJugador, posicion, numeroCamiseta) VALUES (950100, 'DELANTERO', 9);


--- ============================================================
--- HISTORIA 2 (Mateo Sanchez): el entrenador prepara el primer entrenamiento de Samuel
--- ============================================================
--- Samuel ya esta matriculado. Carlos Rojas, entrenador del equipo, organiza el entrenamiento
--- y despues toma la asistencia.
SET LOCAL ROLE rol_entrenador;

--- 1. Carlos programa el primer entrenamiento del Semillero SUB12 para dentro de tres dias.
CALL PA_ENTRENADOR.entrenamientosAd(950100, CURRENT_DATE + 3, TIME '16:00', 'Cancha Principal Norte', 950100);
SELECT idEntrenamiento, fecha, to_char(hora, 'HH24:MI') AS hora, lugar, estado, equipoNombre
FROM PA_ENTRENADOR.entrenamientosProgramadosC(950100);

--- 2. Por error intenta programar otro para ayer; el sistema no acepta fechas pasadas (DEBE FALLAR).
SAVEPOINT h2_fecha;
CALL PA_ENTRENADOR.entrenamientosAd(950101, CURRENT_DATE - 1, TIME '16:00', 'Cancha Principal Norte', 950100);
ROLLBACK TO h2_fecha;

--- 3. La cancha principal se ocupa: Carlos reprograma el entrenamiento para el dia siguiente
---    en la cancha sintetica.
CALL PA_ENTRENADOR.entrenamientosMod(950100, CURRENT_DATE + 4, TIME '17:00', 'Cancha Sintetica', 'PROGRAMADO');
SELECT idEntrenamiento, fecha, to_char(hora, 'HH24:MI') AS hora, lugar, estado
FROM PA_ENTRENADOR.entrenamientosProgramadosC(950100);

--- 4. Llega el dia: Samuel no aparece. Carlos lo marca ausente sin escribir observacion y el
---    disparador la completa sola. Carlos si registra su propia asistencia.
CALL PA_ENTRENADOR.asistenciaReg(950100, 950100, 'N', 'JUGADOR', NULL);
CALL PA_ENTRENADOR.asistenciaReg(950101, 950100, 'S', 'ENTRENADOR', 'Dirigio la sesion');
SELECT nombre, apellido, rol, asistencia, observaciones FROM PA_ENTRENADOR.asistenciaC(950100);

--- 5. Por equivocacion Carlos intenta anotar a un jugador de otra escuela;
---    solo cuentan los jugadores inscritos en la escuela del equipo (DEBE FALLAR).
SAVEPOINT h2_no_inscrito;
CALL PA_ENTRENADOR.asistenciaReg(1, 950100, 'S', 'JUGADOR', 'Jugador de otra escuela');
ROLLBACK TO h2_no_inscrito;

--- 6. Samuel llega tarde pero alcanza a entrenar: Carlos corrige su asistencia.
CALL PA_ENTRENADOR.asistenciaMod(950100, 950100, 'S', 'Llego tarde pero completo la practica');
SELECT nombre, apellido, rol, posicion, asistencia, observaciones FROM PA_ENTRENADOR.asistenciaC(950100);

--- 7. Carlos quiere mover el entrenamiento a otra semana, pero ya tiene asistencias
---    registradas y no se puede cambiar la fecha (DEBE FALLAR).
SAVEPOINT h2_mover;
CALL PA_ENTRENADOR.entrenamientosMod(950100, CURRENT_DATE + 10, TIME '17:00', 'Cancha Sintetica', 'PROGRAMADO');
ROLLBACK TO h2_mover;

--- 8. Termina la sesion: el entrenamiento pasa a REALIZADO y Samuel aparece en la lista del equipo.
CALL PA_ENTRENADOR.entrenamientosMod(950100, CURRENT_DATE + 4, TIME '17:00', 'Cancha Sintetica', 'REALIZADO');
SELECT idEntrenamiento, fecha, lugar, estado FROM PA_ENTRENADOR.entrenamientosC(950100);
SELECT idPersona, nombre, apellido, posicion, numeroCamiseta, equipoNombre FROM PA_ENTRENADOR.jugadoresEquipoC(950100);

--- 9. Un entrenamiento realizado es historia de la escuela: no se puede eliminar (DEBE FALLAR).
SAVEPOINT h2_eliminar;
CALL PA_ENTRENADOR.entrenamientosEli(950100);
ROLLBACK TO h2_eliminar;

RESET ROLE;


--- ============================================================
--- CIERRE: el gerente de la liga ve el resultado de las dos historias
--- ============================================================
SET LOCAL ROLE rol_gerente;

--- La escuela Semillero del Norte ya tiene a Samuel como jugador y su primer entrenamiento realizado.
SELECT * FROM PA_GERENTE.jugadoresPorEscuela() WHERE idEscuela = 950100;
SELECT * FROM PA_GERENTE.entrenamientosPorEquipo() WHERE idEquipo = 950100;

RESET ROLE;


--- ============================================================
--- EPILOGO: las acciones de referencia (lo hace el dueno de la base, sin pasar por los servicios)
--- ============================================================
--- Si el dueno borra el entrenamiento directamente, la base se ocupa de las dependencias:
--- ON DELETE CASCADE elimina las asistencias del entrenamiento.
SELECT COUNT(*) AS asistenciasAntes FROM Participantes WHERE idEntrenamiento = 950100;
DELETE FROM Entrenamientos WHERE idEntrenamiento = 950100;
SELECT COUNT(*) AS asistenciasDespues FROM Participantes WHERE idEntrenamiento = 950100;

--- Y si se borra la inscripcion de Samuel, ON DELETE SET NULL deja su pago sin inscripcion
--- (el pago no se pierde).
SELECT idPago, idInscripcion FROM Pagos WHERE idPago = 950100;
DELETE FROM Inscripciones WHERE idInscripcion = 950100;
SELECT idPago, idInscripcion FROM Pagos WHERE idPago = 950100;

ROLLBACK;
