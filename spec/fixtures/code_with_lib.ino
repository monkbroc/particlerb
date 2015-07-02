#include "led.h"

LED *myLed;
int answer = 42;

void setup() {
  myLed = new LED(D0);
  Spark.function("toggle", ledToggle);
  Spark.variable("answer", &answer, INT);
}

int ledToggle(String argument) {
  myLed->toggle();
  return 1;
}

void loop() {

}
