#include "led.h"
#include "application.h"

LED::LED(int pin) : pin(pin), state(false) {
  pinMode(this->pin, OUTPUT);
}

void LED::toggle() {
  this->state = !this->state;
  digitalWrite(this->pin, this->state);
}

