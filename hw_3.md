## Домашнее задание 3

### 1. Схемы событий

#### TestCreated. Пример формального события.

```json
{
    "event_id": "90a91f4b-8e34-4a3c-bfc8-f6649597445e",
    "event_version": 0,
    "event_name": "TestCreated",
    "produced_at": "2025-07-09T16:54:00Z",
    "payload": {
        "replication_id": "90a91f4b-8e34-4a3c-bfc8-f6649597445e",
        "title": "[ULAB-1] Факторгруппа. Теоремы о гомоморфизмах",
        "candidate_replication_id": "90a91f4b-8e34-4a3c-bfc8-f6649597445e",
        "created_at": "2025-07-09T15:00:00Z",
        "tasks": [
            {
                "replication_id": "90a91f4b-8e34-4a3c-bfc8-f6649597445e",
                "text": "Найти факторгруппу S4/V4, где V4 = {e,(12)(34), (13)(24),(14)(23)} – четверная группа Клейна.",
                "author_replication_id": "90a91f4b-8e34-4a3c-bfc8-f6649597445e",
                "created_at": "2025-07-09T14:00:00Z"
            }
        ]
    }
}
```


#### TestCreated. JSON схема формального события.
```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "title": "TestCreated.v0",
    "description": "Initial json schema for test created formal event",
    "definitions": {
        "payload": {
            "type": "object",
            "properties": {
                "replication_id": {
                    "type": "string"
                },
                "title": {
                    "type": "string"
                },
                "candidate_replication_id": {
                    "type": "string"
                },
                "created_at": {
                    "type": "string"
                },
                "tasks": {
                    "type": "array",
                    "items": {
                        "type": "object",
                        "properties": {
                            "replication_id": {
                                "type": "string"
                            },
                            "text": {
                                "type": "string"
                            },
                            "author_replication_id": {
                                "type": "string"
                            },
                            "created_at": {
                                "type": "string"
                            }
                        },
                        "required": [
                            "replication_id",
                            "text",
                            "author_replication_id",
                            "created_at"
                        ]
                    }
                }
            },
            "required": [
                "replication_id",
                "title",
                "candidate_replication_id",
                "created_at",
                "tasks"
            ]
        }
    },
    "type": "object",
    "properties": {
        "event_id": {
            "type": "string"
        },
        "event_version": {
            "enum": [0]
        },
        "event_name": {
            "enum": ["TestCreated"]
        },
        "produced_at": {
            "type": "string"
        },
        "payload": {
            "$ref": "#/definitions/payload"
        }
    },
    "required": [
        "event_id",
        "event_version",
        "event_name",
        "produced_at",
        "payload"
    ]
}
```

#### TestPassed. Пример функционального события.

```json
{
    "event_id": "90a91f4b-8e34-4a3c-bfc8-f6649597445e",
    "event_version": 0,
    "event_name": "TestPassed",
    "produced_at": "2025-07-09T16:54:00Z",
    "payload": {
        "test_replication_id": "90a91f4b-8e34-4a3c-bfc8-f6649597445e",
        "created_at": "2025-07-09T15:00:00Z",
        "tasks": [
            {
                "replication_id": "90a91f4b-8e34-4a3c-bfc8-f6649597445e",
                "author_replication_id": "90a91f4b-8e34-4a3c-bfc8-f6649597445e",
                "created_at": "2025-07-09T14:00:00Z"
            }
        ]
    }
}
```

#### TestPassed. JSON схема функционального события.
```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "title": "TestPassed.v0",
    "description": "Initial json schema for test passed functional event",
    "definitions": {
        "payload": {
            "type": "object",
            "properties": {
                "test_replication_id": {
                    "type": "string"
                },
                "created_at": {
                    "type": "string"
                },
                "tasks": {
                    "type": "array",
                    "items": {
                        "type": "object",
                        "properties": {
                            "replication_id": {
                                "type": "string"
                            },
                            "author_replication_id": {
                                "type": "string"
                            },
                            "created_at": {
                                "type": "string"
                            }
                        },
                        "required": [
                            "replication_id",
                            "author_replication_id",
                            "created_at"
                        ]
                    }
                }
            },
            "required": [
                "test_replication_id",
                "created_at",
                "tasks"
            ]
        }
    },
    "type": "object",
    "properties": {
        "event_id": {
            "type": "string"
        },
        "event_version": {
            "enum": [0]
        },
        "event_name": {
            "enum": ["TestPassed"]
        },
        "produced_at": {
            "type": "string"
        },
        "payload": {
            "$ref": "#/definitions/payload"
        }
    },
    "required": [
        "event_id",
        "event_version",
        "event_name",
        "produced_at",
        "payload"
    ]
}
```

### 2. Миграции связей

#### Переход формальной синхронной на асинхронную event-driven. 

COMM-20, Получение информации о задании, sync-> Streaming: TaskCreated

1. Добавляем новое событие TaskCreated в schema registry.
2. Добавляем консьюмер, который будет сохранять данные о задании. (сервис найма, ON CONFLICT DO NOTHING;)
3. Пишем продюсер.
4. Выключаем синхронную коммуникацию под фиче флагом.
5. Чистим код от старой коммуникации.


#### Переход формальной асинхронной event-driven на синхронную.

COMM-60, Доставка рейтинга,	async TaskRating -> HTTP-вызов

