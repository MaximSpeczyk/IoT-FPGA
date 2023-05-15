#include <ArdunioMqttClient.h>
#include <WiFiNINA.h>
#include "passwordMQTT.h"

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;

WiFiClient;
MqttClient mqttClient(wifiClient);

const char broker[] = "192.168.0.105";
int port = 1883;
const char topic[] = "MAXIM";

void setup()
{
  Serial.begin
}