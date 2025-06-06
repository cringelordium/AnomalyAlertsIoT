#pragma once
#include <string>
#include <vector>
#include <random>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

struct SensorData {
    std::string id;
    std::string type;
    double value;
    std::string timestamp;
};

class SensorSimulator {
public:
    SensorSimulator(std::string id, std::string type, double min_val, double max_val);
    SensorData generateData();

private:
    std::string id;
    std::string type;
    double min_val;
    double max_val;
    std::default_random_engine generator;
    std::uniform_real_distribution<double> distribution;
};

inline void to_json(json& j, const SensorData& data) {
    j = json{
        {"id", data.id},
        {"type", data.type},
        {"value", data.value},
        {"timestamp", data.timestamp}
    };
}