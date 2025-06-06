import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    _database ??= await _initDB('journal.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        date TEXT
      )
    ''');
  }

  Future<int> insertEntry(String title, String content) async {
    final db = await instance.database;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return await db.insert('entries', {
      'title': title,
      'content': content,
      'date': today,
    });
  }

  Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await instance.database;
    return await db.query('entries');
  }

  Future<void> deleteEntry(int id) async {
    final db = await instance.database;
    await db.delete('entries', where: 'id = ?', whereArgs: [id]);
  }
}
