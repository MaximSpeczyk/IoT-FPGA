#include <WiFiNINA.h>

char ssid[] = "TP-Link_6FF2";
char pass[] = "69202070";
int keyIndex = 0;
int status = WL_IDLE_STATUS;

WiFiServer server(80);
WiFiClient client = server.available();

#define relay 12

void setup()
{
  Serial.begin(9600);
  pinMode(relay, OUTPUT);

  while(!Serial);
    enable_WiFi();
    connect_WiFi();
    server.begin();
    printWifiStatus();
}

void loop()
{
  client = server.available();

  if(client)
  {
    printWEB();
  }
}

void printWifiStatus()
{
  Serial.print("SSID. ");
  Serial.println(WiFi.SSID());

  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");

  Serial.print("Open the Browser :)");
  Serial.println(ip);
}

void enable_WiFi()
{
  if (WiFi.status() == WL_NO_MODULE)
  {
    Serial.println("Communication with WiFi module failed!");
    while (true);
  }
  String fv = WiFi.firmwareVersion();
  if (fv < "1.0.0")
  {
    Serial.println("Please Upgrade Firmware");
  }
}

void connect_WiFi()
{
  while (status != WL_CONNECTED)
  {
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);

    status = WiFi.begin(ssid, pass);
    delay(10000);
  }
}

void printWEB()
{
  if (client)
  {
    Serial.println("new client");
    String currentLine = "";
    while (client.connected())
    {
      if (client.available())
      {
        char c = client.read();
        Serial.write(c);
        if (c == '\n')
        {
          // end of client http request 
          if (currentLine.length() == 0)
          {
            client.println("HTTP 1.1 200 OK");
            client.println("content-type:text/html");
            client.println();

            //create button to turn LED ON and OFF
            client.print("Click <a href=\"/H\">here<\a> to turn the Relay on<br>");
            client.print("Click <a href=\"/L\">here<\a> to turn the Relay off<br><br>");
            
            int randomReading = analogRead(A1);
            client.print("Random reading from analog pin: ");
            client.print(randomReading);

            //HTTP responds ends
            client.println();

            //break while loop
            break;            
          }
          else
          {
            // clear newline
            currentLine = "";
          }
        }
        else if (c != '\r')
        {
          // if not a carriage return character
          currentLine += c ;
        }
        if (currentLine.endsWith("GET /H"))
        {
          digitalWrite(relay, HIGH);
        }
        if (currentLine.endsWith("GET /L"))
        {
          digitalWrite(relay, LOW);
        }
      }
    }
    //close connection
    client.stop();
    Serial.println("client disconnected");
  }
}