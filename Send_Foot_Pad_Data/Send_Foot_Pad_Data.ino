/* "Send_Foot_Pad_Data" by Candide
 *  
 * Adapted from: "sendAllCapPins" by Kate Hartman & Nick Puckett (DIGF 6037 Creation & Computation): https://github.com/DigitalFuturesOCADU/CC2020/tree/main/Experiment3/codeExamples/ArduinoToProcessing/CSV/CapInput/sendAllPins/Arduino/sendAllCapPins
 * // Based on the MPR121test.ino example file
 * 
 * This example interfaces with the Adafruit MPR121 capacitive board: https://learn.adafruit.com/adafruit-mpr121-12-key-capacitive-touch-sensor-breakout-tutorial/overview
 * Reads all 12 pins and writes a 1 or 0 separated by commas
 * 
 * 
  */
#include <Wire.h>
#include "Adafruit_MPR121.h"

#ifndef _BV
#define _BV(bit) (1 << (bit)) 
#endif

Adafruit_MPR121 cap = Adafruit_MPR121();

uint16_t currtouched = 0; // Keeps track of the last pins touched

int tp = 4; // Change this if you aren't using them all, start at pin 0

void setup() 
{
  Serial.begin(9600);

  if (!cap.begin(0x5A)) {
    Serial.println("MPR121 not found, check wiring?");
    while (1);
  }
  Serial.println("MPR121 found!");
}

void loop() 
{

checkAllPins(tp); // Run the function to check the cap interface


 Serial.println(); // Make a new line to separate the message
 delay(100); // Put a delay so it isn't overwhelming
}

void checkAllPins(int totalPins)
{
  currtouched = cap.touched(); // Get the currently touched pads
  
  for (uint8_t i=0; i<totalPins; i++) 
  {
    // If it *is* touched, set 1 if no set 0
    if ((currtouched & _BV(i)))
    {
      Serial.print(1); 
    }
    else
    {
      Serial.print(0);
    }

    // Adds a comma after every value but the last one
    if(i<totalPins-1)
    {
      Serial.print(",");
    }

  
}

  
}
