part of cool_ui;

typedef HideCallback = Future Function();

class WeuiToastWidget extends StatelessWidget {
  const WeuiToastWidget({
    Key? key,
    required this.stopEvent,
    required this.alignment,
    required this.icon,
    required this.message,
  }) : super(key: key);

  final bool stopEvent;
  final Alignment alignment;
  final Widget icon;
  final Widget message;

  @override
  Widget build(BuildContext context) {
    var widget = Material(
      color: Colors.transparent,
      child: Align(
      alignment: this.alignment,
      child: IntrinsicHeight(
        child: Container(
          width: 122.0,
          decoration: BoxDecoration(
              color: Color.fromRGBO(17, 17, 17, 0.7),
              borderRadius: BorderRadius.circular(5.0)),
          constraints: BoxConstraints(
            minHeight: 122.0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 22.0),
                constraints: BoxConstraints(minHeight: 55.0),
                child: IconTheme(
                    data: IconThemeData(color: Colors.white, size: 55.0),
                    child: icon),
              ),
              DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 16.0),
                child: message,
              ),
            ],
          ),
        ),
      ),
    ),
    );
    return IgnorePointer(
      ignoring: !stopEvent,
      child: widget,
    );
  }
}

class WeuiLoadingIcon extends StatefulWidget {
  final double size;

  WeuiLoadingIcon({this.size = 50.0});

  @override
  State<StatefulWidget> createState() => WeuiLoadingIconState();
}

class WeuiLoadingIconState extends State<WeuiLoadingIcon>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller ;
  Animation<double>? _doubleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000))
      ..repeat();
    _doubleAnimation = Tween(begin: 0.0, end: 360.0).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: _doubleAnimation!.value ~/ 30 * 30.0 * 0.0174533,
        child: Image.asset("assets/images/loading.png",
            package: "cool_ui", width: widget.size, height: widget.size));
  }
}

@immutable
class WeuiToastConfigData{
  final String successText;
  final Duration successDuration;
  final bool successBackButtonClose;
  final String loadingText;
  final bool loadingBackButtonClose;
  final Alignment toastAlignment;

  const WeuiToastConfigData({this.successText = '成功',
        this.successDuration =  const Duration(seconds: 3),
        this.successBackButtonClose = true,
        this.loadingText = '加载中',
        this.loadingBackButtonClose = false,
        this.toastAlignment = const Alignment(0.0, -0.2)});

  copyWith({String? successText, Duration? successDuration, String? loadingText, Alignment? toastAlignment}){
    return WeuiToastConfigData(
      successText: successText ?? this.successText,
      successDuration: successDuration ?? this.successDuration,
      loadingText: loadingText ?? this.loadingText,
      toastAlignment: toastAlignment ?? this.toastAlignment
    );
  }
}

class WeuiToastConfig extends InheritedWidget{
  final WeuiToastConfigData? data;
  WeuiToastConfig({required Widget child,this.data}): super(child:child);

  @override
  bool updateShouldNotify(WeuiToastConfig oldWidget) {
    // TODO: implement updateShouldNotify
    return data != oldWidget.data;
  }

  
  static WeuiToastConfigData of(BuildContext context) {
    var widget = context.dependOnInheritedWidgetOfExactType<WeuiToastConfig>();
    if(widget is WeuiToastConfig){
      return widget.data ?? WeuiToastConfigData();
    }
    return WeuiToastConfigData();
  }
}

Future showWeuiSuccessToast(
    {required BuildContext context,
    Widget? message,
    stopEvent = false,
    bool? backButtonClose,
    Alignment? alignment,
    Duration? closeDuration}) {
      
  var config = WeuiToastConfig.of(context);
  message = message?? Text(config.successText);
  closeDuration = closeDuration?? config.successDuration;
  backButtonClose = backButtonClose ?? config.successBackButtonClose;
  var hide = showWeuiToast(
      context: context,
      alignment: alignment,
      message: message,
      stopEvent: stopEvent,
      backButtonClose: backButtonClose,
      icon: Icon(CoolUIIcons.success_no_circle));

  return Future.delayed(closeDuration, () {
    hide();
  });
}

HideCallback showWeuiLoadingToast(
    {required BuildContext context,
    Widget? message,
    stopEvent = true,
    bool? backButtonClose,
    Alignment? alignment}) {
  var config = WeuiToastConfig.of(context);
  message = message?? Text(config.loadingText);
  backButtonClose = backButtonClose ?? config.loadingBackButtonClose;

  return showWeuiToast(
      context: context,
      alignment: alignment,
      message: message,
      stopEvent: stopEvent,
      icon: WeuiLoadingIcon(),
      backButtonClose: backButtonClose);
}

int backButtonIndex = 2;

HideCallback showWeuiToast(
    {required BuildContext context,
    required Widget message,
    required Widget icon,
    bool stopEvent = false,
    Alignment? alignment,
    bool backButtonClose = false}) {
  
  var config = WeuiToastConfig.of(context);
  alignment = alignment ?? config.toastAlignment;

  Completer<VoidCallback> result = Completer<VoidCallback>();
  var backButtonName = 'CoolUI_WeuiToast$backButtonIndex';
  BackButtonInterceptor.add((stopDefaultButtonEvent, routeInfo){
    if(backButtonClose){
      result.future.then((hide){
        hide();
      });
    }
    return true;
  }, zIndex: backButtonIndex, name: backButtonName);
  backButtonIndex++;

  OverlayEntry? overlay = OverlayEntry(
    maintainState: true,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          var hide = await result.future;
          hide();
          return false;
        },
        child: WeuiToastWidget(
            alignment: alignment!,
            icon: icon,
            message: message,
            stopEvent: stopEvent,
          ),
      ));
  result.complete((){
    if(overlay == null){
      return;
    }
    overlay!.remove();
    overlay = null;
    BackButtonInterceptor.removeByName(backButtonName);
  });
  Overlay.of(context)!.insert(overlay!);


  return () async {
    var hide = await result.future;
    hide();
  };
}
