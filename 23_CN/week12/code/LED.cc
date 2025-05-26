#include <iostream>
#include <wiringPi.h>

#define LED 4

int main(void) {
    std::cout << "Raspberry Pi Blink\n";

    if (wiringPiSetup() == -1) {
        return 1;
    }

    pinMode(LED, OUTPUT);

    while(1){
        std::cout << "LED ON\n";
        digitalWrite(LED, HIGH);
        delay(250);
        std::cout << "LED OFF\n";
        digitalWrite(LED, LOW);
        delay(250);
    }

    return 0;
}
