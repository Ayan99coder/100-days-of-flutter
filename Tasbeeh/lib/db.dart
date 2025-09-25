import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDb {
  AppDb._();
  static final AppDb instance = AppDb._();

  Database? _db;
  Database get db => _db!;

  Future<void> init() async {
    if (_db != null) return;
    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = p.join(dir.path, 'dhikr.sqlite');
    _db = await openDatabase(
      path,
      version: 1,
      onConfigure: (d) async => d.execute('PRAGMA foreign_keys = ON;'),
      onCreate: (d, v) async {
        await d.execute('''
          CREATE TABLE settings(
            id INTEGER PRIMARY KEY CHECK(id = 1),
            haptics INTEGER NOT NULL DEFAULT 1,
            sound INTEGER NOT NULL DEFAULT 0,
            target INTEGER NOT NULL DEFAULT 100,
            default_dhikr TEXT NOT NULL DEFAULT 'SubhanAllah',
            theme_mode TEXT NOT NULL DEFAULT 'system'
          );
        ''');
        await d.insert('settings', {
          'id': 1,
          'haptics': 1,
          'sound': 0,
          'target': 100,
          'default_dhikr': 'SubhanAllah',
          'theme_mode': 'system',
        });

        await d.execute('''
          CREATE TABLE dhikr_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            count INTEGER NOT NULL DEFAULT 0
          );
        ''');

        await d.execute('''
          CREATE TABLE sessions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            duration_label TEXT,
            time_range TEXT,
            count INTEGER NOT NULL,
            created_at INTEGER NOT NULL
          );
        ''');

        // seed
        for (final e in const [
          {'name': 'SubhanAllah', 'count': 0},
          {'name': 'Alhamdulillah', 'count': 0},
          {'name': 'Allahu Akbar', 'count': 0},
          {'name': 'La ilaha illallah', 'count': 0},
          {'name': 'Astaghfirullah', 'count': 0},
        ]) {
          await d.insert('dhikr_items', e);
        }
      },
    );
  }

  // SETTINGS -------------------------
  Future<Map<String, Object?>> getSettings() async {
    final rows = await db.query('settings', where: 'id = 1');
    return rows.first;
  }

  Future<void> saveSettings({
    required bool haptics,
    required bool sound,
    required int target,
    required String defaultDhikr,
    required String themeMode, // 'light' | 'dark' | 'system'
  }) async {
    await db.update(
      'settings',
      {
        'haptics': haptics ? 1 : 0,
        'sound': sound ? 1 : 0,
        'target': target,
        'default_dhikr': defaultDhikr,
        'theme_mode': themeMode,
      },
      where: 'id = 1',
    );
  }

  // ITEMS ----------------------------
  Future<List<Map<String, Object?>>> getDhikrItems() async {
    return db.query('dhikr_items', orderBy: 'name ASC');
  }

  Future<void> upsertDhikrItem(String name, int count) async {
    await db.insert(
      'dhikr_items',
      {'name': name, 'count': count},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> incrementDhikrItem(String name, {int by = 1}) async {
    await db.rawUpdate(
      'UPDATE dhikr_items SET count = count + ? WHERE name = ?',
      [by, name],
    );
  }

  // SESSIONS -------------------------
  Future<void> addSession({
    required String title,
    String? durationLabel,
    String? timeRange,
    required int count,
  }) async {
    await db.insert('sessions', {
      'title': title,
      'duration_label': durationLabel,
      'time_range': timeRange,
      'count': count,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, Object?>>> getSessions() async {
    return db.query('sessions', orderBy: 'created_at DESC');
  }
}

String modeToString(ThemeMode m) =>
    m == ThemeMode.dark ? 'dark' : m == ThemeMode.light ? 'light' : 'system';
ThemeMode stringToMode(String s) =>
    s == 'dark' ? ThemeMode.dark : s == 'light' ? ThemeMode.light : ThemeMode.system;

/// Dummy to avoid importing material in db.dart’s top — small trick:
enum ThemeMode { system, light, dark }
