#!/bin/bash
# =======================================================
# 🧪 Тестовый скрипт для проверки archive_logs.sh
# =======================================================

TEST_ROOT="$HOME/lab1_test"
LOG_DIR="$TEST_ROOT/log"
BACKUP_DIR="$TEST_ROOT/backup"

# Определение ОС для правильных параметров dd
OS=$(uname -s)
if [ "$OS" = "Darwin" ]; then
    DD_BS="1m"
else
    DD_BS="1M"
fi

echo "✅ Обнаружена ОС: $OS"

# Очистка и создание окружения
rm -rf "$TEST_ROOT"
mkdir -p "$LOG_DIR" "$BACKUP_DIR"
echo "✅ Тестовое окружение подготовлено: $LOG_DIR, $BACKUP_DIR"

# Генерация файлов на заданный объём (в MB)
generate_files() {
    local total_mb=$1
    local file_index=1
    local current_size=0
    rm -f "$LOG_DIR"/*
    while [ $current_size -lt $total_mb ]; do
        local file_path="$LOG_DIR/file_$file_index.log"
        dd if=/dev/zero of="$file_path" bs=$DD_BS count=50 status=none
        ((current_size+=50))
        ((file_index++))
    done
    echo "📂 Сгенерировано файлов: $((file_index-1)), общий размер ≈ $current_size MB"
}

# --- 9 основных тестов ---
for i in {1..9}; do
    echo; echo "=== Тест $i ==="
    case $i in
        1) generate_files 600; THRESH=70 ;;
        2) generate_files 600; THRESH=50 ;;
        3) generate_files 600; export LAB1_MAX_COMPRESSION=1; THRESH=70 ;;
        4) generate_files 600; THRESH=100 ;;  # не архивируем
        5) generate_files 500; THRESH=70 ;;
        6) generate_files 600; export LAB1_MAX_COMPRESSION=1; THRESH=50 ;;
        7) generate_files 500; THRESH=80 ;;
        8) generate_files 700; THRESH=60 ;;
        9) generate_files 500; THRESH=90 ;;
    esac
    echo "📌 Порог установлен: $THRESH%"
    ./archive_logs.sh "$LOG_DIR" "$THRESH"
    ls -lh "$BACKUP_DIR"
    unset LAB1_MAX_COMPRESSION
done

# Дополнительные тесты
echo; echo "=== Тест 10 (граничное значение 70%) ==="
generate_files 700
THRESH=70
./archive_logs.sh "$LOG_DIR" "$THRESH"
ls -lh "$BACKUP_DIR"

echo; echo "=== Тест 11 (наличие подпапок) ==="
generate_files 500
mkdir -p "$LOG_DIR/subdir"
dd if=/dev/zero of="$LOG_DIR/subdir/extra.log" bs=$DD_BS count=50 status=none
THRESH=60
./archive_logs.sh "$LOG_DIR" "$THRESH"
ls -lh "$BACKUP_DIR"

echo; echo "=== Тест 12 (файл без прав на удаление) ==="
generate_files 500
chmod 444 "$LOG_DIR/file_1.log"
THRESH=60
./archive_logs.sh "$LOG_DIR" "$THRESH"
chmod 644 "$LOG_DIR/file_1.log"
ls -lh "$BACKUP_DIR"

echo; echo "✅ Все 12 тестов завершены."
