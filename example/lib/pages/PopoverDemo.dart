import 'package:cool_ui_example/cool_u_i_example_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cool_ui/cool_ui.dart';

class PopoverDemo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PopoverDemoState();
  }

}

class PopoverDemoState extends State<PopoverDemo>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Popover Demo"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildPopoverButton("左上角","左上角内容"),
              _buildPopoverButton("右上角","右上角内容")
            ],
          ),
          Center(
              child:_buildPopoverButton("中间","中间内容")
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildPopoverButton("左下角","左下角内容"),
              _buildPopoverButton("右下角","右下角内容")
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPopoverButton(String btnTitle,String bodyMessage){
    return CupertinoPopoverButton(
        child: Container(
          margin: EdgeInsets.all(20.0),
          width: 80.0,
          height: 40.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 5.0)]
          ),
          child: Center(child:Text(btnTitle)),
        ),
        popoverBody:Container(
//                    color: Colors.lightBlue,
          width: 100.0,
          height: 100.0,
          child: Text(bodyMessage),
        ),
        popoverWidth: 100.0,
        popoverHeight: 100.0);
  }
}