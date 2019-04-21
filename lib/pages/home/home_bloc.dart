import 'dart:async';
import 'package:solocoding2019_base/bloc/bloc_provider.dart';
import 'package:solocoding2019_base/pages/tasks/bloc/task_bloc.dart';

class HomeBloc implements BlocBase {
  StreamController<String> _titleController =
      StreamController<String>.broadcast();

  Stream<String> get title => _titleController.stream;

  StreamController<Filter> _filterController =
      StreamController<Filter>.broadcast();

  Stream<Filter> get filter => _filterController.stream;

  @override
  void dispose() {
    _titleController.close();
    _filterController.close();
  }

  void updateTitle(String title) {
    _titleController.sink.add(title);
  }

  void applyFilter(String title, Filter filter) {
    _filterController.sink.add(filter);
    updateTitle(title);
  }
}