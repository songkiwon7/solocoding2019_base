import 'package:flutter/material.dart';
import 'package:solocoding2019_base/utils/app_constant.dart';

class MessageInCenterWidget extends StatelessWidget {
  final String _message;

  MessageInCenterWidget(this._message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_message,
        style: TextStyle(fontSize: FONT_MEDIUM, color: Colors.black
      ),),
    );
  }
}