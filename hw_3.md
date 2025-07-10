## Домашнее задание 2

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

### 1. Миграции связей

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



В пронумерованных списках исправь грамматику и пунктуацию. больше ничего не дописывай и не исправляй.