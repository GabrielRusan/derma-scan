// database_helper.dart
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'skin_disease_detector_2.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE predictions(
            id TEXT PRIMARY KEY,
            image_path TEXT NOT NULL,
            predicted_class TEXT NOT NULL,
            confidence REAL NOT NULL,
            top3_confidence_sum REAL NOT NULL,
            all_predictions TEXT, -- JSON string untuk semua probabilitas
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  static Future<int> insertPrediction(Map<String, dynamic> prediction) async {
    final db = await database;
    return await db.insert('predictions', prediction);
  }

  static Future<List<Map<String, dynamic>>> getAllPredictions() async {
    final db = await database;
    return await db.query('predictions', orderBy: 'created_at DESC');
  }

  static Future<void> deletePrediction(String id) async {
    final db = await database;
    await db.delete('predictions', where: 'id = ?', whereArgs: [id]);
  }
}
