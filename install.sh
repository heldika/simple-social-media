#!/bin/sh
set -e

mkdir -p bootstrap/cache \
         storage/framework/cache \
         storage/framework/sessions \
         storage/framework/views

chown -R www-data:www-data bootstrap storage || true
chmod -R ug+rwx bootstrap storage || true

npm install --legacy-peer-deps --no-audit --progress=false
npm run dev
composer config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true || true

composer config --no-plugins allow-plugins.pestphp/pest-plugin true || true
composer install --optimize-autoloader --no-interaction --ignore-platform-reqs
cp .env.example .env || true
php artisan key:generate

sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/g' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=password/g' .env

php artisan migrate:fresh --seed --force
