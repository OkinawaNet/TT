#!/bin/bash

# Папки с диаграммами и изображениями
DRAW_DIR="draw"
IMAGE_DIR="image"

# Создаем папку image, если не существует
mkdir -p "$IMAGE_DIR"

# Получаем список всех .drawio файлов, включая поддиректории
all_drawio_files=$(find "$DRAW_DIR" -type f -name "*.drawio")

# Фильтруем: оставляем только новые или измененные
changed_files=""
for file in $all_drawio_files; do
    # Игнорируем временные/резервные файлы
    if [[ "$file" == *".bkp"* || "$file" == *"~"* ]]; then
        continue
    fi
    
    # Проверяем, является ли файл новым или измененным
    if ! git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
        # Файл новый (не в git)
        changed_files+="$file"$'\n'
    elif git diff --quiet HEAD -- "$file"; then
        # Файл не изменен
        continue
    else
        # Файл изменен
        changed_files+="$file"$'\n'
    fi
done

# Удаляем пустые строки
changed_files=$(echo "$changed_files" | grep -v '^$')

# Если нет изменений - выходим
if [[ -z "$changed_files" ]]; then
    echo "No changes in draw files detected."
    exit 0
fi

echo "Files to render:"
echo "$changed_files"

# Рендерим файлы
echo "$changed_files" | while IFS= read -r file; do
    # Получаем относительный путь
    REL_PATH="${file#$DRAW_DIR/}"
    # Создаем директорию для выходного файла
    OUT_DIR="$IMAGE_DIR/$(dirname "$REL_PATH")"
    mkdir -p "$OUT_DIR"
    
    # Выводим информацию о рендеринге
    output_file="$OUT_DIR/$(basename "${file%.*}").png"
    echo "Rendering $file to $output_file"
    
    # Рендерим диаграмму в PNG
    if ! drawio -x -f png -o "$output_file" "$file"; then
        echo "Error rendering $file"
        exit 1
    fi
done

# Добавляем сгенерированные файлы в Git
git add "$IMAGE_DIR"
echo "Rendering completed. Files added to git."