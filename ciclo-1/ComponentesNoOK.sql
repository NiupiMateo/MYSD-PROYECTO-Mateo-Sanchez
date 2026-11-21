--- Casos incorrectos protegidos por los componentes

--- PC_INSCRIPCION y PC_PAGO

--- ERROR 1: AD_INSCRIPCION con inscripcion vigente en la escuela (DEBE FALLAR)
BEGIN;
INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (930300, 'Escuela Componentes NoOK', 'Calle Test Componentes 3', '6930300001', 'test930300@componentes.com');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930300, '9303000001', 'Test', 'NoOK1', DATE '2012-04-15', '3930300001', 'test930300@prueba.com');
CALL PC_INSCRIPCION.AD_INSCRIPCION(930300, 930300, 930300);
CALL PC_INSCRIPCION.AD_INSCRIPCION(930301, 930300, 930300);
ROLLBACK;

--- ERROR 2: MO_INSCRIPCION con pagos pendientes (DEBE FALLAR)
BEGIN;
INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (930300, 'Escuela Componentes NoOK', 'Calle Test Componentes 3', '6930300001', 'test930300@componentes.com');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930300, '9303000001', 'Test', 'NoOK2', DATE '2012-04-15', '3930300001', 'test930300@prueba.com');
CALL PC_INSCRIPCION.AD_INSCRIPCION(930300, 930300, 930300);
CALL PC_PAGO.AD_PAGO(930300, 150000.00, 'PENDIENTE', 'EFECTIVO', 930300);
CALL PC_INSCRIPCION.MO_INSCRIPCION(930300, 'CANCELADA');
ROLLBACK;

--- ERROR 3: EL_INSCRIPCION con pagos registrados (DEBE FALLAR)
BEGIN;
INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (930300, 'Escuela Componentes NoOK', 'Calle Test Componentes 3', '6930300001', 'test930300@componentes.com');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930300, '9303000001', 'Test', 'NoOK3', DATE '2012-04-15', '3930300001', 'test930300@prueba.com');
CALL PC_INSCRIPCION.AD_INSCRIPCION(930300, 930300, 930300);
CALL PC_PAGO.AD_PAGO(930300, 150000.00, 'PAGADO', 'EFECTIVO', 930300);
CALL PC_INSCRIPCION.EL_INSCRIPCION(930300);
ROLLBACK;

--- ERROR 4: AD_PAGO sobre una inscripcion inexistente (DEBE FALLAR)
BEGIN;
CALL PC_PAGO.AD_PAGO(930300, 150000.00, 'PAGADO', 'EFECTIVO', 9999999);
ROLLBACK;

--- ERROR 5: AD_PAGO sobre una inscripcion cancelada (DEBE FALLAR)
BEGIN;
INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (930300, 'Escuela Componentes NoOK', 'Calle Test Componentes 3', '6930300001', 'test930300@componentes.com');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930300, '9303000001', 'Test', 'NoOK5', DATE '2012-04-15', '3930300001', 'test930300@prueba.com');
CALL PC_INSCRIPCION.AD_INSCRIPCION(930300, 930300, 930300);
CALL PC_INSCRIPCION.MO_INSCRIPCION(930300, 'CANCELADA');
CALL PC_PAGO.AD_PAGO(930300, 150000.00, 'PAGADO', 'EFECTIVO', 930300);
ROLLBACK;

--- ERROR 6: MO_PAGO de un pago ya confirmado (DEBE FALLAR)
BEGIN;
INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (930300, 'Escuela Componentes NoOK', 'Calle Test Componentes 3', '6930300001', 'test930300@componentes.com');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930300, '9303000001', 'Test', 'NoOK6', DATE '2012-04-15', '3930300001', 'test930300@prueba.com');
CALL PC_INSCRIPCION.AD_INSCRIPCION(930300, 930300, 930300);
CALL PC_PAGO.AD_PAGO(930300, 150000.00, 'PAGADO', 'EFECTIVO', 930300);
CALL PC_PAGO.MO_PAGO(930300, 1000.00, 'PENDIENTE');
ROLLBACK;

