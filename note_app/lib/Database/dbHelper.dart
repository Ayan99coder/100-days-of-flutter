import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Model/note_model.dart';

class DbHelper {
  static const _dbName = "note.db";
  static const _version = 1;
  static const _table = "notes";

  static final DbHelper instance = DbHelper._internal();
  static Database? _db;

  DbHelper._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initdb();
    return _db!;
  }

  Future<Database> _initdb() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, _dbName);
    return await openDatabase(path, version: _version, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_table(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      color INTEGER NOT NULL,
      isPinned INTEGER NOT NULL,
      date TEXT NOT NULL
    )
  ''');
  }

  Future<int> insertNote(NoteModel note) async {
    final db = await database;
    return await db.insert(_table, note.toMap());
  }

  Future<List<NoteModel>> getAllNotes() async {
    final db = await database;
    final result = await db.query(_table, orderBy: 'isPinned DESC, id DESC');
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await database;
    return db.update(
      _table,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> togglePin(int id, bool newPinValue) async {
    final db = await database;
    await db.update(
      'notes',
      {'isPinned': newPinValue ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
