#!/bin/bash

if [ -z "$1" ]; then
    echo "Ошибка: не указана директория"
    echo "Использование: ./backup.sh <директория>"
    exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="$HOME/backups"
LOG_FILE="$BACKUP_DIR/backup.log"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Директория не существует"
    exit 1
fi


mkdir -p "$BACKUP_DIR"

AVAILABLE_SPACE=$(df "$BACKUP_DIR" | awk 'NR==2 {print $4}')

if [ "$AVAILABLE_SPACE" -lt 10240 ]; then
    echo "Недостаточно места" >> "$LOG_FILE"
    exit 1
fi

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
tar -czf "$BACKUP_DIR/backup_$DATE.tar.gz" "$SOURCE_DIR" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "Бэкап успешно создан" >> "$LOG_FILE"
else
    echo "Ошибка при создании бэкапа" >> "$LOG_FILE"
fi