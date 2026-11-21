--- Uso correcto de los servicios de los actores

BEGIN;

--- Datos base
INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (940100, 'Escuela Seguridad Test', 'Calle Test Seguridad 1', '6940100001', 'test940100@seguridad.com');
INSERT INTO Categorias (idCategoria, nombre, descripcion, nivel)
VALUES (940100, 'SUB10', 'Categoria Test Seguridad', 'BASICO');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (940101, '9401000002', 'Test', 'Seguridad2', DATE '1988-02-20', '3940100002', 'test940101@prueba.com');
INSERT INTO Entrenadores (idEntrenador, especialidad, experiencia) VALUES (940101, 'Preparacion fisica', '8 anos');

--- ADMINISTRADOR
SET LOCAL ROLE rol_administrador;

CALL PA_ADMINISTRADOR.equiposAd(940100, 'Equipo Seguridad 100', 940100, 940100);
CALL PA_ADMINISTRADOR.equiposAd(940101, 'Equipo Seguridad 101', 940100, 940100);
CALL PA_ADMINISTRADOR.equiposMod(940101, 'Equipo Seguridad 101', 'INACTIVO', 940100, 940100);
SELECT * FROM PA_ADMINISTRADOR.equiposC(940100);
CALL PA_ADMINISTRADOR.equiposEli(940101);

CALL PA_ADMINISTRADOR.personasAd(940100, '9401000001', 'Test', 'Seguridad1', DATE '2014-06-01', '3940100001', 'test940100@prueba.com');
CALL PA_ADMINISTRADOR.personasMod(940100, '9401000001', 'Test', 'Seguridad1', DATE '2014-06-01', '3940100009', 'test940100@prueba.com');
SELECT * FROM PA_ADMINISTRADOR.personasC(940100);
CALL PA_ADMINISTRADOR.personasAd(940102, '9401000003', 'Test', 'Seguridad3', DATE '2014-06-01', '3940100003', 'test940102@prueba.com');
CALL PA_ADMINISTRADOR.personasEli(940102);

CALL PA_ADMINISTRADOR.inscripcionesAd(940100, 940100, 940100);
CALL PA_ADMINISTRADOR.pagosAd(940100, 120000.00, 'PENDIENTE', 'EFECTIVO', 940100);
SELECT * FROM PA_ADMINISTRADOR.inscripcionesC(940100);
SELECT idInscripcion, nombre, apellido, escuelaNombre, montoPendiente
FROM PA_ADMINISTRADOR.inscripcionesPendientes()
WHERE idEscuela = 940100;

CALL PA_ADMINISTRADOR.pagosMod(940100, 120000.00, 'PAGADO');
SELECT * FROM PA_ADMINISTRADOR.pagosC(940100);
SELECT * FROM PA_ADMINISTRADOR.inscripcionesC(940100);
SELECT * FROM PA_ADMINISTRADOR.recaudadoPorEscuela() WHERE idEscuela = 940100;

CALL PA_ADMINISTRADOR.pagosAd(940101, 30000.00, 'PENDIENTE', 'TARJETA', 940100);
CALL PA_ADMINISTRADOR.pagosEli(940101);

RESET ROLE;
INSERT INTO Jugadores (idJugador, posicion, numeroCamiseta) VALUES (940100, 'PORTERO', 1);

--- ENTRENADOR
SET LOCAL ROLE rol_entrenador;

CALL PA_ENTRENADOR.entrenamientosAd(940100, CURRENT_DATE + 5, TIME '15:00', 'Cancha Seguridad', 940100);
CALL PA_ENTRENADOR.entrenamientosMod(940100, CURRENT_DATE + 6, TIME '15:30', 'Cancha Seguridad Norte', 'PROGRAMADO');
SELECT * FROM PA_ENTRENADOR.entrenamientosProgramadosC(940100);

CALL PA_ENTRENADOR.asistenciaReg(940100, 940100, 'N', 'JUGADOR', NULL);
CALL PA_ENTRENADOR.asistenciaReg(940101, 940100, 'S', 'ENTRENADOR', 'Dirigio la sesion');
CALL PA_ENTRENADOR.asistenciaMod(940100, 940100, 'S', 'Llego en el segundo bloque');
SELECT * FROM PA_ENTRENADOR.asistenciaC(940100);
SELECT * FROM PA_ENTRENADOR.jugadoresEquipoC(940100);

CALL PA_ENTRENADOR.entrenamientosAd(940101, CURRENT_DATE + 12, TIME '15:00', 'Cancha Seguridad', 940100);
CALL PA_ENTRENADOR.entrenamientosEli(940101);
SELECT idEntrenamiento, fecha, lugar, estado FROM PA_ENTRENADOR.entrenamientosC(940100);

RESET ROLE;

--- ADMINISTRADOR: consultas
SET LOCAL ROLE rol_administrador;

SELECT * FROM PA_ADMINISTRADOR.jugadoresPorEquipo(940100);
SELECT * FROM PA_ADMINISTRADOR.jugadoresPorCategoria(940100);

RESET ROLE;

--- GERENTE
SET LOCAL ROLE rol_gerente;

SELECT * FROM PA_GERENTE.jugadoresPorEscuela() WHERE idEscuela = 940100;
SELECT * FROM PA_GERENTE.pagosPorEstado();
SELECT * FROM PA_GERENTE.promedioJugadoresPorEntrenamiento();
SELECT * FROM PA_GERENTE.escuelasConMayorDemanda();
SELECT * FROM PA_GERENTE.entrenamientosPorEquipo() WHERE idEquipo = 940100;

RESET ROLE;

ROLLBACK;
