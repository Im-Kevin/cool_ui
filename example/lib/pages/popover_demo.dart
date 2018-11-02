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
              _buildPopoverButton("中间上方","中间上方内容"),
              _buildPopoverButton("右上角","右上角内容")
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children:<Widget>[
                _buildPopoverButton("中间左方","中间左方内容"),
                _buildPopoverButton("正中间","正中间内容"),
                _buildPopoverButton("中间左方","中间左方内容")
              ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildPopoverButton("左下角","左下角内容"),
              _buildPopoverButton("中间下方","中间下方内容"),
              _buildPopoverButton("右下角","右下角内容")
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPopoverButton(String btnTitle,String bodyMessage){
    return Padding(
        padding:  EdgeInsets.all(20.0),
        child:CupertinoPopoverButton(

            child: Container(
              width: 80.0,
              height: 40.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 5.0)]
              ),
              child: Center(child:Text(btnTitle)),
            ),
            popoverBuild: (context) {
              return CupertinoPopoverMenuList(
                children: <Widget>[
                  CupertinoPopoverMenuItem(leading: Icon(Icons.add),child: Text("新增"),),
                  CupertinoPopoverMenuItem(leading: Icon(Icons.edit),child: Text("修改"),),
                  CupertinoPopoverMenuItem(leading: Icon(Icons.delete),child: Text("删除"),)
                ],
              );
            },
            popoverWidth: 150.0,
            popoverHeight: 123.0)

    );

  }
}