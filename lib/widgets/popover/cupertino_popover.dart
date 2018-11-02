part of cool_ui;

class CupertinoPopoverButton extends StatelessWidget{
  final Widget child;
  final Widget popoverBody;
  final WidgetBuilder popoverBuild;
  final double popoverWidth;
  final double popoverHeight;
  final Color popoverColor;
  final double radius;
  final Duration transitionDuration;
  const CupertinoPopoverButton({
    @required this.child,

    @Deprecated(
        '建议不要直接使用popoverBody,而是使用popoverBuild.'
    )
    this.popoverBody,
    this.popoverBuild,
    this.popoverColor=Colors.white,
    @required this.popoverWidth,
    @required this.popoverHeight,
    this.transitionDuration=const Duration(milliseconds: 200),
    this.radius=8.0}):
        assert(popoverBody != null || popoverBuild != null),
        assert(!(popoverBody != null && popoverBuild != null));


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        var offset = WidgetUtil.getWidgetLocalToGlobal(context);
        var bounds = WidgetUtil.getWidgetBounds(context);
        var body = popoverBody;
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
            return Builder(
                builder: (BuildContext context) {
                  return Container();
                }
            );

          },
          barrierDismissible: true,
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black54,
          transitionDuration: transitionDuration,
          transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            if(body == null){
              body = popoverBuild(context);
            }
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: CupertinoPopover(
                attachRect:Rect.fromLTWH(offset.dx, offset.dy, bounds.width, bounds.height),
                child: body,
                width: popoverWidth,
                height: popoverHeight,
                color: popoverColor,
                context: context,
                radius: radius,
                doubleAnimation: animation,
              ),
            );
          },);
      },
      child: child,
    );
  }
}


class CupertinoPopover extends StatefulWidget {
  final Rect attachRect;
  final Widget child;
  final double width;
  final double height;
  final Color color;
  final double radius;
  final Animation<double> doubleAnimation;

  CupertinoPopover({
    @required this.attachRect,
    @required this.child,
    @required this.width,
    @required this.height,
    this.color=Colors.white,
    @required BuildContext context,
    this.doubleAnimation,
    this.radius=8.0}):super(){
    ScreenUtil.getInstance().init(context);
  }

  @override
  CupertinoPopoverState createState() => new CupertinoPopoverState();
}

class CupertinoPopoverState extends State<CupertinoPopover>  with TickerProviderStateMixin{
  static const double _arrowWidth = 12.0;
  static const double _arrowHeight = 8.0;

  double left;
  double top;
  Rect _arrowRect;
  Rect _bodyRect;

//  AnimationController animation;

  /// 是否箭头向上
  bool isArrowUp;

  @override
  void initState() {
    // TODO: implement initState
    isArrowUp = ScreenUtil.screenHeight > widget.attachRect.bottom + widget.height + _arrowWidth;
    super.initState();
    calcRect();
//    animation = new AnimationController(
//        duration: widget.transitionDuration,
//        vsync: this
//    );
//    // Tween({T begin, T end })：创建tween（补间）
//    doubleAnimation = new Tween<double>(begin: 0.0, end: 1.0).animate(animation)..addListener((){
//      setState((){});
//    });
//    animation.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {

    var bodyMiddleX  = _bodyRect.left + _bodyRect.width / 2; // 计算Body的X轴中间点
    var arrowMiddleX = _arrowRect.left + _arrowRect.width /2; //计算箭头的X轴中间点
    var leftOffset = (arrowMiddleX - bodyMiddleX) * (1 - widget.doubleAnimation.value); //计算X轴缩小的偏移值
    return Stack(
        children: <Widget>[
          Positioned(
            left:left + leftOffset,
            top:top,
            child:ScaleTransition(
              alignment: isArrowUp?Alignment.topCenter:Alignment.bottomCenter,
              scale: widget.doubleAnimation,
              child: ClipPath(
                clipper:ArrowCliper(
                    arrowRect:_arrowRect,
                    bodyRect: _bodyRect,
                    isArrowUp: isArrowUp,
                    radius: widget.radius
                ),
                child: Container(
                    padding: EdgeInsets.only(top:isArrowUp?_arrowHeight:0.0),
                    color: Colors.white,
                    width: widget.width,
                    height: _bodyRect.height + _arrowHeight,
                    child: Material(child: widget.child)
                ),),
            ),
          )
        ]
    );
  }

