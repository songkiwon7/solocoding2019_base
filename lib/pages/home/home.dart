import 'package:flutter/material.dart';
import 'package:solocoding2019_base/db/dbHelper.dart';
import 'package:solocoding2019_base/models/Tasks.dart';
import 'package:solocoding2019_base/pages/tasks/add_task.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  DbHelper dbHelper = new DbHelper();
  List<Tasks> tasks;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (tasks == null) {
      tasks = new List<Tasks>();
      getData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: (){
              goToAdd();
            },
          )
        ],
      ),
      body: mainCenter(taskListItems(), count),
    );
  }

  Container mainCenter(ListView listView, int count){
    if(count == 0){
      return Container(
        alignment: Alignment.center,
        child: Text("Empty Task", textAlign: TextAlign.center,style: TextStyle(fontSize: 20.0),),
      );
    }else{
      return Container(
        child: listView,
      );
    }
  }

  ListView taskListItems(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: Icon(Icons.adjust),
            title: Text(this.tasks[position].title),
            subtitle: Text(this.tasks[position].date),
            onTap: (){
              print('onTap');
            },
          ),
        );
      },
    );
  }

  void getData(){
    var dbFuture = dbHelper.initializeDb();
    dbFuture.then((result){
      var listFuture = dbHelper.getTasks();
      listFuture.then((data){
        List<Tasks> taskList = new List<Tasks>();
        count = data.length;

        for (var i = 0; i < count; i++) {
          taskList.add(Tasks.fromObject(data[i]));
        }

        setState(() {
          tasks = taskList;
          count = count;
        });

      });
    });
  }

  void goToAdd() async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen()));
    if (result != null) {
      getData();
    }
  }
}