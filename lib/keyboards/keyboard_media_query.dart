part of cool_ui;

class KeyboardMediaQuery extends StatefulWidget{
  final Widget child;

  KeyboardMediaQuery({this.child})
      : assert(child != null);

  @override
  State<StatefulWidget> createState() =>KeyboardMediaQueryState();

}

class KeyboardMediaQueryState extends State<KeyboardMediaQuery >{
  double keyboardHeight;

  @override
  void initState(){
    super.initState();
    CoolKeyboard._keyboardHeightNotifier.addListener(onUpdateHeight);
  }

  @override
  Widget build(BuildContext context) {
    
    // TODO: implement build
    var data = MediaQuery.of(context, nullOk: true);
    if(data == null){
      data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    }
    // TODO: implement build
    return MediaQuery(
        child: widget.child,
        data:data.copyWith(viewInsets: data.viewInsets.copyWith(bottom: CoolKeyboard._keyboardHeightNotifier.value ?? data.viewInsets.bottom))
    );
  }

  onUpdateHeight(){
    try{
      setState(()=>{});
    }catch(_){}
  }

  @override
  void dispose(){
    super.dispose();
    CoolKeyboard._keyboardHeightNotifier.removeListener(onUpdateHeight);
  }
}