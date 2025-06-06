#!/bin/bash

# Путь к Kafka
KAFKA_DIR=~/kafka

echo "==> Запуск ZooKeeper..."
gnome-terminal -- bash -c "$KAFKA_DIR/bin/zookeeper-server-start.sh $KAFKA_DIR/config/zookeeper.properties; exec bash"

sleep 7

echo "==> Запуск Kafka Broker..."
gnome-terminal -- bash -c "$KAFKA_DIR/bin/kafka-server-start.sh $KAFKA_DIR/config/server.properties; exec bash"

sleep 7

echo "==> Проверка существующих топиков:"
$KAFKA_DIR/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list

echo "==> Запуск консольного Kafka consumer..."
gnome-terminal -- bash -c "$KAFKA_DIR/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic sensor-data --from-beginning; exec bash"
