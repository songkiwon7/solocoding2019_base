import 'dart:async';

import 'package:solocoding2019_base/models/priority.dart';
import 'package:solocoding2019_base/bloc/bloc_provider.dart';
import 'package:solocoding2019_base/pages/tasks/task_db.dart';
import 'package:solocoding2019_base/pages/tasks/models/tasks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class AddTaskBloc implements BlocBase {

  final TaskDB _taskDB;
  Status lastPrioritySelection = Status.PRIORITY_4;

  AddTaskBloc(this._taskDB) {
    updateDueDate(DateTime.now().millisecondsSinceEpoch);
    _prioritySelected.add(lastPrioritySelection);
  }

  BehaviorSubject<int> _dueDateSelected = BehaviorSubject<int>();

  Stream<int> get duDateSelected => _dueDateSelected;

  BehaviorSubject<Status> _prioritySelected = BehaviorSubject<Status>();

  Stream<Status> get prioritySelected => _prioritySelected;

  String updateTitle = "";

  @override
  void dispose() {
    _dueDateSelected.close();
    _prioritySelected.close();
  }

  Observable<String> createTask() {
    return Observable.zip2(duDateSelected, prioritySelected,
            (int duDateSelected, Status status) {
      var task = Tasks.create(
          title: updateTitle,
          dueDate: duDateSelected,
          priority: status);
      _taskDB.updateTask(task).then((value) {
        Notification.onDone();
      });
    });
  }

  void updatePriority(Status priority) {
    _prioritySelected.add(priority);
  }

  void updateDueDate(int millisecondsSinceEpoch) {
    _dueDateSelected.add(millisecondsSinceEpoch);
  }

}