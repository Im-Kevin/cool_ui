
## showWeuiToast
仿Weui的Toast效果
```dart
VoidCallback showWeuiToast({
  @required BuildContext context,
  @required Widget message,
  @required Widget icon,
  bool stopEvent = false,
  Alignment alignment,
  bool backButtonClose})
```
| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [context] | <code>BuildContext</code> | | 上下文 |
| [message] | <code>Widget</code>  | | 提示消息 |
| [icon] | <code>Widget</code>  | | 图标 |
| [stopEvent] | <code>bool</code>  | false | 阻止父页面事件触发 |
| [alignment] | <code>Alignment</code>| 默认是居中偏上 | Toast的位置 |
| [backButtonClose] | <code>bool</code>  |  | 安卓返回按钮是否关闭Toast |

返回参数:VoidCallback,用于关闭Toast


<img width="38%" height="38%" src="./images/toast_demo.gif"/>

## showWeuiSuccessToast
仿Weui的SuccessToast效果
```dart
Future showWeuiSuccessToast({
  @required BuildContext context,
  Widget message,
  bool stopEvent,
  bool backButtonClose,
  Alignment alignment,
  Duration closeDuration
  })
```
| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [context] | <code>BuildContext</code>  | | 上下文 |
| [alignment] | <code>Alignment</code>| 默认是居中偏上 | Toast的位置 |
| [message] | <code>Widget</code> | 成功| 提示消息 |
| [stopEvent] | <code>bool</code>  | false | 阻止父页面事件触发 |
| [closeDuration] | <code>Duration</code>  | 3s | 关闭时间 |
| [backButtonClose] | <code>bool</code>  | true | 安卓返回按钮是否关闭Toast |

返回参数:Future dart 异步操作,代表Toast已关闭


## showWeuiLoadingToast
仿Weui的LoadingToast效果
```dart
VoidCallback showWeuiToast({
  @required BuildContext context,
  Widget message,
  stopEvent = true,
  bool backButtonClose,
  Alignment alignment
  })
```
| Param | Type | Default | Description |
| --- | --- |  --- |  --- |
| [context] | <code>BuildContext<Widget></code> | | 上下文 |
| [message] | <code>Widget<Widget></code> | | 提示消息 |
| [stopEvent] | <code>bool</code>  | true | 阻止父页面事件触发 |
| [backButtonClose] | <code>bool</code>  | false | 安卓返回按钮是否关闭Toast |
| [alignment] | <code>Alignment</code>| 默认是居中偏上 | Toast的位置 |

返回参数:VoidCallback,用于关闭Toast


## WeuiToastConfigData
设置默认Toast效果
```dart
const WeuiToastConfigData({this.successText = '成功',
        this.successDuration =  const Duration(seconds: 3),
        this.successBackButtonClose = true,
        this.loadingText = '加载中',
        this.loadingBackButtonClose = false,
        this.toastAlignment = const Alignment(0.0, -0.2)});
```

| Param | Type | Default | Description |
| --- | --- |  --- |  --- |
| [successText] | <code>String</code> | 成功 | 成功提示消息 |
| [successDuration] | <code>Duration</code> |3s | 成功Toast关闭事件 |
| [successBackButtonClose] | <code>bool</code>  | true | 成功安卓返回按钮是否关闭Toast |
| [loadingText] | <code>String</code>  | 加载中 | 加载中提示消息 |
| [loadingBackButtonClose] | <code>false</code>  | true | 加载中安卓返回按钮是否关闭Toast |
| [alignment] | <code>Alignment</code>| 默认是居中偏上 | Toast的位置 |

## WeuiToastConfig
设置默认Toast效果 配合WeuiToastConfigData使用
```dart
WeuiToastConfig({Widget child,this.data})
```
| Param | Type | Default | Description |
| --- | --- |  --- |  --- |
| [child] | <code>Widget</code> |  | Widget |
| [data] | <code>WeuiToastConfigData</code> | | Toast配置数据 |
在Widget中添加了WeuiToastConfig,然后子Widget的context就可以应用到效果了
例如:
```dart 
main.dart
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WeuiToastConfig( // --关键代码
      data: WeuiToastConfigData( // --关键代码
        successText: '测试ConfigData' // --关键代码
      ), // --关键代码
      child:MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page')
    ));
  }
}
```
代表全局默认配置
