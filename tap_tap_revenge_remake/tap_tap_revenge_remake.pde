int totalFrames;
int numButtons = 5;
int numNotes = 5;
int[][] buttonPos = new int[numButtons][2];
Button[] buttons = new Button[numButtons];
MovingNote[] movingNotes = new MovingNote[5];
color backgroundColor = color(95, 189, 177);


void setup() {
  fullScreen();
  // Buttons distance from the sides of the screen
  int buttonSideDist = width/(numButtons+1);
  //Define the size of the button
  int[] buttonSize = {width/(numButtons*2), width/(numButtons*2)};
  int buttonDist = width/(numButtons+1); // The distance between each button
  int buttonHeight = height-buttonDist;
  // Defining the positions of the buttons
  for (int i = 0; i < numButtons; i++) { 
    int[] tempPos = {buttonSideDist + i*buttonDist, buttonHeight};
    buttonPos[i] = tempPos;
  }
  
  // Defining all colors
  color buttonColor0 = color(174,187,255, 255);
  color buttonColor1 = color(146,178,255, 255);
  color buttonColor2 = color(138,211,255, 255);
  color buttonColor3 = color(182,255,253, 255);
  color buttonColor4 = color(113,255,241, 255);
  color buttonOutline0 = color(174,187,255, 155);
  color buttonOutline1 = color(146,178,255, 155);
  color buttonOutline2 = color(138,211,255, 155);
  color buttonOutline3 = color(182,255,253, 155);
  color buttonOutline4 = color(113,255,241, 155);
  
  color[][] buttonColor = {{buttonColor0, buttonOutline0},
                           {buttonColor1, buttonOutline1},
                           {buttonColor2, buttonOutline2},
                           {buttonColor3, buttonOutline3},
                           {buttonColor4, buttonOutline4}};
  
  
  // Creates the five buttons
  for (int i = 0; i < 5; i++) {
    Button temp = new Button(buttonSize, buttonPos[i], buttonColor[i]);
    temp.drawButton();
    buttons[i] = temp;
  }
  
  // Create movingNotes
  for(int i = 0; i<movingNotes.length; i++) {
    MovingNote temp = new MovingNote(i+1, i);
    movingNotes[i] = temp;
  }
  
  background(backgroundColor);
  createLanes();
  noStroke();
  frameRate(30);
  totalFrames = 0;
  
}

void draw() {
  background(backgroundColor);
  createLanes();
  for (int i = 0; i<5; i++) {
    buttons[i].drawButton();
  }
  for (int i = 0; i<movingNotes.length; i++) {
    if(movingNotes[i].isInFrame()){
      movingNotes[i].drawNote();
    }
  }
  totalFrames+=1;
}

void mousePressed() {
  checkButtons(buttons);
}

