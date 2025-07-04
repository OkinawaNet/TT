#!/bin/bash

# Папки с диаграммами и изображениями
DRAW_DIR="draw"
IMAGE_DIR="image"

# Создаем папку image, если не существует
mkdir -p "$IMAGE_DIR"

# Получаем список измененных и новых .drawio файлов
changed_files=$(git status --porcelain "$DRAW_DIR" | grep -E '\.drawio$' | awk '
    # Обработка переименований: R old -> new
    $1 ~ /^R/ {print $4}
    # Обработка остальных изменений: M, A, AM, ?? и др.
    $1 !~ /^R/ {print $2}
')

# Рендерим только измененные файлы
echo "$changed_files" | while IFS= read -r file; do
    # Получаем относительный путь
    REL_PATH="${file#$DRAW_DIR/}"
    # Создаем директорию для выходного файла
    OUT_DIR="$IMAGE_DIR/$(dirname "$REL_PATH")"
    mkdir -p "$OUT_DIR"
    # Рендерим диаграмму в PNG
    drawio -x -f png -o "$OUT_DIR/$(basename "${file%.*}").png" "$file"
done

# Добавляем сгенерированные файлы в Git
git add "$IMAGE_DIR"