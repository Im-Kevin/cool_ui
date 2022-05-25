part of cool_ui;

class KeyboardMediaQuery extends StatefulWidget {
  final Widget child;

  KeyboardMediaQuery({required this.child});

  @override
  State<StatefulWidget> createState() => KeyboardMediaQueryState();
}

class KeyboardMediaQueryState extends State<KeyboardMediaQuery> {
  double keyboardHeight = 0;
  ValueNotifier<double> keyboardHeightNotifier =
      CoolKeyboard._keyboardHeightNotifier;

  @override
  void initState() {
    super.initState();
    CoolKeyboard._keyboardHeightNotifier.addListener(onUpdateHeight);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var data = MediaQuery.maybeOf(context);
    if (data == null) {
      data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    }
    var bottom = CoolKeyboard._keyboardHeightNotifier.value != 0
        ? CoolKeyboard._keyboardHeightNotifier.value
        : data.viewInsets.bottom;
    // TODO: implement build
    return MediaQuery(
        child: widget.child,
        data: data.copyWith(
            viewInsets: data.viewInsets.copyWith(bottom: bottom)));
  }

  onUpdateHeight() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() => {});
      SchedulerBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.handleMetricsChanged();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    CoolKeyboard._keyboardHeightNotifier.removeListener(onUpdateHeight);
  }
}
