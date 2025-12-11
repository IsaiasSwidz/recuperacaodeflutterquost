import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/alert_model.dart';

class DatabaseService {
  static const String _databaseName = 'monitoring.db';
  static const int _databaseVersion = 1;
  
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  
  Database? _database;
  
  DatabaseService._internal();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE alerts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        triggerTime TEXT NOT NULL,
        processedTime TEXT,
        isCritical INTEGER NOT NULL
      )
    ''');
  }
  
  Future<int> insertAlert(AlertModel alert) async {
    final db = await database;
    return await db.insert('alerts', alert.toMap());
  }
  
  Future<List<AlertModel>> getAlerts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'alerts',
      orderBy: 'triggerTime DESC',
    );
    
    return List.generate(maps.length, (i) {
      return AlertModel.fromMap(maps[i]);
    });
  }
  
  Future<int> clearAlerts() async {
    final db = await database;
    return await db.delete('alerts');
  }
  
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}