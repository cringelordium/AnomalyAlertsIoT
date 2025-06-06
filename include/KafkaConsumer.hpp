#pragma once
#include <string>
#include <cppkafka/cppkafka.h>

class KafkaConsumer {
public:
    KafkaConsumer(const std::string& brokers, const std::string& topic, const std::string& group_id);
    void consume_loop();

private:
    std::string topic;
    class cppkafka::Consumer* consumer;
};
