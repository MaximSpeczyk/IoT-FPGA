#include <ArduinoMqttClient.h>
#include <WiFiNINA.h>
#include "passwordMQTT.h"

#define relay 12

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);

const char broker[] = "192.168.0.105";
int port = 1883;
const char topic[] = "RELAY";

char readCl;

void setup()
{
  pinMode(relay, OUTPUT);

  Serial.begin(9600);
  while (!Serial)
  {
    ;
  }

  Serial.print("Connecting to SSID: ");
  Serial.println(ssid);

  while (WiFi.begin(ssid, pass) != WL_CONNECTED)
  {
    Serial.print(".");
    delay(4000);
  }

  Serial.println("Congrats, you are connected :)");
  Serial.println();

  Serial.print("Attempting to connect to the MQTT broker: ");
  Serial.println(broker);

  if (!mqttClient.connect(broker, port))
  {
    Serial.print("MQTT connection failed! Error code = ");
    Serial.println(mqttClient.connectError());

    while (1)
      ;
  }

  Serial.println("You are connected to the MQTT broker :)");
  Serial.println();

  mqttClient.onMessage(onMqttMessage);

  Serial.print("Subscribing to topic: ");
  Serial.println(topic);
  Serial.println();

  mqttClient.subscribe(topic);

  Serial.println();
}

void loop()
{
  mqttClient.poll();
}

void onMqttMessage(int messageSize)
{
  Serial.println("Received a message with topic '");
  Serial.print(mqttClient.messageTopic());
  Serial.print("', length ");
  Serial.print(messageSize);
  Serial.println(" bytes:");

  while (mqttClient.available())
  {
    char receivedChar = (char)mqttClient.read();
    Serial.print(receivedChar);

    if (receivedChar == '1')
    {
      digitalWrite(relay, HIGH);
    }
    else if (receivedChar == '0')
    {
      digitalWrite(relay, LOW);
    }
  }

  Serial.println();
  Serial.println();
}
