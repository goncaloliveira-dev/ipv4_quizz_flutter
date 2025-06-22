import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = 'ipv4game.db';
  static final _databaseVersion = 1;

  //construtor privado para criar uma única instância com a bd
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  //se _database for nulo, atribui _initDatabase()
  Future<Database> get database async => _database ??= await _initDatabase();

  //inicializa a base de dados
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  //cria automaticamente a bd na sua primeira vez
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
  CREATE TABLE scores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    score INTEGER NOT NULL DEFAULT 0,
    difficulty INTEGER NOT NULL,
    created_at TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
  )
''');
  }

  //MÉTODOS DO USER:
  //registar utilizador
  Future<int> registerUser(String username, String password) async {
    final db = await database;
    // Verificar se o nome já existe
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return 0; // já existe
    }

    // Inserir novo utilizador
    return await db.insert('users', {
      'username': username,
      'password': password,
    });
  }

  //login do utilizador
  Future<Map<String, dynamic>?> login(String username, String password) async {
    Database db = await database;
    //verifica se o user já existe
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  //MÉTODOS DO SCORE:
  //cada tentativa, uma nova linha (um novo score)
  Future<void> insertScore(int userId, int score, int level) async {
    final db = await database;
    await db.insert('scores', {
      'user_id': userId,
      'score': score,
      'difficulty': level,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> getCorrectAnswersByLevel(int userId, int level) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
    SELECT COUNT(*) as correct
    FROM scores
    WHERE user_id = ? AND difficulty = ? AND score > 0
  ''',
      [userId, level],
    );
    return result.first['correct'] != null ? result.first['correct'] as int : 0;
  }

  //retorna a lista de pontuações do user
  Future<List<Map<String, dynamic>>> getUserScores(int userId) async {
    final db = await database;
    return await db.query(
      'scores',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  //soma de todas as pontuações
  Future<int> getTotalScore(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(score) as total FROM scores WHERE user_id = ?',
      [userId],
    );
    return result.first['total'] != null ? result.first['total'] as int : 0;
  }

  Future<List<Map<String, dynamic>>> getTopScoresByMedal(
    String medal,
    int limit,
  ) async {
    final db = await database;
    String whereClause;
    List<dynamic> whereArgs = [];

    if (medal == 'ouro') {
      whereClause = 'total >= ?';
      whereArgs = [300];
    } else if (medal == 'prata') {
      whereClause = 'total >= ? AND total < ?';
      whereArgs = [100, 300];
    } else {
      // bronze
      whereClause = 'total < ?';
      whereArgs = [100];
    }

    final result = await db.rawQuery(
      '''
    SELECT users.username, SUM(scores.score) as total
    FROM scores
    INNER JOIN users ON users.id = scores.user_id
    GROUP BY users.id
    HAVING $whereClause
    ORDER BY total DESC
    LIMIT ?
  ''',
      [...whereArgs, limit],
    );

    return result;
  }
}
