#include <SPI.h>
#include <WiFiNINA.h>
#include <dht11.h>
#include <ArduinoMqttClient.h>

#define DHT11PIN 13
#define relay 12
#define light 11
#define humiditySoil 10

int lightValue;
int soilHumdidity;

dht11 DHT11;  

void setup()
{
  Serial.begin(9600);

  pinMode(relay, OUTPUT);
  pinMode(light, INPUT);
  pinMode(humiditySoil, INPUT);

}

void loop()
{
  int check = DHT11.read(DHT11PIN);

  Serial.print("Humidity (%): ");
  Serial.println((float)DHT11.humidity, 2);

  Serial.print("Temperature (C): ");
  Serial.println((float)DHT11.temperature, 2);

  lightValue = digitalRead(light);
  Serial.print("Light value: ");
  Serial.println(lightValue);

  soilHumdidity = digitalRead(humiditySoil);
  Serial.print("Soil Humidity: ");
  Serial.println(soilHumdidity);

  digitalWrite(relay, HIGH);
  delay(3000);
  digitalWrite(relay, LOW);

  delay(4000);
}