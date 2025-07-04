#!/bin/bash

# Папки с диаграммами и изображениями
DRAW_DIR="draw"
IMAGE_DIR="image"

# Создаем папку image, если не существует
mkdir -p "$IMAGE_DIR"

# Получаем список измененных, новых и untracked .drawio файлов
changed_files=$(git diff --name-only --diff-filter=d HEAD -- "$DRAW_DIR" | grep '\.drawio$')
changed_files+=$'\n'$(git ls-files --others --exclude-standard -- "$DRAW_DIR" | grep '\.drawio$')

# Удаляем пустые строки и временные/резервные файлы (например, .bak, .bkp)
changed_files=$(echo "$changed_files" | grep -v '^$' | grep -v '\..*\.drawio')

# Если нет изменений - выходим
if [[ -z "$changed_files" ]]; then
    echo "No changes in draw files detected."
    exit 0
fi

echo "Files to render:"
echo "$changed_files"

# Рендерим только измененные файлы
echo "$changed_files" | while IFS= read -r file; do
    # Пропускаем временные/резервные файлы
    if [[ "$file" == *".~"* || "$file" == *".bkp"* ]]; then
        echo "Skipping backup/temporary file: $file"
        continue
    fi

    # Получаем относительный путь
    REL_PATH="${file#$DRAW_DIR/}"
    # Создаем директорию для выходного файла
    OUT_DIR="$IMAGE_DIR/$(dirname "$REL_PATH")"
    mkdir -p "$OUT_DIR"
    
    # Выводим информацию о рендеринге
    echo "Rendering $file to $OUT_DIR/$(basename "${file%.*}").png"
    
    # Рендерим диаграмму в PNG
    if ! drawio -x -f png -o "$OUT_DIR/$(basename "${file%.*}").png" "$file"; then
        echo "Error rendering $file"
    fi
done

# Добавляем сгенерированные файлы в Git
git add "$IMAGE_DIR"