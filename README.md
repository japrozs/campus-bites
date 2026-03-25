# CampusBites

A Flutter mobile app helping college students find affordable food near campus and track their weekly meal budget. Works fully offline using local storage.

---

## Team Members

| Name               | Student ID | Role                                               |
| ------------------ | ---------- | -------------------------------------------------- |
| Japroz Singh Saini | 002753343  | UI design, navigation, screens, dark mode, testing |
| Alex Henriquez     | 002855700  | Database, models, data logic, documentation        |

**GitHub:** https://github.com/japrozs/campus-bites

---

## Features

- Browse and search food spots by name or cuisine
- Filter by cuisine, price tier, and open/closed status
- Active filter indicator on the Filter button
- View food spot details (cuisine, price, hours)
- Save and remove favorite restaurants
- Duplicate favorite prevention
- Leave star ratings (1–5) and written reviews
- Track meal expenses with add, edit, and delete
- Weekly spending total on the budget screen
- Dark mode toggle — applies instantly, persists on restart
- Form validation before any database write
- Fully offline — no internet required

---

## Technologies Used

| Technology         | Version | Purpose                       |
| ------------------ | ------- | ----------------------------- |
| Flutter            | 3.x     | UI framework                  |
| Dart               | 3.x     | Programming language          |
| sqflite            | ^2.3.0  | Local SQLite database         |
| shared_preferences | ^2.2.2  | User settings persistence     |
| path               | ^1.8.3  | Database file path resolution |

---

## Installation Instructions

1. Make sure you have Flutter installed. If not, follow the guide at https://docs.flutter.dev/get-started/install

2. Clone the repository:

```bash
git clone https://github.com/japrozs/campus-bites
cd campus-bites
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app on an Android emulator or physical device:

```bash
flutter run
```

> **Note:** This app is tested on Android. Make sure you have an Android emulator running or a physical device connected before running.

---

## Usage Guide

**Home Screen** — Browse the list of food spots. Use the search bar to find by name or cuisine. Tap the Filter button to narrow results by cuisine, price, or open status.

**Food Spot Details** — Tap any restaurant to see its details. Tap "Save to Favorites" to bookmark it. Tap "Add Review" to leave a star rating and comment.

**Budget Tracker** — Tap the Budget tab. Tap "+ Add Expense" to log a meal. Tap the edit icon to update an entry or the delete icon to remove it. The weekly total updates automatically.

**Favorites** — Tap the Favorites tab to see all saved spots. Tap the open icon to go back to that restaurant's details. Tap the delete icon to remove it.

**Settings** — Toggle dark mode to switch the app theme instantly. Change the default filter preference. Tap "Save Settings" to persist your preferences.

---

## Database Schema

| Table            | Key Columns                             |
| ---------------- | --------------------------------------- |
| `restaurants`    | id, name, cuisine, price, hours, isOpen |
| `reviews`        | id, restaurantId, rating (1–5), comment |
| `favorites`      | id, restaurantId (UNIQUE)               |
| `budget_entries` | id, name, amount, date                  |

**SharedPreferences keys:** `darkMode` (bool), `notifications` (bool), `filterPreference` (String)

---

## Architecture

```
UI Layer       →  screens/ (stateful widgets, setState, ValueNotifier)
Data Layer     →  db/database_helper.dart (singleton, async CRUD methods)
Persistence    →  SQLite .db file + SharedPreferences
```

Navigation uses a `BottomNavigationBar` with `IndexedStack` for the 4 main tabs. Deeper screens use `Navigator.push`.

---

## File Structure

```
lib/
├── main.dart                         # Entry point, theme, dark mode notifier
├── models/                           # restaurant.dart, review.dart, budget_entry.dart
├── db/database_helper.dart           # All SQLite CRUD operations
└── screens/
    ├── splash_screen.dart
    ├── home_screen.dart              # Bottom nav host
    ├── food_list_tab.dart            # Search, filters, restaurant list
    ├── food_spot_details_screen.dart
    ├── add_review_screen.dart
    ├── budget_tracker_screen.dart
    ├── favorites_screen.dart
    └── settings_screen.dart
```

---

## Known Issues

- Restaurant data is seeded/hardcoded — there is no way to add new restaurants from within the app
- Notifications toggle in Settings has no functional effect
- Budget entries are not linked to specific restaurants
- No weekly budget limit or overspending alert

---

## Future Enhancements

- Allow users to add their own restaurant entries
- Implement push notifications for budget reminders
- Add spending charts and weekly/monthly breakdowns
- Set a weekly budget limit with an alert when exceeded
- Add real GPS-based location filtering for nearby spots
- Cloud sync so data persists across devices

---

## License

This project is licensed under the MIT License.

```
MIT License

Copyright (c) 2026 Japroz Singh Saini & Alex Henriquez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```
