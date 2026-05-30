#include <LiquidCrystal.h>
#include <Servo.h>

LiquidCrystal lcd(12, 11, 5, 4, 3, 2); // LCD pins
Servo servoMotor; // Servo motor object

const int buzzerPin = 6; // Buzzer pin
const int photoresistorPin = A0; // Photoresistor analog pin
const int triggerPin = 9; // Ultrasonic sensor trigger pin
const int echoPin = 10; // Ultrasonic sensor echo pin

int toneFrequency = 0; // Initialize tone frequency
int servoAngle = 0; // Initialize servo angle
float knownResistorValue = 10000.0; // Value of the known resistor in ohms

// Custom character for the degree symbol
byte degreeSymbol[8] = {
  B00111,
  B00101,
  B00111,
  B00000,
  B00000,
  B00000,
  B00000,
  B00000
};
// Custom character for 'c'
byte custom_small_c[8] = {
  B00000,
  B00000,
  B01111,
  B10000,
  B10000,
  B10000,
  B01111,
  B00000
};
//Custom character for 'm'
byte custom_small_m[8] = {
  B00000,
  B00000,
  B11111,
  B10101,
  B10101,
  B10101,
  B10101,
  B00000
};

//Custom character for 'H'
byte customH[8] = {
  B10001,
  B10001,
  B10001,
  B11111,
  B10001,
  B10001,
  B10001,
  B00000
};

//ohm symbol
byte ohm[8] = { 
  B00000,
  B01110,
  B10001,
  B10001,
  B01010,
  B11011,
  B00000
};
// Custom characters for A, C, and W
byte customA[8] = {
  B00100,
  B01010,
  B11111,
  B10001,
  B10001,
  B10001,
  B10001,
  B00000
};

byte customC[8] = {
  B01110,
  B10001,
  B10000,
  B10000,
  B10000,
  B10001,
  B01110,
  B00000
};

byte customW[8] = {
  B10001,
  B10001,
  B10001,
  B10101,
  B10101,
  B11011,
  B10001,
  B00000
};

void setup() {
  lcd.createChar(1, ohm);
  lcd.createChar(2, customH);
  lcd.createChar(3, custom_small_c);
  lcd.createChar(4, custom_small_m);
  lcd.createChar(5, degreeSymbol);
  lcd.createChar(6, customA);
  lcd.createChar(7, customC);
  lcd.createChar(8, customW);
  lcd.begin(16, 2);

  pinMode(buzzerPin, OUTPUT);
  pinMode(triggerPin, OUTPUT);
  pinMode(echoPin, INPUT);

  servoMotor.attach(7); // Servo control pin
}

void loop() {
  // Read photoresistor value
  int lightValue = analogRead(photoresistorPin);
  float photoResistorVoltage = lightValue * (5.0 / 1023.0); // Convert analog value to voltage
  float photoResistorResistance = knownResistorValue * (5.0 / photoResistorVoltage - 1.0); // Calculate resistance using voltage divider formula

  toneFrequency = map(lightValue, 0, 1023, 100, 1000);
  tone(buzzerPin, toneFrequency);

  // Read ultrasound sensor value
  long duration, distance;
  digitalWrite(triggerPin, LOW);
  delayMicroseconds(2);
  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(triggerPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;
  servoAngle = map(distance, 0, 200, 0, 180);
  servoMotor.write(servoAngle);

  // Clear the LCD display
  lcd.clear();
  
  int resistance_output= (int)photoResistorResistance;
  if(resistance_output <= -1){
  resistance_output = -resistance_output;
  }
  else{
  resistance_output = resistance_output;
  }
  

  // Display values on LCD
  lcd.setCursor(0, 0);
  lcd.print(resistance_output);
  lcd.write(byte(1));
  lcd.print(" => ");
  lcd.print(toneFrequency);
  lcd.write(byte(2));
  lcd.print("z");
 
  
  

  lcd.setCursor(0, 1);
  lcd.print(distance);
  lcd.write(byte(3));
  lcd.write(byte(4));
  lcd.print(" => ");
  lcd.print(servoAngle);
  lcd.write(byte(5)); // Display custom degree symbol
  lcd.write(byte(6));
  lcd.write(byte(7));
  lcd.write(byte(8));

  delay(500); // Adjust delay as needed for optimal display update rate
}