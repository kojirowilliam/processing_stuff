import processing.sound.*;

FFT fft;
AudioIn in;
int totBands = 16384; // Total number of bands analyzed
int minBands = 0; // Lower limit scope of visualized bands
int maxBands = totBands; // Higher limit scope of visualized bands
float[] spectrum = new float[totBands];
float highestFreq = 0;
int highestBand = 0;
float frequencyMultiplier = 1.344; // works pretty well

void setup() {
  size(640,640);
  
  background(#542220);
    
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, totBands);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
  noStroke();
}      

void draw() {
  
  frameRate(2);
  background(#542220);
  fft.analyze(spectrum);

  for(int i = minBands; i < maxBands; i++){
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
  rectMode(CORNERS);
  fill(#013220);
  rect( i*10, 0, i*10+10, height - spectrum[i]*height*50 );
  if (spectrum[i] > highestFreq) {
    highestFreq = spectrum[i];
    highestBand = i;
    }
  }
  println("band[" + highestBand + "] = " + highestFreq);
  drawBand(highestBand);
  //if (highestFreq > 0.1) {
  //  drawFreq(highestFreq);
  //}
  highestBand = 0;
  highestFreq = 0;
}

void drawBand(int band) {
// Writes the highest frequency
  textAlign(CENTER);
  textSize(50);
  fill(255);
  text(band*frequencyMultiplier, width/2, height/2);
}
