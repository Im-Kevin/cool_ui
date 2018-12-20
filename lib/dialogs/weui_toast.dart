part of cool_ui;

class WeuiToast extends TransitionRoute{
  OverlayEntry _toastBarrier;
  final Widget message;
  final Widget icon;
  final RouteTransitionsBuilder _transitionBuilder;
  final Duration closeDuration;
  final Alignment alignment;
  WeuiToast({
    @required this.message,
    @required this.icon,
    this.alignment = const Alignment(0.0,-0.2),
    Duration transitionDuration = const Duration(milliseconds: 100),
    RouteTransitionsBuilder transitionBuilder,
    this.closeDuration
  }):assert(icon != null),
        assert(message!=null),
        _transitionDuration = transitionDuration,
        _transitionBuilder = transitionBuilder;


  @override
  void didChangePrevious(Route<dynamic> previousRoute) {
    super.didChangePrevious(previousRoute);
    changedInternalState();
  }

  @override
  void changedInternalState() {
    super.changedInternalState();
    _toastBarrier.markNeedsBuild();
  }


  @override
  Iterable<OverlayEntry> createOverlayEntries() sync* {
    yield _toastBarrier = OverlayEntry(builder: _buildToastBarrier);
    yield OverlayEntry(builder: _buildToastScope, maintainState: true);
  }

  // TODO: implement opaque
  @override
  bool get opaque => false;

  // TODO: implement transitionDuration
  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;


  Widget _buildToastBarrier(BuildContext context){
    return IgnorePointer(
      ignoring: true,
    );
  }

  Widget _buildToastScope(BuildContext context){
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: this.alignment,
        child: IntrinsicHeight(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context,child){
              return _buildTransition(context,animation,secondaryAnimation,child);
            },
            child: Container(
              width: 122.0,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(17, 17, 17, 0.7),
                  borderRadius: BorderRadius.circular(5.0)
              ),
              constraints: BoxConstraints(
                minHeight: 122.0,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 22.0),
                    constraints:BoxConstraints(
                        minHeight: 55.0
                    ) ,
                    child: IconTheme(data: IconThemeData(color: Colors.white,size: 55.0), child: icon),
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0
                    ),
                    child: message,
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget _buildTransition( BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child){
    if (_transitionBuilder == null) {
      return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.linear,
          ),
          child: child);
    } // Some default transition
    return _transitionBuilder(context, animation, secondaryAnimation, child);
  }
}


Future showWeuiSuccessToast({
  @required BuildContext context,
  Widget message=const Text("成功"),
  RouteTransitionsBuilder transitionBuilder,
  Alignment alignment = const Alignment(0.0,-0.2),
  Duration closeDuration = const Duration(seconds: 3)
}){

  var hide =  showWeuiToast(
      context: context,
      alignment: alignment,
      message: message,
      icon: Icon(CoolUIIcons.success_no_circle),
      transitionBuilder:transitionBuilder);

  return Future.delayed(closeDuration,(){
    hide();
  });
}


VoidCallback showWeuiLoadingToast({
  @required BuildContext context,
  @required Widget message,
  Alignment alignment = const Alignment(0.0,-0.2),
  RouteTransitionsBuilder transitionBuilder
}){
  return showWeuiToast(
      context: context,
      alignment: alignment,
      message: message,
      icon: WeuiLoadingIcon(),
      transitionBuilder:transitionBuilder);
}

VoidCallback showWeuiToast({
  @required BuildContext context,
  @required Widget message,
  @required Widget icon,
  Alignment alignment = const Alignment(0.0,-0.2),
  RouteTransitionsBuilder transitionBuilder}){
  Completer<VoidCallback> result = Completer<VoidCallback>();
  Navigator.of(context,rootNavigator: true).push(
      WeuiToast(
        alignment: alignment,
          message: Builder(builder: (context){
            if(!result.isCompleted){
              result.complete(()=>Navigator.pop(context));
            }
            return message;
          }),
          icon: icon,
          transitionBuilder:transitionBuilder));
  return (){
    result.future.then((hide){
      hide();
    });
  };
}

class WeuiLoadingIcon extends StatefulWidget{
  final double size;

  WeuiLoadingIcon({this.size = 50.0});

  @override
  State<StatefulWidget> createState() => WeuiLoadingIconState();

}

class WeuiLoadingIconState extends State<WeuiLoadingIcon>
    with SingleTickerProviderStateMixin
{
  AnimationController _controller;
  Animation<double> _doubleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000))
      ..repeat();
    _doubleAnimation= Tween(begin: 0.0,end: 360.0).animate(_controller)..addListener((){
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _doubleAnimation.value ~/ 30 * 30.0 * 0.0174533,
      child: Image.asset("assets/images/loading.png",
        package: "cool_ui",
        width: widget.size,
        height: widget.size)
    );
  }
}