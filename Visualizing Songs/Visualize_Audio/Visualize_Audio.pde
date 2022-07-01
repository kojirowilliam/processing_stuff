// References for visualize audio https://www.generativehut.com/post/using-processing-for-music-visualization

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

int canvasWidth = 1000;
int canvasHeight = 500;

String audioFile = "../mp3 tests/Future_song.mp3";

float fps = 30;
float smoothingFactor = 0.1; // FFT audio analysis smoothing factor

AudioPlayer track;
FFT fft;
Minim minim;

// General
int bands = 256; // Must be multiple of 2
float[] spectrum = new float[bands];
float[] sum = new float[bands];

// Graphics
float unit;
int groundLineY;
PVector center;

void settings() {
  size(canvasWidth, canvasHeight);
  smooth(8);
}

void setup() {
  frameRate(fps);

  // Graphics related variable setting
  unit = height / 100; // Everything else can be based around unit to make it change depending on size 
  strokeWeight(unit / 10.24);
  groundLineY = height * 3/4;
  center = new PVector(width / 2, height * 3/4);  
  
  minim = new Minim(this);
  track = minim.loadFile(audioFile, 2048);
 
  track.loop();
 
  fft = new FFT( track.bufferSize(), track.sampleRate() );
 
  fft.linAverages(bands);
 
  // track.cue(60000); // Cue in milliseconds
}

void draw() {
  fft.forward(track.mix);
 
  spectrum = new float[bands];
 
  for(int i = 0; i < fft.avgSize(); i++)
  {
    spectrum[i] = fft.getAvg(i) / 2;
 
    // Smooth the FFT spectrum data by smoothing factor
    sum[i] += (abs(spectrum[i]) - sum[i]) * smoothingFactor;
  }
 
  // Reset canvas
  fill(0);
  noStroke();
  rect(0, 0, width, height);
  noFill();
 
  drawAll(sum);
}

//int numRects = 20;
//frequencyRect[] frequencyRects = new FrequencyRect[numRects];

//void setup() {
//  size(1000, 500);
//  background(color(#54AD24));
//  line(width/10, height-50, width*.9, height-50);
//  for (int i = 0; i < numRects; i++) {
    
//  }
//}

//void draw() {
  
//}

//class frequencyRect() {
//  frequencyRect () {
    
//  }
//}

//class updateFrequencies() {
  
//}
