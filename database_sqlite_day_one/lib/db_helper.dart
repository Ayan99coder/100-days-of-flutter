import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  // Database lazily load hoga
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  // Database create karo
  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), "simple.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT
          )
        ''');
      },
    );
  }
  // Data insert function
  Future<int> insertTask(String title) async {
    final dbClient = await database;
    return await dbClient.insert("tasks", {"title": title});
  }
}
