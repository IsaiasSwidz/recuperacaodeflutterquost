/// Serviço de Banco de Dados - Gerencia eventos no SQLite
/// 
/// Esta classe gerencia o armazenamento local dos eventos de alerta
/// usando SQLite, permitindo operações CRUD e notificando os ouvintes
/// quando os dados são alterados
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event.dart';

class DatabaseService extends ChangeNotifier {
  static Database? _database;

  /// Inicializa o banco de dados
  /// 
  /// Abre ou cria o banco de dados SQLite para armazenamento local
  static Future<void> initialize() async {
    _database = await _initDatabase();
  }

  /// Inicializa a instância do banco de dados
  /// 
  /// Cria o caminho para o banco de dados e configura a tabela de eventos
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'events.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  /// Cria a tabela de eventos no banco de dados
  /// 
  /// Define a estrutura da tabela para armazenar eventos de alerta
  static Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        description TEXT
      )
    ''');
  }

  /// Insere um novo evento no banco de dados
  /// 
  /// Converte o objeto Event para mapa e o insere na tabela
  /// Notifica os ouvintes após a inserção
  Future<int> insertEvent(Event event) async {
    final db = _database;
    if (db == null) return Future.error('Database not initialized');
    
    final id = await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    notifyListeners();
    return id;
  }

  /// Obtém todos os eventos do banco de dados
  /// 
  /// Retorna uma lista de eventos ordenados por timestamp em ordem decrescente
  Future<List<Event>> getAllEvents() async {
    final db = _database;
    if (db == null) return [];
    
    final List<Map<String, dynamic>> maps = await db.query('events', orderBy: 'timestamp DESC');
    
    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

  /// Exclui um evento específico do banco de dados
  /// 
  /// Remove o evento com o ID fornecido e notifica os ouvintes
  Future<void> deleteEvent(int id) async {
    final db = _database;
    if (db == null) return;
    
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  /// Limpa todos os eventos do banco de dados
  /// 
  /// Remove todos os registros da tabela de eventos e notifica os ouvintes
  Future<void> clearAllEvents() async {
    final db = _database;
    if (db == null) return;
    
    await db.delete('events');
    notifyListeners();
  }
}