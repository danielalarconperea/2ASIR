import sqlite3

# Conectar (creará el archivo 'soc_data.db' si no existe)
conexion = sqlite3.connect('soc_data.db')
cursor = conexion.cursor()

# Crear tabla de logs basada en la arquitectura de tu SOC
cursor.execute('''
    CREATE TABLE IF NOT EXISTS logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dispositivo TEXT,
        tipo_evento TEXT,
        valor_cpu REAL,
        valor_ram REAL,
        alerta INTEGER,
        mensaje TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    )
''')

conexion.commit()
conexion.close()
print("Base de datos configurada correctamente.")