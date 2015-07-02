const int LED = D0;
bool state = false;
int answer = 42;

void setup() {
    pinMode(LED, OUTPUT);
    Spark.function("toggle", ledToggle);
    Spark.variable("answer", &answer, INT);
}

int ledToggle(String argument) {
    state = !state;
    digitalWrite(LED, state);
    return 1;
}

void loop() {

}
