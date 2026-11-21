--- Casos correctos de uso de los componentes

--- PC_PERSONA y PC_EQUIPO

BEGIN;

INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (930000, 'Escuela Componentes Test 0', 'Calle Test Componentes 0', '6930000001', 'test930000@componentes.com');
INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (930001, 'Escuela Componentes Test 00', 'Calle Test Componentes 00', '6930000002', 'test930001@componentes.com');
INSERT INTO Categorias (idCategoria, nombre, descripcion, nivel)
VALUES (930000, 'SUB10', 'Categoria Test Componentes', 'BASICO');

--- AD_PERSONA: persona nueva
CALL PC_PERSONA.AD_PERSONA(930000, '9300000001', 'Mateo', 'Sanchez', DATE '2012-04-15', '3930000001', 'mateo.sanchez930000@mail.com');
SELECT * FROM PC_PERSONA.CO_PERSONA(930000);

--- MO_PERSONA: cambia telefono y correo
CALL PC_PERSONA.MO_PERSONA(930000, '9300000001', 'Mateo', 'Sanchez', DATE '2012-04-15', '3930000009', 'mateo.nuevo930000@mail.com');
SELECT idPersona, telefono, correo FROM PC_PERSONA.CO_PERSONA(930000);

--- EL_PERSONA: sin inscripciones se elimina
CALL PC_PERSONA.EL_PERSONA(930000);
SELECT COUNT(*) AS personas FROM PC_PERSONA.CO_PERSONA(930000);

--- AD_EQUIPO: queda ACTIVO
CALL PC_EQUIPO.AD_EQUIPO(930000, 'Equipo Componentes A', 930000, 930000);
CALL PC_EQUIPO.AD_EQUIPO(930001, 'Equipo Componentes B', 930000, 930000);
SELECT * FROM PC_EQUIPO.CO_EQUIPO(930000);

--- MO_EQUIPO: sin entrenamientos puede cambiar de escuela y de estado
CALL PC_EQUIPO.MO_EQUIPO(930001, 'Equipo Componentes B', 'INACTIVO', 930001, 930000);
SELECT idEquipo, nombre, estadoEquipo, idEscuela FROM PC_EQUIPO.CO_EQUIPO(930001);

--- EL_EQUIPO: sin entrenamientos se elimina
CALL PC_EQUIPO.EL_EQUIPO(930001);
SELECT COUNT(*) AS equipos FROM PC_EQUIPO.CO_EQUIPO(930001);

ROLLBACK;


--- PC_INSCRIPCION y PC_PAGO

BEGIN;

INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (930100, 'Escuela Componentes Test', 'Calle Test Componentes 1', '6930100001', 'test930100@componentes.com');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930100, '9301000001', 'Mateo', 'Sanchez', DATE '2012-04-15', '3930100001', 'mateo.sanchez930100@mail.com');

--- AD_INSCRIPCION: queda PENDIENTE con la fecha actual
CALL PC_INSCRIPCION.AD_INSCRIPCION(930100, 930100, 930100);
SELECT * FROM PC_INSCRIPCION.CO_INSCRIPCION(930100);

--- AD_PAGO: pago pendiente de la matricula
CALL PC_PAGO.AD_PAGO(930100, 150000.00, 'PENDIENTE', 'EFECTIVO', 930100);
SELECT * FROM PC_PAGO.CO_PAGO(930100);

--- MO_PAGO: al confirmar el pago la inscripcion queda ACTIVA
CALL PC_PAGO.MO_PAGO(930100, 150000.00, 'PAGADO');
SELECT idPago, fechaPago, monto, estadoPago FROM PC_PAGO.CO_PAGO(930100);
SELECT idInscripcion, estadoInscripcion FROM PC_INSCRIPCION.CO_INSCRIPCION(930100);

--- AD_PAGO: pago PAGADO desde el registro
CALL PC_PAGO.AD_PAGO(930101, 80000.00, 'PAGADO', 'TRANSFERENCIA', 930100);

--- EL_PAGO: se elimina un pago pendiente
CALL PC_PAGO.AD_PAGO(930102, 50000.00, 'PENDIENTE', 'TARJETA', 930100);
CALL PC_PAGO.EL_PAGO(930102);
SELECT idPago, monto, estadoPago, metodoPago FROM PC_PAGO.CO_PAGO(930100);

--- MO_INSCRIPCION: sin pagos pendientes se puede cancelar
CALL PC_INSCRIPCION.MO_INSCRIPCION(930100, 'CANCELADA');
SELECT idInscripcion, estadoInscripcion FROM PC_INSCRIPCION.CO_INSCRIPCION(930100);

