import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/Expense_Model.dart';
import '../Models/Budgets.dart';

class DBHelper {
  static const _dbName = 'expenses.db';
  static const _dbVersion = 2; // updated version for budget table
  static const _table = 'expenses';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ----------------------------- CREATE TABLES -----------------------------
  Future _onCreate(Database db, int version) async {
    // Expense table
    await db.execute('''
      CREATE TABLE $_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        notes TEXT,
        type TEXT NOT NULL
      )
    ''');

    // Budget table
    await db.execute('''
      CREATE TABLE budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        limitAmount REAL NOT NULL,
        spent REAL NOT NULL
      )
    ''');
  }

  // ----------------------------- UPGRADE HANDLER -----------------------------
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS budgets (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          category TEXT NOT NULL,
          limitAmount REAL NOT NULL,
          spent REAL NOT NULL
        )
      ''');
    }
  }

  // ----------------------------- EXPENSE CRUD -----------------------------
  Future<int> insertExpense(Expense e) async {
    final db = await database;
    return await db.insert(_table, e.toMap());
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final maps = await db.query(_table, orderBy: 'date DESC, id DESC');
    return maps.map((m) => Expense.fromMap(m)).toList();
  }

  Future<List<Expense>> getExpensesByDate(String date) async {
    final db = await database;
    final maps = await db.query(_table, where: 'date = ?', whereArgs: [date]);
    return maps.map((m) => Expense.fromMap(m)).toList();
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateExpense(Expense e) async {
    final db = await database;
    return db.update(
      _table,
      e.toMap(),
      where: 'id = ?',
      whereArgs: [e.id],
    );
  }

  // ----------------------------- AGGREGATION -----------------------------
  Future<double> getTotalByType(String type) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM $_table WHERE type = ?',
      [type],
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }

  Future<Map<String, double>> getMonthlyExpenses() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT strftime('%Y-%m', date) AS month, SUM(amount) as total
      FROM expenses
      WHERE type = 'expense'
      GROUP BY month
      ORDER BY month ASC
    ''');

    Map<String, double> data = {};
    for (var row in result) {
      data[row['month'] as String] = (row['total'] as num).toDouble();
    }
    return data;
  }

  // ----------------------------- BUDGET CRUD -----------------------------
  Future<int> insertBudget(Budget budget) async {
    final db = await database;
    return await db.insert(
      'budgets',
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Budget>> getAllBudgets() async {
    final db = await database;
    final result = await db.query('budgets');
    return result.map((e) => Budget.fromMap(e)).toList();
  }

  // ----------------------------- UPDATE BUDGET SPENT -----------------------------
  Future<void> updateBudgetSpent(String category, double amount) async {
    final db = await database;

    final result = await db.query(
      'budgets',
      where: 'category = ?',
      whereArgs: [category],
    );

    if (result.isNotEmpty) {
      final current = Budget.fromMap(result.first);
      await db.update(
        'budgets',
        {'spent': current.spent + amount},
        where: 'id = ?',
        whereArgs: [current.id],
      );
    }
  }
}
