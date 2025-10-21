-- Crear la base de datos
CREATE DATABASE absentismo_db;

-- Conectar a la base de datos 
\c absentismo_db;

-- Tablas

CREATE TABLE Familias (
    id_familia SERIAL PRIMARY KEY,
    nombre_tutor VARCHAR(100),
    telefono_contacto VARCHAR(50),
    correo_electronico VARCHAR(100),
    direccion VARCHAR(200),
    situacion_laboral VARCHAR(100),
    nivel_educativo_tutor VARCHAR(100),
    ingresos_aprox NUMERIC(10,2)
);

CREATE TABLE Profesorado (
    id_profesor SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    apellidos VARCHAR(100),
    especialidad VARCHAR(100),
    correo_institucional VARCHAR(100),
    telefono_contacto VARCHAR(50)
);

CREATE TABLE Cursos (
    id_curso SERIAL PRIMARY KEY,
    nombre_curso VARCHAR(100),
    nivel_educativo VARCHAR(100),
    tutor INT REFERENCES Profesorado(id_profesor),
    anio_escolar VARCHAR(20)
);

CREATE TABLE Alumnos (
    id_alumno SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    apellidos VARCHAR(100),
    fecha_nacimiento DATE,
    genero VARCHAR(20),
    direccion VARCHAR(200),
    id_familia INT REFERENCES Familias(id_familia),
    id_curso INT REFERENCES Cursos(id_curso),
    estado_escolar VARCHAR(50)
);

CREATE TABLE Asignaturas (
    id_asignatura SERIAL PRIMARY KEY,
    nombre_asignatura VARCHAR(100),
    id_profesor INT REFERENCES Profesorado(id_profesor),
    id_curso INT REFERENCES Cursos(id_curso),
    horas_semanales INT
);

CREATE TABLE Calificaciones (
    id_calificacion SERIAL PRIMARY KEY,
    id_alumno INT REFERENCES Alumnos(id_alumno),
    id_asignatura INT REFERENCES Asignaturas(id_asignatura),
    trimestre INT,
    nota NUMERIC(5,2),
    observacion_docente TEXT
);

CREATE TABLE Asistencia (
    id_asistencia SERIAL PRIMARY KEY,
    id_alumno INT REFERENCES Alumnos(id_alumno),
    fecha DATE,
    estado VARCHAR(20),
    observacion TEXT
);

CREATE TABLE Incidencias (
    id_incidencia SERIAL PRIMARY KEY,
    id_alumno INT REFERENCES Alumnos(id_alumno),
    tipo_incidencia VARCHAR(100),
    descripcion TEXT,
    fecha DATE,
    id_profesor INT REFERENCES Profesorado(id_profesor)
);

CREATE TABLE Zonas (
    id_zona SERIAL PRIMARY KEY,
    nombre_zona VARCHAR(100),
    nivel_renta_promedio NUMERIC(10,2),
    tasa_desempleo NUMERIC(5,2),
    numero_entidades_apoyo INT
);

CREATE TABLE Servicios_Sociales (
    id_servicio SERIAL PRIMARY KEY,
    nombre_entidad VARCHAR(100),
    tipo_servicio VARCHAR(100),
    contacto VARCHAR(100),
    id_zona INT REFERENCES Zonas(id_zona)
);

CREATE TABLE Intervenciones (
    id_intervencion SERIAL PRIMARY KEY,
    id_alumno INT REFERENCES Alumnos(id_alumno),
    id_servicio INT REFERENCES Servicios_Sociales(id_servicio),
    tipo_intervencion VARCHAR(100),
    fecha_inicio DATE,
    fecha_fin DATE,
    resultado VARCHAR(100)
);
