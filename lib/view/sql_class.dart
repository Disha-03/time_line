import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:timeline_demo/view/model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE tasks (
          id INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT,
          status TEXT,
          timeSpent INTEGER
        )
      ''');

        await db.execute('''
        CREATE TABLE comments (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          taskId INTEGER,
          text TEXT,
          timestamp TEXT,
          FOREIGN KEY (taskId) REFERENCES tasks (id)
        )
      ''');
      },
    );
  }
  Future<int> updateTaskStatus(int taskId, String status) async {
    Database? db = await instance.database;
    return await db!.update(
      'tasks',
      {'status': status},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
  Future<int> addTask(Task user) async {
    int userId = 0;
    Database db = await _initDatabase();
    await db.insert("tasks", user.toMap()).then((value) {
      userId = value;

      userId = value;
    });
    return userId;
  }

  Future<List<Task>> getTasksByStatus(String status) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = await db!.query(
      'tasks',
      where: 'status = ?',
      whereArgs: [status],
    );
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<int> addComment(int taskId, Comment comment) async {
    Database? db = await instance.database;
    return await db!.insert('comments', comment.toMap());
  }

  Future<List<Comment>> getComments(int taskId) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = await db!.query(
      'comments',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
    return List.generate(maps.length, (i) {
      return Comment.fromMap(maps[i]);
    });
  }
}