#include "KafkaProducer.hpp"
#include <cppkafka/cppkafka.h>
#include <iostream>
#include <exception>

using namespace cppkafka;

KafkaProducer::KafkaProducer(const std::string& brokers, const std::string& topic)
    : topic(topic) {
    Configuration config = {
        { "metadata.broker.list", brokers }
    };
    producer = new Producer(config);
}

void KafkaProducer::send_message(const std::string& key, const std::string& value) {
    try {
        producer->produce(MessageBuilder(topic).key(key).payload(value));
        producer->flush();
    } catch (const std::exception& e) {
        std::cerr << "error sending message to Kafka i guess: " << e.what() << std::endl;
    }
}

