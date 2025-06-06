#include "SensorSimulator.hpp"
#include <ctime>
#include <sstream>
#include <iomanip>
#include <chrono>


SensorSimulator::SensorSimulator(std::string id, std::string type, double min_val, double max_val)
    : id(id), type(type), min_val(min_val), max_val(max_val), generator(std::random_device()()), distribution(min_val, max_val) {}

SensorData SensorSimulator::generateData() {
    double value = distribution(generator);
    auto now = std::chrono::system_clock::now();
    auto in_time_t = std::chrono::system_clock::to_time_t(now);

    std::stringstream ss;
    ss << std::put_time(std::localtime(&in_time_t), "%Y-%m-%d %H:%M:%S");

    return SensorData{id, type, value, ss.str()};
}