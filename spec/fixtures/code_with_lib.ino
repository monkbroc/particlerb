#include "led.h"

LED *myLed;

void setup() {
  myLed = new LED(D0);
  Spark.function("toggle", ledToggle);
}

int ledToggle(String argument) {
  myLed->toggle();
  return 0;
}

void loop() {

}
