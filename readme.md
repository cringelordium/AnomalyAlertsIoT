# zookeeper

bin/zookeeper-server-start.sh config/zookeeper.properties


# kafka

bin/kafka-server-start.sh config/server.properties


# topic check

bin/kafka-topics.sh --list --bootstrap-server localhost:9092


# if topic is not created:

bin/kafka-topics.sh --create \
    --topic sensor-data \
    --bootstrap-server localhost:9092 \
    --partitions 1 \
    --replication-factor 1


# consumer

bin/kafka-console-consumer.sh \
    --bootstrap-server localhost:9092 \
    --topic sensor-data \
    --from-beginning


# or bash script: 

(пока не сделал)

chmod +X zookeeper_kafka.sh 
./zookeeper_kafka.sh

