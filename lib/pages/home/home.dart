import 'package:flutter/material.dart';
import 'package:solocoding2019_base/bloc/bloc_provider.dart';
import 'package:solocoding2019_base/pages/home/home_bloc.dart';
import 'package:solocoding2019_base/pages/tasks/task_db.dart';
import 'package:solocoding2019_base/pages/tasks/bloc/task_bloc.dart';
import 'package:solocoding2019_base/pages/tasks/task_widgets.dart';
import 'package:solocoding2019_base/pages/tasks/add_task.dart';
import 'package:solocoding2019_base/pages/tasks/bloc/add_task_bloc.dart';

class HomePage extends StatelessWidget {
  final TaskBloc _taskBloc = TaskBloc(TaskDB.get())
;
  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = BlocProvider.of(context);
    homeBloc.filter.listen((filter) {
      _taskBloc.updateFilters(filter);
    });
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          initialData: 'All Tasks',
          stream: homeBloc.title,
          builder: (context, snapshot) {
            return Text(snapshot.data);
          }),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add, color: Colors.white, size: 28.0,
            ),
            onPressed: () async {
              var blocProviderAddTask = BlocProvider(
                  child: AddTaskScreen(),
                  bloc: AddTaskBloc(TaskDB.get()));
              await Navigator.push(
                  context,
                  MaterialPageRoute<bool>(builder: (context) => blocProviderAddTask));
              _taskBloc.refresh();
            },
          )
        ],
      ),
      body: BlocProvider(
          child: TaskPage(),
          bloc: _taskBloc
      ),
    );
  }

}

