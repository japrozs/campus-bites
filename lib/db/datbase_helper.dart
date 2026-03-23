import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../models/budget_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('campusbites.db');
    return _database!;
  } 

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  } 


  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE restaurants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cuisine TEXT NOT NULL,
        price TEXT NOT NULL,
        hours TEXT NOT NULL,
        isOpen INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE reviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurantId INTEGER NOT NULL,
        rating INTEGER NOT NULL,
        comment TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurantId INTEGER NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE budget_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    // Seed some restaurants
    final restaurants = [
      {
        'name': 'Campus Grill',
        'cuisine': 'American',
        'price': '\$',
        'hours': '9 AM - 8 PM',
        'isOpen': 1,
      },
      {
        'name': 'Panda Express',
        'cuisine': 'Chinese',
        'price': '\$\$',
        'hours': '10 AM - 9 PM',
        'isOpen': 1,
      },
      {
        'name': 'Subway',
        'cuisine': 'Sandwiches',
        'price': '\$',
        'hours': '8 AM - 10 PM',
        'isOpen': 1,
      },
      {
        'name': 'Taco Bell',
        'cuisine': 'Mexican',
        'price': '\$',
        'hours': '7 AM - 11 PM',
        'isOpen': 1,
      },
      {
        'name': 'Starbucks',
        'cuisine': 'Coffee',
        'price': '\$\$',
        'hours': '6 AM - 7 PM',
        'isOpen': 0,
      },
      {
        'name': 'Pizza Hut',
        'cuisine': 'Italian',
        'price': '\$\$',
        'hours': '11 AM - 10 PM',
        'isOpen': 1,
      },
      {
        'name': 'Chipotle',
        'cuisine': 'Mexican',
        'price': '\$\$',
        'hours': '10 AM - 9 PM',
        'isOpen': 1,
      },
      {
        'name': 'Chick-fil-A',
        'cuisine': 'American',
        'price': '\$',
        'hours': '6 AM - 10 PM',
        'isOpen': 0,
      },
    ];
    for (final r in restaurants) {
      await db.insert('restaurants', r);
    }
  }
  
  // ---- Restaurants ----
  Future<List<Restaurant>> getRestaurants() async {
    final db = await database;
    final maps = await db.query('restaurants');
    return maps.map((m) => Restaurant.fromMap(m)).toList();
  }

  // ---- Reviews ----
  Future<int> insertReview(Review review) async {
    final db = await database;
    return await db.insert('reviews', review.toMap());
  }

  Future<List<Review>> getReviews(int restaurantId) async {
    final db = await database;
    final maps = await db.query(
      'reviews',
      where: 'restaurantId = ?',
      whereArgs: [restaurantId],
    );
    return maps.map((m) => Review.fromMap(m)).toList();
  }


  // ---- Favorites ----
  Future<int> addFavorite(int restaurantId) async {
    final db = await database;
    return await db.insert('favorites', {
      'restaurantId': restaurantId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> removeFavorite(int restaurantId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'restaurantId = ?',
      whereArgs: [restaurantId],
    );
  }
  Future<int> updateBudgetEntry(BudgetEntry entry) async {
    final db = await database;
    return await db.update(
      'budget_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteBudgetEntry(int id) async {
    final db = await database;
    return await db.delete('budget_entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<BudgetEntry>> getBudgetEntries() async {
    final db = await database;
    final maps = await db.query('budget_entries', orderBy: 'date DESC');
    return maps.map((m) => BudgetEntry.fromMap(m)).toList();
  }
}