#!/bin/bash

# Получаем текущую директорию
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Проверяем, существуют ли директории
if [ ! -d ~/testnet ]; then
    echo "Директория ~/testnet не найдена. Создание..."
    mkdir -p ~/testnet
fi

if [ ! -d ~/testnet/config ]; then
    echo "Директория ~/testnet/config не найдена. Создание..."
    mkdir -p ~/testnet/config
fi

# Проверяем, существует ли файл
if [ ! -f ~/testnet/config/config.ini ]; then
    echo "Файл config.ini не найден. Копирование..."
    cp $dir/configs/master/config.ini ~/testnet/config/config.ini
fi

# Запускаем контейнер Docker с нужными параметрами
docker run --name node -d -p 8888:8888 -p 9876:9876 \
-v ~/testnet/data:/mnt/dev/data \
-v ~/testnet/config:/mnt/dev/config \
-v ~/testnet/wallet:/root/eosio-wallet \
-v $dir/../../contracts:/mnt/dev/contracts \
dicoop/leap_v4.0.4 \
/bin/bash -c '/usr/bin/nodeos -d /mnt/dev/data -p eosio --config-dir /mnt/dev/config --disable-replay-opts'

echo "Контейнер node установлен - блокчейн запущен."
sleep 10
