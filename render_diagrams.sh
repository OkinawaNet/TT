#!/bin/bash

# Папки с диаграммами и изображениями
DRAW_DIR="draw"
IMAGE_DIR="image"

# Создаем папку image, если не существует
mkdir -p "$IMAGE_DIR"

# Получаем список всех .drawio файлов из последнего коммита
changed_files=$(git diff-tree --no-commit-id --name-only -r HEAD^ HEAD | grep "^$DRAW_DIR/.*\.drawio$" | grep -v "\.bkp$" | grep -v "~$")

# Если нет изменений - выходим
if [[ -z "$changed_files" ]]; then
    echo "No changes in .drawio files detected in the last commit."
    exit 0
fi

echo "Files to render:"
echo "$changed_files"

# Проверяем, установлен ли drawio
if ! command -v drawio >/dev/null 2>&1; then
    echo "Error: drawio is not installed or not found in PATH."
    exit 1
fi

# Рендерим файлы
while IFS= read -r file; do
    # Получаем относительный путь
    REL_PATH="${file#$DRAW_DIR/}"
    # Создаем директорию для выходного файла
    OUT_DIR="$IMAGE_DIR/$(dirname "$REL_PATH")"
    mkdir -p "$OUT_DIR"
    
    # Выводим информацию о рендеринге
    output_file="$OUT_DIR/$(basename "${file%.*}").png"
    echo "Rendering $file to $output_file"
    
    # Рендерим диаграмму в PNG
    if ! drawio -x -f png -o "$output_file" "$file" 2>/dev/null; then
        echo "Error rendering $file"
        exit 1
    fi
done <<< "$changed_files"

# Добавляем сгенерированные файлы в Git
git add "$IMAGE_DIR"
# Создаем новый коммит с сгенерированными файлами
git commit -m "Add/udpate rendered PNGs from drawio files"
echo "Rendering completed. Generated files committed."
exit 0
