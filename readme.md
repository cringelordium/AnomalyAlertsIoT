# IoT Anomaly Alerts 

Рассмотрим интересную (или не очень) ситуацию в которой термометр в квартире зачемает что температура поднялась выше безопасной. А как нам об этом узнать? А что делать? Тогда пусть термометр квартиры или любой другой IoT-сенсор шлет нам данные, причем реальном времени, мы их собираем, проверяем на аномалии (в случае чего получаем алерты), передаём и отображаем.

Проект эмулирует работу IoT-системы мониторинга, которая:

собирает данные с виртуальных сенсоров (температура, давление и т.д.),

отправляет их через Kafka,

обрабатывает и анализирует на аномалии,

выдаёт данные через gRPC-сервер,

отдаёт метрики Prometheus для мониторинга в Grafana.

# А какие компоненты?

| Компонент               | Назначение                                                             |
| ----------------------- | ---------------------------------------------------------------------- |
| **SensorSimulator**     | Генерирует фейковые данные сенсора (например, `temp = 36.5`)           |
| **KafkaProducer**       | Отправляет эти данные в Kafka (topic: `sensor-data`)                   |
| **KafkaConsumer**       | Читает данные из Kafka и проверяет их на аномалии                      |
| **AnomalyDetector**     | (внутри Consumer'а) Логика проверки порогов (например, `temp > 40.0`)  |
| **gRPC Server**         | Выдаёт: список последних показаний и список аномалий                   |
| **Prometheus Exporter** | Отдаёт метрики для Prometheus (например, количество аномалий в минуту) |
| **Grafana Dashboard**   | Визуализирует метрики и события                                        |

# Возможный сценарий:

Температура > 50°C

SensorSimulator сгенерировал temp = 53.2

Producer отправил сообщение в Kafka

Consumer его получил, увидел, что значение выше порога

Зафиксировал как аномалию [ALERT]

gRPC сервер теперь вернёт её по /GetAnomalies

Prometheus увидит, что "обнаружена аномалия" — передаст в Grafana

Grafana покажет график пиков

# Stack

| Технология         | Зачем нужна                       |
| ------------------ | --------------------------------- |
| **C++20**          | Основной язык реализации          |
| **Kafka**          | Передача сообщений между модулями |
| **cppkafka**       | Kafka-клиент на C++               |
| **gRPC**           | Сетевой сервер/клиент             |
| **Protobuf**       | Описание gRPC API                 |
| **Prometheus-cpp** | Экспорт метрик                    |
| **Grafana**        | Панель мониторинга                |
| **CMake**          | Сборка проекта :)                 |


# Preparation (im gon delete it later) 

zookeeper
```
bin/zookeeper-server-start.sh config/zookeeper.properties
```

kafka
```
bin/kafka-server-start.sh config/server.properties
```

topic check
```
bin/kafka-topics.sh --list --bootstrap-server localhost:9092
```

if topic is not created:
```
bin/kafka-topics.sh --create \
    --topic sensor-data \
    --bootstrap-server localhost:9092 \
    --partitions 1 \
    --replication-factor 1
```

consumer
```
bin/kafka-console-consumer.sh \
    --bootstrap-server localhost:9092 \
    --topic sensor-data \
    --from-beginning
```

or bash script: 
(пока не сделал)
```
chmod +X zookeeper_kafka.sh 
./zookeeper_kafka.sh
```
