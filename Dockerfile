# Используем многоэтапную сборку для оптимизации размера
FROM ubuntu:22.04 AS builder

# Установка необходимых пакетов
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libgrpc++-dev \
    libprotobuf-dev \
    protobuf-compiler-grpc \
    libssl-dev \
    zlib1g-dev \
    libboost-all-dev \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Сборка librdkafka
RUN git clone https://github.com/edenhill/librdkafka.git && \
    cd librdkafka && \
    git checkout v2.3.0 && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# Сборка cppkafka
RUN git clone https://github.com/mfontanini/cppkafka.git && \
    cd cppkafka && \
    git checkout v0.4.1 && \
    mkdir build && \
    cd build && \
    cmake .. -DCPPKAFKA_BUILD_SHARED=OFF -DCPPKAFKA_DISABLE_TESTS=ON -DCPPKAFKA_DISABLE_EXAMPLES=ON && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# Рабочая директория
WORKDIR /app

# Копируем исходный код
COPY . .

# Создаем директорию для сборки
RUN mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc)

# Финальный образ
FROM ubuntu:22.04

# Установка только необходимых runtime зависимостей
RUN apt-get update && apt-get install -y \
    libgrpc++1 \
    libprotobuf23 \
    libssl3 \
    libboost-system1.74.0 \
    libboost-thread1.74.0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копируем собранные библиотеки из builder
COPY --from=builder /usr/local/lib/librdkafka* /usr/local/lib/
COPY --from=builder /usr/local/lib/libcppkafka* /usr/local/lib/
COPY --from=builder /usr/local/include/librdkafka /usr/local/include/
COPY --from=builder /usr/local/include/cppkafka /usr/local/include/

# Обновляем кэш библиотек
RUN ldconfig

# Копируем собранное приложение из builder
COPY --from=builder /app/build/AnomalyAlert /app/
COPY --from=builder /app/build/KafkaConsumer /app/
COPY --from=builder /app/config /app/config

# Запуск приложения
CMD ["./AnomalyAlert"] 