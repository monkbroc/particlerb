const int LED = D0;
bool state = false;

void setup() {
    pinMode(LED, OUTPUT);
    Spark.function("toggle", ledToggle);
}

int ledToggle(String argument) {
    state = !state;
    digitalWrite(LED, state);
    return 0;
}

void loop() {

}
