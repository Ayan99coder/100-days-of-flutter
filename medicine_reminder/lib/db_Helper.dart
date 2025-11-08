import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Pateint_Model.dart';

class DBHelper {
  static const _dbName = 'medicine.db';
  static const _dbVersion = 1;
  static const _tableName = 'medicines';

  static final DBHelper instance = DBHelper._privateConstructor();

  DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        dosage TEXT,
        time TEXT,
        note TEXT
      )
    ''');
  }

  // 🔹 Insert Data
  Future<int> insertMedicine(Medicine medicine) async {
    final db = await database;
    return await db.insert(_tableName, medicine.toMap());
  }

  // 🔹 Get All Data
  Future<List<Medicine>> getAllMedicines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return maps.map((map) => Medicine.fromMap(map)).toList();
  }

  // 🔹 Delete by ID
  Future<int> deleteMedicine(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
