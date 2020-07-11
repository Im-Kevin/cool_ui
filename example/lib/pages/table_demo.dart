import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cool_ui/cool_ui.dart';


class TableDemo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TableDemoState();
  }

}

class TableDemoState extends State<TableDemo>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Table Demo"),
        ),
        body: CoolTable()
    );
  }

}