--- ERROR 7: EL_PAGO de un pago ya confirmado (DEBE FALLAR)
BEGIN;
INSERT INTO Escuelas (idEscuela, nombre, direccion, telefono, correo)
VALUES (930300, 'Escuela Componentes NoOK', 'Calle Test Componentes 3', '6930300001', 'test930300@componentes.com');
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930300, '9303000001', 'Test', 'NoOK7', DATE '2012-04-15', '3930300001', 'test930300@prueba.com');
CALL PC_INSCRIPCION.AD_INSCRIPCION(930300, 930300, 930300);
CALL PC_PAGO.AD_PAGO(930300, 150000.00, 'PAGADO', 'EFECTIVO', 930300);
CALL PC_PAGO.EL_PAGO(930300);
ROLLBACK;


--- PC_ENTRENAMIENTO y PC_ASISTENCIA

--- ERROR 8: AD_ENTRENAMIENTO con un equipo inexistente (DEBE FALLAR)
BEGIN;
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930400, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 9999999);
ROLLBACK;

--- ERROR 9: AD_ENTRENAMIENTO con fecha anterior a la actual (DEBE FALLAR)
BEGIN;
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930400, CURRENT_DATE - 1, TIME '16:00', 'Cancha Test', 1);
ROLLBACK;

--- ERROR 10: MO_ENTRENAMIENTO cambia la fecha con asistencias (DEBE FALLAR)
BEGIN;
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930400, '9304000001', 'Test', 'NoOK10', DATE '1990-01-15', '3930400001', 'test930400@prueba.com');
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930400, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 1);
CALL PC_ASISTENCIA.AD_ASISTENCIA(930400, 930400, 'S', 'ENTRENADOR', 'Dirigio la sesion');
CALL PC_ENTRENAMIENTO.MO_ENTRENAMIENTO(930400, CURRENT_DATE + 9, TIME '16:00', 'Cancha Test', 'PROGRAMADO');
ROLLBACK;

--- ERROR 11: MO_ENTRENAMIENTO de un entrenamiento ya realizado (DEBE FALLAR)
BEGIN;
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930400, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 1);
CALL PC_ENTRENAMIENTO.MO_ENTRENAMIENTO(930400, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 'REALIZADO');
CALL PC_ENTRENAMIENTO.MO_ENTRENAMIENTO(930400, CURRENT_DATE + 7, TIME '18:00', 'Otra cancha', 'PROGRAMADO');
ROLLBACK;

--- ERROR 12: EL_ENTRENAMIENTO con asistencias registradas (DEBE FALLAR)
BEGIN;
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930400, '9304000001', 'Test', 'NoOK12', DATE '1990-01-15', '3930400001', 'test930400@prueba.com');
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930400, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 1);
CALL PC_ASISTENCIA.AD_ASISTENCIA(930400, 930400, 'S', 'ENTRENADOR', 'Dirigio la sesion');
CALL PC_ENTRENAMIENTO.EL_ENTRENAMIENTO(930400);
ROLLBACK;

--- ERROR 13: AD_ASISTENCIA en entrenamiento no programado (DEBE FALLAR)
BEGIN;
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930400, '9304000001', 'Test', 'NoOK13', DATE '1990-01-15', '3930400001', 'test930400@prueba.com');
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930400, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 1);
CALL PC_ENTRENAMIENTO.MO_ENTRENAMIENTO(930400, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 'CANCELADO');
CALL PC_ASISTENCIA.AD_ASISTENCIA(930400, 930400, 'S', 'ENTRENADOR', 'Dirigio la sesion');
ROLLBACK;

--- ERROR 14: AD_ASISTENCIA de jugador no inscrito en la escuela (DEBE FALLAR)
BEGIN;
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930400, '9304000001', 'Test', 'NoOK14', DATE '2013-05-10', '3930400001', 'test930400@prueba.com');
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930400, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 1);
CALL PC_ASISTENCIA.AD_ASISTENCIA(930400, 930400, 'S', 'JUGADOR', 'Buen rendimiento');
ROLLBACK;

--- ERROR 15: AD_ASISTENCIA duplicado (DEBE FALLAR)
BEGIN;
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930400, '9304000001', 'Test', 'NoOK15', DATE '1990-01-15', '3930400001', 'test930400@prueba.com');
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930400, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 1);
CALL PC_ASISTENCIA.AD_ASISTENCIA(930400, 930400, 'S', 'ENTRENADOR', 'Dirigio la sesion');
CALL PC_ASISTENCIA.AD_ASISTENCIA(930400, 930400, 'N', 'ENTRENADOR', NULL);
ROLLBACK;

