int totalFrames;
int numButtons = 5;
int[][] buttonPos = new int[numButtons][2];
Button[] buttons = new Button[numButtons];
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
  
  background(backgroundColor);
  createLanes();
  noStroke();
  frameRate(30);
  totalFrames = 0;
  
  // Creates the five buttons
  for (int i = 0; i < 5; i++) {
    Button temp = new Button(buttonSize, buttonPos[i], buttonColor[i]);
    temp.drawButton();
    buttons[i] = temp;
  }
}

void draw() {
  background(backgroundColor);
  createLanes();
  for (int i = 0; i<5; i++) {
    buttons[i].drawButton();
  }
}

void mousePressed() {
  checkButtons(buttons);
}

// Creates lanes for each of the buttons
void createLanes() {
  stroke(3);
  fill(155, 0.5);
  for (int i = 0; i < numButtons; i++) {
    int[] position = buttons[i].getPos();
    int[] size = buttons[i].getSize();
    triangle(width/2, 0, position[0]-size[0], position[1], position[0]+size[0], position[1]);
  }
}

// Does an action when the buttons are clicked
void checkButtons(Button[] buttons) {
  println(buttons.length);
  for (int i = 0; i < buttons.length; i++) {
    println(i);
    println(buttons[i]);
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
    return size;
  }
  
  int[] getPos() {
    return position;
  }
  
  void setColor(color newColor) {
    mainColor = newColor;
    drawButton();
  }
}
    
