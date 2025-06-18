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
    nlohmann-json3-dev \
    curl \
    unzip \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Установка vcpkg
RUN git clone https://github.com/Microsoft/vcpkg.git && \
    cd vcpkg && \
    ./bootstrap-vcpkg.sh && \
    ./vcpkg integrate install

# Установка зависимостей через vcpkg
RUN cd vcpkg && \
    ./vcpkg install cppkafka:x64-linux && \
    ./vcpkg install prometheus-cpp:x64-linux

# Рабочая директория
WORKDIR /app

# Копируем исходный код
COPY . .

# Создаем директорию для сборки
RUN mkdir build && cd build && \
    cmake .. -DCMAKE_TOOLCHAIN_FILE=/vcpkg/scripts/buildsystems/vcpkg.cmake && \
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
COPY --from=builder /vcpkg/installed/x64-linux/lib/libcppkafka.so* /usr/local/lib/
COPY --from=builder /vcpkg/installed/x64-linux/lib/libprometheus-cpp-*.so* /usr/local/lib/

# Обновляем кэш библиотек
RUN ldconfig

# Копируем собранное приложение из builder
COPY --from=builder /app/build/anomaly_alert /app/
COPY --from=builder /app/config /app/config

# Запуск приложения
CMD ["./anomaly_alert"] 