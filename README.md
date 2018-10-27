# cool_ui

用flutter实现一些我认为好看的UI控件,有觉得好看的UI控件可以提出来,我会考虑实现,

Usage
Add this to your package's pubspec.yaml file:
``` yaml
dependencies:
  cool_ui: "^0.0.8"
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
  }
```
