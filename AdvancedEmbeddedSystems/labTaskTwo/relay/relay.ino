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