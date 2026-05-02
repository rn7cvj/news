# news

Первый учебный iOS-проект на SwiftUI.

## Что делает проект

- Загружает новости из News API.
- Показывает список новостей (Feed) с пагинацией.
- Открывает детальный экран конкретной новости.

## Технологии

- SwiftUI
- async/await
- MVVM + UseCase/Repository/DataSource

## Настройка локального API ключа

1. Скопируйте файл:
   `news/Configuration.example.xcconfig` -> `news/Configuration.xcconfig`
2. Укажите реальный ключ:
   `NEWS_API_KEY=...`

`news/Configuration.xcconfig` добавлен в `.gitignore` и не должен попадать в git.
