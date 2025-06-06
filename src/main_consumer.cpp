#include "KafkaConsumer.hpp"

int main() {
    KafkaConsumer consumer("localhost:9092", "sensor-data", "anomaly-detector");
    consumer.consume_loop();
    return 0;
}
