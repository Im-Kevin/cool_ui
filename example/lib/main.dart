import 'package:cool_ui_example/cool_u_i_example_icons.dart';
import 'package:cool_ui_example/pages/custom_keyboard.dart';
import 'package:cool_ui_example/pages/paint_event_demo.dart';
import 'package:cool_ui_example/pages/popover_demo.dart';
import 'package:cool_ui_example/pages/weui_toast_demo.dart';
import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/material.dart';

import 'keyboards/test_keyboard.dart';

void main(){
  NumberKeyboard.register();
  TestKeyboard.register();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WeuiToastConfig(
      data: WeuiToastConfigData(
        successText: '测试ConfigData'
      ),
      child:MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.blue
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page')
    ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return  Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(CoolUIExampleIcon.popover),
              title: Text("Popover"),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PopoverDemo()));
              },
            ),
            ListTile(
              title: Text("PaintEvent"),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PaintEventDemo()));
              },
            ),
            ListTile(
              title: Text("WeuiToastEvent"),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WeuiToastDemo()));
              },
            ),
            ListTile(
              title: Text("CustomKeyboardEvent"),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CustomKeyboardDemo()));
              },
            )
          ],
        )
    );
  }
}