1. Добавляем новый эндпоинт в сервис найма. (овнер данных)
2. Допиливаем обработчик события TestPassed в сервисе бонусов, чтобы бегал за данными в сервис найма.
3. Когда заработает новая логика, отключаем продюсер со стороны сервиса найма.  
4. Ждем, когда консьюмеры обработают все данные из брокера.  
5. Удаляем код консьюмера со всех сервисов потребителей.  
6. Удаляем записи про рейтинг в бд.  
7. Удаляем топик из брокера.  
8. Чистим код от старой коммуникации.


#### Переход функциональной синхронной на асинхронную event-driven.

COMM-40, Зачисление бонусов на счёт менеджера, HTTP -> Business event: TestPassed

1. Добавляем новое событие в schema registry
2. Добавляем в сервис бонусов «пустой» консьюмер без бизнес-логики
3. Продьюсим событие, что тест выполнен.
4. Проверяем, что всё работает.
5. Переносим новую бизнес-логику в консьюмер, а старую выключаем
6. Чистим код от старой коммуникации.


### 3. Миграции для новых требований бизнеса.

#### [US-160] Разбейте названия заданий [Knowledge Area] Title на knowledge area и title. Это нужно сделать во всех местах, где есть старое название.

Пусть есть бизнес-событие TestCreated.  

1. Добавить новое поле `knowledge_area` в таблицу с тестами, в сервисе управления заданиями и в сервисе найма.  
2. Задеплоить сервис управления заданиями с изменениями в базе данных.  
3. Написать обвязку для получения `title` на `knowledge_area + title`. Если в значении `title` есть `knowledge_area`, использовать новый код, если нет — оставить как есть. Такой код выглядит так:  

```ruby
class Test  
  def old_title  
    if title.match(/\[d+\].+/)?  
      title  
    else  
      "[#{knowledge_area}] #{title}"  
    end  
  end  
end  
```  

4. В сервисе управления заданиями заменить прямое получение `title` из базы данных на `old_title` везде, где выдаётся описание теста.  
5. Добавить новую версию события в schema registry.
6. Добавить новую колонку `knowledge_area` в базу данных в сервисе найма. Код не трогать.  
7. Зарелизить новую версию сервисов управления заданиями и найма.  
8. Перенести во всех сервисах-консьюмерах данные в новую колонку `knowledge_area` из `title`.  
9. Добавить логику разделения старой строки `title` на `title` и `knowledge_area` в сервисе найма. В коде это будет выглядеть так:  

```ruby
def consumer_v0(event)  
  knowledge_area, title = event[:payload][:title].scan(/\[(d+\)] (.+)/)  
  # ...  
end  
```  

10. Задеплоить сервис найма.  
11. Изменить код сервиса найма для обработки новой версии события создания теста.  
12. Обновить продюсер в сервисе управления заданиями на отправку новой версии события.  
13. Отключить старый продюсер в сервисе управления заданиями.  
14. Задеплоить продюсер (сервис управления заданиями).  
15. Подождать, пока обработаются все события нулевой версии.  
16. Удалить старый код в консьюмерах сервиса найма.  
17. Задеплоить сервис найма.  
18. Почистить систему от старого события.

#### [US-170] Необходимо анонимизировать информацию о менеджерах, чтобы агрессивные кандидаты не могли угрожать несчастным менеджерам.

Программисты реализовали событие TestPassed с передачей имени менеджера а также отображают имя в найме. Теперь нам нужно выпилить это имя из события. (оставляем лишь replication_id)

1. В сервисе найма выпилить везде отображение имени менеджера name.  
2. Создать schema registry и нулевую версию события.  
3. Добавить новую версию события в schema registry (без name).  
4. Добавить консьюмер новой версии события в сервис бонусов.  
5. Задеплоить сервис бонусов.  
6. Добавить продьюсер новой версии события в сервис найма.  
7. Удалить продьюсинг старой версии события в сервисе найма.  
8. Задеплоить сервис найма.  
9. Подождать, пока обработаются все события нулевой версии.  
10. Удалить консьюмер старой версии события из сервиса бонусов.  
11. Удалить колонку с именем в БД бонусов и найма.
12. Задеплоить бонусы и найм.
13. Почистить систему от старого события.


#### 4. Возможные проблемы с биллингом

1. **Проблемы с синхронной командой CreditToAccount**  
   Проблемы могут возникнуть при отправке запроса в биллинг (вне нашей системы). В случае недоступности сервиса или ошибок можно выполнить ретрай, а затем разбираться по месту.  

2. **Проблемы с асинхронными коммуникациями**  
   2.1. **Сломался message broker, и продюсер не может отправить события**  
      - Использовать `ack: all` для финансовых транзакций.  
      - Применять ретраи если брокер вообще недоступен.  

   2.2. **Событие потерялось и не доставилось консьюмеру**  
      - Решение: `At-least-once delivery`. При записи в БД: `ON CONFLICT DO NOTHING`.  

   2.3. **Событие оказалось невалидным, и консьюмер не может его прочитать**  
      - Использовать Dead Letter Queue (DLQ), затем разбираться вручную.  

   2.4. **Событие валидно, но развалилась бизнес-логика**  
      - Например, не удаётся получить рейтинг через HTTP. Отправить обработку в ретрай.