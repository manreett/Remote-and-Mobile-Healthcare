#include <TimeLib.h>
#include <Arduino_JSON.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <Wire.h>
#include "MAX30105.h"

MAX30105 particleSensor;


//  variables
const int pulsePin = 36;
const int LED = 13;
String username = "md";
String password = "mde";


// pulse sensor
int pulseThresh = 550;
int bpm = 0;
unsigned long timeOfLastBeat = 0;  // Time of the last heartbeat
unsigned long timeBetweenBeats = 0; // Time between two consecutive heartbeats

//Sp02
int red = 0;
int emg = 0;
int ir = 0;


// WiFi
const char* ssid = "MH-WiFi";
const char* wifiPassword = "Taltola123";

// database
String url = "http://68.183.205.184/insertdata.php";

void setup() {   

  Serial.begin(9600);

  delay(1000);

  // setup time
  setTime(19,0,0,1,4,2023);

  // setup wifi
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, wifiPassword);

  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(100);
  }

    // Initialize sensor
  if (particleSensor.begin() == false)
  {
    Serial.println("MAX30105 was not found. Please check wiring/power. ");
    while (1);
  }
  
  particleSensor.setup(); //Configure sensor. Use 6.4mA for LED drive 
  Serial.println("Connected to WiFi.");
  Serial.println(WiFi.localIP());

}

unsigned long last_millis = millis();

void loop() {

  // heartbeat

  if (millis() - last_millis >= 1000) {
    Serial.println("here");

      bpm = analogRead(pulsePin);
      emg = analogRead(34);
    // 10 seconds have passed
      //SP02
    last_millis = millis();
    red = particleSensor.getRed();
    ir = particleSensor.getIR();



    
  

  storeData(bpm, red, ir, emg);

  delay(20);
  }
  



}


String intTo2DigitString(int number) {
    // convert the number to a string
    String strNumber = String(number);
    
    // if the string has only one digit, add a leading zero
    if (strNumber.length() == 1) {
        strNumber = "0" + strNumber;
    }
    
    return strNumber;
}

bool storeData(int bpm, int red, int ir, int emg) {
  Serial.println("Storing data...");
  Serial.println(red, ir);
  // create JSON object for hrdata
  JSONVar hrdata;
  hrdata["username"] = username;
  hrdata["password"] = password;
  hrdata["bpm"] = bpm;
    hrdata["ir_value"] = ir;
  hrdata["red_value"] = red;
  hrdata["ecg_value"] = emg;
  String ts = String(year()) + intTo2DigitString(month()) + intTo2DigitString(day()) + intTo2DigitString(hour()) + intTo2DigitString(minute()) + intTo2DigitString(second());
  Serial.println(ts);
  hrdata["timestamp"] = ts;

  sendHrdata(hrdata);
}

void sendHrdata(JSONVar hrdata) {

  // send data to the cloud
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(url);
    http.addHeader("Content-Type", "application/json");
    int httpCode = http.POST(JSON.stringify(hrdata));
    Serial.println(httpCode);
    if (httpCode > 0) {
      String payload =http.getString();
      Serial.println(payload);
    }

    http.end();
  }
}

