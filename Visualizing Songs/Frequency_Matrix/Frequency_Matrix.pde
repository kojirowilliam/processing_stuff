int canvasWidth = 900; // 50 for margin on each side, 50 for the size of each block in the matrix, and 5 as a barrier between blocks, 60 (50+10 for margin) for the size of the letters 
int canvasHeight = 850; // 50 for margin on the top and bottom, 50 for the size of each block in the matrix, and 5 as a barrier between blocks, 
String[] notes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
NoteBlock[] noteBlocks;

void settings() { 
  size(canvasWidth, canvasHeight);
}

void setup() {
  background(#CB6B6B);
    textAlign(LEFT);
  fill(100, 220);
  textSize(50);
  for (int i = 0; i<=8; i++) {
     text(i, 0, 75*i+190);
  }
  textAlign(CENTER);
  for (int i = 0; i<12; i++) {
    text(notes[i], 70*i+65, height);
  }
  int totBlocks = 9*12;
  noteBlocks = new NoteBlock[totBlocks];
  initNoteBlocks();
  
  //translate() Could use a translate here to shift everything automatically and create a new origin point.
}

// Goal is a 12 x 9 grid with A, A#, B, C, C#, D, D#, E, F, F#, G, G# on the left side and numbers from 0-8 on the bottom to signal the frequency of the sound
// Notes that are played more often are a darker gradient of red. The gradient changes as time goes on so that the colors of each matrix change over time.
void draw() {
  for (int i = 0; i < noteBlocks.length; i++) {
    noteBlocks[i].createBlock();
  }
}
void initNoteBlocks() {
  stroke(10);
  fill(#F5E3E3, 10);
  int index = 0;
  for(int x = 0; x < 12; x++) {
    for (int y = 0; y < 9; y++) {
      NoteBlock temp = new NoteBlock(40 + 70*x, 150+ 75 *y, notes[x]+y);
      noteBlocks[index] = temp;
      index++;
    }
  }
}

class NoteBlock {
  float xpos, ypos;
  String name;
  float blockWidth = 50;
  float blockHeight = 50;
  int blockRadius = 20;
  
  NoteBlock(float x, float y, String note) {
    xpos = x;
    ypos = y;
    name = note;
  }
  
  void createBlock() {
    rect(xpos, ypos, blockWidth, blockHeight, blockRadius);
  }
  
}
