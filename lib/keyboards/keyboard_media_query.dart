part of cool_ui;

class KeyboardMediaQuery extends StatefulWidget{
  final Widget child;

  KeyboardMediaQuery({this.child})
      : assert(child != null);

  @override
  State<StatefulWidget> createState() =>KeyboardMediaQueryState();

}

class KeyboardMediaQueryState extends State<KeyboardMediaQuery >{
  @override
  Widget build(BuildContext context) {
    
    // TODO: implement build
    var data = MediaQuery.of(context);
    print('KeyboardMediaQuery${CoolKeyboard.keyboardHeight}');
    // TODO: implement build
    return MediaQuery(
        child: widget.child,
        data:data.copyWith(viewInsets: data.viewInsets.copyWith(bottom: CoolKeyboard.keyboardHeight))
    );
  }

  update(){
    setState(()=>{});
  }
}