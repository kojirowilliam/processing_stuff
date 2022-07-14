import processing.sound.*;

//TODO:WILL: You need to get rid of some of the debug code. You are now able to get multiple frequencies at once, but you can't draw multiple at once yet.
// Clean up the code a little first and then work on coloring the note blocks based on how strong their frequency amplitudes are, rather than just how close
// the frequency bands are to each note blocks frequencies.

FFT fft;
AudioIn in;
int totBands = 16384; // Total number of bands analyzed
int minBands = 0; // Lower limit scope of visualized bands
int maxBands = totBands; // Higher limit scope of visualized bands
float[] spectrum = new float[totBands];
int numFreqs = 20; // The number of frequencies kept track of every cycle
float absoluteFreq = 0;
float absoluteBand = 0;
float highestAmp = 0;
float[] highestFreq = new float[numFreqs];
float[] highestBand= new float[numFreqs];
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
  fill(100, 220);
  textSize(50);
  textAlign(LEFT);
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
}

// Goal is a 12 x 8 grid with A, A#, B, C, C#, D, D#, E, F, F#, G, G# on the left side and numbers from 1-8 on the bottom to signal the frequency of the sound
// Notes that are played more often are a darker gradient of green. The gradient changes as time goes on so that the colors of each matrix change over time.
void draw() {
  colorNoteBlocks();
  // Drawing the note blocks
  stroke(10);
  for (int i = 0; i<noteBlocks.length; i++) {
    noteBlocks[i].createBlock();
  }
  curFrame += 1;
}

void colorNoteBlocks() {
  getHighestFreq(); // Sets highestFreq[] and highestBand[]
  calculateAmps(); // Calculates the totAmps for each noteBlock
  for (int i = 0; i<noteBlocks.length; i++) {
    if (noteBlocks[i].getTotAmp() > 0) {
      println(noteBlocks[i].getTotAmp());
      float tempAlpha = map(noteBlocks[i].getTotAmp(), 0, highestAmp, 0, 10);
      color tempColor = color(noteBlocks[i].getColor(), tempAlpha);
      noteBlocks[i].setColor(tempColor);
    }
    else {
      noteBlocks[i].setBaseColor();
    }
  }
  highestAmp = 0;
}

void getHighestFreq() {
  absoluteFreq = 0;
  absoluteBand = 0;
  for (int i = 0; i<numFreqs; i++) {
    highestFreq[i] = 0;
    highestBand[i] = 0;
  }
  fft.analyze(spectrum);
  for (int i = minBands; i < maxBands; i++) {
    if (spectrum[i] > absoluteFreq) {
      absoluteFreq = spectrum[i];
      absoluteBand = i*frequencyMultiplier;
    }
    if (spectrum[i] > min(highestFreq)) {
      int j = 0;
      while (highestFreq[j] > spectrum[i]) {
        j++;
      }
      highestFreq = splice(highestFreq, spectrum[i], j);
      highestBand = splice(highestBand, i*frequencyMultiplier, j);
      highestFreq = shorten(highestFreq);
      highestBand = shorten(highestBand);
    }
  }
  //printArray(highestBand);
  //printArray(highestFreq);
  //println(absoluteBand+": "+absoluteFreq);
}

void calculateAmps() {
  for (int i = 0; i<highestBand.length; i++) {
    for (int j=0; j<noteBlocks.length && highestBand[i] < noteBlocks[j].getMaxFreq() && highestBand[i] > noteBlocks[j].getMinFreq(); j++) {
      noteBlocks[j].incrementAmp(highestFreq[i]);
      if (highestAmp < noteBlocks[j].getTotAmp()) {
        highestAmp = noteBlocks[j].getTotAmp();
      }
    }
  }
}

void initNoteBlocks() {
  float baseFreq = 27.5*pow(2, 3.0/12.0); // The frequency of the first note, A0.
  float noteFreq; // The frequency of the indexth note.
  int index = 0;
  for (int y = 0; y < 8; y++) {
    for (int x = 0; x < 12; x++) {
      noteFreq = baseFreq * pow(2, index/12.0);
      //println(notes[x]+y+": " + noteFreq);
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
  color noteColor = baseColor;
  color ampTot = 0; // The total amps the noteblock has during the current frame

  NoteBlock(float x, float y, float freq, String note) {
    xpos = x;
    ypos = y;
    noteFreq = freq;
    name = note;

    maxFreq = freqError*noteFreq;
    minFreq = 2*noteFreq - maxFreq;
  }

  float getMaxFreq() {
    return maxFreq;
  }

  float getMinFreq() {
    return minFreq;
  }

  float getTotAmp() {
    return ampTot;
  }

  color getColor() { // Returns what color the note block should be
    return ampColor;
  }

  void setBaseColor() {
    noteColor = baseColor;
  }

  void setColor(color newColor) {
    noteColor = newColor;
  }

  void createBlock() {
    fill(noteColor);
    rect(xpos, ypos, blockWidth, blockHeight, blockRadius);
    ampTot = 0;
  }

  void incrementAmp(float num) {
    println("incrementing amp");
    ampTot += num;
  }

  //float freqAmp(float newBand, float newFreq) { // Returns a value between 0,255 of the current frequencies amplitude.
  //  float amp = 0;
  //  float curMaxAmp = max(highestFreq);
  //  if (curMaxAmp < maxAmp) {
  //    curMaxAmp = maxAmp;
  //  }
  //  if (minFreq < newBand && newBand < maxFreq) {
  //    amp = map(newFreq, 0, curMaxAmp, 0, 255);
  //  }
  //  return amp;
  //}
}
