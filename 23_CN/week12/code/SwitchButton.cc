#include <iostream>
#include <wiringPi.h>

#define LED 4
#define BUTTON 1

int main(void) {
    std::cout << "Raspberry Pi Button\n";

    if (wiringPiSetup() == -1) {
        return 1;
    }

    pinMode(BUTTON, INPUT);
    pinMode(LED, OUTPUT);

    while(1){
		if(digitalRead(BUTTON)==HIGH){
	        std::cout << "Toggle ON\n";
			digitalWrite(LED, !digitalRead(LED));
			delay(250);
		}
    }

    return 0;
}

