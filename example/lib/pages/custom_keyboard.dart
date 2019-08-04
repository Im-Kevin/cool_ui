import 'package:cool_ui_example/keyboards/test_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cool_ui/cool_ui.dart';


class CustomKeyboardDemo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomKeyboardDemoState();
  }

}

class CustomKeyboardDemoState extends State<CustomKeyboardDemo>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return KeyboardMediaQuery(
        child: Builder(builder: (ctx) {
          CoolKeyboard.init(ctx);
          return Scaffold(
              appBar: AppBar(
                title: Text("Custom Keyboard Demo"),
              ),
              body: ListView(
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.text,
                  ),
                  Container(
                    height: 300.0,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '演示键盘弹出后滚动'),
                    keyboardType: NumberKeyboard.inputType,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '多个键盘演示'),
                    keyboardType: TestKeyboard.inputType,
                  )
                ],
              )
          );
        })
    );
  }
}