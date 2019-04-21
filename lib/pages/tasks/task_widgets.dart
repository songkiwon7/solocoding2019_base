import 'package:flutter/material.dart';
import 'package:solocoding2019_base/bloc/bloc_provider.dart';
import 'package:solocoding2019_base/pages/tasks/bloc/task_bloc.dart';
import 'package:solocoding2019_base/pages/tasks/models/tasks.dart';
import 'package:solocoding2019_base/pages/tasks/row_task.dart';
import 'package:solocoding2019_base/utils/app_util.dart';

class TaskPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final TaskBloc _taskBloc = BlocProvider.of(context);
    return StreamBuilder<List<Tasks>>(
      stream: _taskBloc.tasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildTaskList(snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildTaskList(List<Tasks> list) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: list.length == 0
      ? MessageInCenterWidget("No Task Added")
      : Container(
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: ObjectKey(list[index]),
                onDismissed: (DismissDirection direction) {
                  var taskID = list[index].id;
                  final TaskBloc _taskBloc = 
                      BlocProvider.of<TaskBloc>(context);
                  String message = "";
                  if (direction == DismissDirection.endToStart) {
                    _taskBloc.updateStatus(
                        taskID, TaskStatus.COMPLETE);
                    message = "Task completed";
                  } else {
                    _taskBloc.delete(taskID);
                    message = "Task deleted";
                  }
                  SnackBar snackbar =
                      SnackBar(content: Text(message));
                  Scaffold.of(context).showSnackBar(snackbar);
                },
                background: Container(
                  color: Colors.red,
                  child: ListTile(
                    leading:
                      Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.green,
                  child: ListTile(
                    trailing:
                    Icon(Icons.check, color: Colors.white),
                  ),
                ),
                child: TaskRow(list[index]),
              );
            }),
      ),
    );
  }
}