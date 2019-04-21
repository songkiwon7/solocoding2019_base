import 'package:flutter/material.dart';
import 'package:solocoding2019_base/bloc/bloc_provider.dart';
import 'package:solocoding2019_base/pages/home/home.dart';
import 'package:solocoding2019_base/pages/home/home_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.orange, primaryColor: Colors.pinkAccent),
      home: BlocProvider(
          child: HomePage(),
          bloc: HomeBloc(),
      ));
  }
}