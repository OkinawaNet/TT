   #!/bin/bash

   # Папки с диаграммами и изображениями
   DRAW_DIR="draw"
   IMAGE_DIR="image"

   # Создаем папку image, если не существует
   mkdir -p "$IMAGE_DIR"

   # Находим все файлы .drawio в папке draw
   find "$DRAW_DIR" -type f -name "*.drawio" | while read -r file; do
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