# cool_ui [![pub package](https://img.shields.io/pub/v/cool_ui.svg)](https://pub.dartlang.org/packages/cool_ui)

用flutter实现一些我认为好看的UI控件,有觉得好看的UI控件可以提出来,我会考虑实现,

Usage
Add this to your package's pubspec.yaml file:
``` yaml
dependencies:
  cool_ui: "^0.0.9"
```

## CupertinoPopover
仿iOS的UIPopover

![Image text](./images/popover_demo.gif)

#### 案例核心代码
```dart
CupertinoPopoverButton(
        child: Container(
          margin: EdgeInsets.all(20.0),
          width: 80.0,
          height: 40.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 5.0)]
          ),
          child: Center(child:Text('左上角')),
        ),
        popoverBody:Container(
          width: 100.0,
          height: 100.0,
          child: Text('左上角内容'),
        ),
        popoverWidth: 100.0,
        popoverHeight: 100.0);
```
## CupertinoPopoverMenuList,CupertinoPopoverMenuItem
用于快速搭建一个弹出的菜单项

#### 案例核心代码
```dart
    CupertinoPopoverMenuList(
                    children: <Widget>[
                      CupertinoPopoverMenuItem(leading: Icon(Icons.add),child: Text("新增"),),
                      CupertinoPopoverMenuItem(leading: Icon(Icons.edit),child: Text("修改"),),
                      CupertinoPopoverMenuItem(leading: Icon(Icons.delete),child: Text("删除"),)
                    ],
                  )
```
