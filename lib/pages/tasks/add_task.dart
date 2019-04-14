import 'package:flutter/material.dart';
import 'package:solocoding2019_base/db/dbHelper.dart';
import 'package:solocoding2019_base/models/Tasks.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddTaskState();
}

DateTime now = DateTime.now();

class _AddTaskState extends State<AddTaskScreen> {

  TextEditingController txtTitle = new TextEditingController();
  String validateText = "";

  DbHelper dbHelper = new DbHelper();
  String createDate = "${now.day}.${now.month}.${now.year}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtTitle,
              decoration: InputDecoration(labelText: "할 일을 입력하세요."),
            ),
            Divider(
              color: Colors.white,
              height: 20.0,
            ),
            Text("$validateText", style: TextStyle(color: Colors.red),),
            ButtonTheme(
              minWidth: 200.0,
              height: 50.0,
              child: RaisedButton(
                child: Text("확인"),
                textColor: Colors.white,
                color: Colors.blue,
                elevation: 4.0,
                splashColor: Colors.blueGrey,
                onPressed: () {
                  save();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void save() async {
    if (txtTitle.text.length >= 2 && txtTitle.text.length <= 30) {
      int result = await dbHelper.insert(Tasks(txtTitle.text, createDate, "completed"));
      validateText = '';
      if (result != 0) {
        Navigator.pop(context, true);
      }
    } else {
      setState(() {
        validateText = '필수 입력 항목입니다.';
      });
    }
  }

}