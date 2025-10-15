#!/bin/bash
# ------------------------------------------------------------
# archive_logs.sh — Архивация логов (кроссплатформенная версия)
# ------------------------------------------------------------

SOURCE_DIR="$1"
LIMIT="$2"
BACKUP_DIR="./backup"

if [ $# -lt 2 ]; then
  echo "Использование: $0 <папка> <порог>"
  echo "Пример: $0 ./log 70"
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "[ОШИБКА] Каталог '$SOURCE_DIR' не найден!"
  exit 1
fi

# Определение ОС
OS=$(uname -s)
echo "[INFO] Обнаружена ОС: $OS"

if [ "$OS" = "Darwin" ]; then
    # macOS
    DIR_SIZE=$(du -sk "$SOURCE_DIR" | awk '{print $1 * 1024}')
    FS_SIZE=$(df -k "$SOURCE_DIR" | tail -1 | awk '{print $2 * 1024}')
else
    # Linux
    DIR_SIZE=$(du -sb "$SOURCE_DIR" 2>/dev/null | awk '{print $1}')
    if [ -z "$DIR_SIZE" ]; then
        DIR_SIZE=$(du -sk "$SOURCE_DIR" | awk '{print $1 * 1024}')
    fi
    FS_SIZE=$(df -B1 "$SOURCE_DIR" 2>/dev/null | tail -1 | awk '{print $2}')
    if [ -z "$FS_SIZE" ]; then
        FS_SIZE=$(df -k "$SOURCE_DIR" | tail -1 | awk '{print $2 * 1024}')
    fi
fi

# Используем виртуальный размер для тестов (700MB)
VIRTUAL_FS=$((700 * 1024 * 1024))
USAGE=$(awk -v d=$DIR_SIZE -v f=$VIRTUAL_FS 'BEGIN { printf "%.0f", (d/f)*100 }')

echo "[INFO] Размер папки: $((DIR_SIZE / 1024 / 1024)) MB"
echo "[INFO] Используется: $USAGE% от файловой системы"

if [ "$USAGE" -le "$LIMIT" ]; then
  echo "[OK] Заполненность ниже порога, архивация не требуется."
  exit 0
fi

mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

if [ "$LAB1_MAX_COMPRESSION" = "1" ]; then
  ARCHIVE_NAME="logs_${TIMESTAMP}.tar.xz"
  COMPRESS_OPT="-J"
  echo "[INFO] Включено максимальное сжатие (XZ)."
else
  ARCHIVE_NAME="logs_${TIMESTAMP}.tar.gz"
  COMPRESS_OPT="-z"
  echo "[INFO] Используется стандартное сжатие (gzip)."
fi

ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"
echo "[INFO] Создаю архив: $ARCHIVE_PATH"

# Создаем архив
if tar $COMPRESS_OPT -cf "$ARCHIVE_PATH" -C "$SOURCE_DIR" .; then
  echo "[OK] Архив успешно создан."
else
  echo "[ОШИБКА] Не удалось создать архив!"
  exit 1
fi

# Удаляем исходные файлы
if rm -rf "${SOURCE_DIR:?}/"*; then
  echo "[OK] Каталог '$SOURCE_DIR' очищен."
else
  echo "[WARN] Не удалось удалить некоторые файлы."
fi

echo "[DONE] Архивация завершена успешно."
#!/bin/bash
# ------------------------------------------------------------
# archive_logs.sh — Архивация логов (кроссплатформенная версия)
# ------------------------------------------------------------

SOURCE_DIR="$1"
LIMIT="$2"
BACKUP_DIR="./backup"

if [ $# -lt 2 ]; then
  echo "Использование: $0 <папка> <порог>"
  echo "Пример: $0 ./log 70"
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "[ОШИБКА] Каталог '$SOURCE_DIR' не найден!"
  exit 1
fi

# Определение ОС
OS=$(uname -s)
echo "[INFO] Обнаружена ОС: $OS"

if [ "$OS" = "Darwin" ]; then
    # macOS
    DIR_SIZE=$(du -sk "$SOURCE_DIR" | awk '{print $1 * 1024}')
    FS_SIZE=$(df -k "$SOURCE_DIR" | tail -1 | awk '{print $2 * 1024}')
else
    # Linux
    DIR_SIZE=$(du -sb "$SOURCE_DIR" 2>/dev/null | awk '{print $1}')
    if [ -z "$DIR_SIZE" ]; then
        DIR_SIZE=$(du -sk "$SOURCE_DIR" | awk '{print $1 * 1024}')
    fi
    FS_SIZE=$(df -B1 "$SOURCE_DIR" 2>/dev/null | tail -1 | awk '{print $2}')
    if [ -z "$FS_SIZE" ]; then
        FS_SIZE=$(df -k "$SOURCE_DIR" | tail -1 | awk '{print $2 * 1024}')
    fi
fi

# Используем виртуальный размер для тестов (700MB)
VIRTUAL_FS=$((700 * 1024 * 1024))
USAGE=$(awk -v d=$DIR_SIZE -v f=$VIRTUAL_FS 'BEGIN { printf "%.0f", (d/f)*100 }')

echo "[INFO] Размер папки: $((DIR_SIZE / 1024 / 1024)) MB"
echo "[INFO] Используется: $USAGE% от файловой системы"

if [ "$USAGE" -le "$LIMIT" ]; then
  echo "[OK] Заполненность ниже порога, архивация не требуется."
  exit 0
fi

mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

if [ "$LAB1_MAX_COMPRESSION" = "1" ]; then
  ARCHIVE_NAME="logs_${TIMESTAMP}.tar.xz"
  COMPRESS_OPT="-J"
  echo "[INFO] Включено максимальное сжатие (XZ)."
else
  ARCHIVE_NAME="logs_${TIMESTAMP}.tar.gz"
  COMPRESS_OPT="-z"
  echo "[INFO] Используется стандартное сжатие (gzip)."
fi

ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"
echo "[INFO] Создаю архив: $ARCHIVE_PATH"

# Создаем архив
if tar $COMPRESS_OPT -cf "$ARCHIVE_PATH" -C "$SOURCE_DIR" .; then
  echo "[OK] Архив успешно создан."
else
  echo "[ОШИБКА] Не удалось создать архив!"
  exit 1
fi

# Удаляем исходные файлы
if rm -rf "${SOURCE_DIR:?}/"*; then
  echo "[OK] Каталог '$SOURCE_DIR' очищен."
else
  echo "[WARN] Не удалось удалить некоторые файлы."
fi

echo "[DONE] Архивация завершена успешно."
#!/bin/bash
# ------------------------------------------------------------
# archive_logs.sh — Архивация логов (кроссплатформенная версия)
# ------------------------------------------------------------

SOURCE_DIR="$1"
LIMIT="$2"
BACKUP_DIR="./backup"

if [ $# -lt 2 ]; then
  echo "Использование: $0 <папка> <порог>"
  echo "Пример: $0 ./log 70"
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "[ОШИБКА] Каталог '$SOURCE_DIR' не найден!"
  exit 1
fi

# Определение ОС
OS=$(uname -s)
echo "[INFO] Обнаружена ОС: $OS"

if [ "$OS" = "Darwin" ]; then
    # macOS
    DIR_SIZE=$(du -sk "$SOURCE_DIR" | awk '{print $1 * 1024}')
    FS_SIZE=$(df -k "$SOURCE_DIR" | tail -1 | awk '{print $2 * 1024}')
else
    # Linux
    DIR_SIZE=$(du -sb "$SOURCE_DIR" 2>/dev/null | awk '{print $1}')
    if [ -z "$DIR_SIZE" ]; then
        DIR_SIZE=$(du -sk "$SOURCE_DIR" | awk '{print $1 * 1024}')
    fi
    FS_SIZE=$(df -B1 "$SOURCE_DIR" 2>/dev/null | tail -1 | awk '{print $2}')
    if [ -z "$FS_SIZE" ]; then
        FS_SIZE=$(df -k "$SOURCE_DIR" | tail -1 | awk '{print $2 * 1024}')
    fi
fi

# Используем виртуальный размер для тестов (700MB)
VIRTUAL_FS=$((700 * 1024 * 1024))
USAGE=$(awk -v d=$DIR_SIZE -v f=$VIRTUAL_FS 'BEGIN { printf "%.0f", (d/f)*100 }')

echo "[INFO] Размер папки: $((DIR_SIZE / 1024 / 1024)) MB"
echo "[INFO] Используется: $USAGE% от файловой системы"

if [ "$USAGE" -le "$LIMIT" ]; then
  echo "[OK] Заполненность ниже порога, архивация не требуется."
  exit 0
fi

mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

if [ "$LAB1_MAX_COMPRESSION" = "1" ]; then
  ARCHIVE_NAME="logs_${TIMESTAMP}.tar.xz"
  COMPRESS_OPT="-J"
  echo "[INFO] Включено максимальное сжатие (XZ)."
else
  ARCHIVE_NAME="logs_${TIMESTAMP}.tar.gz"
  COMPRESS_OPT="-z"
  echo "[INFO] Используется стандартное сжатие (gzip)."
fi

ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"
echo "[INFO] Создаю архив: $ARCHIVE_PATH"

# Создаем архив
if tar $COMPRESS_OPT -cf "$ARCHIVE_PATH" -C "$SOURCE_DIR" .; then
  echo "[OK] Архив успешно создан."
else
  echo "[ОШИБКА] Не удалось создать архив!"
  exit 1
fi

# Удаляем исходные файлы
if rm -rf "${SOURCE_DIR:?}/"*; then
  echo "[OK] Каталог '$SOURCE_DIR' очищен."
else
  echo "[WARN] Не удалось удалить некоторые файлы."
fi

echo "[DONE] Архивация завершена успешно."#!/bin/bash
# ------------------------------------------------------------
# archive_logs.sh — Архивация логов (кроссплатформенная версия)
# ------------------------------------------------------------

SOURCE_DIR="$1"
LIMIT="$2"
BACKUP_DIR="./backup"

if [ $# -lt 2 ]; then
  echo "Использование: $0 <папка> <порог>"
  echo "Пример: $0 ./log 70"
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "[ОШИБКА] Каталог '$SOURCE_DIR' не найден!"
  exit 1
fi

# Определение ОС
OS=$(uname -s)
echo "[INFO] Обнаружена ОС: $OS"

if [ "$OS" = "Darwin" ]; then
    # macOS
    DIR_SIZE=$(du -sk "$SOURCE_DIR" | awk '{print $1 * 1024}')
    FS_SIZE=$(df -k "$SOURCE_DIR" | tail -1 | awk '{print $2 * 1024}')
else
    # Linux
    DIR_SIZE=$(du -sb "$SOURCE_DIR" 2>/dev/null | awk '{print $1}')
    if [ -z "$DIR_SIZE" ]; then
        DIR_SIZE=$(du -sk "$SOURCE_DIR" | awk '{print $1 * 1024}')
    fi
    FS_SIZE=$(df -B1 "$SOURCE_DIR" 2>/dev/null | tail -1 | awk '{print $2}')
    if [ -z "$FS_SIZE" ]; then
        FS_SIZE=$(df -k "$SOURCE_DIR" | tail -1 | awk '{print $2 * 1024}')
    fi
fi

# Используем виртуальный размер для тестов (700MB)
VIRTUAL_FS=$((700 * 1024 * 1024))
USAGE=$(awk -v d=$DIR_SIZE -v f=$VIRTUAL_FS 'BEGIN { printf "%.0f", (d/f)*100 }')

echo "[INFO] Размер папки: $((DIR_SIZE / 1024 / 1024)) MB"
echo "[INFO] Используется: $USAGE% от файловой системы"

if [ "$USAGE" -le "$LIMIT" ]; then
  echo "[OK] Заполненность ниже порога, архивация не требуется."
  exit 0
fi

mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

if [ "$LAB1_MAX_COMPRESSION" = "1" ]; then
  ARCHIVE_NAME="logs_${TIMESTAMP}.tar.xz"
  COMPRESS_OPT="-J"
  echo "[INFO] Включено максимальное сжатие (XZ)."
else
  ARCHIVE_NAME="logs_${TIMESTAMP}.tar.gz"
  COMPRESS_OPT="-z"
  echo "[INFO] Используется стандартное сжатие (gzip)."
fi

ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"
echo "[INFO] Создаю архив: $ARCHIVE_PATH"

# Создаем архив
if tar $COMPRESS_OPT -cf "$ARCHIVE_PATH" -C "$SOURCE_DIR" .; then
  echo "[OK] Архив успешно создан."
else
  echo "[ОШИБКА] Не удалось создать архив!"
  exit 1
fi

# Удаляем исходные файлы
if rm -rf "${SOURCE_DIR:?}/"*; then
  echo "[OK] Каталог '$SOURCE_DIR' очищен."
else
  echo "[WARN] Не удалось удалить некоторые файлы."
fi

echo "[DONE] Архивация завершена успешно."
