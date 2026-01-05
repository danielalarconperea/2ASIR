# main_coordinator.py
from aws_connector import AWSMqttClient
import time
import json
import sqlite3

def guardar_en_db(datos):
    """Función auxiliar para registrar el evento en SQLite"""
    try:
        conn = sqlite3.connect('soc_data.db')
        cursor = conn.cursor()
        
        # Insertar los datos recibidos del JSON
        cursor.execute('''
            INSERT INTO logs (dispositivo, tipo_evento, valor_cpu, valor_ram, alerta, mensaje)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (
            datos.get("dispositivo"),
            "Telemetría", 
            datos.get("cpu"),
            datos.get("ram"),
            1 if datos.get("alerta") else 0,
            datos.get("mensaje", "Reporte rutinario")
        ))
        
        conn.commit()
        conn.close()
    except Exception as e:
        print(f"Error al escribir en DB: {e}")

def procesar_evento(topic, payload, **kwargs):
    """Callback que procesa los mensajes entrantes de AWS IoT"""
    try:
        datos = json.loads(payload.decode('utf-8'))
        print(f"Mensaje recibido en {topic}: {datos}")
        
        # Guardar en la base de datos
        guardar_en_db(datos)
        print(f"✅ Evento de {datos.get('dispositivo')} guardado en DB.")

        # Lógica de respuesta / alertas
        if datos.get("alerta"):
            print(f"!!! ACCIÓN REQUERIDA en {datos.get('dispositivo')} !!!")
            # Aquí podrías añadir lógica para enviar comandos de vuelta (ej. backup)

    except Exception as e:
        print(f"Error procesando evento: {e}")

# --- Configuración del Cliente MQTT ---
iot_client = AWSMqttClient(
    endpoint="aj4wsdnimoej8-ats.iot.eu-north-1.amazonaws.com",
    cert_path="./Pi5-dani.cert.pem",
    key_path="./Pi5-dani.private.key",
    root_ca_path="./root-CA.crt",
    client_id="Pi5-dani"
)

# --- Inicio del Programa ---
try:
    iot_client.connect()
    
    # Suscribirse al topic de eventos (usando comodín '+' para recibir de todas las Pi)
    iot_client.subscribe("seguridad/+/eventos", procesar_evento)
    
    print("Coordinador SOC activo y escuchando permanentemente...")
    
    # Bucle infinito para mantener el programa vivo
    while True:
        time.sleep(1)

except Exception as e:
    print(f"Error fatal en el Coordinador: {e}")