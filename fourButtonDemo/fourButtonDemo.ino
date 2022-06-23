/*
Gets information from four buttons.
*/

const int button0 = 12;
const int button1 = 13;
const int button2 = 14;
const int button3 = 27;

int buttonState0 = 0;
int buttonState1 = 0;
int buttonState2 = 0;
int buttonState3 = 0;
void setup() {
  // It's inverted since I don't have a 10k resistor
  pinMode(button0, INPUT_PULLUP);
  pinMode(button1, INPUT_PULLUP);
  pinMode(button2, INPUT_PULLUP);
  pinMode(button3, INPUT_PULLUP);

  Serial.begin(9600);
}

void loop() {
  buttonState0 = digitalRead(button0);
  buttonState1 = digitalRead(button1);
  buttonState2 = digitalRead(button2);
  buttonState3 = digitalRead(button3);

  if (buttonState0 == HIGH) {
    Serial.println("Button 0 was pressed");
    delay(10);
  }
  else if (buttonState1 == HIGH) {
    Serial.println("Button 1 was pressed");
    delay(10);
  }
  else if (buttonState2 == HIGH) {
    Serial.println("Button 2 was pressed");
    delay(10);
  }
  else if (buttonState3 == HIGH) {
    Serial.println("Button 3 was pressed");
    delay(10);
  }

}
