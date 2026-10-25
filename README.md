# Практична робота №12 — HTTP через dio

**Oleksandr · 32-IST · варіант / номер у журналі 25.**

Три валідовані форми надсилають POST JSON через dio на власний піддомен RequestCatcher: /login, /signup, /reset. Є очікування, захист від повторного натискання, повідомлення успіху та помилки. Адреса задається на відповідному екрані. Використовуйте лише вигадані навчальні дані.

## Відкрити та запустити

В Android Studio оберіть File → Open і цю папку, де лежить pubspec.yaml. Встановіть плагіни Flutter/Dart і виберіть Android-пристрій або запущений емулятор.

```powershell
flutter pub get
flutter run
```

Точка входу Android-застосунку: `lib/main.dart`. Мінімальний Android API: 24.

## Код

lib/auth_api.dart — HTTP, таймаути та перевірка адреси; lib/auth_screen.dart — форми; AndroidManifest.xml — INTERNET.

`lib/ui.dart` — невеликі локальні допоміжні віджети. Проєкт не залежить від інших практичних.

[Перевірені скріншоти різних станів Android](screenshots/README.md) — підписаний набір для цієї роботи.

## Перевірка

```powershell
dart analyze --fatal-infos
flutter test --exclude-tags visual
```

Окремий рендер екрана телефону 390×844: `flutter test test/visual_test.dart`. Він створює `screenshots/initial.png`; для №13 рендер використовує демонстраційний репозиторій, а справжнє збереження перевіряє integration_test.

## RequestCatcher

Відкрийте [RequestCatcher](https://requestcatcher.com), створіть власний піддомен та вставте HTTPS-адресу в поле RequestCatcher URL кожної потрібної форми. Після надсилання відкрийте сторінку піддомену й перегляньте отриманий запит. Готовий чужий піддомен у код не зашито.

Альтернативний запуск з адресою за замовчуванням:

```powershell
flutter run --dart-define=REQUEST_CATCHER_URL=https://YOUR-SUBDOMAIN.requestcatcher.com
```

Тести API використовують локальний адаптер, не надсилають дані в інтернет.

## APK та матеріали

```powershell
flutter build apk --debug
# Або для завантаження навчального прикладу в Appetize:
flutter build apk --release
```

APK: `build/app/outputs/flutter-apk/app-debug.apk` або `app-release.apk`. Стандартний навчальний шаблон підписує release debug-ключем; для навчального перегляду, не для публікації в магазині.

[Початкове завдання](Завдання.txt) · [Оригінал методички](../materials/методичка.docx)

Вимоги методички до звітів, власних публічних репозиторіїв, Appetize, відео та QR-кодів наведено в Завдання.txt. Зовнішні публікації та звіти не створювалися в межах запиту на код.
