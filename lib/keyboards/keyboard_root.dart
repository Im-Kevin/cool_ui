part of cool_ui;

class KeyboardRootWidget extends StatefulWidget {
  final Widget child;

  /// The text direction for this subtree.
  final TextDirection textDirection;

  const KeyboardRootWidget(
      {Key key, this.child, this.textDirection = TextDirection.ltr})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return KeyboardRootState();
  }
}

class KeyboardRootState extends State<KeyboardRootWidget> {
  WidgetBuilder _keyboardbuilder;

  bool get hasKeyboard => _keyboardbuilder != null;
  // List<OverlayEntry> _initialEntries = [];

  @override
  void initState() {
    super.initState();
    // _initialEntries.add(this.initChild());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return KeyboardMediaQuery(child: Builder(builder: (context) {
      CoolKeyboard.init(this, context);

      List<Widget> children = [widget.child];
      if (_keyboardbuilder != null) {
        children.add(Builder(
          builder: _keyboardbuilder,
        ));
      }
      return Directionality(
          textDirection: widget.textDirection,
          child: Stack(
            children: children,
          ));
    }));
  }

  setKeyboard(WidgetBuilder keyboardbuilder) {
    this._keyboardbuilder = keyboardbuilder;
    setState(() {});
  }

  clearKeyboard() {
    if (this._keyboardbuilder != null) {
      this._keyboardbuilder = null;
      setState(() {});
    }
  }
}
