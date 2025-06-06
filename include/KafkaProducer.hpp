#pragma once

#include <string>
#include <vector>
#include <cppkafka/cppkafka.h>

class KafkaProducer {
public:
    KafkaProducer(const std::string& brokers, const std::string& topic);
    void send_message(const std::string& key, const std::string& value);

private:
    std::string topic;
    class cppkafka::Producer* producer;
};
