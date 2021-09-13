# 自定义键盘使用方法快速入门

## 效果

<img width="38%" height="38%" src="./images/custom_keyboard.gif"/>

## Flutter 2.5后添加的步骤
替换runApp为runMockApp
```dart
void main() {
  // runApp(MyApp()); // 旧的
  runMockApp(KeyboardRootWidget(child: MyApp())); // 新的
}
```


## Step1
编写个性化的键盘

```dart
class NumberKeyboard extends StatelessWidget{
    static const CKTextInputType inputType = const CKTextInputType(name:'CKNumberKeyboard'); //定义InputType类型
    static double getHeight(BuildContext ctx){ //编写获取高度的方法
         ...
    }


  final KeyboardController controller ; //用于控制键盘输出的Controller
  const NumberKeyboard({this.controller});

   static register(){   //注册键盘的方法
      CoolKeyboard.addKeyboard(NumberKeyboard.inputType,KeyboardConfig(builder: (context,controller, params){ // 可通过CKTextInputType传参数到键盘内部
        return NumberKeyboard(controller: controller);
      },getHeight: NumberKeyboard.getHeight));
    }

    @override
    Widget build(BuildContext context) { //键盘的具体内容
      ...
      return Container( //例子
        color: Colors.white,
        child: GestureDetector(
           behavior: HitTestBehavior.translucent,
           child: Center(child: Text('1'),),
           onTap: (){
              controller.addText('1'); 往输入框光标位置添加一个1
           },
        ),
      )
    }
}
```

## Step2
注册键盘,并且添加了KeyboardRootWidget

```dart
void main(){
  NumberKeyboard.register(); //注册键盘
  runApp(KeyboardRootWidget(child: MyApp())); //添加了KeyboardRootWidget
}
```

## Step3
给需要使用自定义键盘的页面添加以下代码

```dart
@override
Widget build(BuildContext context) {
  return KeyboardMediaQuery(//用于键盘弹出的时候页面可以滚动到输入框的位置
      child: Page
  );
}
```


## Step4
具体使用
```dart
TextField(
   ...
   keyboardType: NumberKeyboard.inputType, 像平常一样设置键盘输入类型一样将Step1编写的inputType传递进去
   ...
 )
```

# KeyboardController


- [deleteOne](#deleteOne)
- [addText](#addText)
- [doneAction](#doneAction)
- [nextAction](#nextAction)
- [sendPerformAction](#sendPerformAction)


### deleteOne()
删除一个字符,一般用于键盘的删除键

### addText(String insertText)
在光标位置添加文字,一般用于键盘输入

### doneAction()
触发键盘的完成Action

### nextAction()
触发键盘的下一项Action

### newLineAction()
触发键盘的换行Action

### sendPerformAction(TextInputAction action)
///发送其他Action

