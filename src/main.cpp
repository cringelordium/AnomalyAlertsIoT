#include <iostream>
#include "SensorSimulator.hpp"
#include "KafkaProducer.hpp"
#include <nlohmann/json.hpp>
#include <thread>
#include <chrono>
#include <atomic>

using json = nlohmann::json;

int main() {
    SensorSimulator temp_sensor("sensor_number_1", "temperature", 20.0, 50.0);
    KafkaProducer producer("localhost:9092", "sensor-data");

    for (int i = 0; i < 10; ++i) {
        SensorData data = temp_sensor.generateData();
        json j = data;
        std::string message = j.dump();

        std::cout << "\033[32m[SENDING]\033[32m " << message << std::endl;
        producer.send_message(data.id, message);
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }

    return 0;
}