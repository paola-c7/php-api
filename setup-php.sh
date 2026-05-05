#!/usr/bin/env bash

set -e

echo "Aggiornamento pacchetti..."
sudo apt update

echo "Installazione PHP (CLI + estensioni base)..."
sudo apt install -y \
    php \
    php-cli \
    php-curl \
    php-mbstring \
    php-xml \
    php-zip

echo "Verifica installazione:"
php -v

echo "PHP installato correttamente!"
