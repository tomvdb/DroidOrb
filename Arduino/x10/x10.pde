/*
 *  DroidOrb Android accessory
 * 
 *  This is free software. You can redistribute it and/or modify it under
 *  the terms of Creative Commons Attribution 3.0 United States License. 
 *  To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/us/ 
 *  or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 *
 *  See Github project http://github.com/tobykurien/DroidOrb for latest
 */

#include <Wire.h>
#include <NewSoftSerial.h>

#define DEVICE_ADDR 1
#define DEBUG_LED 13

bool led_flash = 0;

// X10 CM11 connect to pins 3 and 4
NewSoftSerial cm11(4,3);

void setup() {
  // Initialise serial port
  Serial.begin(9600);
  cm11.begin(4800);

  pinMode(DEBUG_LED, OUTPUT);

  // Initialise I2C bus
  Wire.begin(DEVICE_ADDR);
  Wire.onReceive(&i2cHandler);

  // debug using LED
  digitalWrite(DEBUG_LED, LOW);

  cm11.flush();

  // expect a checksum response
  while (cm11.available() == 0){
    delay(1000);
    // send sample data to CM11
    //cm11.print(0xdf);
    //cm11.print(0x13);
    //cm11.print(0x0);

    cm11.print(0x04);
    cm11.print(0x66);
  }
  Serial.print("Got data ");
  while (cm11.available() != 0) Serial.print(cm11.read());

  // got data!
  led_flash = 1;
}

// Receive I2C data from DroidOrb
void i2cHandler(int numBytes) {
  int data = Wire.receive();
  if (data == 1) {
    led_flash = 1;
  } else {
    led_flash = 0;
  }
}

void loop() {
  if (led_flash) {
    digitalWrite(DEBUG_LED, HIGH);
  }

  delay(500);

  if (led_flash) {
    digitalWrite(DEBUG_LED, LOW);
    delay(500);
  }
}
