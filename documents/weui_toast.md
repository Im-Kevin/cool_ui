
## showWeuiToast
仿Weui的Toast效果
```dart
VoidCallback showWeuiToast({
  @required BuildContext context,
  @required Widget message,
  @required Widget icon,
  Alignment alignment = const Alignment(0.0,-0.2),
  RouteTransitionsBuilder transitionBuilder})
```
| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [context] | <code>BuildContext<Widget></code> | | 上下文 |
| [message] | <code>Widget<Widget></code>  | | 提示消息 |
| [alignment] | <code>Alignment<Widget></code>| 默认是居中偏上 | Toast的位置 |
| [icon] | <code>Widget<Widget></code>  | | 图标 |
| [transitionBuilder] | <code>RouteTransitionsBuilder<Widget></code> | | 自定义过度动画 |

返回参数:VoidCallback,用于关闭Toast


<img width="38%" height="38%" src="./images/toast_demo.gif"/>

## showWeuiSuccessToast
仿Weui的SuccessToast效果
```dart
Future showWeuiSuccessToast({
  @required BuildContext context,
  @required Widget message=const Text("成功"),
  Alignment alignment = const Alignment(0.0,-0.2),
  RouteTransitionsBuilder transitionBuilder,
  Duration closeDuration = const Duration(seconds: 3)
  })
```
| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [context] | <code>BuildContext<Widget></code>  | | 上下文 |
| [transitionBuilder] | <code>RouteTransitionsBuilder<Widget></code>  | | 自定义过度动画 |
| [alignment] | <code>Alignment<Widget></code>| 默认是居中偏上 | Toast的位置 |
| [message] | <code>Widget<Widget></code> | 成功| 提示消息 |
| [closeDuration] | <code>Duration<Widget></code>  | 3s | 关闭时间 |

返回参数:Future dart 异步操作,代表Toast已关闭


## showWeuiLoadingToast
仿Weui的LoadingToast效果
```dart
VoidCallback showWeuiToast({
  @required BuildContext context,
  @required Widget message,
  Alignment alignment = const Alignment(0.0,-0.2),
  RouteTransitionsBuilder transitionBuilder
  })
```
| Param | Type | Default | Description |
| --- | --- |  --- |  --- |
| [context] | <code>BuildContext<Widget></code> | | 上下文 |
| [message] | <code>Widget<Widget></code> | | 提示消息 |
| [alignment] | <code>Alignment<Widget></code>| 默认是居中偏上 | Toast的位置 |
| [transitionBuilder] | <code>RouteTransitionsBuilder<Widget></code> | | 自定义过度动画 |

返回参数:VoidCallback,用于关闭Toast
