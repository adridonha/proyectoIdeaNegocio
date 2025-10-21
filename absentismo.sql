CREATE DATABASE IF NOT EXISTS absentismo_db;
USE absentismo_db;

CREATE TABLE Familias (
  id_familia INT AUTO_INCREMENT PRIMARY KEY,
  nombre_tutor VARCHAR(100),
  telefono_contacto VARCHAR(50),
  correo_electronico VARCHAR(100),
  direccion VARCHAR(200),
  situacion_laboral VARCHAR(100),
  nivel_educativo_tutor VARCHAR(100),
  ingresos_aprox DECIMAL(10,2)
);

CREATE TABLE Profesorado (
  id_profesor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  apellidos VARCHAR(100),
  especialidad VARCHAR(100),
  correo_institucional VARCHAR(100),
  telefono_contacto VARCHAR(50)
);

CREATE TABLE Cursos (
  id_curso INT AUTO_INCREMENT PRIMARY KEY,
  nombre_curso VARCHAR(100),
  nivel_educativo VARCHAR(100),
  tutor INT,
  anio_escolar VARCHAR(20),
  FOREIGN KEY (tutor) REFERENCES Profesorado(id_profesor)
);

CREATE TABLE Alumnos (
  id_alumno INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  apellidos VARCHAR(100),
  fecha_nacimiento DATE,
  genero VARCHAR(20),
  direccion VARCHAR(200),
  id_familia INT,
  id_curso INT,
  estado_escolar VARCHAR(50),
  FOREIGN KEY (id_familia) REFERENCES Familias(id_familia),
  FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);

CREATE TABLE Asignaturas (
  id_asignatura INT AUTO_INCREMENT PRIMARY KEY,
  nombre_asignatura VARCHAR(100),
  id_profesor INT,
  id_curso INT,
  horas_semanales INT,
  FOREIGN KEY (id_profesor) REFERENCES Profesorado(id_profesor),
  FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);

CREATE TABLE Calificaciones (
  id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
  id_alumno INT,
  id_asignatura INT,
  trimestre INT,
  nota DECIMAL(5,2),
  observacion_docente TEXT,
  FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno),
  FOREIGN KEY (id_asignatura) REFERENCES Asignaturas(id_asignatura)
);

CREATE TABLE Asistencia (
  id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
  id_alumno INT,
  fecha DATE,
  estado VARCHAR(20),
  observacion TEXT,
  FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno)
);

CREATE TABLE Incidencias (
  id_incidencia INT AUTO_INCREMENT PRIMARY KEY,
  id_alumno INT,
  tipo_incidencia VARCHAR(100),
  descripcion TEXT,
  fecha DATE,
  id_profesor INT,
  FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno),
  FOREIGN KEY (id_profesor) REFERENCES Profesorado(id_profesor)
);

CREATE TABLE Zonas (
  id_zona INT AUTO_INCREMENT PRIMARY KEY,
  nombre_zona VARCHAR(100),
  nivel_renta_promedio DECIMAL(10,2),
  tasa_desempleo DECIMAL(5,2),
  numero_entidades_apoyo INT
);

CREATE TABLE Servicios_Sociales (
  id_servicio INT AUTO_INCREMENT PRIMARY KEY,
  nombre_entidad VARCHAR(100),
  tipo_servicio VARCHAR(100),
  contacto VARCHAR(100),
  id_zona INT,
  FOREIGN KEY (id_zona) REFERENCES Zonas(id_zona)
);

CREATE TABLE Intervenciones (
  id_intervencion INT AUTO_INCREMENT PRIMARY KEY,
  id_alumno INT,
  id_servicio INT,
  tipo_intervencion VARCHAR(100),
  fecha_inicio DATE,
  fecha_fin DATE,
  resultado VARCHAR(100),
  FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno),
  FOREIGN KEY (id_servicio) REFERENCES Servicios_Sociales(id_servicio)
);
