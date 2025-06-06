#include "KafkaConsumer.hpp"
#include <cppkafka/cppkafka.h>
#include <nlohmann/json.hpp>
#include <iostream>

using namespace cppkafka;
using json = nlohmann::json;

KafkaConsumer::KafkaConsumer(const std::string& brokers, const std::string& topic, const std::string& group_id)
    : topic(topic) {
    Configuration config = {
        { "metadata.broker.list", brokers },
        { "group.id", group_id },
        { "auto.offset.reset", "earliest" }
    };
    consumer = new Consumer(config);
    consumer->subscribe({ topic });
}

void KafkaConsumer::consume_loop() {
    while (true) {
        Message msg = consumer->poll();
        if (!msg) continue;

        if (msg.get_error()) {
            std::cerr << "[ERROR] Kafka: " << msg.get_error() << std::endl;
            continue;
        }

        try {
            std::string payload = msg.get_payload();
            json j = json::parse(payload);
            double value = j["value"];
            std::string id = j["id"];
            std::string type = j["type"];
            std::string ts = j["timestamp"];

            std::cout << "[RECV] Sensor " << id << " (" << type << ") = " << value << " at " << ts << std::endl;

            if (type == "temperature" && value > 45.0) {
                std::cout << "\033[31m[ALERT] ANOMALY DETECTED\033[0m\n";
            }
        }
        catch (const std::exception& e) {
            std::cerr << "[PARSE ERROR] " << e.what() << std::endl;
        }
    }
}
