import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Models/Models.dart';

class DbHelper {
  static const _dbName = "notes.db";
  static const _version = 1;
  static const _table = "notes";

  DbHelper._internal();
  static final DbHelper instance = DbHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, _dbName);

    return openDatabase(
      dbPath,
      version: _version,
      onCreate: _onCreate,
    );
  }

  /// 🧱 CREATE TABLE (FULL & MATCHING WITH MODEL)
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        color INTEGER NOT NULL,
        isPinned INTEGER NOT NULL DEFAULT 0,
        isArchived INTEGER NOT NULL DEFAULT 0,
        isTrashed INTEGER NOT NULL DEFAULT 0,
        date TEXT NOT NULL,
        trashDate TEXT
      )
    ''');
  }

  /// ➕ INSERT NOTE
  Future<int> insertNote(NoteModel note) async {
    final db = await database;
    return await db.insert(_table, note.toMap());
  }

  /// 🏠 HOME NOTES
  Future<List<NoteModel>> getAllNotes() async {
    final db = await database;
    final result = await db.query(
      _table,
      where: 'isArchived = ? AND isTrashed = ?',
      whereArgs: [0, 0],
      orderBy: 'isPinned DESC, id DESC',
    );
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  /// 📌 PIN / UNPIN
  Future<void> togglePin(int id, bool value) async {
    final db = await database;
    await db.update(
      _table,
      {'isPinned': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 🗄️ ARCHIVE / UNARCHIVE
  Future<void> toggleArchive(int id, bool value) async {
    final db = await database;
    await db.update(
      _table,
      {'isArchived': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 🗑️ MOVE TO TRASH / RESTORE
  Future<void> toggleTrash(int id, bool value) async {
    final db = await database;
    await db.update(
      _table,
      {
        'isTrashed': value ? 1 : 0,
        'trashDate': value ? DateTime.now().toIso8601String() : null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 🗂️ ARCHIVED NOTES
  Future<List<NoteModel>> getArchivedNotes() async {
    final db = await database;
    final result = await db.query(
      _table,
      where: 'isArchived = ? AND isTrashed = ?',
      whereArgs: [1, 0],
      orderBy: 'isPinned DESC, id DESC',
    );
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  /// 🗑️ TRASH NOTES
  Future<List<NoteModel>> getTrashNotes() async {
    final db = await database;
    final result = await db.query(
      _table,
      where: 'isTrashed = ?',
      whereArgs: [1],
      orderBy: 'trashDate DESC',
    );
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  /// ❌ DELETE PERMANENTLY
  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(
      _table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<List<NoteModel>> searchNotes(String query) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: '''
      (title LIKE ? OR content LIKE ?)
      AND isTrashed = 0
    ''',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'isPinned DESC, date DESC',
    );

    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

}
