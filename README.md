# CampusBites — App Overview & Architecture

## About

CampusBites is a Flutter mobile app helping college students find affordable food near campus and track their weekly meal budget. Works fully offline using local storage.

**Team U12** | Japroz Singh Saini (UI/navigation) · Alex Henriquez (database/navigation/docs)
**GitHub:** https://github.com/japrozs/campus-bites

---

## Tech Stack

|                    |                           |
| ------------------ | ------------------------- |
| Flutter + Dart     | UI framework              |
| sqflite            | Local SQLite database     |
| shared_preferences | User settings persistence |

---

## Architecture

```
UI Layer       ->  screens/ (stateful widgets, setState, ValueNotifier)
Data Layer     ->  db/database_helper.dart (singleton, async CRUD methods)
Persistence    ->  SQLite .db file + SharedPreferences
```

Navigation uses a `BottomNavigationBar` (`IndexedStack`) for the 4 main tabs. Deeper screens use `Navigator.push`.

---

## File Structure

```
lib/
├── main.dart                        # Entry point, theme, dark mode notifier
├── models/                          # restaurant.dart, review.dart, budget_entry.dart
├── db/database_helper.dart          # All SQLite CRUD operations
└── screens/
    ├── splash_screen.dart
    ├── home_screen.dart             # Bottom nav host
    ├── food_list_tab.dart           # Search, filters, restaurant list
    ├── food_spot_details_screen.dart
    ├── add_review_screen.dart
    ├── budget_tracker_screen.dart
    ├── favorites_screen.dart
    └── settings_screen.dart
```

---

## Database Schema

| Table            | Key Columns                             |
| ---------------- | --------------------------------------- |
| `restaurants`    | id, name, cuisine, price, hours, isOpen |
| `reviews`        | id, restaurantId, rating (1–5), comment |
| `favorites`      | id, restaurantId (UNIQUE)               |
| `budget_entries` | id, name, amount, date                  |

**SharedPreferences:** `darkMode` (bool), `notifications` (bool), `filterPreference` (String)

---

## Navigation Flow

```
Splash -> Home ---> Food Spot Details ---> Add Review
              ├── Budget Tracker
              ├── Favorites
              └── Settings
```

---

## Key Features

- Live search + filter sheet (Cuisine, Price, Open Now) with active filter indicator
- Favorites with duplicate prevention via `ConflictAlgorithm.ignore`
- Budget tracker with add/edit/delete and weekly total
- Dark mode via `ValueNotifier` — updates theme instantly app-wide, persists on restart
- Form validation on review and expense submission before any DB write