--- AD_INSCRIPCION: se vuelve a inscribir tras cancelar
CALL PC_INSCRIPCION.AD_INSCRIPCION(930101, 930100, 930100);
SELECT idInscripcion, fechaInscripcion, estadoInscripcion FROM PC_INSCRIPCION.CO_INSCRIPCION(930100);

--- EL_INSCRIPCION: una inscripcion sin pagos se elimina
CALL PC_INSCRIPCION.EL_INSCRIPCION(930101);
SELECT idInscripcion, estadoInscripcion FROM PC_INSCRIPCION.CO_INSCRIPCION(930100);

ROLLBACK;


--- PC_ENTRENAMIENTO y PC_ASISTENCIA

BEGIN;

INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (930200, 'Escuela Componentes Test 2', 'Calle Test Componentes 2', '6930200001', 'test930200@componentes.com');
INSERT INTO Categorias (idCategoria, nombre, descripcion, nivel)
VALUES (930200, 'SUB12', 'Categoria Test Componentes', 'BASICO');
INSERT INTO Equipos (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
VALUES (930200, 'Equipo Componentes 200', 'ACTIVO', 930200, 930200);
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930200, '9302000001', 'Test', 'Jugador1', DATE '2013-05-10', '3930200001', 'test930200@prueba.com');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930201, '9302000002', 'Test', 'Jugador2', DATE '2013-08-22', '3930200002', 'test930201@prueba.com');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930202, '9302000003', 'Test', 'Entrenador', DATE '1990-01-15', '3930200003', 'test930202@prueba.com');
INSERT INTO Inscripciones (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (930200, CURRENT_DATE, 'ACTIVA', 930200, 930200);
INSERT INTO Inscripciones (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (930201, CURRENT_DATE, 'ACTIVA', 930201, 930200);
INSERT INTO Jugadores (idJugador, posicion, numeroCamiseta) VALUES (930200, 'DELANTERO', 9);
INSERT INTO Jugadores (idJugador, posicion, numeroCamiseta) VALUES (930201, 'DEFENSA', 4);
INSERT INTO Entrenadores (idEntrenador, especialidad, experiencia) VALUES (930202, 'Tactica', '5 anos');

--- AD_ENTRENAMIENTO: queda PROGRAMADO
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930200, CURRENT_DATE + 7, TIME '16:00', 'Cancha Principal Norte', 930200);
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930201, CURRENT_DATE + 14, TIME '10:00', 'Cancha Auxiliar', 930200);
SELECT * FROM PC_ENTRENAMIENTO.CO_ENTRENAMIENTO(930200);

--- MO_ENTRENAMIENTO: reprogramar sin asistencias
CALL PC_ENTRENAMIENTO.MO_ENTRENAMIENTO(930200, CURRENT_DATE + 8, TIME '17:30', 'Cancha Sintetica', 'PROGRAMADO');
SELECT idEntrenamiento, fecha, hora, lugar, estado FROM PC_ENTRENAMIENTO.CO_ENTRENAMIENTO(930200);

--- AD_ASISTENCIA: jugadores inscritos y entrenador
CALL PC_ASISTENCIA.AD_ASISTENCIA(930200, 930200, 'S', 'JUGADOR', 'Buen rendimiento');
CALL PC_ASISTENCIA.AD_ASISTENCIA(930201, 930200, 'N', 'JUGADOR', NULL);
CALL PC_ASISTENCIA.AD_ASISTENCIA(930202, 930200, 'S', 'ENTRENADOR', 'Dirigio la sesion');
SELECT * FROM PC_ASISTENCIA.CO_ASISTENCIA(930200);

--- MO_ASISTENCIA: el jugador llego tarde, pasa de N a S
CALL PC_ASISTENCIA.MO_ASISTENCIA(930201, 930200, 'S', 'Llego tarde pero participo');
SELECT idPersona, asistencia, observaciones FROM PC_ASISTENCIA.CO_ASISTENCIA(930200);

--- EL_ASISTENCIA: se retira una asistencia
CALL PC_ASISTENCIA.EL_ASISTENCIA(930202, 930200);
SELECT idPersona, rol, asistencia FROM PC_ASISTENCIA.CO_ASISTENCIA(930200);

--- MO_ENTRENAMIENTO: pasa a REALIZADO
CALL PC_ENTRENAMIENTO.MO_ENTRENAMIENTO(930200, CURRENT_DATE + 8, TIME '17:30', 'Cancha Sintetica', 'REALIZADO');
SELECT idEntrenamiento, fecha, estado FROM PC_ENTRENAMIENTO.CO_ENTRENAMIENTO(930200);

--- EL_ENTRENAMIENTO: programado y sin asistencias
CALL PC_ENTRENAMIENTO.EL_ENTRENAMIENTO(930201);
SELECT idEntrenamiento, fecha, estado FROM PC_ENTRENAMIENTO.CO_ENTRENAMIENTO(930200);

ROLLBACK;
