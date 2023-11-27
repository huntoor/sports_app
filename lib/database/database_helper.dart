import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sports.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Sports (
        id INTEGER PRIMARY KEY,
        name TEXT,
        sport TEXT,
        age INTEGER
      )
    ''');
  }

  Future<int> insertSport(Map<String, dynamic> sport) async {
    var client = await db;
    return client.insert('Sports', sport);
  }

  Future<List<Map<String, dynamic>>> getAllSports() async {
    var client = await db;
    return client.query('Sports');
  }

  Future<int> updateSport(Map<String, dynamic> sport) async {
    var client = await db;
    return client.update('Sports', sport, where: 'id = ?', whereArgs: [sport['id']]);
  }

  Future<int> deleteSport(int id) async {
    var client = await db;
    return client.delete('Sports', where: 'id = ?', whereArgs: [id]);
  }
}
