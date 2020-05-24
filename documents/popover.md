
## CupertinoPopoverButton
仿iOS的UIPopover效果的

用于弹窗的按钮
```dart
CupertinoPopoverButton({
    this.child,
    this.popoverBuild,
    this.popoverColor=Colors.white,
    this.popoverBoxShadow,
    @required this.popoverWidth,
    @required this.popoverHeight,
    BoxConstraints popoverConstraints,
    this.direction = CupertinoPopoverDirection.bottom,
    this.onTap,
    this.transitionDuration=const Duration(milliseconds: 200),
    this.barrierColor = Colors.black54,
    this.radius=8.0});
```


| Param | Type | Default | Description |
| --- | --- | --- | --- |
| child | <code>Widget</code> |  | 按钮的内容 |
| popoverBuild | <code>WidgetBuilder</code> |  | 生成弹出框的内容 |
| [popoverWidth] | <code>double</code> |  | 弹出框的宽度 |
| [popoverHeight] | <code>double</code> |  | 弹出框的高度 |
| [popoverConstraints] | <code>BoxConstraints</code> | maxHeight:123.0  maxWidth:150.0 | 弹出框的最大最小高宽|
| [direction] | <code>CupertinoPopoverDirection</code> | CupertinoPopoverDirection.bottom | 方向|
| [onTap] | <code>BoolCallback</code> |  | 按钮点击事件,返回true取消默认反应(不打开Popover) |
| [popoverColor] | <code>Color</code> | 白色 | 弹出框的背景颜色 |
| [popoverBoxShadow] | <code>BoxShadow</code> |  | 弹出框的阴影 |
| [barrierColor] | <code>Color</code> | Colors.black54 | 遮罩层的颜色,目前不允许设置透明,如需要透明则使用Color.fromRGBO(0, 0, 0, 0.01)可达到类似效果|
| [transitionDuration] | <code>Duration</code> | 0.2s  | 过度动画时间 |
| [radius] | <code>double</code> |  8.0 | 弹出框的圆角弧度 |


**Example**

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
        popoverBuild:(BuildContext context){
              return  Container(
                          width: 100.0,
                          height: 100.0,
                          child: Text('左上角内容'),
                        )
        });
```


<img width="38%" height="38%" src="./images/popover_demo.gif"/>

## CupertinoPopoverMenuList
Popover弹出的菜单样式列表,一般与[CupertinoPopoverMenuItem](#CupertinoPopoverMenuItem)一起用,会给两个Item加间隔线
```dart
CupertinoPopoverMenuList({this.children})
```
| Param | Type | Description |
| --- | --- | --- |
| children | <code>List<Widget></code>  | 子元素,一般是CupertinoPopoverMenuItem |


## CupertinoPopoverMenuItem
单个菜单项

```dart
const CupertinoPopoverMenuItem({
    this.leading,
    this.child,
    this.onTap,
    this.background = Colors.white,
    this.activeBackground = const Color(0xFFd9d9d9),
    this.isTapClosePopover=true
  });
```
| Param | Type |  Default | Description |
| --- | --- | --- | --- |
| [leading] | <code>Widget<Widget></code>  | 菜单左边,一般放图标 |
| [child] | <code>Widget<Widget></code>  | 菜单内容 |
| [onTap] | <code>BoolCallback</code> |  | 按钮点击事件,返回true取消默认反应(不关闭Popover) |
| [activeBackground] | <code>Color</code> | Color(0xFFd9d9d9) | 按下时背景色 |
| [background] | <code>Color</code> | Colors.white | 默认背景色 |
| [isTapClosePopover] | <code>bool<Widget></code>  | 是否点击关闭 |

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

