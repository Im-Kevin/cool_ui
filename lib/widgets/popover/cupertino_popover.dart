part of cool_ui;

typedef BoolCallback = bool Function();
class CupertinoPopoverButton extends StatelessWidget{
  final Widget child;
  final WidgetBuilder popoverBuild;
  final double popoverWidth;
  final double popoverHeight;
  final Color popoverColor;
  final double radius;
  final Duration transitionDuration;
  final BoolCallback onTap;
  final BoxConstraints popoverConstraints;
  final Color barrierColor;

  CupertinoPopoverButton({
    @required this.child,
    this.popoverBuild,
    this.popoverColor=Colors.white,
    this.popoverWidth,
    this.popoverHeight,
    BoxConstraints popoverConstraints,
    this.onTap,
    this.transitionDuration=const Duration(milliseconds: 200),
    this.barrierColor = Colors.black54,
    this.radius=8.0}):
        assert(popoverBuild != null),
        this.popoverConstraints =
        (popoverWidth != null || popoverHeight != null)

            ? popoverConstraints?.tighten(width: popoverWidth, height: popoverHeight)
            ?? BoxConstraints.tightFor(width: popoverWidth, height: popoverHeight)
            : popoverConstraints;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        if(onTap != null && onTap()){
          return;
        }
        var offset = _WidgetUtil.getWidgetLocalToGlobal(context);
        var bounds = _WidgetUtil.getWidgetBounds(context);
        var body;
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
          barrierColor: this.barrierColor,
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
                constraints:popoverConstraints,
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

// ignore: must_be_immutable
class CupertinoPopover extends StatefulWidget {
  final Rect attachRect;
  final Widget child;
  final Color color;
  final double radius;
  final Animation<double> doubleAnimation;
  BoxConstraints constraints;

  CupertinoPopover({
    @required this.attachRect,
    @required this.child,
    BoxConstraints constraints,
    this.color=Colors.white,
    @required BuildContext context,
    this.doubleAnimation,
    this.radius=8.0}):super(){
    BoxConstraints temp;
    if(constraints != null){
      temp = BoxConstraints(maxHeight:123.0,maxWidth:150.0).copyWith(
        minWidth: constraints.minWidth.isFinite?constraints.minWidth:null,
        minHeight: constraints.minHeight.isFinite?constraints.minHeight:null,
        maxWidth: constraints.maxWidth.isFinite?constraints.maxWidth:null,
        maxHeight: constraints.maxHeight.isFinite?constraints.maxHeight:null,
      );
    }else{
      temp=BoxConstraints(maxHeight:123.0,maxWidth:150.0);
    }
    this.constraints = temp.copyWith(maxHeight: temp.maxHeight + CupertinoPopoverState._arrowHeight);
  }

  @override
  CupertinoPopoverState createState() => new CupertinoPopoverState();


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints, showName: false));
    properties.add(DiagnosticsProperty<Color>('color', color, showName: false));
    properties.add(DiagnosticsProperty<double>('double', radius, showName: false));
  }
}

class CupertinoPopoverState extends State<CupertinoPopover>  with TickerProviderStateMixin{
  static const double _arrowWidth = 12.0;
  static const double _arrowHeight = 8.0;

//  AnimationController animation;

  /// 是否箭头向上
  bool isArrowUp;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _CupertionPopoverPosition(
          attachRect: widget.attachRect,
          scale: widget.doubleAnimation,
          constraints: widget.constraints,
          child: _CupertionPopoverContext(
            attachRect: widget.attachRect,
            scale: widget.doubleAnimation,
            radius: widget.radius,
            color: widget.color,
            child: Material(child: widget.child),
          ),
        )
      ],
    );
  }

}


class _CupertionPopoverPosition extends SingleChildRenderObjectWidget{
  final Rect attachRect;
  final Animation<double> scale;
  final BoxConstraints constraints;

  _CupertionPopoverPosition({Widget child,this.attachRect,this.constraints,this.scale}):super(child:child);

  @override
  RenderObject createRenderObject(BuildContext context) =>_CupertionPopoverPositionRenderObject(
      attachRect:attachRect,
      constraints:constraints);


  @override
  void updateRenderObject(BuildContext context, _CupertionPopoverPositionRenderObject renderObject) {
    renderObject
      ..attachRect = attachRect
      ..additionalConstraints = constraints;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints, showName: false));
  }

}

class _CupertionPopoverPositionRenderObject extends RenderShiftedBox{
  Rect get attachRect => _attachRect;
  Rect _attachRect;
  set attachRect(Rect value) {
    if (_attachRect == value)
      return;
    _attachRect = value;
    markNeedsLayout();
  }



  BoxConstraints get additionalConstraints => _additionalConstraints;
  BoxConstraints _additionalConstraints;
  set additionalConstraints(BoxConstraints value) {
    if (_additionalConstraints == value)
      return;
    _additionalConstraints = value;
    markNeedsLayout();
  }


  _CupertionPopoverPositionRenderObject({RenderBox child,Rect attachRect,Color color,BoxConstraints constraints,Animation<double> scale}) : super(child){
    this._attachRect = attachRect;
    this._additionalConstraints = constraints;
  }


