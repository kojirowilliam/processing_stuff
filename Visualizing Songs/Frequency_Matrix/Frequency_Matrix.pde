import processing.sound.*;

FFT fft;
AudioIn in;
int totBands = 16384; // Total number of bands analyzed
int minBands = 0; // Lower limit scope of visualized bands
int maxBands = totBands; // Higher limit scope of visualized bands
float[] spectrum = new float[totBands];
float highestFreq = 0;
float highestBand = 0;
float frequencyMultiplier = 1.345564; // works pretty well. Tuned the mic to A4

int canvasWidth = 900; // 50 for margin on each side, 50 for the size of each block in the matrix, and 5 as a barrier between blocks, 60 (50+10 for margin) for the size of the letters 
int canvasHeight = 850; // 50 for margin on the top and bottom, 50 for the size of each block in the matrix, and 5 as a barrier between blocks, 
String[] notes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
float freqError = 1.02; // Since 2^(1/12) is a little more than 1.05, 1.02 should be about the mid point between two note
NoteBlock[] noteBlocks;

int frames = 30;
int curFrame = 0;

void settings() { 
  size(canvasWidth, canvasHeight);
}

void setup() {
  frameRate(frames);
  background(#CB6B6B);
    textAlign(LEFT);
  fill(100, 220);
  textSize(50);
  for (int i = 1; i<=8; i++) {
     text(i, 0, 75*i+190);
  }
  textAlign(CENTER);
  for (int i = 0; i<12; i++) {
    text(notes[i], 70*i+65, height);
  }
  int totBlocks = 8*12;
  noteBlocks = new NoteBlock[totBlocks];
  initNoteBlocks();
  
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, totBands);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
  
  //translate() Could use a translate here to shift everything automatically and create a new origin point.
}

// Goal is a 12 x 9 grid with A, A#, B, C, C#, D, D#, E, F, F#, G, G# on the left side and numbers from 0-8 on the bottom to signal the frequency of the sound
// Notes that are played more often are a darker gradient of red. The gradient changes as time goes on so that the colors of each matrix change over time.
void draw() {
  fft.analyze(spectrum);
  for(int i = minBands; i < maxBands; i++){
    if(spectrum[i] > highestFreq) {
      highestBand = i*frequencyMultiplier;
      highestFreq = spectrum[i];
    }
  }
  
  // Drawing the note blocks
  for (int i = 0; i < noteBlocks.length; i++) {
    println(highestBand);
    noteBlocks[i].createBlock(highestBand);
  }
  curFrame += 1;
  highestBand = 0;
  highestFreq = 0;
}

void initNoteBlocks() {
  float baseFreq = 27.5*pow(2,3.0/12.0); // The frequency of the first note, A0.
  float noteFreq; // The frequency of the indexth note.
  int index = 0;
  for(int y = 0; y < 8; y++) {
    for (int x = 0; x < 12; x++) {
      noteFreq = baseFreq * pow(2, index/12.0);
      println(notes[x]+y+": " + noteFreq);
      NoteBlock temp = new NoteBlock(40 + 70*x, 225+ 75 *y, noteFreq, notes[x]+y);
      noteBlocks[index] = temp;
      index++;
    }
  }
}

class NoteBlock {
  float xpos, ypos, noteFreq;
  String name;
  float minFreq, maxFreq;
  //color ampColor; // The color of the block that varies depending on the amplitude of the frequency
  float blockWidth = 50;
  float blockHeight = 50;
  int blockRadius = 20;
  color baseColor = color(#F5E3E3, 10);
  color ampColor = color(#d92637);
  
  NoteBlock(float x, float y, float freq, String note) {
    xpos = x;
    ypos = y;
    noteFreq = freq;
    name = note;
    
    maxFreq = freqError*noteFreq;
    minFreq = 2*noteFreq - maxFreq;
  }
  
  void createBlock(float newFreq) {
    stroke(10);
    fill(getColor(newFreq));
    rect(xpos, ypos, blockWidth, blockHeight, blockRadius);
  }
  
  float freqAmp(float newFreq) { // Returns a value between 0,255 of the current frequencies amplitude.
    float amp = 0;
    if (minFreq < newFreq && newFreq < maxFreq) {
      if (newFreq > noteFreq) {
        amp = map(newFreq, noteFreq, maxFreq, 0, 255);
        //println(name+", newFreq: " + newFreq + ", noteFreq: " + noteFreq);
      }
      else {
        amp = map(newFreq, minFreq, noteFreq, 0, 255);
        //println(name+", newFreq: " + newFreq + ", noteFreq: " + noteFreq);
      }
    }
    return amp;
  }
  
  color getColor(float newFreq) { // Returns what color the note block should be
    float amp = freqAmp(newFreq);
    if (amp == 0) {
      return baseColor;
    }
    return color(10, 10, amp, 5);
  }
}
