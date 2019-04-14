import 'package:flutter/material.dart';
import 'package:solocoding2019_base/pages/home/home.dart';
import 'package:solocoding2019_base/pages/tasks/add_task.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/add_task': (context) => AddTaskScreen(),
      },
    )
  );
}