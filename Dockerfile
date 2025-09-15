FROM alpine:3.18

# Установка зависимостей
RUN apk add --no-cache \
    libgcc \
    sqlite-libs \
    ca-certificates

# Создание пользователя и группы
RUN addgroup -S sctg && adduser -S sctg -G sctg

# Создание директорий
RUN mkdir -p /app /data && chown sctg:sctg /app /data

WORKDIR /app

# Копирование бинарника
COPY --chown=sctg:sctg --from=builder /app/target/x86_64-unknown-linux-musl/release/sctgdesk-api-server /app/

# Копирование статических файлов webconsole
COPY --chown=sctg:sctg webconsole/dist /app/webconsole/dist

# Копирование скрипта запуска
COPY docker-entrypoint.sh /app/
RUN chmod +x /app/docker-entrypoint.sh

# Настройка пользователя
USER sctg

# Экспорт портов
EXPOSE 21114

# Точка входа
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["sctgdesk-api-server"]