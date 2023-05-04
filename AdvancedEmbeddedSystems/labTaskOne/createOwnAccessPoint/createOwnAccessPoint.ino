#include <SPI.h>
#include <WiFiNINA.h>
#include "password.h" 

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;   
int keyIndex = 0;                

int led1 =  LED_BUILTIN;
int status = WL_IDLE_STATUS;
WiFiServer server(80);

void setup() 
{
  Serial.begin(9600);
  while (!Serial) 
  {
    ;
  }

  Serial.println("Access Point Web Server");

  pinMode(led1, OUTPUT); 

  if (WiFi.status() == WL_NO_MODULE) 
  {
    Serial.println("Communication with WiFi module failed!");
    while (true);
  }

  String fv = WiFi.firmwareVersion();
  if (fv < WIFI_FIRMWARE_LATEST_VERSION) 
  {
    Serial.println("Please upgrade the firmware");
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

            client.print("Click <a href=\"/H\">here</a> turn the LED on<br>");
            client.print("Click <a href=\"/L\">here</a> turn the LED off<br>");

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

        if (currentLine.endsWith("GET /H")) 
        {
          digitalWrite(led1, HIGH);
        }
        if (currentLine.endsWith("GET /L")) 
        {
          digitalWrite(led1, LOW);      
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

  Serial.print("To see this page in action, open a browser to http://");
  Serial.println(ip);
}
