#include <SPI.h>
#include <WiFiNINA.h>
#include "passwordDH11.h"
#include <dht11.h>

#define DHT11PIN 13

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;   
int keyIndex = 0;

dht11 DHT11;         

int status = WL_IDLE_STATUS;
WiFiServer server(80);

void setup() 
{
  Serial.begin(9600);
  while (!Serial) 
  {
    ;
  }

  Serial.println("You want to know the temperature and humidity?");
 

  if (WiFi.status() == WL_NO_MODULE) 
  {
    Serial.println("Communication with WiFi module failed!");
    while (true);
  }

  String fv = WiFi.firmwareVersion();
  if (fv < WIFI_FIRMWARE_LATEST_VERSION) 
  {
    Serial.println("Please upgrade to the latest firmware");
  }

  Serial.print("Creating access point named: ");
  Serial.println(ssid);

  status = WiFi.beginAP(ssid, pass);
  if (status != WL_AP_LISTENING) 
  {
    Serial.println("Creating access point failed");
    while (true);
  }

  delay(10000);

  server.begin();

  printWiFiStatus();
}


void loop() 
{
  int check = DHT11.read(DHT11PIN);

  if (status != WiFi.status()) 
  {
    status = WiFi.status();

    if (status == WL_AP_CONNECTED) 
    {
      Serial.println("Device connected to AP");
    } 
    else 
    {
      Serial.println("Device disconnected from AP");
    }
  }
  
  WiFiClient client = server.available();

  if (client) 
  {                            
    Serial.println("new client");           
    String currentLine = "";                
    while (client.connected()) 
    {            
      delayMicroseconds(10);                
      if (client.available()) 
      {             
        char c = client.read();            
        Serial.write(c);                    
        if (c == '\n') 
        {                   
          if (currentLine.length() == 0) 
          {
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println();

            client.print("Humidity (%):  ");
            client.println((float)DHT11.humidity, 2);

            //why am I not able to create a new line, \n does not work, as well as client.println()
            
            client.println("Temperature (C): ");
            client.println((float)DHT11.temperature, 2);

            client.println();
            break;
          }
          else 
          {
            currentLine = "";
          }
        }
        else if (c != '\r') 
        {
          currentLine += c;
        }
      }
    }
    client.stop();
    Serial.println("client disconnected");
  }
}

void printWiFiStatus()
{
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  Serial.print("Have fun, open this in the browser://");
  Serial.println(ip);
}
