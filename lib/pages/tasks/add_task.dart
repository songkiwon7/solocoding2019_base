import 'package:flutter/material.dart';
import 'package:solocoding2019_base/bloc/bloc_provider.dart';
import 'package:solocoding2019_base/pages/tasks/bloc/add_task_bloc.dart';
import 'package:solocoding2019_base/utils/date_util.dart';
import 'package:solocoding2019_base/models/priority.dart';

class AddTaskScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldState =
      GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formState =
      GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AddTaskBloc createTaskBloc = BlocProvider.of(context);
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text("Add Task"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done, color: Colors.white, size: 28.0,
            ),
            onPressed: () {
              if (_formState.currentState.validate()) {
                _formState.currentState.save();
                createTaskBloc.createTask().listen((value) {
                  Navigator.pop(context, true);
                });
              }
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Form(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  var msg = value.isEmpty ? "Title Cannot be Empty" : null;
                  return msg;
                },
                onSaved: (value) {
                  createTaskBloc.updateTitle = value;
                },
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(hintText: "Title"),
              ),
            ),
            key: _formState,
          ),
//          ListTile(
//            leading: Icon(Icons.calendar_today),
//            title: Text("Due Date"),
//            subtitle: StreamBuilder(
//              stream: createTaskBloc.duDateSelected,
//              initialData: DateTime.now().millisecondsSinceEpoch,
//              builder: (context, snapshot) =>
//                  Text(getFormattedDate(snapshot.data)),
//            ),
//            onTap: () {
//
//            },
//          ),
//          ListTile(
//            leading: Icon(Icons.flag),
//            title: Text("Priority"),
//            subtitle: StreamBuilder(
//              stream: createTaskBloc.prioritySelected,
//              initialData: Status.PRIORITY_4,
//              builder: (context, snapshot) =>
//                  Text(priorityText[snapshot.data.index]),
//            ),
//            onTap: () {
//
//            },
//          ),
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.send, color: Colors.white),
//        onPressed: () {
//          if (_formState.currentState.validate()) {
//            _formState.currentState.save();
//            createTaskBloc.createTask().listen((value) {
//              Navigator.pop(context, true);
//            });
//          }
//        },
//      ),
    );
  }

}