  calcRect(){
    double arrowLeft = 0.0;
    double arrowTop = 0.0;
    double bodyTop = 0.0;
    double bodyLeft = 0.0;
    arrowLeft = widget.attachRect.left +  widget.attachRect.width / 2 - _arrowWidth / 2;
    if(widget.attachRect.left > widget.width / 2 &&
        ScreenUtil.screenWidth - widget.attachRect.right > widget.width / 2){ //判断是否可以在中间

      bodyLeft = widget.attachRect.left +  widget.attachRect.width / 2 - widget.width / 2;
    }else if(widget.attachRect.left < widget.width / 2){ //靠左
      bodyLeft = 10.0;
    }else{ //靠右
      bodyLeft = ScreenUtil.screenWidth - 10.0 - widget.width;
    }

    if(isArrowUp){
      arrowTop = widget.attachRect.bottom;
      bodyTop = arrowTop + _arrowHeight;
    }else{
      arrowTop = widget.attachRect.top - _arrowHeight;
      bodyTop = widget.attachRect.top - widget.height - _arrowHeight;
    }

    left = bodyLeft;
    top = isArrowUp?arrowTop:bodyTop;
    _arrowRect = Rect.fromLTWH(arrowLeft - left, arrowTop - top, _arrowWidth, _arrowHeight);
    _bodyRect = Rect.fromLTWH(0.0, bodyTop - top, widget.width, widget.height);
  }
}


class ArrowCliper extends CustomClipper<Path>{
  final bool isArrowUp;
  final Rect arrowRect;
  final Rect bodyRect;
  final double radius;
  const ArrowCliper({this.isArrowUp,this.arrowRect,this.bodyRect,this.radius = 13.0});

  @override
  Path getClip(Size size) {
    Path path = new Path();

    if(isArrowUp)
    {

      path.moveTo(arrowRect.left,arrowRect.bottom); //箭头
      path.lineTo(arrowRect.left + arrowRect.width / 2, arrowRect.top);
      path.lineTo(arrowRect.right, arrowRect.bottom);

      path.lineTo(bodyRect.right - radius,bodyRect.top); //右上角
      path.conicTo(bodyRect.right,bodyRect.top
          ,bodyRect.right,bodyRect.top + radius,1.0);

      path.lineTo(bodyRect.right,bodyRect.bottom - radius);  //右下角
      path.conicTo(bodyRect.right,bodyRect.bottom
          ,bodyRect.right -radius ,bodyRect.bottom,1.0);


      path.lineTo(bodyRect.left + radius, bodyRect.bottom); //左下角
      path.conicTo(bodyRect.left,bodyRect.bottom
          ,bodyRect.left ,bodyRect.bottom - radius,1.0);

      path.lineTo(bodyRect.left, bodyRect.top + radius); //左上角
      path.conicTo(bodyRect.left,bodyRect.top
          ,bodyRect.left + radius,bodyRect.top,1.0);
    }else{

      path.moveTo(bodyRect.left + radius,bodyRect.top);

      path.lineTo(bodyRect.right - radius,bodyRect.top); //右上角
      path.conicTo(bodyRect.right,bodyRect.top
          ,bodyRect.right,bodyRect.top + radius,1.0);

      path.lineTo(bodyRect.right,bodyRect.bottom - radius);  //右下角
      path.conicTo(bodyRect.right,bodyRect.bottom
          ,bodyRect.right -radius ,bodyRect.bottom,1.0);

      path.lineTo(arrowRect.right, arrowRect.top); //箭头
      path.lineTo(arrowRect.left + arrowRect.width / 2, arrowRect.bottom);
      path.lineTo(arrowRect.left,arrowRect.top);

      path.lineTo(bodyRect.left + radius, bodyRect.bottom); //左下角
      path.conicTo(bodyRect.left,bodyRect.bottom
          ,bodyRect.left ,bodyRect.bottom - radius,1.0);

      path.lineTo(bodyRect.left, bodyRect.top + radius); //左上角
      path.conicTo(bodyRect.left,bodyRect.top
          ,bodyRect.left + radius,bodyRect.top,1.0);

    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(ArrowCliper oldClipper) {
    return this.isArrowUp != oldClipper.isArrowUp || this.arrowRect != oldClipper.arrowRect || this.bodyRect != oldClipper.bodyRect;
  }

}