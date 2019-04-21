import 'package:meta/meta.dart';
import 'package:solocoding2019_base/models/priority.dart';

class Tasks {
  static final tblTask = "Tasks";
  static final dbId = "id";
  static final dbTitle = "title";
  static final dbComment = "comment";
  static final dbDueDate = "dueDate";
  static final dbPriority = "priority";
  static final dbStatus = "status";
  static final dbProjectID = "projectId";

  String title, comment, projectName;
  int id, dueDate, projectId, projectColor;
  Status priority;
  TaskStatus taskStatus;

  Tasks.create(
      {@required this.title,
        this.projectId,
        this.comment = "",
        this.dueDate = -1,
        this.priority = Status.PRIORITY_4}) {

    if (this.dueDate == -1) {
      this.dueDate = DateTime.now().millisecondsSinceEpoch;
    }
    this.taskStatus = TaskStatus.PENDING;
  }

  bool operator == (o) => o is Tasks && o.id == id;

  Tasks.update(
      {@required this.id,
        @required this.title,
        @required this.projectId,
        this.comment = "",
        this.dueDate = -1,
        this.priority = Status.PRIORITY_4,
        this.taskStatus = TaskStatus.PENDING}) {
    if (this.dueDate == -1) {
      this.dueDate = DateTime.now().millisecondsSinceEpoch;
    }
  }

  Tasks.fromMap(Map<String, dynamic> map)
      : this.update(
        id: map[dbId],
        title: map[dbTitle],
        projectId: map[dbProjectID],
        comment: map[dbComment],
        dueDate: map[dbDueDate],
        priority: Status.values[map[dbPriority]],
        taskStatus: TaskStatus.values[map[dbStatus]],
      );
}

enum TaskStatus {
  PENDING,
  COMPLETE,
}