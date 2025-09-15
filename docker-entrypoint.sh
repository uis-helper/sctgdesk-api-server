#!/bin/sh
set -e

# Инициализация базы данных если не существует
if [ ! -f "/data/db_v2.sqlite3" ]; then
    echo "Initializing database..."
    sqlite3 /data/db_v2.sqlite3 "VACUUM;"
fi

# Создание конфигурационных файлов если отсутствуют
if [ ! -f "/data/oauth2.toml" ]; then
    echo "Creating default oauth2.toml..."
    cat > /data/oauth2.toml << EOF
[providers.github]
client_id = ""
client_secret = ""
redirect_uri = "http://localhost:21114/api/oauth2/callback/github"
scope = ["user:email"]

[providers.dex]
client_id = ""
client_secret = ""
redirect_uri = "http://localhost:21114/api/oauth2/callback/dex"
auth_url = "http://localhost:5556/dex/auth"
token_url = "http://localhost:5556/dex/token"
userinfo_url = "http://localhost:5556/dex/userinfo"
EOF
fi

if [ ! -f "/data/s3config.toml" ]; then
    echo "Creating default s3config.toml..."
    cat > /data/s3config.toml << EOF
region = "us-east-1"
bucket = "your-bucket-name"
access_key = ""
secret_key = ""
endpoint = ""
EOF
fi

# Запуск приложения
exec "$@"