## Домашнее задание 2

### 1. Схемы событий

#### TestCreated. Пример события

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


#### TestCreated. JSON схема
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