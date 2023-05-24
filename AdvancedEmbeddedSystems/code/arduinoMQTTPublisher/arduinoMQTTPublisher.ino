#include <ArduinoMqttClient.h>
#include <WiFiNINA.h>
#include "passwordMQTT.h"
#include <dht11.h>

#define DHT11PIN 13
#define LIGHT_PIN 11
#define HUMIDITY_SOIL_PIN 10

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);

const char broker[] = "raspberrypi.local";
int port = 1883;
const char dhtTopic[] = "DHT11";
const char lightTopic[] = "light";
const char humiditySoilTopic[] = "Soil";

int lightValue;
int soilHumidity;

dht11 dhtSensor;

const long interval = 5000;
unsigned long previousMillis = 0;

void setup()
{
  Serial.begin(9600);
  while (!Serial)
  {
    ;
  }

  Serial.print("Attempting to connect to WPA SSID: ");
  Serial.println(ssid);
  while (WiFi.begin(ssid, pass) != WL_CONNECTED)
  {
    Serial.print(".");
    delay(5000);
  }

  Serial.println("You're connected to the network");
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

  Serial.println("You're connected to the MQTT broker!");
  Serial.println();

  pinMode(LIGHT_PIN, INPUT);
  pinMode(HUMIDITY_SOIL_PIN, INPUT);
}

void loop()
{
  int check = dhtSensor.read(DHT11PIN);

  mqttClient.poll();

  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval)
  {
    previousMillis = currentMillis;

    int check = dhtSensor.read(DHT11PIN);

    lightValue = digitalRead(LIGHT_PIN);
    soilHumidity = digitalRead(HUMIDITY_SOIL_PIN);

    Serial.print("Sending message to topic: ");
    Serial.println(dhtTopic);
    Serial.println(dhtSensor.temperature);
    Serial.println(dhtSensor.humidity);

    mqttClient.beginMessage(dhtTopic);
    mqttClient.print("Humidity (%): ");
    mqttClient.println((float)dhtSensor.humidity, 2);

    mqttClient.print("Temperature (C): ");
    mqttClient.println((float)dhtSensor.temperature, 2);
    mqttClient.endMessage();

    Serial.print("Sending message to topic: ");
    Serial.println(lightTopic);
    Serial.println(lightValue);

    mqttClient.beginMessage(lightTopic);
    mqttClient.print("Light value: ");
    mqttClient.println(lightValue);
    mqttClient.endMessage();

    Serial.print("Sending message to topic: ");
    Serial.println(humiditySoilTopic);
    Serial.println(soilHumidity);

    mqttClient.beginMessage(humiditySoilTopic);
    mqttClient.print("Soil Humidity: ");
    mqttClient.println(soilHumidity);
    mqttClient.endMessage();

    Serial.println();
  }
}
