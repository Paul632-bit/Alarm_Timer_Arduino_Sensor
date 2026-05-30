# Arduino Multi-Sensor Control System

<img width="800" height="500" alt="Screenshot 2026-04-22 012115" src="https://github.com/user-attachments/assets/0b6411aa-2bb7-4612-a0f8-3120ce24320e" />

This project is an Arduino-based multi-sensor control system that integrates a Light Dependent Resistor (LDR), ultrasonic distance sensor, buzzer, servo motor, and a 16x2 LCD display. The system measures ambient light and distance to an object, and controls a buzzer and servo motor accordingly, displaying real-time data on the LCD.

## Features

- **LDR Sensor**: Measures ambient light and calculates the resistance of the photoresistor
- **Ultrasonic Sensor**: Measures the distance to an object in centimeters
- **Buzzer**: Emits a tone whose frequency is mapped to the light intensity
- **Servo Motor Control**: Servo angle is adjusted based on the measured distance
- **LCD Display**: Shows resistance (with Ω symbol), buzzer frequency (Hz), distance (cm), and servo angle (degrees)

## Hardware Requirements

- Arduino Uno (or compatible)
- LDR (Light Dependent Resistor)
- 10kΩ resistor (for LDR voltage divider)
- Ultrasonic sensor (HC-SR04 or similar)
- Buzzer
- Servo motor
- 16x2 LCD Display (compatible with LiquidCrystal library)
- Jumper wires, breadboard, and power supply

## Pin Connections

| Component | Arduino Pin |
|-----------|-------------|
| LDR (Analog Out) | A0 |
| Buzzer | 6 |
| Ultrasonic Trig | 9 |
| Ultrasonic Echo | 10 |
| Servo Motor Signal | 7 |
| LCD RS | 12 |
| LCD E | 11 |
| LCD D4 | 5 |
| LCD D5 | 4 |
| LCD D6 | 3 |
| LCD D7 | 2 |

## Custom LCD Characters

The project creates the following custom characters for better display formatting:

| Character | Description |
|-----------|-------------|
| Ω | Ohm symbol for resistance |
| Hz | Hertz symbol for frequency |
| c | Small 'c' for centimeters |
| m | Small 'm' for centimeters |
| ° | Degree symbol |
| A, C, W | Custom letters for display formatting |

## How It Works

### Initialization

The LCD is initialized with all custom characters during the `setup()` function.

### Sensor Readings

- **LDR**: The analog value is read and converted to resistance using the voltage divider formula
- **Ultrasonic Sensor**: Measures distance by calculating the time taken for the sound wave to return

### Output Control

- **Buzzer**: Emits a tone with frequency mapped from the light value (100 Hz to 1000 Hz)
- **Servo Motor**: The servo angle is mapped from the measured distance (0° to 180°)

### Display

The LCD shows real-time data on two lines:

- **Top row**: Resistance (Ω) and Buzzer Frequency (Hz)
- **Bottom row**: Distance (cm) and Servo Angle (degrees)

## Example LCD Output
```
1000Ω => 500Hz
20cm => 45°
```

## Code Overview

The main logic is implemented in `Arduino.ino`:

1. Reads LDR analog value and calculates resistance
2. Reads distance from ultrasonic sensor
3. Maps light value to buzzer frequency
4. Maps distance to servo angle
5. Updates the LCD with all real-time values
6. Repeats every 500ms

## Key Functions

| Function | Purpose |
|----------|---------|
| `setup()` | Initializes pins, LCD, and creates custom characters |
| `loop()` | Main program loop that reads sensors and updates outputs |
| `analogRead()` | Reads LDR value |
| `pulseIn()` | Measures ultrasonic echo pulse duration |
| `tone()` | Generates buzzer frequency |
| `servo.write()` | Sets servo motor angle |
| `lcd.createChar()` | Creates custom LCD characters |

## Getting Started

### Wiring

Connect all components according to the pin mapping table above.

### Upload Code

1. Open `Arduino.ino` in the Arduino IDE
2. Select the correct board and port
3. Click Upload

### Power Up

Power the Arduino and observe the LCD display and hardware responses.

## TinkerCAD Simulation

You can view and simulate the circuit on TinkerCAD using the following link:

[TinkerCAD Simulation](https://www.tinkercad.com/things/alaE7P3wkhH-1155179557ardionotinkercad?sharecode=n_6FELVj1LMdy5_G6EenKvlzM_FUxVRG_C5TEvg96j8)



<img width="500" height="250" alt="Screenshot 2026-05-31 000540" src="https://github.com/user-attachments/assets/e3dfbfea-dea9-4bd1-8a54-769c0f1383b9" />


## Assembly Code Projects

This repository also includes two 8051 assembly language programs that demonstrate microcontroller programming with the Atmel 8051 MCU.

### Calculator (Calculator.asm)

An assembly implementation of a calculator that performs arithmetic operations (multiplication and division) and displays results on a 16x2 LCD display.

**Features:**
- Performs hex arithmetic operations on 8-bit values
- Displays input values and results on an LCD
- First line shows input values: "T:xxH U:xxH"
- Second line shows calculation results: "T:xxxxxx Q:xxxx"
- Includes comprehensive LCD control routines
- Handles hexadecimal to ASCII conversion for display

### Alarm Timer (Timer.asm)

A countdown timer with alarm functionality.

**Features:**
- Uses Timer1 interrupts for accurate timing
- Displays countdown on a 4-digit 7-segment display
- Starts countdown from the value 9557
- Activates a buzzer/alarm (on P1.5) when the countdown reaches 8507
- Display multiplexing for the 7-segment displays
- BCD countdown logic with carry handling
- Customized delay routines for display stability
- Interrupt-driven timing for accuracy

## Circuit Setup for Assembly Projects

For the 8051 assembly programs, you will need:

- Atmel 8051 microcontroller (AT89C51/52 or compatible)
- For Calculator: 16x2 LCD display connected to Port 0 and Port 2
- For Timer: 4-digit 7-segment display (common cathode) connected to Port 0 and Port 2
- Buzzer connected to P1.5 (for the Timer program)
- 11.0592 MHz crystal oscillator
- 5V power supply
- Associated passive components (resistors, capacitors)

## Files

| File | Description |
|------|-------------|
| [`Arduino_sensor.ino`](Arduino_sensor.ino) | Main Arduino source code |
| [`Calculator.asm`](Calculator.asm) | Assembly code for a calculator |
| [`Timer.asm`](Timer.asm) | Assembly code for a timer |
## Conclusion

Both the Arduino and 8051 assembly projects demonstrate practical applications of microcontroller programming, sensor integration, and real-time output control. The Arduino project focuses on multi-sensor data acquisition and actuation, while the assembly projects showcase low-level hardware control, interrupt handling, and I/O operations on the Atmel 8051 microcontroller architecture.