// Creates lanes for each of the buttons
void createLanes() {
  strokeWeight(20);
  stroke(#9efa80);
  fill(155, 0.5);
  for (int i = 0; i < numButtons; i++) {
    int[] position = buttons[i].getPos();
    int[] size = buttons[i].getSize();
    triangle(width/2, 0, position[0]-size[0], position[1], position[0]+size[0], position[1]);
  }
}

// Does an action when the buttons are clicked
void checkButtons(Button[] buttons) {
  for (int i = 0; i < buttons.length; i++) {
    if (buttons[i].overButton()) {
      backgroundColor = (buttons[i].getColor());
    }
  }
}

class Button {
  int x, y, X, Y;
  color mainColor, outlineColor;
  Button (int[] size, int[] position, color[] buttonColor) {
    x = position[0];
    y = position[1];
    X = size[0];
    Y = size[1];
    mainColor = buttonColor[0];
    outlineColor = buttonColor[1];
  }
  
  // Draws the button
  void drawButton() {
    strokeWeight(16); // How thick the button lines are
    fill(mainColor);
    stroke(outlineColor);
    ellipse(x, y, X, Y);
  }
  
  // Returns whether the user is over a button
  boolean overButton() {
    if(mouseX >= x - X/2 && mouseX <= x + X/2
      && mouseY >= y - Y/2 && mouseY <= y + Y/2) {
        return true;
      }
      return false;
  }
  
  color getColor() {
    return mainColor;
  }
  
  int[] getSize() {
    int[] size = {X, Y};
    return size;
  }
  
  int[] getPos() {
    int[] position = {x,y};
    return position;
  }
  
  void setColor(color newColor) {
    mainColor = newColor;
  }
}

float[] calculateSpeed(float travelTime, int button) {
  // Calculates the speed of the movingNote depending on when it needs to be on the note in pixels/frame
  float[] origin = {width/2, 0};
  float[] speed = new float[2];
  speed[0] = (buttonPos[button][0]-origin[0])/(travelTime*30);
  speed[1] = (buttonPos[button][1]-origin[1])/(travelTime*30);
  return speed;
}

void testNote(float startDraw, float eta) {
  float[] origin = {width/2, 0};
  float[] speed = calculateSpeed(startDraw-eta, 2); // calculate the speed of a note last 2 sec at button 2
  if (totalFrames > startDraw*30 && totalFrames < eta*30) {
    float traveledFrames = totalFrames-startDraw*30;
    float scaleConstant = traveledFrames/((eta-startDraw)*30);
    float[] size = {buttons[2].getSize()[0]*scaleConstant, buttons[2].getSize()[1]*scaleConstant};
    float[] position = {origin[0]+speed[0]*traveledFrames, origin[1]-speed[1]*traveledFrames};
    strokeWeight(16); // How thick the button lines are
    fill(15, 89, 89);
    stroke(111, 155, 155);
    //printArray(size);
    //printArray(position);
    ellipse(position[0], position[1], size[0], size[1]);
    //println("I drew smt");
  }
  else {
    //println(totalFrames + ": " + "not drawing");
  }
}

class MovingNote {
  float[] origin = {width/2, 0};
  float[] speed;
  float[] size;
  float[] position;
  float totFrames; // How many frames the note will travel in total
  float startFrame;
  float endFrame;
  float fadeOutDuration;
  int parentButton;
  int[] baseColor;
  
  MovingNote(float eta, int button) {
    // eta is what time it should be at the button in seconds.
    // button is which button the note will be on
    fadeOutDuration = 30;
    parentButton = button;
    endFrame = eta*30;
    startFrame = (eta-2)*30; // TODO:WILL Make this smarter
    totFrames = endFrame-startFrame;
    speed = calculateSpeed(totFrames, parentButton); // calculate the speed of a note last 2 sec at button 2
  }
  boolean isInFrame() {
    if (totalFrames > startFrame && totalFrames <= endFrame+fadeOutDuration) {
      return true;
    }
    return false;
  }
  void drawNote() {
    float traveledFrames = totalFrames-startFrame; // How many frames the note has traveled
    float scaleFactor = traveledFrames/totFrames;
    float[] size = {buttons[parentButton].getSize()[0]*scaleFactor, buttons[parentButton].getSize()[1]*scaleFactor};
    float[] position = {origin[0]+speed[0]*traveledFrames, origin[1]+speed[1]*traveledFrames};
    strokeWeight(16); // How thick the button lines are
    fill(15, 89, 89);
    stroke(111, 155, 155);
    println("drawing note on button " + parentButton);
    printArray(size);
    printArray(position);
    ellipse(position[0], position[1], size[0], size[1]);
  }
  float[] calculateSpeed(float frameDuration, int button) {
    // Calculates the speed of the movingNote depending on when it needs to be on the note in pixels/frame
    float[] origin = {width/2, 0};
    float[] speed = new float[2];
    speed[0] = (buttonPos[button][0]-origin[0])/frameDuration;
    speed[1] = (buttonPos[button][1]-origin[1])/frameDuration;
    return speed;
  }
}
