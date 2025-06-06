cmake_minimum_required(VERSION 3.14)
project(AnomalyAlert)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(include)

find_package(Threads REQUIRED)

find_package(PkgConfig REQUIRED)
pkg_check_modules(CPPKAFKA REQUIRED IMPORTED_TARGET cppkafka)
pkg_check_modules(RDKAFKA REQUIRED IMPORTED_TARGET rdkafka++)
pkg_check_modules(NLOHMANN_JSON REQUIRED nlohmann_json)

add_executable(AnomalyAlert
    src/main.cpp
    src/simulator/SensorSimulator.cpp
    src/simulator/KafkaProducer.cpp
)

target_link_libraries(AnomalyAlert
    PkgConfig::CPPKAFKA
    PkgConfig::RDKAFKA
    Threads::Threads
)

add_executable(KafkaConsumer
    src/main_consumer.cpp
    src/consumer/KafkaConsumer.cpp
)

target_link_libraries(KafkaConsumer
    PkgConfig::CPPKAFKA
    PkgConfig::RDKAFKA
    Threads::Threads
)
