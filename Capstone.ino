#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_MAX30102.h>
#include <PulseSensorPlayground.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <WiFiClientSecure.h>
#include <ESP8266HTTPClient.h>

// Set the pins for the pulse sensor
const int pulseSensorPin = A0;
const int pulseLedPin = 13;

// Set the pins for the AD8232 heart rate monitor
const int ecgOutputPin = A1;

// Set the I2C address for the MAX30102 sensor
#define MAX30102_I2C_ADDRESS 0x57

// Initialize the sensors
PulseSensorPlayground pulseSensor;
Adafruit_MAX30102 max30102;

// WiFi credentials
const char* ssid = "YourWiFiSSID";
const char* password = "YourWiFiPassword";

// PHP script URL
const char* phpScriptUrl = "http://yourdomain.com/sensors_data.php";

void setup() {
  // Start the serial connection
  Serial.begin(9600);

  // Initialize the pulse sensor
  pulseSensor.begin(pulseSensorPin, PulseSensorPlayground::SAMPLEINTERVAL_ADJUSTDRIFT);
  pinMode(pulseLedPin, OUTPUT);

  // Initialize the AD8232 heart rate monitor
  pinMode(ecgOutputPin, INPUT);

  // Initialize the MAX30102 sensor
  Wire.begin();
  max30102.begin(MAX30102_I2C_ADDRESS, Wire);
  max30102.setup(0, 4);
  max30102.setPulseAmplitudeRed(0x0A);
  max30102.setPulseAmplitudeGreen(0x0A);

  // Connect to WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi.");
}

void loop() {
  // Read sensor data values
  int bpm = pulseSensor.getBeatsPerMinute();
  int ecgValue = analogRead(ecgOutputPin);
  int irValue = max30102.getIR();
  int redValue = max30102.getRed();

  // Send the sensor data values to the PHP script via HTTP POST method
  HTTPClient http;
  http.begin(phpScriptUrl);
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");
  String postData = "username=myUsername&password=myPassword&bpm=" + String(bpm) + "&ecg_value=" + String(ecgValue) + "&ir_value=" + String(irValue) + "&red_value=" + String(redValue);
  int httpResponseCode = http.POST(postData);
  http.end();

  // Print the response from the PHP script
  Serial.println("HTTP Response code: " + String(httpResponseCode));

  // Wait for 1 second before reading sensor data values again
  delay(1000);
}
