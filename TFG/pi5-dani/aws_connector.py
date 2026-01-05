# aws_connector.py
import json
import time
from awscrt import io, mqtt
from awsiot import mqtt_connection_builder

class AWSMqttClient:
    def __init__(self, endpoint, cert_path, key_path, root_ca_path, client_id):
        """
        Inicializa el cliente MQTT con tus certificados específicos.
        """
        self.endpoint = endpoint
        self.cert_path = cert_path
        self.key_path = key_path
        self.root_ca_path = root_ca_path
        self.client_id = client_id
        self.connection = None

    def connect(self):
        """
        Establece la conexión segura con AWS IoT Core.
        """
        print(f"Conectando dispositivo: {self.client_id}...")
        mqtt_connection = mqtt_connection_builder.mtls_from_path(
            endpoint=self.endpoint,
            cert_filepath=self.cert_path,
            pri_key_filepath=self.key_path,
            ca_filepath=self.root_ca_path,
            client_id=self.client_id,
            clean_session=False,
            keep_alive_secs=30
        )
        connect_future = mqtt_connection.connect()
        connect_future.result()
        self.connection = mqtt_connection
        print(f"¡{self.client_id} conectado con éxito a AWS!")

    def publish(self, topic, payload_dict):
        """
        Publica un mensaje JSON en el bus de AWS.
        """
        if not self.connection:
            print("Error: No hay conexión.")
            return
        message_json = json.dumps(payload_dict)
        self.connection.publish(
            topic=topic,
            payload=message_json,
            qos=mqtt.QoS.AT_LEAST_ONCE
        )
        print(f"Publicado en {topic}: {message_json}")

    def subscribe(self, topic, callback_function):
        """
        Se suscribe a un topic para recibir mensajes.
        """
        if not self.connection:
            print("Error: No hay conexión establecida.")
            return
        print(f"Suscribiéndose a {topic}...")
        subscribe_future, packet_id = self.connection.subscribe(
            topic=topic,
            qos=mqtt.QoS.AT_LEAST_ONCE,
            callback=callback_function
        )
        subscribe_future.result()
        print(f"Suscrito exitosamente a {topic}")

# --- CONFIGURACIÓN ESPECÍFICA PARA TU PI5-DANI ---
if __name__ == '__main__':
    # Datos proporcionados por el usuario
    ENDPOINT = "aj4wsdnimoej8-ats.iot.eu-north-1.amazonaws.com"
    CLIENT_ID = "Pi5-dani"
    # Nombres de archivos detectados en tu comando 'ls'
    cliente = AWSMqttClient(
        endpoint=ENDPOINT,
        cert_path="./Pi5-dani.cert.pem", # Nombre exacto de tu imagen
        key_path="./Pi5-dani.private.key", # Nombre exacto de tu imagen
        root_ca_path="./root-CA.crt", # Nombre exacto de tu imagen
        client_id=CLIENT_ID
    )
    try:
        cliente.connect()
        # Prueba de envío al topic de eventos del coordinador
        cliente.publish("seguridad/cliente1/eventos", {"estado": "online", "msg": "Pi5 lista"})
        time.sleep(2)
    except Exception as e:
        print(f"Error en la conexión: {e}")