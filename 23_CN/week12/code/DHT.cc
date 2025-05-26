#include <iostream>
#include <wiringPi.h>
#include <dht.h>

#define DHTPIN 1  // 실제 DHT 센서 연결된 GPIO 핀 번호

int main(void) {
    if (wiringPiSetup() == -1) {
        std::cerr << "WiringPi initialization failed." << std::endl;
        return 1;
    }
    dht DHT;
    int result;
    while (1) {
        result = DHT.read22(DHTPIN);  // DHT22를 사용하는 경우, read22를 사용합니다.
        if (result == DHTLIB_OK) {
            std::cout << "Temperature: " << DHT.temperature << "°C, Humidity: " << DHT.humidity << "%" << std::endl;
        } else {
            std::cerr << "DHT read failed, error code: " << result << std::endl;
        }
        delay(2000);  // 2초 동안 대기
    }

    return 0;
}
