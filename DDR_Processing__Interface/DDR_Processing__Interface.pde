/*
"DDR Processing Interface" by Candide Uyanze

Based on:
- "DDR in Processing" by Jon Castro (3/24/17): https://jon-castro.itch.io/ddr-in-processing
- "Starburst-Music-Viz" by Andre Le: https://github.com/andrele/Starburst-Music-Viz/blob/master/andreMusicViz.pde
- "Arduino controllers that send keypress events" by tobyonline: https://robot-resource.blogspot.com/2018/01/arduino-controllers-that-send-keypress.html
- "Read Cap IMU" and "Read All Pins Launch on Touch" by Kate Hartman & Nick Puckett (DIGF 6037 Creation & Computation): https://github.com/DigitalFuturesOCADU/CC2020/blob/main/Experiment3/codeExamples/ArduinoToProcessing/CSV/SendItAll
  Above was based on this Lab on the ITP Physical Computing site: 
  https://itp.nyu.edu/physcomp/labs/labs-serial-communication/two-way-duplex-serial-communication-using-an-arduino/
*/


// Java robot class stuff
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;
 
Robot robot;


// Arduino to Processing variables
import processing.serial.*; // import the Processing serial library
Serial myPort;              // The serial port

int totalPins = 4; // change to the number of pin values you're sending
int pinValues[] = new int[totalPins];
//int pinValuesPrev[] = new int[totalPins];

int upKey;
int rightKey;
int downKey;
int leftKey;


// DDR variables
import processing.sound.*;

SoundFile file;
/*FFT fft;
int bands = 512;
float[] spectrum = new float[bands];*/
float radius = 1000;
int x = 1000; // original: 540
int y = 400;
float speed = 12;
int count = -60; // -45
int keys = UP;
int score = 0;
PImage img;
boolean press = false;
int combo = 1;
String status = "";
boolean hit = false;
int y2= y;
Amplitude amp;
int r = 0;
int g = 0;
int b = 0;
PImage Up;
PImage Right;
PImage Down;
PImage Left;
PImage Up_S;
PImage Right_S;
PImage Down_S;
PImage Left_S;



void setup(){
  frameRate(60);
  size(1920, 1080);
  
  //Let's get a Robot...
    try { 
    robot = new Robot();
  } catch (AWTException e) {
    e.printStackTrace();
    exit();
  }
  
  // Load image files
  Up = loadImage("Up_Empty.png");
  Right = loadImage("Right_Empty.png");
  Down = loadImage("Down_Empty.png");
  Left = loadImage("Left_Empty.png");
  Up_S = loadImage("Up_Solid.png");
  Right_S = loadImage("Right_Solid.png");
  Down_S = loadImage("Down_Solid.png");
  Left_S = loadImage("Left_Solid.png");
  
  // Load audio
  //fft is for outputing based off frequency not amplitude
  //fft = new FFT(this, bands);
  amp = new Amplitude(this);
  file = new SoundFile(this, "1er_Gaou-Magic-System.wav"); // change audio here
  file.play();
  //fft.input(file);
  amp.input(file);
  
  // Load Arduino port stuff
  //list all the available serial ports in the console
  printArray(Serial.list());
  //change the 0 to the appropriate number of the serial port that your microcontroller is attached to.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  //read incoming bytes to a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
}



