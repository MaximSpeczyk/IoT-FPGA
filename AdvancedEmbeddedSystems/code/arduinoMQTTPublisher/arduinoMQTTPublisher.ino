#include <ArduinoMqttClient.h>
#include <WiFiNINA.h>
#include "passwordMQTT.h"
#include <dht11.h> 

#define DHT11PIN 13
#define light 11
#define humiditySoil 10

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);

const char broker[] = "192.168.0.105";
int        port     = 1883;
const char DHT11[]  = "DHT11";
const char lightChanel[]  = "light";
const char humiditySoilChanel[]  = "Soil";

int lightValue;
int soilHumdidity;

dht11 DHT11; 

const long interval = 5000;
unsigned long previousMillis = 0;

int count = 0;

void setup() 
{
  Serial.begin(9600);
  while (!Serial) {
    ;
  }


  Serial.print("Attempting to connect to WPA SSID: ");
  Serial.println(ssid);
  while (WiFi.begin(ssid, pass) != WL_CONNECTED) {

    Serial.print(".");
    delay(5000);
  }

  Serial.println("You're connected to the network");
  Serial.println();

  Serial.print("Attempting to connect to the MQTT broker: ");
  Serial.println(broker);

  if (!mqttClient.connect(broker, port)) {
    Serial.print("MQTT connection failed! Error code = ");
    Serial.println(mqttClient.connectError());

    while (1);
  }

  Serial.println("You're connected to the MQTT broker!");
  Serial.println();

  pinMode(relay, OUTPUT);
  pinMode(light, INPUT);
  pinMode(humiditySoil, INPUT);

}

void loop() 
{

  int check = DHT11.read(DHT11PIN);

  mqttClient.poll();

  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval) 
  {

    previousMillis = currentMillis;

    int check = DHT11.read(DHT11PIN);

    lightValue = digitalRead(light);

    soilHumdidity = digitalRead(humiditySoil);

    Serial.print("Sending message to topic: DHT11");
    Serial.println(DHT11);
    Serial.println(DHT11.temperature);
    Serial.println(DHT11.humdidity);

    mqttClient.beginMessage(DHT11);
    mqttClient.print("Humidity (%): ");
    mqttClient.println((float)DHT11.humidity, 2);

    mqttClient.print("Temperature (C): ");
    mqttClient.println((float)DHT11.temperature, 2);
    mqttClient.endMessage();

    Serial.print("Sending message to topic: lightChanel");
    Serial.println(lightChanel);
    Serial.println(lightValue);

    mqttClient.beginMessage(lightChanel);
    mqttClient.print("Light value: ");
    mqttClient.println(lightValue);
    mqttClient.endMessage();

    Serial.print("Sending message to topic: humiditySoilChanel");
    Serial.println(humiditySoilChanel);
    Serial.println(humiditySoilChanel);

    mqttClient.beginMessage(humiditySoilChanel);
    mqttClient.print("Soil Humidity: ");
    mqttClient.println(soilHumdidity);
    mqttClient.endMessage();
    
    Serial.println();
  }
}