import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cool_ui/cool_ui.dart';

class WeuiToastDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WeuiToastDemoState();
  }
}

class WeuiToastDemoState extends State<WeuiToastDemo> {
  bool isPaintBackgroud = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("WeuiToast Demo"),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 72.0),
          children: <Widget>[
            MaterialButton(
              color: Colors.blue[400],
              child: Text(
                "成功",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => showWeuiSuccessToast(context: context),
            ),
            MaterialButton(
              color: Colors.blue[400],
              child: Text(
                "加载中",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                var hide = showWeuiLoadingToast(context: context);
                Future.delayed(Duration(seconds: 5), () {
                  hide();
                });
              },
            ),
          ].map((Widget button) {
            return Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: button);
          }).toList(),
        ));
  }
}