void draw(){
   keyReleased();
   background(0,0,0,20);
   
   // Music visualizationa
      noFill();
   ellipse(1500, 540, 800*amp.analyze(), 800*amp.analyze());
   
    pushStyle();
    // Calculate the gray value for this circle
    // stroke(amplitude*255);
    noFill();
    stroke(255,255,255,amp.analyze()*255);
    strokeWeight(map(amp.analyze(), 0, 1, 2, 10));
    //strokeWeight((float)(xr-xl)*strokeMultiplier);
    
    // Draw an ellipse for this frequency
    ellipse(1500, 540, (amp.analyze()*540), (amp.analyze()*540));
    
    popStyle();
    
   //this is used to output frequency spectrum
   //frequency and amp cannot be displayed at the same time
   /*fft.analyze(spectrum);
   stroke(255,200 * random (.5,1), 200 *  random (.5,1));
   fill(255,200 * random (.5,1), 200 * random (.5,1));
   for(int i = 0; i < bands; i++){
    The result of the FFT is normalized
    draw the line for frequency band i scaling it up by 5 to get more amplitude.
    if(i > 400){
      line(2*i, height, 2*i, spectrum[i]*height*10);
      line( 2*i, 0, 2*i, 0 + spectrum[i]*height*10);
    }
    else{
      line( 2*i, height, 2*i, height - spectrum[i]*height*5);
      line( 2*i, 0, 2*i, 0 + spectrum[i]*height*5);
  } */
  
  
  //using the Arduino serial info and converting it to keystrokes
    if (upKey == 1) {
    println("pressing UP");
    robot.keyPress(KeyEvent.VK_UP);
    }
    else if (upKey == 0){
    robot.keyRelease(KeyEvent.VK_UP);  
    }

    if (rightKey == 1) {
    println("pressing RIGHT");
    robot.keyPress(KeyEvent.VK_RIGHT);
    }
    else if (rightKey == 0){
    robot.keyRelease(KeyEvent.VK_RIGHT);  
    }    
    
    if (downKey == 1) {
    println("pressing DOWN");
    robot.keyPress(KeyEvent.VK_DOWN);
    }
    else if (downKey == 0){
    robot.keyRelease(KeyEvent.VK_DOWN);  
    }
    
    if (leftKey == 1) {
    println("pressing LEFT");
    robot.keyPress(KeyEvent.VK_LEFT);
    }
    else if (leftKey == 0){
    robot.keyRelease(KeyEvent.VK_LEFT);  
    }

  
  //prints background stuff. First digit is the size of the color bars, next three are Red, Blue, Green. Last two digits are for the mini arrows that are pulsing
   printRects(0,255,0,0, Up_S, 0, 0); // (600,255,0,255, Up_S, 100, 700);
   printRects(270,255,0,140, Right_S, 0, 0); // (400,0,0,255, Right_S, 100, 500);
   printRects(540,255,0,255, Down_S, 0, 0); // (200,0,255,100, Down_S, 100, 300)
   printRects(810,0,0,255, Left_S, 0, 0); // (0,255,0,0, Left_S, 100, 100);
   
   //prints the hitbox of the arrows (the outline)
   tint(0,0,0,100);
   imageMode(CENTER);
   image(Up,300,135,175 + 50 * amp.analyze(),175 + 50 * amp.analyze()); //(Up,100,700,175 + 50 * amp.analyze(),175 + 50 * amp.analyze())
   image(Right,300,405,175 + 50 * amp.analyze(),175 + 50 * amp.analyze()); // (Right,100,500,175 + 50 * amp.analyze(),175 + 50 * amp.analyze())
   image(Down,300,675,175 + 50 * amp.analyze(),175 + 50 * amp.analyze()); // (Down,100,300,175 + 50 * amp.analyze(),175 + 50 * amp.analyze());   
   image(Left,300,930,175 + 50 * amp.analyze(),175 + 50 * amp.analyze()); // (Left,100,100,175 + 50 * amp.analyze(),175 + 50 * amp.analyze())
   imageMode(CORNER);
   tint(255);
   
   //spawns an arrow when the last one dissapears
   //synched to framerate
   if (count == 61 || count == -60){ //(count == 46 || count == -45)
     count = 0;
     //decides what arrow to ouput
     spawnRect(random(0,4));
   }
   //checks if keys are correctly hit
   move();
   textSize(20);
   stroke(255);
   text("SCORE: " + score,1500,530);
   text("COMBO: " + combo,1500,565);
   fill(r,g,b);
   textSize(40);
   textAlign(CENTER);
   //hit or miss status
   text(status,300,y2 + 110); // (status,100,y2 + 110)
}



