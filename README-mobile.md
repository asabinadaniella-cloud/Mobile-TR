# Mobile application workspace

Этот каталог содержит Expo-приложение, созданное на TypeScript с использованием `expo-router`.

## Требования

- Node.js 18+
- npm 9+

## Установка зависимостей

```bash
cd mobile
npm install
```

## Доступные команды

```bash
npm run dev     # запуск Expo dev server с поддержкой expo-router
npm run build   # генерация статического бандла (expo export)
npm run lint    # проверка кода ESLint
npm run format  # проверка форматирования Prettier
npm run format:write # автоматическое форматирование
npm run test    # запуск Jest тестов
```

## Медиа-активы

Каталог `mobile/assets` содержит только файл-заглушку `.gitkeep`. Для корректного отображения иконок и заставки необходимо добавить реальные изображения со следующими именами:

- `icon-placeholder.png` — основная иконка приложения (1024×1024, без прозрачного фона).
- `splash-placeholder.png` — картинка для заставки загрузки (минимум 1242×2436, формат PNG или JPEG).
- `adaptive-icon-placeholder.png` — адаптивная иконка Android (PNG 1024×1024 с прозрачным фоном).
- `favicon-placeholder.png` — иконка для веб-версии (например, 512×512).

Поместите файлы в `mobile/assets` с указанными именами либо обновите пути в `app.json`, если предпочитаете другие названия.

## Git Hooks

После установки зависимостей автоматически активируется husky pre-commit hook, выполняющий форматирование и линтинг изменённых файлов через `lint-staged`.
