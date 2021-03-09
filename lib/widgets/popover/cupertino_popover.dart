part of cool_ui;

enum CupertinoPopoverDirection { top, bottom, left, right }

typedef BoolCallback = bool Function();

class CupertinoPopoverButton extends StatelessWidget {
  final Widget child;
  final WidgetBuilder? popoverBuild;
  final double? popoverWidth;
  final double? popoverHeight;
  final Color popoverColor;
  final List<BoxShadow>? popoverBoxShadow;
  final double radius;
  final Duration transitionDuration;
  final BoolCallback? onTap;
  final BoxConstraints? popoverConstraints;
  final Color barrierColor;
  final CupertinoPopoverDirection direction;

  CupertinoPopoverButton(
      {required this.child,
      this.popoverBuild,
      this.popoverColor = Colors.white,
      this.popoverBoxShadow,
      this.popoverWidth,
      this.popoverHeight,
      BoxConstraints? popoverConstraints,
      this.direction = CupertinoPopoverDirection.bottom,
      this.onTap,
      this.transitionDuration = const Duration(milliseconds: 200),
      this.barrierColor = Colors.black54,
      this.radius = 8.0})
      : assert(popoverBuild != null),
        this.popoverConstraints =
            (popoverWidth != null || popoverHeight != null)
                ? popoverConstraints?.tighten(
                        width: popoverWidth, height: popoverHeight) ??
                    BoxConstraints.tightFor(
                        width: popoverWidth, height: popoverHeight)
                : popoverConstraints;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null && onTap!()) {
          return;
        }
        var offset = _WidgetUtil.getWidgetLocalToGlobal(context);
        var bounds = _WidgetUtil.getWidgetBounds(context);
        var body;
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Builder(builder: (BuildContext context) {
              return Container();
            });
          },
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: this.barrierColor,
          transitionDuration: transitionDuration,
          transitionBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) {
            if (body == null) {
              body = popoverBuild!(context);
            }
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: CupertinoPopover(
                attachRect: Rect.fromLTWH(
                    offset.dx, offset.dy, bounds.width, bounds.height),
                child: body,
                constraints: popoverConstraints,
                color: popoverColor,
                boxShadow: popoverBoxShadow,
                context: context,
                radius: radius,
                doubleAnimation: animation,
                direction: direction,
              ),
            );
          },
        );
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
  final List<BoxShadow>? boxShadow;
  final double radius;
  final CupertinoPopoverDirection direction;
  final Animation<double> doubleAnimation;
  BoxConstraints? constraints;

  CupertinoPopover(
      {required this.attachRect,
      required this.child,
      BoxConstraints? constraints,
      this.color = Colors.white,
      this.boxShadow,
      required BuildContext context,
      this.direction = CupertinoPopoverDirection.bottom,
      required this.doubleAnimation,
      this.radius = 8.0})
      : super() {
    BoxConstraints temp;
    if (constraints != null) {
      temp = BoxConstraints(maxHeight: 123.0, maxWidth: 150.0).copyWith(
        minWidth: constraints.minWidth.isFinite ? constraints.minWidth : null,
        minHeight:
            constraints.minHeight.isFinite ? constraints.minHeight : null,
        maxWidth: constraints.maxWidth.isFinite ? constraints.maxWidth : null,
        maxHeight:
            constraints.maxHeight.isFinite ? constraints.maxHeight : null,
      );
    } else {
      temp = BoxConstraints(maxHeight: 123.0, maxWidth: 150.0);
    }
    this.constraints = temp.copyWith(
        maxHeight: temp.maxHeight + CupertinoPopoverState._arrowHeight);
  }

  @override
  CupertinoPopoverState createState() => new CupertinoPopoverState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>(
        'constraints', constraints,
        showName: false));
    properties.add(DiagnosticsProperty<Color>('color', color, showName: false));
    properties
        .add(DiagnosticsProperty<double>('double', radius, showName: false));
  }
}

class CupertinoPopoverState extends State<CupertinoPopover>
    with TickerProviderStateMixin {
  static const double _arrowWidth = 12.0;
  static const double _arrowHeight = 8.0;

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
            boxShadow: widget.boxShadow ?? [],
            direction: widget.direction,
            child:
                Material(type: MaterialType.transparency, child: widget.child),
          ),
        )
      ],
    );
  }
}