--- ERROR 16: EL_ASISTENCIA de un entrenamiento ya realizado (DEBE FALLAR)
BEGIN;
INSERT INTO Personas (idPersona, documento, nombre, apellido, fechaNacimiento, telefono, correo)
VALUES (930400, '9304000001', 'Test', 'NoOK16', DATE '1990-01-15', '3930400001', 'test930400@prueba.com');
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930400, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 1);
CALL PC_ASISTENCIA.AD_ASISTENCIA(930400, 930400, 'S', 'ENTRENADOR', 'Dirigio la sesion');
CALL PC_ENTRENAMIENTO.MO_ENTRENAMIENTO(930400, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 'REALIZADO');
CALL PC_ASISTENCIA.EL_ASISTENCIA(930400, 930400);
ROLLBACK;


--- PC_PERSONA y PC_EQUIPO

--- ERROR 17: AD_PERSONA con un documento que ya existe (DEBE FALLAR)
BEGIN;
CALL PC_PERSONA.AD_PERSONA(930500, '5092891721', 'Test', 'NoOK17', DATE '2012-04-15', '3930500001', 'test930500@prueba.com');
ROLLBACK;

--- ERROR 18: AD_PERSONA con fecha de nacimiento futura (DEBE FALLAR)
BEGIN;
CALL PC_PERSONA.AD_PERSONA(930500, '9305000001', 'Test', 'NoOK18', CURRENT_DATE + 1, '3930500001', 'test930500@prueba.com');
ROLLBACK;

--- ERROR 19: AD_PERSONA con correo sin formato valido (DEBE FALLAR)
BEGIN;
CALL PC_PERSONA.AD_PERSONA(930500, '9305000001', 'Test', 'NoOK19', DATE '2012-04-15', '3930500001', 'correo-sin-arroba');
ROLLBACK;

--- ERROR 20: MO_PERSONA con el documento de otra persona (DEBE FALLAR)
BEGIN;
CALL PC_PERSONA.MO_PERSONA(2, '5092891721', 'Test', 'NoOK20', DATE '2012-04-15', '3930500001', 'test930500@prueba.com');
ROLLBACK;

--- ERROR 21: EL_PERSONA con inscripciones registradas (DEBE FALLAR)
BEGIN;
CALL PC_PERSONA.EL_PERSONA(1);
ROLLBACK;

--- ERROR 22: AD_EQUIPO con una escuela inexistente (DEBE FALLAR)
BEGIN;
CALL PC_EQUIPO.AD_EQUIPO(930500, 'Equipo NoOK22', 9999999, 1);
ROLLBACK;

--- ERROR 23: AD_EQUIPO con una categoria inexistente (DEBE FALLAR)
BEGIN;
CALL PC_EQUIPO.AD_EQUIPO(930500, 'Equipo NoOK23', 1, 9999999);
ROLLBACK;

--- ERROR 24: AD_EQUIPO con nombre repetido en la escuela (DEBE FALLAR)
BEGIN;
CALL PC_EQUIPO.AD_EQUIPO(930500, 'Equipo NoOK24', 1, 1);
CALL PC_EQUIPO.AD_EQUIPO(930501, 'Equipo NoOK24', 1, 1);
ROLLBACK;

--- ERROR 25: MO_EQUIPO cambia la escuela con entrenamientos registrados (DEBE FALLAR)
BEGIN;
CALL PC_EQUIPO.AD_EQUIPO(930500, 'Equipo NoOK25', 1, 1);
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930500, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 930500);
CALL PC_EQUIPO.MO_EQUIPO(930500, 'Equipo NoOK25', 'ACTIVO', 2, 1);
ROLLBACK;

--- ERROR 26: EL_EQUIPO con entrenamientos asociados (DEBE FALLAR)
BEGIN;
CALL PC_EQUIPO.AD_EQUIPO(930500, 'Equipo NoOK26', 1, 1);
CALL PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(930500, CURRENT_DATE + 7, TIME '16:00', 'Cancha Test', 930500);
CALL PC_EQUIPO.EL_EQUIPO(930500);
ROLLBACK;
