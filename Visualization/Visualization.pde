import processing.serial.*;

Serial myPort;  // Create object from Serial class
static String val;    // Data received from the serial port
int sensorVal = 0;

void setup()
{
  fullScreen(P3D);
  noStroke();
  fill(204);
  String portName = "COM6";// Change the number (in this case ) to match the corresponding port number connected to your Arduino. 

  myPort = new Serial(this, portName, 115200);
}

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
  val = myPort.readStringUntil('\n'); 
  try {
   sensorVal = Integer.valueOf(val.trim());
  }
  catch(Exception e) {
  ;
  }
  println(sensorVal); // read it and store it in vals!
  }  
  noStroke(); 
  background(0); 
  float dirY = (sensorVal/ float(height) - 0.5) * 2 * -1;
  float dirX = (mouseX / float(width) - 0.5) * 2;
  directionalLight(204, 204, 204, -dirX, -dirY, -1); 
  translate(width/2 - 100, height/2, 0);  
  translate(200, 0, 0); 
  sphere(200);


  fill(255);
  ellipse(random(width), random(height), 3, 3);

}