  @override
  void performLayout() {
    child.layout(_additionalConstraints.enforce(constraints), parentUsesSize: true);
    size = Size(constraints.maxWidth,constraints.maxHeight);

    final BoxParentData childParentData = child.parentData;

    childParentData.offset = calcOffset(child.size);
  }

  Offset calcOffset(Size size){
    double bodyLeft = 0.0;

    var isArrowUp = _ScreenUtil.getInstance().screenHeight > attachRect.bottom + size.height + CupertinoPopoverState._arrowHeight;

    if(attachRect.left > size.width / 2 &&
        _ScreenUtil.getInstance().screenWidth - attachRect.right > size.width / 2){ //判断是否可以在中间
      bodyLeft = attachRect.left +  attachRect.width / 2 - size.width / 2;
    }else if(attachRect.left < size.width / 2){ //靠左
      bodyLeft = 10.0;
    }else{ //靠右
      bodyLeft = _ScreenUtil.getInstance().screenWidth - 10.0 - size.width;
    }

    if(isArrowUp){
      return Offset(bodyLeft,attachRect.bottom);
    }else{
      return Offset(bodyLeft,attachRect.top - size.height - CupertinoPopoverState._arrowHeight);
    }
  }


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>('additionalConstraints', additionalConstraints));
  }
}

class _CupertionPopoverContext extends SingleChildRenderObjectWidget{
  final Rect attachRect;
  final Color color;
  final Animation<double> scale;
  final double radius;
  _CupertionPopoverContext({Widget child,this.attachRect,this.color,this.scale,this.radius}):super(child:child);

  @override
  RenderObject createRenderObject(BuildContext context) => _CupertionPopoverContextRenderObject(
      attachRect: attachRect,
      color: color,
      scale: scale,
      radius: radius
  );


  @override
  void updateRenderObject(BuildContext context, _CupertionPopoverContextRenderObject renderObject) {
    renderObject
      ..attachRect = attachRect
      ..color = color
      ..scale = scale
      ..radius = radius;
  }

}

class _CupertionPopoverContextRenderObject extends RenderShiftedBox{
  Rect get attachRect => _attachRect;
  Rect _attachRect;
  set attachRect(Rect value) {
    if (_attachRect == value)
      return;
    _attachRect = value;
    markNeedsLayout();
  }


  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (_color == value)
      return;
    _color = value;
    markNeedsLayout();
  }


  Animation<double> get scale => _scale;
  Animation<double> _scale;
  set scale(Animation<double> value) {
    if (_scale == value)
      return;
    _scale = value;
    markNeedsLayout();
  }


  double get radius => _radius;
  double _radius;
  set radius(double value) {
    if (_radius == value)
      return;
    _radius = value;
    markNeedsLayout();
  }


  _CupertionPopoverContextRenderObject({RenderBox child,Rect attachRect,Color color,Animation<double> scale,double radius}) : super(child){
    this._attachRect = attachRect;
    this._color = color;
    this._scale = scale;
    this._radius = radius;
  }


  @override
  void performLayout() {
    assert(constraints.maxHeight.isFinite);
    BoxConstraints childConstraints = BoxConstraints(maxHeight: constraints.maxHeight - CupertinoPopoverState._arrowHeight).enforce(constraints);

    child.layout(childConstraints, parentUsesSize: true);
    size = Size(child.size.width,child.size.height + CupertinoPopoverState._arrowHeight);
    final BoxParentData childParentData = child.parentData;
    var isArrowUp = _ScreenUtil.getInstance().screenHeight > attachRect.bottom + size.height + CupertinoPopoverState._arrowHeight;
    if(isArrowUp)
    {
      childParentData.offset = Offset(0.0, CupertinoPopoverState._arrowHeight);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO: implement paint
    Matrix4 transform = Matrix4.identity();
//
    var isArrowUp = _ScreenUtil.getInstance().screenHeight > attachRect.bottom + size.height + CupertinoPopoverState._arrowHeight;

    var arrowLeft =attachRect.left + attachRect.width / 2 - CupertinoPopoverState._arrowWidth / 2 - offset.dx;
    var translation = Offset(arrowLeft + CupertinoPopoverState._arrowWidth / 2,isArrowUp?0.0:size.height);
    transform.translate(translation.dx, translation.dy);
    transform.scale(scale.value, scale.value, 1.0);
    transform.translate(-translation.dx, -translation.dy);
    Rect arrowRect = Rect.fromLTWH(
        arrowLeft,
        isArrowUp?0.0:child.size.height,
        CupertinoPopoverState._arrowWidth,
        CupertinoPopoverState._arrowHeight);
    Rect bodyRect = Offset(0.0, isArrowUp?CupertinoPopoverState._arrowHeight:0.0) & child.size;

    context.pushClipPath(needsCompositing,
        offset,offset & size,
        getClip(size,isArrowUp,arrowRect,bodyRect),(context,offset){
          context.pushTransform(needsCompositing, offset, transform,(context,offset){
            final Paint backgroundPaint = Paint();
            backgroundPaint.color = color;
            context.canvas.drawRect(offset & size, backgroundPaint);
            super.paint(context,offset);
          });
        });
  }


  Path getClip(Size size,bool isArrowUp,Rect arrowRect,Rect bodyRect) {
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
}