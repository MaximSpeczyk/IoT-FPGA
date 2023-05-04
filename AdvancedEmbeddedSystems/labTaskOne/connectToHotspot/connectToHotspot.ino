#include <WiFiNINA.h>

char ssid[] = "ArduinoRev";
char pass[] = "@rduino!";
int keyIndex = 0;
int status = WL_IDLE_STATUS; //connection status


WiFiServer server(80);
WiFiClient client = server.available();

void setup() {
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  while(!Serial);
    enable_WiFi();
    connect_WiFi();
    server.begin();
    printWifiStatus();
}

void loop() {
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

  //IP Address
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // recieved signal strength
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");

  Serial.print("To see this page in action, open a browser");
  Serial.println(ip);
}

void enable_WiFi()
{
  // check wifi module
  if (WiFi.status() == WL_NO_MODULE)
  {
    Serial.println("Communication with WiFi module failed!");
    //don't continue
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
  // attempt to connect WiFi
  while (status != WL_CONNECTED)
  {
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);

    //connect wifi
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
            client.print("Click <a href=\"/H\">here<\a> to turn the LED on<br>");
            client.print("Click <a href=\"/L\">here<\a> to turn the LED off<br><br>");
            
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
          digitalWrite(LED_BUILTIN, HIGH);
        }
        if (currentLine.endsWith("GET /L"))
        {
          digitalWrite(LED_BUILTIN, LOW);
        }
      }
    }
    //close connection
    client.stop();
    Serial.println("client disconnected");
  }
}
