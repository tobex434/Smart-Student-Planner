import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'task.dart';
import 'user.dart';

/// This class handles all local SQLite database operations for the app.
/// It follows the Singleton pattern to ensure only one database connection exists.
class DatabaseHelper {
  /// The single, global instance of DatabaseHelper.
  static final DatabaseHelper instance = DatabaseHelper._init();

  /// The internal database object, initially null.
  static Database? _database;

  /// Private constructor ensures no other instances are created elsewhere.
  DatabaseHelper._init();

  /// Getter that returns the active database connection.
  /// If the database isn't open yet, it triggers the initialization.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('smartstudentplanner.db');
    return _database!;
  }

  /// Finds the correct file path for the database and opens it.
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Runs the first time the app is launched to build the table structure.
  Future<void> _createDB(Database db, int version) async {
    // tasks table
    await db.execute('''
      CREATE TABLE tasks (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        userId      INTEGER NOT NULL,
        title       TEXT    NOT NULL,
        description TEXT    NOT NULL,
        priority    TEXT    NOT NULL,
        deadline    TEXT,
        modules     TEXT    NOT NULL,
        reminders   INTEGER NOT NULL DEFAULT 1,
        isComplete  INTEGER NOT NULL DEFAULT 0,
        createdAt   TEXT    NOT NULL
      )
    ''');

    // users table
    await db.execute('''
      CREATE TABLE users (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        name     TEXT    NOT NULL,
        email    TEXT    NOT NULL UNIQUE,
        password TEXT    NOT NULL,
        course   TEXT    NOT NULL DEFAULT ''
      )
    ''');
  }

  // CREATE OPERATIONS

  /// Converts a Task object to a Map and saves it into the 'tasks' table.
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ OPERATIONS

  /// Fetches every task from the table and converts the raw data back into Task objects.
  Future<List<Task>> getAllTasks(int userId) async {
    final db = await database;
    final rows = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    return rows.map((row) => Task.fromMap(row)).toList();
  }

  /// Filters for incomplete tasks where the deadline matches today's date.
  Future<List<Task>> getTasksDueToday(int userId) async {
    final db = await database;
    final today = DateTime.now();
    final datePrefix =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final rows = await db.query(
      'tasks',
      where: 'userId = ? AND deadline LIKE ? AND isComplete = 0',
      whereArgs: [userId, '$datePrefix%'],
      orderBy: 'deadline ASC',
    );
    return rows.map((row) => Task.fromMap(row)).toList();
  }

  // returns only completed tasks
  Future<List<Task>> getCompletedTasks(int userId) async {
    final db = await database;
    final rows = await db.query(
      'tasks',
      where: 'userId = ? AND isComplete = 1',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    return rows.map((row) => Task.fromMap(row)).toList();
  }

  /// Searches for tasks by checking if the title or description contains the search term.
  Future<List<Task>> searchTasks(int userId, String keyword) async {
    final db = await database;
    final rows = await db.query(
      'tasks',
      where: 'userId = ? AND (title LIKE ? OR description LIKE ?)',
      whereArgs: [userId, '%$keyword%', '%$keyword%'],
      orderBy: 'createdAt DESC',
    );
    return rows.map((row) => Task.fromMap(row)).toList();
  }

  // UPDATE OPERATIONS

  /// Updates an existing task record using its unique ID as the reference.
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  /// Efficiently updates only the completion status of a task.
  Future<int> toggleComplete(int id, bool isComplete) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'isComplete': isComplete ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE OPERATIONS

  /// Permanently removes a task from the database by ID.
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // ANALYTICS AND UTILITIES

  /// Returns the total count of all tasks for use in dashboard widgets.
  Future<int> getTaskCount(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE userId = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getCompletedCount(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE userId = ? AND isComplete = 1',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Closes the database connection to free up resources when the app is terminated.
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  //
  // USER METHODS
  //

  // inserts a new user 
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // finds a user by email 
  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }

  // checks if any user exists 
  Future<bool> hasAnyUser() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM users');
    final count = Sqflite.firstIntValue(result) ?? 0;
    return count > 0;
  }

  //  updates user profile fields
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}
