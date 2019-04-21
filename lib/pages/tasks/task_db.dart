
import 'package:solocoding2019_base/db/app_db.dart';
import 'package:solocoding2019_base/pages/tasks/models/tasks.dart';

import 'package:sqflite/sqflite.dart';

class TaskDB {

  static final TaskDB _taskDB = TaskDB._internal(AppDataBase.get());

  AppDataBase _appDataBase;

  TaskDB._internal(this._appDataBase);

  static TaskDB get() {
    return _taskDB;
  }

  Future<List<Tasks>> getTasks(
      {int startDate = 0, endDate = 0, TaskStatus taskStatus}) async {
    var db = await _appDataBase.getDb();
    var whereClause = startDate > 0 && endDate > 0
        ? "WHERE ${Tasks.tblTask}.${Tasks.dbDueDate} BETWEEN $startDate AND $endDate"
        : "";

    if (taskStatus != null) {
      var taskWhereClause =
          "${Tasks.tblTask}.${Tasks.dbStatus} = ${taskStatus.index}";
      whereClause = whereClause.isEmpty
          ? "WHERE $taskWhereClause"
          : "$whereClause AND $taskWhereClause";
    }

    var result = await db.rawQuery(
        'SELECT ${Tasks.tblTask}.* '
            'FROM ${Tasks.tblTask} $whereClause '
            'ORDER BY ${Tasks.tblTask}.${Tasks.dbDueDate} ASC; ');

    return _bindDta(result);
  }

  List<Tasks> _bindDta(List<Map<String, dynamic>> result) {
    List<Tasks> tasks = List();
    for (Map<String, dynamic> item in result) {
      var myTask = Tasks.fromMap(item);
      tasks.add(myTask);
    }
    return tasks;
  }

  Future deleteTask(int taskID) async {
    var db = await _appDataBase.getDb();
    await db.transaction((Transaction txn) async {
      txn.rawDelete(
        'DELETE FROM ${Tasks.tblTask} WHERE ${Tasks.dbId}=$taskID; ');
    });
  }

  Future updateTaskStatus(int taskID, TaskStatus status) async {
    var db = await _appDataBase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawQuery(
        "UPDATE ${Tasks.tblTask} SET ${Tasks.dbStatus} = '${status.index}' WHERE ${Tasks.dbId} = '$taskID' ");
    });
  }
  
  Future updateTask(Tasks task) async {
    var db = await _appDataBase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawInsert('INSERT OR REPLACE INTO '
          '${Tasks.tblTask}(${Tasks.dbId},${Tasks.dbTitle},${Tasks.dbProjectID},${Tasks.dbComment},${Tasks.dbDueDate},${Tasks.dbPriority},${Tasks.dbStatus})'
          ' VALUES(${task.id}, "${task.title}", ${task.projectId},"${task.comment}", ${task.dueDate},${task.priority.index},${task.taskStatus.index})');
    });
  }

}