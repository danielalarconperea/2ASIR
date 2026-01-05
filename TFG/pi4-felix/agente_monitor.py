# agente_monitor.py
import time
import psutil
from aws_connector import AWSMqttClient

# CONFIGURACIÓN PARA LA PI 4 (FELIX)
ENDPOINT = "aj4wsdnimoej8-ats.iot.eu-north-1.amazonaws.com"
CLIENT_ID = "Pi4-Felix"
TOPIC_EVENTOS = "seguridad/cliente1/eventos"

# Rutas de certificados
CERT_PATH = "./Pi4-Felix.cert.pem"
KEY_PATH = "./Pi4-Felix.private.key"
ROOT_CA = "./root-CA.crt"

def iniciar_agente():
    cliente = AWSMqttClient(
        endpoint=ENDPOINT,
        cert_path=CERT_PATH,
        key_path=KEY_PATH,
        root_ca_path=ROOT_CA,
        client_id=CLIENT_ID
    )

    try:
        cliente.connect()
        print(f"Agente iniciado en {CLIENT_ID}. Monitoreando sistema...")

        while True:
            # Medir recursos
            uso_cpu = psutil.cpu_percent(interval=1)
            uso_ram = psutil.virtual_memory().percent

            datos = {
                "dispositivo": CLIENT_ID,
                "cpu": uso_cpu,
                "ram": uso_ram,
                "timestamp": time.time(),
                "alerta": False
            }

            # Lógica de alerta: si el CPU supera el 80%
            if uso_cpu > 80:
                datos["alerta"] = True
                datos["mensaje"] = "¡ALERTA CRÍTICA: CPU al límite!"
                print(f"⚠️ Alerta detectada: {uso_cpu}% CPU")

            # Publicar en AWS
            cliente.publish(TOPIC_EVENTOS, datos)
            time.sleep(10) # Envío cada 10 segundos

    except Exception as e:
        print(f"Error en el agente: {e}")

if __name__ == "__main__":
    iniciar_agente()


