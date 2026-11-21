--- Restricciones unicas

ALTER TABLE Personas ADD CONSTRAINT uk_persona_documento UNIQUE (documento);
ALTER TABLE Personas ADD CONSTRAINT uk_persona_correo UNIQUE (correo);
ALTER TABLE Personas ADD CONSTRAINT uk_persona_telefono UNIQUE (telefono);
ALTER TABLE Escuelas ADD CONSTRAINT uk_escuela_direccion UNIQUE (direccion);
ALTER TABLE Escuelas ADD CONSTRAINT uk_escuela_correo UNIQUE (correo);
ALTER TABLE Escuelas ADD CONSTRAINT uk_escuela_telefono UNIQUE (telefono);
