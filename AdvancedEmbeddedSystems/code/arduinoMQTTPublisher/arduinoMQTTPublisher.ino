#include <ArduinoMqttClient.h>
#include <WiFiNINA.h>
#include "passwordMQTT.h"
#include <dht11.h>

#define DHT11PIN 13
#define LIGHT_PIN A4
#define HUMIDITY_SOIL_PIN A5

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);

const char broker[] = "192.168.122.84";
int port = 1883;

const char dhtTopicTemperature[] = "DHT11Temp";
const char dhtTopicHumidity[] = "DHT11Hum";
const char lightTopic[] = "light";
const char humiditySoilTopic[] = "Soil";

float lightValue;
float soilHumidity;

dht11 dhtSensor;

const long interval =3000;
unsigned long previousMillis = 0;

void setup()
{
  Serial.begin(9600);
  while (!Serial)
  {
    ;
  }

  //connecting to the SSID
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

  //connecting to the MQTT broker
  if (!mqttClient.connect(broker, port))
  {
    Serial.print("MQTT connection failed! Error code = ");
    Serial.println(mqttClient.connectError());
    while (1)
      ;
  }

  Serial.println("You're connected to the MQTT broker!");
  Serial.println();

  //setting the analog pins to INPUT 
  //this includes the photoresistor and the soil sensor
  pinMode(LIGHT_PIN, INPUT);
  pinMode(HUMIDITY_SOIL_PIN, INPUT);
}

void loop()
{

  mqttClient.poll();

  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval)
  {
    //every 3 seconds there will be an update to the data that is published
    previousMillis = currentMillis;

    //check the DHT11 for its data (temperature and humidity in %)
    int check = dhtSensor.read(DHT11PIN);

    //get the data from the photoresistor (the more light the lower the value)
    lightValue = analogRead(LIGHT_PIN);

    //get the data from the soil sensor (%)
    soilHumidity = analogRead(HUMIDITY_SOIL_PIN);

    //printing the information that is being published to the serial monitor
    Serial.print("Sending message to topic: ");
    Serial.println(dhtTopicTemperature);
    Serial.println(dhtSensor.temperature);
    Serial.println(dhtTopicHumidity);
    Serial.println(dhtSensor.humidity);

    //publishing the humidity data from the DHT11 to the topic "dhtTopicHumidity"
    mqttClient.beginMessage(dhtTopicHumidity);
    mqttClient.println((float)dhtSensor.humidity, 2);
    mqttClient.endMessage();

    //publishing the temperature data from the DHT11 to the topic "dhtTopicTemperature"
    mqttClient.beginMessage(dhtTopicTemperature);
    mqttClient.println((float)dhtSensor.temperature, 2);
    mqttClient.endMessage();

    //printing the information that is being published to the serial monitor
    Serial.print("Sending message to topic: ");
    Serial.println(lightTopic);
    Serial.println(lightValue);

    //publishing the data from the photoresistor to the topic "lightTopic"
    mqttClient.beginMessage(lightTopic);
    mqttClient.println(lightValue);
    mqttClient.endMessage();

    //printing the information that is being published to the serial monitor
    Serial.print("Sending message to topic: ");
    Serial.println(humiditySoilTopic);
    Serial.println(soilHumidity);

    //publishing the data from the soil sensor to the topic "humiditySoilTopic"
    mqttClient.beginMessage(humiditySoilTopic);
    mqttClient.println(soilHumidity);
    mqttClient.endMessage();

    //new line
    Serial.println();
  }
}
