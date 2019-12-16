import 'package:cool_ui_example/keyboards/test_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/services.dart';

class CustomKeyboardDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomKeyboardDemoState();
  }
}

class CustomKeyboardDemoState extends State<CustomKeyboardDemo> {
  TextEditingController textEditingController =
      TextEditingController(text: 'test');
  TextEditingController textEditing2Controller =
      TextEditingController(text: 'test');

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return KeyboardMediaQuery(child: Builder(builder: (ctx) {
      // CoolKeyboard.init(ctx);
      return Scaffold(
          appBar: AppBar(
            title: Text("Custom Keyboard Demo"),
          ),
          body: ListView(
            children: <Widget>[
              TextField(
                controller: textEditingController,
                keyboardType: TextInputType.text,
              ),
              Container(
                height: 300.0,
              ),
              FlatButton(
                child: Text('弹出功能演示'),
                onPressed: (){
                  showInputDialogs(
                    context: context,messageWidget: Text('弹出输入功能演示'),
                    keyboardType: NumberKeyboard.inputType
                  );
                },
              ),
              TextField(
                controller: textEditing2Controller,
                decoration: InputDecoration(labelText: '演示键盘弹出后滚动'),
                keyboardType: NumberKeyboard.inputType,
              ),
              TextField(
                decoration: InputDecoration(labelText: '多个键盘演示'),
                keyboardType: TestKeyboard.inputType,
              )
            ],
          ));
    }));
  }

  static Future<String> showInputDialogs(
      {@required BuildContext context,
      Widget titleWidget,
      Widget messageWidget,
      List<TextInputFormatter> inputFormatters,
      TextInputType keyboardType = TextInputType.number}) {
    String value;
    return showCupertinoDialog<String>(
        context: context,
        builder: (context) {
//       The minimum insets for contents of the Scaffold to keep visible.
          List<Widget> children = [];
          if (messageWidget != null) {
            children.add(messageWidget);
          }
          children.add(Form(
              child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Material(
                      child: TextField(
                    inputFormatters: inputFormatters,
                    keyboardType: keyboardType,
                    autofocus: true,
                    onChanged: (newValue) {
                      value = newValue;
                    },
                  )))));
          return AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets +
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
              duration: const Duration(milliseconds: 300),
              // curve: Curves.linear,
              child: CupertinoAlertDialog(
                title: titleWidget,
                content: Column(
                  children: children,
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text("取消"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text("確認"),
                    onPressed: () {
                      Navigator.of(context).pop(value ?? '');
                    },
                  )
                ],
              ));
        });
  }
}
