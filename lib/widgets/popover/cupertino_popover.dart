part of cool_ui;

enum CupertinoPopoverDirection{
  top,
  bottom,
}

typedef BoolCallback = bool Function();
class CupertinoPopoverButton extends StatelessWidget{
  final Widget child;
  final WidgetBuilder popoverBuild;
  final double popoverWidth;
  final double popoverHeight;
  final Color popoverColor;
  final List<BoxShadow> popoverBoxShadow;
  final double radius;
  final Duration transitionDuration;
  final BoolCallback onTap;
  final BoxConstraints popoverConstraints;
  final Color barrierColor;
  final CupertinoPopoverDirection direction;

  CupertinoPopoverButton({
    @required this.child,
    this.popoverBuild,
    this.popoverColor=Colors.white,
    this.popoverBoxShadow,
    this.popoverWidth,
    this.popoverHeight,
    BoxConstraints popoverConstraints,
    this.direction = CupertinoPopoverDirection.bottom,
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
                boxShadow: popoverBoxShadow,
                context: context,
                radius: radius,
                doubleAnimation: animation,
                direction: direction,
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
  final List<BoxShadow> boxShadow;
  final double radius;
  final CupertinoPopoverDirection direction;
  final Animation<double> doubleAnimation;
  BoxConstraints constraints;

  CupertinoPopover({
    @required this.attachRect,
    @required this.child,
    BoxConstraints constraints,
    this.color=Colors.white,
    this.boxShadow,
    @required BuildContext context,
    this.direction = CupertinoPopoverDirection.bottom,
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
          direction: widget.direction,
          child: _CupertionPopoverContext(
            attachRect: widget.attachRect,
            scale: widget.doubleAnimation,
            radius: widget.radius,
            color: widget.color,
            boxShadow: widget.boxShadow,
            direction: widget.direction,
            child: Material(type: MaterialType.transparency, child: widget.child),
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
  final CupertinoPopoverDirection direction;

  _CupertionPopoverPosition({Widget child,this.attachRect,this.constraints,this.scale, this.direction}):super(child:child);

  @override
  RenderObject createRenderObject(BuildContext context) =>_CupertionPopoverPositionRenderObject(
      attachRect:attachRect,
      direction: direction,
      constraints:constraints);


  @override
  void updateRenderObject(BuildContext context, _CupertionPopoverPositionRenderObject renderObject) {
    renderObject
      ..attachRect = attachRect
      ..direction = direction
      ..additionalConstraints = constraints;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints, showName: false));
  }

}

class _CupertionPopoverPositionRenderObject extends RenderShiftedBox{

  CupertinoPopoverDirection get direction => _direction;
  CupertinoPopoverDirection _direction;
  set direction(CupertinoPopoverDirection value) {
    if (_direction == value)
      return;
    _direction = value;
    markNeedsLayout();
  }

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


  _CupertionPopoverPositionRenderObject({RenderBox child,Rect attachRect,Color color,BoxConstraints constraints,Animation<double> scale, CupertinoPopoverDirection direction}) : super(child){
    this._attachRect = attachRect;
    this._additionalConstraints = constraints;
    this._direction = direction;
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
    CupertinoPopoverDirection calcDirection = _calcDirection(attachRect,size, direction); 
    

    if(attachRect.left > size.width / 2 &&
        _ScreenUtil.getInstance().screenWidth - attachRect.right > size.width / 2){ //判断是否可以在中间
      bodyLeft = attachRect.left +  attachRect.width / 2 - size.width / 2;
    }else if(attachRect.left < size.width / 2){ //靠左
      bodyLeft = 10.0;
    }else{ //靠右
      bodyLeft = _ScreenUtil.getInstance().screenWidth - 10.0 - size.width;
    }

    if(calcDirection == CupertinoPopoverDirection.bottom){
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
  final List<BoxShadow> boxShadow;
  final Animation<double> scale;
  final double radius;
  final CupertinoPopoverDirection direction;
  _CupertionPopoverContext({Widget child,this.attachRect,this.color, this.boxShadow,this.scale,this.radius, this.direction}):super(child:child);

  @override
  RenderObject createRenderObject(BuildContext context) => _CupertionPopoverContextRenderObject(
      attachRect: attachRect,
      color: color,
      boxShadow: boxShadow,
      scale: scale.value,
      direction: direction,
      radius: radius
  );


  @override
  void updateRenderObject(BuildContext context, _CupertionPopoverContextRenderObject renderObject) {
    renderObject
      ..attachRect = attachRect
      ..color = color
      ..boxShadow = boxShadow
      ..scale = scale.value
      ..direction = direction
      ..radius = radius;
  }

}

class _CupertionPopoverContextRenderObject extends RenderShiftedBox{
  CupertinoPopoverDirection get direction => _direction;
  CupertinoPopoverDirection _direction;
  set direction(CupertinoPopoverDirection value) {
    if (_direction == value)
      return;
    _direction = value;
    markNeedsLayout();
  }


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

  List<BoxShadow> get boxShadow => _boxShadow;
  List<BoxShadow> _boxShadow;
  set boxShadow(List<BoxShadow> value) {
    if (_boxShadow == value)
      return;
    _boxShadow = value;
    markNeedsLayout();
  }


  double get scale => _scale;
  double _scale;
  set scale(double value) {
    // print('scale:${_scale.value}');
    // if (_scale == value)
    //   return;
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


  _CupertionPopoverContextRenderObject({RenderBox child,Rect attachRect,Color color, List<BoxShadow> boxShadow,double scale,double radius, CupertinoPopoverDirection direction}) : super(child){
    this._attachRect = attachRect;
    this._color = color;
    this._boxShadow = boxShadow;
    this._scale = scale;
    this._radius = radius;
    this._direction = direction;
  }


  @override
  void performLayout() {
    assert(constraints.maxHeight.isFinite);
    BoxConstraints childConstraints = BoxConstraints(maxHeight: constraints.maxHeight - CupertinoPopoverState._arrowHeight).enforce(constraints);

    child.layout(childConstraints, parentUsesSize: true);
    size = Size(child.size.width,child.size.height + CupertinoPopoverState._arrowHeight);
    final BoxParentData childParentData = child.parentData;
    CupertinoPopoverDirection calcDirection = _calcDirection(attachRect,size, direction); 
    if(calcDirection == CupertinoPopoverDirection.bottom)
    {
      childParentData.offset = Offset(0.0, CupertinoPopoverState._arrowHeight);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO: implement paint
    Matrix4 transform = Matrix4.identity();
//

    CupertinoPopoverDirection calcDirection = _calcDirection(attachRect,size, direction); 
    var isArrowUp = calcDirection == CupertinoPopoverDirection.bottom;

    var arrowLeft =attachRect.left + attachRect.width / 2 - CupertinoPopoverState._arrowWidth / 2 - offset.dx;
    var translation = Offset(arrowLeft + CupertinoPopoverState._arrowWidth / 2,isArrowUp?0.0:size.height);
    transform.translate(translation.dx, translation.dy);
    transform.scale(scale, scale, 1.0);
    transform.translate(-translation.dx, -translation.dy);
    Rect arrowRect = Rect.fromLTWH(
        arrowLeft,
        isArrowUp?0.0:child.size.height,
        CupertinoPopoverState._arrowWidth,
        CupertinoPopoverState._arrowHeight);
    Rect bodyRect = Offset(0.0, isArrowUp?CupertinoPopoverState._arrowHeight:0.0) & child.size;

    _paintShadows(context, transform, offset, isArrowUp,arrowRect,bodyRect);

    Path clipPath = _getClip(isArrowUp,arrowRect,bodyRect);
    context.pushClipPath(needsCompositing,
        offset,offset & size,
        clipPath,(context,offset){
          context.pushTransform(needsCompositing, offset, transform,(context,offset){
            final Paint backgroundPaint = Paint();
            backgroundPaint.color = color;
            context.canvas.drawRect(offset & size, backgroundPaint);
            super.paint(context,offset);
          });

        });
  }


  
  void _paintShadows(PaintingContext context, Matrix4 transform, Offset offset, bool isArrowUp,Rect arrowRect,Rect bodyRect) {
    if (boxShadow == null)
      return;
    for (final BoxShadow boxShadow in boxShadow) {
      final Paint paint = boxShadow.toPaint();
      arrowRect = arrowRect.shift(offset).shift(boxShadow.offset).inflate(boxShadow.spreadRadius);
      bodyRect = bodyRect.shift(offset).shift(boxShadow.offset).inflate(boxShadow.spreadRadius);
      Path path = _getClip(isArrowUp, arrowRect, bodyRect);
      
      context.pushTransform(needsCompositing, offset, transform,(context,offset){
        context.canvas.drawPath(path,paint);
      });
    }
  }
  
  Path _getClip(bool isArrowUp,Rect arrowRect,Rect bodyRect) {
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

CupertinoPopoverDirection _calcDirection(Rect attachRect,Size size, CupertinoPopoverDirection direction) {
  bool isArrowUp;
  switch(direction){
    case CupertinoPopoverDirection.top:
      isArrowUp = attachRect.top < size.height + CupertinoPopoverState._arrowHeight; // 判断顶部位置够不够
      break;
    case CupertinoPopoverDirection.bottom:
      isArrowUp = _ScreenUtil.getInstance().screenHeight > attachRect.bottom + size.height + CupertinoPopoverState._arrowHeight;
      break;
  } 
  return isArrowUp ? CupertinoPopoverDirection.bottom : CupertinoPopoverDirection.top;
}