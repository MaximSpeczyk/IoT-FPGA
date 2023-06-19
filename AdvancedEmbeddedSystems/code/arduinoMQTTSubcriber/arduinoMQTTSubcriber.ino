#include <ArduinoMqttClient.h>
#include <WiFiNINA.h>
#include "passwordMQTT.h"

#define relay 12
#define LED 11

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);

const char broker[] = "192.168.122.84";
int port = 1883;
const char topicR[] = "RELAY";
const char topicL[] = "lightON";

char readCl;

void setup()
{
  //setting the two pins to OUTPUT
  pinMode(relay, OUTPUT);
  pinMode(LED, OUTPUT);

  Serial.begin(9600);
  while (!Serial)
  {
    ;
  }

  Serial.print("Connecting to SSID: ");
  Serial.println(ssid);

  //connecting to the SSID
  while (WiFi.begin(ssid, pass) != WL_CONNECTED)
  {
    Serial.print(".");
    delay(4000);
  }

  Serial.println("Congrats, you are connected :)");
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

  Serial.println("You are connected to the MQTT broker :)");
  Serial.println();

  mqttClient.onMessage(onMqttMessage);


  //printing which topics the arduino is going to be subscribed too
  Serial.print("Subscribing to topic: ");
  Serial.println(topicR);
  Serial.println(topicL);
  Serial.println();

  //subscribing to the topic "RELAY"
  mqttClient.subscribe(topicR);
  //subscribing to the topic "lightON"
  mqttClient.subscribe(topicL);

  Serial.println();
}

void loop()
{
  mqttClient.poll();
}

void onMqttMessage(int messageSize)
{
  //printing to the sererial monitor which topic the arduino is receiving
  String topic = mqttClient.messageTopic();
  Serial.println("Received a message with topic '");
  Serial.print(mqttClient.messageTopic());
  Serial.print("', length ");
  Serial.print(messageSize);
  Serial.println(" bytes:");

  while (mqttClient.available())
  {
    //changes the char "receivedChar" to the topic that is publishing to the specific topic
    //it holds the value of both topics, depends on which topic had the latest publish
    char receivedChar = (char)mqttClient.read();
    Serial.print(receivedChar);

    //if the latest topic was "RELAY", the "recievedChar" holds the data which turns on or off the relay
    if (topic == topicR)
    {
      //turn on the relay
      if (receivedChar == '1')
      {
        digitalWrite(relay, HIGH);
      }
      //turn off the relay
      else if (receivedChar == '0')
      {
        digitalWrite(relay, LOW);
      }
    }

    //if the latest topic was "lightON", the "recievedChar" holds the data which turns on or off the led
    else if (topic == topicL)
    {
      //turn on the led
      if (receivedChar == '1')
      {
        digitalWrite(LED, HIGH);
      }
      //turn off the led
      else if (receivedChar == '0')
      {
        digitalWrite(LED, LOW);
      }
    }
  }

  //print two more new lines
  Serial.println();
  Serial.println();
}
