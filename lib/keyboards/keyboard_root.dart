part of cool_ui;

class KeyboardRootWidget extends StatefulWidget {
  final Widget child;
  /// The text direction for this subtree.
  final TextDirection textDirection;

  const KeyboardRootWidget({Key key, this.child, this.textDirection = TextDirection.ltr}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return KeyboardRootState();
  }
}

class KeyboardRootState extends State<KeyboardRootWidget> {
  List<OverlayEntry> _initialEntries = [];

  @override
  void initState() {
    super.initState();

    _initialEntries.add(this.initChild());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: widget.textDirection,
        child: KeyboardMediaQuery(
            child: Overlay(
          initialEntries: _initialEntries,
        )));
  }

  OverlayEntry initChild() {
    return OverlayEntry(builder: (ctx) {
      CoolKeyboard.init(ctx);
      return widget.child;
    });
  }
}
