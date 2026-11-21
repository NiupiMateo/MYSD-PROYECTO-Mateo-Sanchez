--- Creacion de tablas

CREATE TABLE Personas (
    idPersona TIdentificador NOT NULL,
    documento TDocumento NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    telefono TTelefono NOT NULL,
    correo TCorreo NOT NULL
);

CREATE TABLE Jugadores (
    idJugador TIdentificador NOT NULL,
    posicion VARCHAR(20),
    numeroCamiseta INTEGER NOT NULL
);

CREATE TABLE Acudientes (
    idAcudiente TIdentificador NOT NULL,
    parentesco VARCHAR(20) NOT NULL
);

CREATE TABLE Administradores (
    idAdministrador TIdentificador NOT NULL,
    fechaRegistro DATE
);

CREATE TABLE Entrenadores (
    idEntrenador TIdentificador NOT NULL,
    especialidad VARCHAR(100),
    experiencia VARCHAR(300)
);

CREATE TABLE Escuelas (
    idEscuela TIdentificador NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono TTelefono NOT NULL,
    correo TCorreo NOT NULL
);

CREATE TABLE Categorias (
    idCategoria TIdentificador NOT NULL,
    nombre VARCHAR(10) NOT NULL,
    descripcion VARCHAR(120),
    nivel TNivel NOT NULL
);

CREATE TABLE Equipos (
    idEquipo TIdentificador NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    estadoEquipo TEstadoEquipo NOT NULL,
    idEscuela TIdentificador NOT NULL,
    idCategoria TIdentificador NOT NULL
);

CREATE TABLE Inscripciones (
    idInscripcion TIdentificador NOT NULL,
    fechaInscripcion DATE NOT NULL,
    estadoInscripcion TEstadoInscripcion NOT NULL,
    idPersona TIdentificador NOT NULL,
    idEscuela TIdentificador NOT NULL
);

CREATE TABLE Pagos (
    idPago TIdentificador NOT NULL,
    fechaPago DATE NOT NULL,
    monto NUMERIC(10,2) NOT NULL,
    estadoPago TEstadoPago NOT NULL,
    metodoPago TMetodoPago NOT NULL,
    idInscripcion TIdentificador NOT NULL
);

CREATE TABLE Entrenamientos (
    idEntrenamiento TIdentificador NOT NULL,
    fecha DATE NOT NULL,
    hora TIMESTAMP NOT NULL,
    lugar VARCHAR(200) NOT NULL,
    estado TEstadoEntrenamiento NOT NULL,
    idEquipo TIdentificador NOT NULL
);

CREATE TABLE Participantes (
    idPersona TIdentificador NOT NULL,
    idEntrenamiento TIdentificador NOT NULL,
    asistencia CHAR(1) NOT NULL,
    rol TRol NOT NULL,
    observaciones VARCHAR(100)
);

CREATE TABLE EquiposRecibenEntrenamientos (
    idEntrenamiento TIdentificador NOT NULL,
    idEquipo TIdentificador NOT NULL,
    asistencia CHAR(1) NOT NULL,
    observaciones VARCHAR(100)
);
