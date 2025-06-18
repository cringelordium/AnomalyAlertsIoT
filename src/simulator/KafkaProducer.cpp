#include "KafkaProducer.hpp"
#include <cppkafka/cppkafka.h>
#include <iostream>
#include <exception>
#include <thread>
#include <chrono>

using namespace cppkafka;

KafkaProducer::KafkaProducer(const std::string& brokers, const std::string& topic)
    : topic(topic) {
    // Ждем, пока Kafka будет готова
    std::cout << "Waiting for Kafka to be ready..." << std::endl;
    std::this_thread::sleep_for(std::chrono::seconds(30));

    Configuration config = {
        { "metadata.broker.list", brokers },
        { "client.id", "anomaly-alert-producer" },
        { "message.timeout.ms", "5000" },
        { "queue.buffering.max.ms", "100" },
        { "queue.buffering.max.messages", "10000" },
        { "retries", "3" },
        { "retry.backoff.ms", "1000" }
    };
    producer = new Producer(config);
}

void KafkaProducer::send_message(const std::string& key, const std::string& value) {
    const int max_retries = 3;
    int retry_count = 0;
    bool success = false;

    while (!success && retry_count < max_retries) {
        try {
            producer->produce(MessageBuilder(topic).key(key).payload(value));
            producer->flush();
            success = true;
        } catch (const std::exception& e) {
            retry_count++;
            std::cerr << "Error sending message to Kafka (attempt " << retry_count << "/" << max_retries << "): " << e.what() << std::endl;
            
            if (retry_count < max_retries) {
                std::this_thread::sleep_for(std::chrono::seconds(1));
            }
        }
    }

    if (!success) {
        std::cerr << "Failed to send message after " << max_retries << " attempts" << std::endl;
    }
}