class _CupertionPopoverPosition extends SingleChildRenderObjectWidget {
  final Rect attachRect;
  final Animation<double> scale;
  final BoxConstraints? constraints;
  final CupertinoPopoverDirection direction;

  _CupertionPopoverPosition(
      {required Widget child,
      required this.attachRect,
      this.constraints,
      required this.scale,
      required this.direction})
      : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _CupertionPopoverPositionRenderObject(
          attachRect: attachRect,
          direction: direction,
          constraints: constraints ?? BoxConstraints());

  @override
  void updateRenderObject(BuildContext context,
      _CupertionPopoverPositionRenderObject renderObject) {
    renderObject
      ..attachRect = attachRect
      ..direction = direction
      ..additionalConstraints = constraints ?? BoxConstraints();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>(
        'constraints', constraints,
        showName: false));
  }
}

class _CupertionPopoverPositionRenderObject extends RenderShiftedBox {
  CupertinoPopoverDirection get direction => _direction;
  CupertinoPopoverDirection _direction;
  set direction(CupertinoPopoverDirection value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  Rect get attachRect => _attachRect;
  Rect _attachRect;
  set attachRect(Rect value) {
    if (_attachRect == value) return;
    _attachRect = value;
    markNeedsLayout();
  }

  BoxConstraints get additionalConstraints => _additionalConstraints;
  BoxConstraints _additionalConstraints;
  set additionalConstraints(BoxConstraints value) {
    if (_additionalConstraints == value) return;
    _additionalConstraints = value;
    markNeedsLayout();
  }

  _CupertionPopoverPositionRenderObject(
      {RenderBox? child,
      required Rect attachRect,
      BoxConstraints constraints = const BoxConstraints(),
      required CupertinoPopoverDirection direction})
      : 
      this._attachRect = attachRect,
      this._additionalConstraints = constraints,
      this._direction = direction,
      super(child);

  @override
  void performLayout() {
    child!.layout(_additionalConstraints.enforce(constraints),
        parentUsesSize: true);
    size = Size(constraints.maxWidth, constraints.maxHeight);

    final BoxParentData childParentData = child!.parentData as BoxParentData;

    childParentData.offset = calcOffset(child!.size);
  }

  Offset calcOffset(Size size) {
    CupertinoPopoverDirection calcDirection =
        _calcDirection(attachRect, size, direction);

    if (calcDirection == CupertinoPopoverDirection.top ||
        calcDirection == CupertinoPopoverDirection.bottom) {
      double bodyLeft = 0.0;
      // 上下
      if (attachRect.left > size.width / 2 &&
          _ScreenUtil.getInstance().screenWidth - attachRect.right >
              size.width / 2) {
        //判断是否可以在中间
        bodyLeft = attachRect.left + attachRect.width / 2 - size.width / 2;
      } else if (attachRect.left < size.width / 2) {
        //靠左
        bodyLeft = 10.0;
      } else {
        //靠右
        bodyLeft = _ScreenUtil.getInstance().screenWidth - 10.0 - size.width;
      }

      if (calcDirection == CupertinoPopoverDirection.bottom) {
        return Offset(bodyLeft, attachRect.bottom);
      } else {
        return Offset(bodyLeft,
            attachRect.top - size.height);
      }
    } else {
      double bodyTop = 0.0;
      if (attachRect.top > size.height / 2 &&
          _ScreenUtil.getInstance().screenHeight - attachRect.bottom >
              size.height / 2) {
        //判断是否可以在中间
        bodyTop = attachRect.top + attachRect.height / 2 - size.height / 2;
      } else if (attachRect.top < size.height / 2) {
        //靠左
        bodyTop = 10.0;
      } else {
        //靠右
        bodyTop = _ScreenUtil.getInstance().screenHeight - 10.0 - size.height;
      }

      if (calcDirection == CupertinoPopoverDirection.right) {
        return Offset(attachRect.right, bodyTop);
      } else {
        return Offset(
            attachRect.left - size.width,
            bodyTop);
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>(
        'additionalConstraints', additionalConstraints));
  }
}

class _CupertionPopoverContext extends SingleChildRenderObjectWidget {
  final Rect attachRect;
  final Color color;
  final List<BoxShadow> boxShadow;
  final Animation<double> scale;
  final double radius;
  final CupertinoPopoverDirection direction;
  _CupertionPopoverContext(
      {required Widget child,
      required this.attachRect,
      required this.color,
      this.boxShadow = const [],
      required this.scale,
      required this.radius,
      required this.direction})
      : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _CupertionPopoverContextRenderObject(
          attachRect: attachRect,
          color: color,
          boxShadow: boxShadow,
          scale: scale.value,
          direction: direction,
          radius: radius);

  @override
  void updateRenderObject(
      BuildContext context, _CupertionPopoverContextRenderObject renderObject) {
    renderObject
      ..attachRect = attachRect
      ..color = color
      ..boxShadow = boxShadow
      ..scale = scale.value
      ..direction = direction
      ..radius = radius;
  }
}

class _CupertionPopoverContextRenderObject extends RenderShiftedBox {
  CupertinoPopoverDirection get direction => _direction;
  CupertinoPopoverDirection _direction;
  set direction(CupertinoPopoverDirection value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  Rect get attachRect => _attachRect;
  Rect _attachRect;
  set attachRect(Rect value) {
    if (_attachRect == value) return;
    _attachRect = value;
    markNeedsLayout();
  }

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsLayout();
  }

  List<BoxShadow> get boxShadow => _boxShadow;
  List<BoxShadow> _boxShadow;
  set boxShadow(List<BoxShadow> value) {
    if (_boxShadow == value) return;
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
    if (_radius == value) return;
    _radius = value;
    markNeedsLayout();
  }

  _CupertionPopoverContextRenderObject(
      {RenderBox? child,
      required Rect attachRect,
      required Color color,
      List<BoxShadow> boxShadow = const [],
      required double scale,
      required double radius,
      required CupertinoPopoverDirection direction})
      : 
    this._attachRect = attachRect,
    this._color = color,
    this._boxShadow = boxShadow,
    this._scale = scale,
    this._radius = radius,
    this._direction = direction,super(child);

  @override
  void performLayout() {
    assert(constraints.maxHeight.isFinite);
    BoxConstraints childConstraints;

    if (direction == CupertinoPopoverDirection.top ||
        direction == CupertinoPopoverDirection.bottom) {
      childConstraints = BoxConstraints(
              maxHeight:
                  constraints.maxHeight - CupertinoPopoverState._arrowHeight)
          .enforce(constraints);
    } else {
      childConstraints = BoxConstraints(
              maxWidth:
                  constraints.maxWidth - CupertinoPopoverState._arrowHeight)
          .enforce(constraints);
    }

    child!.layout(childConstraints, parentUsesSize: true);

    if (direction == CupertinoPopoverDirection.top ||
        direction == CupertinoPopoverDirection.bottom) {
      size = Size(child!.size.width,
          child!.size.height + CupertinoPopoverState._arrowHeight);
    } else {
      size = Size(child!.size.width + CupertinoPopoverState._arrowHeight,
          child!.size.height);
    }
    CupertinoPopoverDirection calcDirection =
        _calcDirection(attachRect, size, direction);

    final BoxParentData childParentData = child!.parentData as BoxParentData;
    if (calcDirection == CupertinoPopoverDirection.bottom) {
      childParentData.offset = Offset(0.0, CupertinoPopoverState._arrowHeight);
    } else if (calcDirection == CupertinoPopoverDirection.right) {
      childParentData.offset = Offset(CupertinoPopoverState._arrowHeight, 0.0);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO: implement paint
    Matrix4 transform = Matrix4.identity();
//

    CupertinoPopoverDirection calcDirection =
        _calcDirection(attachRect, size, direction);
        
    Rect? arrowRect;
    Offset? translation;
    Rect bodyRect;

    final BoxParentData childParentData = (child!.parentData) as BoxParentData;
    bodyRect = childParentData.offset & child!.size;

    var arrowLeft = attachRect.left + // 用于 Top和Bottom
        attachRect.width / 2 -
        CupertinoPopoverState._arrowWidth / 2 -
        offset.dx;

    var arrowTop = attachRect.top + // 用于 Left和Right
        attachRect.height / 2 -
        CupertinoPopoverState._arrowWidth / 2 -
        offset.dy;

    switch (calcDirection) {
      case CupertinoPopoverDirection.top:
        arrowRect = Rect.fromLTWH(
            arrowLeft,
            child!.size.height,
            CupertinoPopoverState._arrowWidth,
            CupertinoPopoverState._arrowHeight);
        translation = Offset(
            arrowLeft + CupertinoPopoverState._arrowWidth / 2, size.height);

        break;
      case CupertinoPopoverDirection.left:
        arrowRect = Rect.fromLTWH(
            child!.size.width,
            arrowTop,
            CupertinoPopoverState._arrowHeight,
            CupertinoPopoverState._arrowWidth);
        translation = Offset(
            size.width, arrowTop + CupertinoPopoverState._arrowWidth / 2);
        break;
      case CupertinoPopoverDirection.bottom:
        arrowRect = Rect.fromLTWH(
            arrowLeft,
            0,
            CupertinoPopoverState._arrowWidth,
            CupertinoPopoverState._arrowHeight);
        translation =
            Offset(arrowLeft + CupertinoPopoverState._arrowWidth / 2, 0);
        break;
      case CupertinoPopoverDirection.right:
        arrowRect = Rect.fromLTWH(
            0,
            arrowTop,
            CupertinoPopoverState._arrowHeight,
            CupertinoPopoverState._arrowWidth);
        translation = Offset(
            0, arrowTop + CupertinoPopoverState._arrowWidth / 2);
        break;
      default:
    }

    transform.translate(translation!.dx, translation.dy);
    transform.scale(scale, scale, 1.0);
    transform.translate(-translation.dx, -translation.dy);

    _paintShadows(
        context, transform, offset, calcDirection, arrowRect!, bodyRect);

    Path clipPath = _getClip(calcDirection, arrowRect, bodyRect);
    context.pushClipPath(needsCompositing, offset, offset & size, clipPath,
        (context, offset) {
      context.pushTransform(needsCompositing, offset, transform,
          (context, offset) {
        final Paint backgroundPaint = Paint();
        backgroundPaint.color = color;
        context.canvas.drawRect(offset & size, backgroundPaint);
        super.paint(context, offset);
      });
    });
  }

  void _paintShadows(PaintingContext context, Matrix4 transform, Offset offset,
      CupertinoPopoverDirection direction, Rect arrowRect, Rect bodyRect) {
    for (final BoxShadow boxShadow in boxShadow) {
      final Paint paint = boxShadow.toPaint();
      arrowRect = arrowRect
          .shift(offset)
          .shift(boxShadow.offset)
          .inflate(boxShadow.spreadRadius);
      bodyRect = bodyRect
          .shift(offset)
          .shift(boxShadow.offset)
          .inflate(boxShadow.spreadRadius);
      Path path = _getClip(direction, arrowRect, bodyRect);

      context.pushTransform(needsCompositing, offset, transform,
          (context, offset) {
        context.canvas.drawPath(path, paint);
      });
    }
  }

  Path _getClip(
      CupertinoPopoverDirection direction, Rect arrowRect, Rect bodyRect) {
    Path path = new Path();

    if (direction == CupertinoPopoverDirection.top) {
      path.moveTo(arrowRect.left, arrowRect.top); //箭头
      path.lineTo(arrowRect.left + arrowRect.width / 2, arrowRect.bottom);
      path.lineTo(arrowRect.right, arrowRect.top);

      path.lineTo(bodyRect.right - radius, bodyRect.bottom); //右下角
      path.conicTo(bodyRect.right, bodyRect.bottom, bodyRect.right,
          bodyRect.bottom - radius, 1.0);

      path.lineTo(bodyRect.right, bodyRect.top + radius); //右上角
      path.conicTo(bodyRect.right, bodyRect.top, bodyRect.right - radius,
          bodyRect.top, 1.0);

      path.lineTo(bodyRect.left + radius, bodyRect.top); //左上角
      path.conicTo(bodyRect.left, bodyRect.top, bodyRect.left,
          bodyRect.top + radius, 1.0);

      path.lineTo(bodyRect.left, bodyRect.bottom - radius); //左下角
      path.conicTo(bodyRect.left, bodyRect.bottom, bodyRect.left + radius,
          bodyRect.bottom, 1.0);
    } else if (direction == CupertinoPopoverDirection.right) {
      path.moveTo(arrowRect.right, arrowRect.top); //箭头
      path.lineTo(arrowRect.left, arrowRect.top + arrowRect.height / 2);
      path.lineTo(arrowRect.right, arrowRect.bottom);

      path.lineTo(bodyRect.left, bodyRect.bottom - radius); //左下角
      path.conicTo(bodyRect.left, bodyRect.bottom, bodyRect.left + radius,
          bodyRect.bottom, 1.0);

      path.lineTo(bodyRect.right - radius, bodyRect.bottom); //右下角
      path.conicTo(bodyRect.right, bodyRect.bottom, bodyRect.right,
          bodyRect.bottom - radius, 1.0);

      path.lineTo(bodyRect.right, bodyRect.top + radius); //右上角
      path.conicTo(bodyRect.right, bodyRect.top, bodyRect.right - radius,
          bodyRect.top, 1.0);

      path.lineTo(bodyRect.left + radius, bodyRect.top); //左上角
      path.conicTo(bodyRect.left, bodyRect.top, bodyRect.left,
          bodyRect.top + radius, 1.0);
    } else if (direction == CupertinoPopoverDirection.left) {
      path.moveTo(arrowRect.left, arrowRect.top); //箭头
      path.lineTo(arrowRect.right, arrowRect.top + arrowRect.height / 2);
      path.lineTo(arrowRect.left, arrowRect.bottom);

      path.lineTo(bodyRect.right, bodyRect.bottom - radius); //右下角
      path.conicTo(bodyRect.right, bodyRect.bottom, bodyRect.right - radius,
          bodyRect.bottom, 1.0);

      path.lineTo(bodyRect.left + radius, bodyRect.bottom); //左下角
      path.conicTo(bodyRect.left, bodyRect.bottom, bodyRect.left,
          bodyRect.bottom - radius, 1.0);

      path.lineTo(bodyRect.left, bodyRect.top + radius); //左上角
      path.conicTo(bodyRect.left, bodyRect.top, bodyRect.left + radius,
          bodyRect.top, 1.0);

      path.lineTo(bodyRect.right - radius, bodyRect.top); //右上角
      path.conicTo(bodyRect.right, bodyRect.top, bodyRect.right,
          bodyRect.top + radius, 1.0);
    } else {
      path.moveTo(arrowRect.left, arrowRect.bottom); //箭头
      path.lineTo(arrowRect.left + arrowRect.width / 2, arrowRect.top);
      path.lineTo(arrowRect.right, arrowRect.bottom);

      path.lineTo(bodyRect.right - radius, bodyRect.top); //右上角
      path.conicTo(bodyRect.right, bodyRect.top, bodyRect.right,
          bodyRect.top + radius, 1.0);

      path.lineTo(bodyRect.right, bodyRect.bottom - radius); //右下角
      path.conicTo(bodyRect.right, bodyRect.bottom, bodyRect.right - radius,
          bodyRect.bottom, 1.0);

      path.lineTo(bodyRect.left + radius, bodyRect.bottom); //左下角
      path.conicTo(bodyRect.left, bodyRect.bottom, bodyRect.left,
          bodyRect.bottom - radius, 1.0);

      path.lineTo(bodyRect.left, bodyRect.top + radius); //左上角
      path.conicTo(bodyRect.left, bodyRect.top, bodyRect.left + radius,
          bodyRect.top, 1.0);
    }
    path.close();
    return path;
  }
}

CupertinoPopoverDirection _calcDirection(
    Rect attachRect, Size size, CupertinoPopoverDirection direction) {
  switch (direction) {
    case CupertinoPopoverDirection.top:
      return (attachRect.top < size.height + CupertinoPopoverState._arrowHeight)
          ? CupertinoPopoverDirection.bottom
          : CupertinoPopoverDirection.top; // 判断顶部位置够不够
    case CupertinoPopoverDirection.bottom:
      return _ScreenUtil.getInstance().screenHeight >
              attachRect.bottom +
                  size.height +
                  CupertinoPopoverState._arrowHeight
          ? CupertinoPopoverDirection.bottom
          : CupertinoPopoverDirection.top;
    case CupertinoPopoverDirection.left:
      return (attachRect.left < size.width + CupertinoPopoverState._arrowHeight)
          ? CupertinoPopoverDirection.right
          : CupertinoPopoverDirection.left; // 判断顶部位置够不够
    case CupertinoPopoverDirection.right:
      return _ScreenUtil.getInstance().screenWidth >
              attachRect.right +
                  size.width +
                  CupertinoPopoverState._arrowHeight
          ? CupertinoPopoverDirection.right
          : CupertinoPopoverDirection.left;
  }
}
