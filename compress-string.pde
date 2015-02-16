/*
 * Compress String
 * (Jordan Arnesen, 2015 February 16)
 *  ---------------------------- 
 */

// VARIABLES
//______________________________________________________
// The next line is needed if running in JavaScript Mode with Processing.js
 @pjs font="Georgia.ttf"; 

char letter;
String words = "Begin...";

// SETUP
//______________________________________________________
void setup() {
  size(640, 360);
  // Create the font
  textFont(createFont("Georgia", 36));
}


// DISPLAY FUNCTIONS
//______________________________________________________
void draw() {
  background(0); // Set background to black

  // Draw the letter to the center of the screen
  textSize(14);
  text("Click on the program, then type to add to the String", 50, 50);
  text("Current key: " + letter, 50, 70);
  text("The String is " + words.length() +  " characters long", 50, 90);
  
  textSize(36);
  text(words, 50, 120, 540, 300);
}

// PLAYER INPUTS
//______________________________________________________
void keyPressed() {
  // The variable "key" always contains the value 
  // of the most recent key pressed.
  if ((key >= 'A' && key <= 'z') || key == ' ') {
    letter = key;
    words = words + key;
    // Write the letter to the console
    println(key);
  }
}
