import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cool_ui/cool_ui.dart';


class PaintEventDemo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PaintEventDemoState();
  }

}

class PaintEventDemoState extends State<PaintEventDemo>{
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
            FlatButton(onPressed: (){
              setState((){
                isPaintBackgroud = !isPaintBackgroud;
              });
            }, child: Text(isPaintBackgroud?"渲染前填充颜色":"渲染后填充颜色")),
            PaintEvent(
              child: Text("子Widget文字"),
              paintAfter: (context,offset,size){
                if(!isPaintBackgroud){
                  final Paint paint = Paint();
                  paint.color = Colors.red;
                  context.canvas.drawRect(offset&size, paint);
                }
              },paintBefore: (context,offset,size){
              if(isPaintBackgroud){
                final Paint paint = Paint();
                paint.color = Colors.red;
                context.canvas.drawRect(offset&size, paint);
              }
            },
            )
          ],
        )
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