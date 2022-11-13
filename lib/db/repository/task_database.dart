import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_list/db/model/task_model.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  TaskDatabase();

  static Database? _database;
  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const stringType = "TEXT NOT NULL";
    const descriptionType = "TEXT";
    await db.execute(''' 
    CREATE TABLE $tableTask (
     ${TaskFields.id} $idType,
     ${TaskFields.title} $stringType,
     ${TaskFields.description} $descriptionType,
     ${TaskFields.duration} $stringType,
     ${TaskFields.status} $stringType
    )
    ''');
  }

  Future<TaskModel> create(TaskModel task) async {
    final db = await instance.database;

    final id = await db.insert(tableTask, task.toJson());

    print(id);

    return task.copy(id: id);
  }

  Future<TaskModel> getTask(id) async {
    final db = await instance.database;

    final task = await db.query(
      tableTask,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );

    debugPrint(task.toString());

    if (task.isNotEmpty) {
      return TaskModel.fromJson(task.first);
    } else {
      throw Exception('Task Not Found');
    }
  }

  Future<List<TaskModel>> getAllTask() async {
    final db = await instance.database;

    final tasks = await db.query(
      tableTask,
    );
    debugPrint(tasks.toString());

    if (tasks.isNotEmpty) {
      return tasks.map((e) => TaskModel.fromJson(e)).toList();
    } else {
      throw Exception('No Tasks Found');
    }
  }

  Future updateTask(TaskModel task) async {
    final db = await instance.database;
    await db.update(
      tableTask,
      task.toJson(),
      where: '${TaskFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future delete(int id) async {
    final db = await instance.database;
    await db.delete(
      tableTask,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
