import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'food_orders.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE orders (
              id INTEGER PRIMARY KEY,
              foodItem TEXT,
              cost REAL,
              date TEXT,
              targetCost REAL
            )''',
        );
      },
    );
  }

  Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    return await db.insert('orders', order);
  }

  Future<List<Map<String, dynamic>>> getOrders(String date) async {
    final db = await database;
    return await db.query('orders', where: 'date = ?', whereArgs: [date]);
  }

  Future<int> deleteOrder(int id) async {
    final db = await database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateOrder(Map<String, dynamic> order) async {
    final db = await database;
    return await db.update(
      'orders',
      order,
      where: 'id = ?',
      whereArgs: [order['id']],
    );
  }
}
