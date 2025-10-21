import mysql.connector
import psycopg2
import json
from decimal import Decimal

# Conexiones a las bases de datos

# MySQL
mysql_conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='admin123',
    database='absentismo_db',
    port=3306
)
mysql_cursor = mysql_conn.cursor()

# MariaDB
mariadb_conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='admin123',
    database='absentismo_db',
    port=3307
)
mariadb_cursor = mariadb_conn.cursor()

# PostgreSQL
pg_conn = psycopg2.connect(
    host='localhost',
    user='admin',
    password='admin123',
    database='absentismo_db',
    port=5433
)
pg_cursor = pg_conn.cursor()

# Función para generar JSON

def generar_json(cursor, query, archivo):
    cursor.execute(query)
    columnas = [desc[0] for desc in cursor.description]
    datos = []
    for fila in cursor.fetchall():
        fila_dict = {}
        for i, valor in enumerate(fila):
            # Convertir Decimal a float
            if isinstance(valor, Decimal):
                valor = float(valor)
            # Convertir date/datetime a string
            elif hasattr(valor, 'isoformat'):
                valor = valor.isoformat()
            fila_dict[columnas[i]] = valor
        datos.append(fila_dict)
    with open(archivo, 'w', encoding='utf-8') as f:
        json.dump(datos, f, ensure_ascii=False, indent=4)

# Consultas importantes

# 1. Datos de alumnos con sus familias y cursos (importante para ver la distribución de estudiantes)
query_alumnos = """
SELECT a.id_alumno, a.nombre, a.apellidos, a.genero, a.fecha_nacimiento,
       f.nombre_tutor, f.telefono_contacto, f.correo_electronico,
       c.nombre_curso, c.nivel_educativo
FROM Alumnos a
JOIN Familias f ON a.id_familia = f.id_familia
JOIN Cursos c ON a.id_curso = c.id_curso
LIMIT 10;
"""

# 2. Incidencias y el profesor que las registró (importante para analizar problemas frecuentes)
query_incidencias = """
SELECT i.id_incidencia, i.tipo_incidencia, i.descripcion, i.fecha,
       a.nombre AS alumno_nombre, a.apellidos AS alumno_apellidos,
       p.nombre AS profesor_nombre, p.apellidos AS profesor_apellidos
FROM Incidencias i
JOIN Alumnos a ON i.id_alumno = a.id_alumno
JOIN Profesorado p ON i.id_profesor = p.id_profesor
LIMIT 10;
"""

# 3. Intervenciones y servicios sociales (importante para analizar apoyo recibido)
query_intervenciones = """
SELECT inter.id_intervencion, inter.tipo_intervencion, inter.fecha_inicio, inter.fecha_fin, inter.resultado,
       a.nombre AS alumno_nombre, a.apellidos AS alumno_apellidos,
       s.nombre_entidad, s.tipo_servicio
FROM Intervenciones inter
JOIN Alumnos a ON inter.id_alumno = a.id_alumno
JOIN Servicios_Sociales s ON inter.id_servicio = s.id_servicio
LIMIT 10;
"""

# Generar archivos JSON

# MySQL
generar_json(mysql_cursor, query_alumnos, "alumnos_mysql.json")
generar_json(mysql_cursor, query_incidencias, "incidencias_mysql.json")
generar_json(mysql_cursor, query_intervenciones, "intervenciones_mysql.json")

# MariaDB
generar_json(mariadb_cursor, query_alumnos, "alumnos_mariadb.json")
generar_json(mariadb_cursor, query_incidencias, "incidencias_mariadb.json")
generar_json(mariadb_cursor, query_intervenciones, "intervenciones_mariadb.json")

# PostgreSQL
generar_json(pg_cursor, query_alumnos, "alumnos_postgres.json")
generar_json(pg_cursor, query_incidencias, "incidencias_postgres.json")
generar_json(pg_cursor, query_intervenciones, "intervenciones_postgres.json")

# Cerrar conexiones

mysql_cursor.close()
mysql_conn.close()
mariadb_cursor.close()
mariadb_conn.close()
pg_cursor.close()
pg_conn.close()

print("Archivos JSON generados correctamente para MySQL, MariaDB y PostgreSQL.")
