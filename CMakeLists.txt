cmake_minimum_required(VERSION 3.14)
project(AnomalyAlert)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Добавляем путь к нашим CMake модулям
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(FetchContent)

# Fetch and configure nlohmann_json
FetchContent_Declare(
    json
    GIT_REPOSITORY https://github.com/nlohmann/json.git
    GIT_TAG v3.11.3
)

FetchContent_MakeAvailable(json)

include_directories(include)

find_package(Threads REQUIRED)
find_package(RdKafka REQUIRED)
find_package(cppkafka REQUIRED)

add_executable(AnomalyAlert
    src/main.cpp
    src/simulator/SensorSimulator.cpp
    src/simulator/KafkaProducer.cpp
)

target_link_libraries(AnomalyAlert
    ${cppkafka_LIBRARIES}
    ${RdKafka_LIBRARIES}
    nlohmann_json::nlohmann_json
    Threads::Threads
)

add_executable(KafkaConsumer
    src/main_consumer.cpp
    src/consumer/KafkaConsumer.cpp
)

target_link_libraries(KafkaConsumer
    ${cppkafka_LIBRARIES}
    ${RdKafka_LIBRARIES}
    nlohmann_json::nlohmann_json
    Threads::Threads
)
