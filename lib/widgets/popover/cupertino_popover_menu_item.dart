part of cool_ui;

class CupertinoPopoverMenuList extends StatelessWidget {
  final List<Widget> children;
  const CupertinoPopoverMenuList({this.children});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: children.length * 2 - 1,
      shrinkWrap: true,
      itemBuilder: (context, int i) {
        if (i.isOdd) {
          // 在每一列之前，添加一个1像素高的分隔线widget
          return const Divider(
            height: 1.0,
          );
        }
        final int index = i ~/ 2;
        return children[index];
      },
      padding: EdgeInsets.all(0.0),
    );
  }
}

class CupertinoPopoverMenuItem extends StatefulWidget {
  final Widget leading;
  final Widget child;
  final BoolCallback onTap;
  final bool isTapClosePopover;
  final Color activeBackground;
  final Color background;

  const CupertinoPopoverMenuItem(
      {this.leading,
      this.child,
      this.onTap,
      this.background = Colors.white,
      this.activeBackground = const Color(0xFFd9d9d9),
      this.isTapClosePopover = true});

  @override
  State<StatefulWidget> createState() => CupertinoPopoverMenuItemState();
}

class CupertinoPopoverMenuItemState extends State<CupertinoPopoverMenuItem> {
  bool isDown = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    if (widget.leading != null) {
      widgets.add(Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        width: 35.0,
        height: 35.0,
        child: IconTheme(
            data: IconThemeData(color: Color(0xff007aff), size: 20.0),
            child: widget.leading),
      ));
    }
    widgets.add(Expanded(
        child: DefaultTextStyle(
            style: TextStyle(color: Color(0xff007aff), fontSize: 17.0),
            child: widget.child)));
    return GestureDetector(
      onTapDown: (detail) {
        setState(() {
          isDown = true;
        });
      },
      onTapUp: (detail) {
        if (isDown) {
          setState(() {
            isDown = false;
          });
          if (widget.onTap != null && widget.onTap()) {
            return;
          }
          if (widget.isTapClosePopover) {
            Navigator.of(context).pop();
          }
        }
      },
      onTapCancel: () {
        if (isDown) {
          setState(() {
            isDown = false;
          });
        }
      },
      child: Container(
        color: isDown ? widget.activeBackground : widget.background,
        child: Padding(
          padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
          child: Row(children: widgets),
        ),
      ),
    );
  }
}
