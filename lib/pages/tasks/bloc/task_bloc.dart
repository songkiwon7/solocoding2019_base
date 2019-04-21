import 'dart:async';
import 'dart:collection';

import 'package:solocoding2019_base/bloc/bloc_provider.dart';
import 'package:solocoding2019_base/pages/tasks/task_db.dart';
import 'package:solocoding2019_base/pages/tasks/models/tasks.dart';

class TaskBloc implements BlocBase {

  StreamController<List<Tasks>> _taskController =
      StreamController<List<Tasks>>.broadcast();

  Stream<List<Tasks>> get tasks => _taskController.stream;

  StreamController<int> _cmdController = StreamController<int>.broadcast();

  TaskDB _taskDB;
  List<Tasks> _tasksList;
  Filter _lastFilterStatus;

  TaskBloc(this._taskDB) {
    filterByStatus(TaskStatus.PENDING);
    _cmdController.stream.listen((_) {
      _updateTaskStream(_tasksList);
    });
  }

  void _filterTask(int taskStartTime, int taskEndTime, TaskStatus status) {
    _taskDB
        .getTasks(
        startDate: taskStartTime, endDate: taskEndTime, taskStatus:  status)
        .then((tasks) {
      _updateTaskStream(tasks);
    });
  }

  void _updateTaskStream(List<Tasks> tasks) {
    _tasksList = tasks;
    _taskController.sink.add(UnmodifiableListView<Tasks>(_tasksList));
  }

  @override
  void dispose() {
    _taskController.close();
    _cmdController.close();
  }

  void filterTodayTasks() {
    final dateTime = DateTime.now();
    final int taskStartTime =
        DateTime(dateTime.year, dateTime.month, dateTime.day)
            .millisecondsSinceEpoch;
    final int taskEndTime =
        DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59)
            .millisecondsSinceEpoch;

    _filterTask(taskStartTime, taskEndTime, TaskStatus.PENDING);
    _lastFilterStatus = Filter.byToday();
  }

  void filterTasksForNextWeek() {
    final dateTime = DateTime.now();
    final int taskStartTime =
        DateTime(dateTime.year, dateTime.month, dateTime.day)
            .millisecondsSinceEpoch;
    final int taskEndTime =
        DateTime(dateTime.year, dateTime.month, dateTime.day + 7, 23, 59)
            .millisecondsSinceEpoch;

    _filterTask(taskStartTime, taskEndTime, TaskStatus.PENDING);
    _lastFilterStatus = Filter.byNextWeek();
  }

  void filterByStatus(TaskStatus status) {
    _taskDB.getTasks(taskStatus: status).then((tasks) {
      if (tasks == null) return;
      _lastFilterStatus = Filter.byStatus(status);
      _updateTaskStream(tasks);
    });
  }

  void updateStatus(int taskID, TaskStatus status) {
    _taskDB.updateTaskStatus(taskID, status).then((tasks) {
      refresh();
    });
  }

  void delete(int taskID) {
    _taskDB.deleteTask(taskID).then((value) {
      refresh();
    });
  }

  void refresh() {
    if (_lastFilterStatus != null) {
      switch (_lastFilterStatus.filterStatus) {
        case FILTER_STATUS.BY_TODAY:
          filterTodayTasks();
          break;
        case FILTER_STATUS.BY_WEEK:
          filterTasksForNextWeek();
          break;
        case FILTER_STATUS.BY_PROJECT:
          break;
        case FILTER_STATUS.BY_LABEL:
          break;
        case FILTER_STATUS.BY_STATUS:
          filterByStatus(_lastFilterStatus.status);
          break;
      }
    }
  }

  void updateFilters(Filter filter) {
    _lastFilterStatus = filter;
    refresh();
  }
}

enum FILTER_STATUS { BY_TODAY, BY_WEEK, BY_PROJECT, BY_LABEL, BY_STATUS }

class Filter {
  String labelName;
  int projectId;
  FILTER_STATUS filterStatus;
  TaskStatus status;

  Filter.byToday() {
    filterStatus = FILTER_STATUS.BY_TODAY;
  }

  Filter.byNextWeek() {
    filterStatus = FILTER_STATUS.BY_WEEK;
  }

  Filter.byProject(this.projectId) {
    filterStatus = FILTER_STATUS.BY_PROJECT;
  }

  Filter.byLabel(this.labelName) {
    filterStatus = FILTER_STATUS.BY_LABEL;
  }

  Filter.byStatus(this.status) {
    filterStatus = FILTER_STATUS.BY_STATUS;
  }
}