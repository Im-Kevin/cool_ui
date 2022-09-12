import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cool_ui/cool_ui.dart';

class PaintEventDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PaintEventDemoState();
  }
}

class PaintEventDemoState extends State<PaintEventDemo> {
  bool isPaintBackgroud = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("PaintEvent Demo"),
        ),
        body: Row(
          children: <Widget>[
            MaterialButton(
                onPressed: () {
                  setState(() {
                    isPaintBackgroud = !isPaintBackgroud;
                  });
                },
                child: Text(isPaintBackgroud ? "渲染前填充颜色" : "渲染后填充颜色")),
            PaintEvent(
              child: Text("子Widget文字"),
              paintAfter: (context, offset, size) {
                if (!isPaintBackgroud) {
                  final Paint paint = Paint();
                  paint.color = Colors.red;
                  context.canvas.drawRect(offset & size, paint);
                }
              },
              paintBefore: (context, offset, size) {
                if (isPaintBackgroud) {
                  final Paint paint = Paint();
                  paint.color = Colors.red;
                  context.canvas.drawRect(offset & size, paint);
                }
              },
            )
          ],
        ));
  }
}