// Loading arrows
void spawnRect(float i){ // y  = y position of incoming arrow
  if( i >= 0 && i < 1){
    keys = UP;
    img = loadImage("Up.png");
    y = 40; //600
  }
  if( i >= 1 && i < 2){
    keys = RIGHT;
    img = loadImage("Right.png");
    y = 300; // 400
  }
  if( i >= 2 && i < 3){
     keys = DOWN;
     img = loadImage("Down.png");
     y = 580; // 200
  }
  if( i >= 3 && i <= 4){
    keys = LEFT;
    img = loadImage("Left.png");
    y = 830; //0
  }
}


// Printing success/failure messages
void move(){
  if (keyPressed) {
    if (keyCode == keys && x < 200 && x >= 150 && press == false) { // if (keyCode == keys && x < 50 && press == false)
      score += 100 * combo;
      combo++;
      press = true;
      hit = true;
      status = "PERFECT";
      y2 = y;
      r = 127;
      g = 255;
      b = 0;
    }
    if (keyCode == keys && x < 300 && x >= 200 && press == false) { //(keyCode == keys && x < 100 && x >= 50 && press == false)
      score += 50 * combo;
      combo++;
      press = true;
      hit = true;
      status = "COOL";
      y2 = y;
      r = 50;
      g = 205;
      b = 100;
    }
    if (keyCode == keys && x > 300 && press == false){ // (keyCode == keys && x > 100 && press == false)
      combo = 1;
      status = "MISS";
      y2 = y;
      r = 255;
      g = 192;
      b = 203;
    }
    if (keyCode != keys && x > 300 && x < 930){ // (keyCode != keys && x > 100 && x < 450)
      combo = 1;
      status = "MISS";
      r = 255;
      g = 192;
      b = 203;
    }
  }
  if (hit != true && x == 0){
      combo = 1;
      status = "MISS";
      y2 = y;
      r = 255;
      g = 0;
      b = 0;
    }
  fill(255);
  image(img,x,y,200,200); // moving arrow size
  x -= 18;
  count++;
  if(x < 10){
    x = 1080; //540
    hit = false;
  }
}



// So you cant hold down keys
void keyReleased(){
  if (!keyPressed){
    press = false;
  }
}



// Prints using the colors in the correct location
void printRects(int y,int r, int b, int g, PImage img, int _X, int _Y){
   //stroke(r,g,b,100);
   fill(r,g,b, 50); //(r,g,b, 50)
   rect(160,y,270,270); // hitboxes, orignally: 0,y,200,200
   rect(0,y,1920,1080); // colored bars, orignally: 0,y,600,200
   line(200,y + 0,1920,y + 0); // top translucent bar
   //line(200,y + 50,1920,y + 50); // first translucent vertical bar x 4, originally (200,y + 50,600,y + 50)
   //line(200,y + 100,1920,y + 100); // 2nd translucent vertical bar x 4, originally (200,y + 100,600,y + 100)
   //line(200,y + 150,1920,y + 150); // 3rd translucent vertical bar x 4, originally (200,y + 150,600,y + 150)
   fill(r,g,b,50); //(r,g,b,50);
   tint(r,g,b, 10); //(r,g,b, 100);
   imageMode(CENTER);
   image(img,_X,_Y,250 * amp.analyze(),250 * amp.analyze());
}



//Arduino serial port stuff
void serialEvent(Serial myPort) {
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {
    // println(myString);
    myString = trim(myString);
    
    //store the message as a string array
    String tempData[] = split(myString,',');
    
    //uncomment to see what the data looks like in the string array
    //printArray(tempData);
    
    ///read the first 4 items of the array into the pinValues array and convert
    for(int i=0;i<totalPins;i++)
    {
     pinValues[i]=int(tempData[i]); 
    }
    
    //convert the last 4 items in the String array to floats
    upKey = int(tempData[totalPins-4]);
    rightKey = int(tempData[totalPins-3]);
    downKey = int(tempData[totalPins-2]);
    leftKey = int(tempData[totalPins-1]);
  }
}
