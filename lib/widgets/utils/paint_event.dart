part of cool_ui;

typedef PaintCallback = void Function(PaintingContext context, Offset offset,Size size);

class PaintEvent extends SingleChildRenderObjectWidget{


  final PaintCallback paintBefore;
  final PaintCallback paintAfter;


  const PaintEvent({
    Key key,
    this.paintBefore,
    this.paintAfter,
    Widget child
  }) :
        super(key: key, child: child);
  @override
  PaintEventProxyBox createRenderObject(BuildContext context) {
    return PaintEventProxyBox(
      paintAfter: paintAfter,
      paintBefore: paintBefore
    );
  }

  @override
  void updateRenderObject(BuildContext context, PaintEventProxyBox renderObject) {
    renderObject..paintAfter = paintBefore
          ..paintAfter = paintAfter;
  }

}


class PaintEventProxyBox extends RenderProxyBox{
  PaintCallback paintBefore;
  PaintCallback paintAfter;

  PaintEventProxyBox({
    RenderBox child,
    this.paintBefore,
    this.paintAfter
  }):super(child);

  @override
  void detach() {
    super.detach();
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(size.width != null);
    assert(size.height != null);

    if(this.paintBefore != null){
      this.paintBefore(context,offset,size);
    }

    super.paint(context, offset);



    if(this.paintAfter != null){
      this.paintAfter(context,offset,size);
    }

  }
}