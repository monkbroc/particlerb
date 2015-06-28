class LED {
  public:
  LED(int pin);
  void toggle();

  private:
  int pin;
  bool state;
};

