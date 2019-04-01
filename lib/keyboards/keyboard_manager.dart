part of cool_ui;


typedef GetKeyboardHeight = double Function(BuildContext context);
typedef KeyboardBuilder = Widget Function(BuildContext context,KeyboardController controller);

class CoolKeyboard {
  static JSONMethodCodec _codec = const JSONMethodCodec();
  static KeyboardConfig _currentKeyboard;
  static Map<CKTextInputType,KeyboardConfig> _keyboards = {};
  static BuildContext _context;
  static OverlayEntry _keyboardEntry;
  static KeyboardController _keyboardController;
  static GlobalKey<KeyboardPageState> _pageKey;
  static bool isInterceptor = false;

  static double get keyboardHeight =>_keyboardHeight;
  static double _keyboardHeight;


  static init(BuildContext context){
    _context = context;
    interceptorInput();
  }

  static interceptorInput(){
    if(isInterceptor)
      return;
    isInterceptor = true;
    BinaryMessages.setMockMessageHandler("flutter/textinput", (ByteData data) async{
      var methodCall = _codec.decodeMethodCall(data);
      switch(methodCall.method){
        case 'TextInput.show':
          if(_currentKeyboard != null){
            openKeyboard();
            return _codec.encodeSuccessEnvelope(null);
          }else{
            return await _sendPlatformMessage("flutter/textinput", data);
          }
          break;
        case 'TextInput.hide':
          if(_currentKeyboard != null){
            hideKeyboard();
            return _codec.encodeSuccessEnvelope(null);
          }else{
            return await _sendPlatformMessage("flutter/textinput", data);
          }
          break;
        case 'TextInput.setEditingState':
          var editingState =  TextEditingValue.fromJSON(methodCall.arguments);
          if(editingState != null && _keyboardController != null){
            _keyboardController.value = editingState;
            return _codec.encodeSuccessEnvelope(null);
          }
          break;
        case 'TextInput.clearClient':
          hideKeyboard(animation:true);
          clearKeyboard();
          break;
        case 'TextInput.setClient':
          var setInputType = methodCall.arguments[1]['inputType'];
          InputClient client;
          _keyboards.forEach((inputType,keyboardConfig){
            if(inputType.name == setInputType['name']){
              client = InputClient.fromJSON(methodCall.arguments);
              clearKeyboard();
              _currentKeyboard = keyboardConfig;
              _keyboardController = KeyboardController(client:client)..addListener((){
                var callbackMethodCall = MethodCall("TextInputClient.updateEditingState",[
                                                    _keyboardController.client.connectionId,
                                                    _keyboardController.value.toJSON()]);
                BinaryMessages.handlePlatformMessage("flutter/textinput", _codec.encodeMethodCall(callbackMethodCall), (data){

                });
              });
            }
          });
          if(client != null){
            await _sendPlatformMessage("flutter/textinput", _codec.encodeMethodCall(MethodCall('TextInput.hide')));
            return _codec.encodeSuccessEnvelope(null);
          }else{
            hideKeyboard(animation:false);
            clearKeyboard();
          }
          break;
      }
      ByteData response =  await _sendPlatformMessage("flutter/textinput", data);
      return response;
    });
  }

  static Future<ByteData> _sendPlatformMessage(String channel, ByteData message) {
    final Completer<ByteData> completer = Completer<ByteData>();
    ui.window.sendPlatformMessage(channel, message, (ByteData reply) {
      try {
        completer.complete(reply);
      } catch (exception, stack) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'services library',
          context: 'during a platform message response callback',
        ));
      }
    });
    return completer.future;
  }

  static addKeyboard(CKTextInputType inputType,KeyboardConfig config){
    _keyboards[inputType] = config;
  }

  static openKeyboard(){
    if(_keyboardEntry != null)
      return;
    _pageKey = GlobalKey<KeyboardPageState>();
    _keyboardHeight = _currentKeyboard.getHeight(_context);
    KeyboardMediaQueryState queryState = _context.ancestorStateOfType(const TypeMatcher<KeyboardMediaQueryState>()) as  KeyboardMediaQueryState;
    queryState.update();

    var tempKey = _pageKey;
    _keyboardEntry = OverlayEntry(builder: (ctx) {
      if(_currentKeyboard != null && _keyboardHeight != null)
      {
        return  KeyboardPage(
            key: tempKey,
            child: Builder(builder: (ctx){
              return _currentKeyboard.builder(ctx,_keyboardController);
            }),
            height:_keyboardHeight
        );
      }else{
        return Container();
      }
    });

    Overlay.of(_context).insert(_keyboardEntry);
  }

  static hideKeyboard({bool animation=true}){
    if(_keyboardEntry != null && _pageKey != null) {
      _keyboardHeight = null;
      _pageKey.currentState.animationController.addStatusListener((status) {
        if (status == AnimationStatus.dismissed ||
            status == AnimationStatus.completed) {
          if (_keyboardEntry != null) {
            _keyboardEntry.remove();
            _keyboardEntry = null;
          }
        }
      });
      if (animation)
      {
        _pageKey.currentState.exitKeyboard();
      }
      else{
        _keyboardEntry.remove();
        _keyboardEntry = null;
      }
    }
    _pageKey = null;

    KeyboardMediaQueryState queryState = _context.ancestorStateOfType(const TypeMatcher<KeyboardMediaQueryState>()) as  KeyboardMediaQueryState;
    queryState.update();
  }

  static clearKeyboard(){
    _currentKeyboard = null;
    if(_keyboardController != null){
      _keyboardController.dispose();
      _keyboardController = null;
    }
  }

  static sendPerformAction(TextInputAction action){
    var callbackMethodCall = MethodCall("TextInputClient.performAction",
        [
          _keyboardController.client.connectionId,
          action.toString()
        ]);
    BinaryMessages.handlePlatformMessage(
        "flutter/textinput", _codec.encodeMethodCall(callbackMethodCall), (
        data) {});
  }

}

class KeyboardConfig{
  final KeyboardBuilder builder;
  final GetKeyboardHeight getHeight;
  const KeyboardConfig({this.builder,this.getHeight});
}

class InputClient{
  final int connectionId;
  final  TextInputConfiguration configuration;
  const InputClient({this.connectionId,this.configuration});

  factory InputClient.fromJSON(List<dynamic> encoded) {
    return InputClient(connectionId: encoded[0],configuration: TextInputConfiguration(
        inputType:CKTextInputType.fromJSON(encoded[1]['inputType']),
        obscureText:encoded[1]['obscureText'],
        autocorrect:encoded[1]['autocorrect'],
        actionLabel:encoded[1]['actionLabel'],
        inputAction:_toTextInputAction(encoded[1]['inputAction']),
        textCapitalization:_toTextCapitalization(encoded[1]['textCapitalization']),
        keyboardAppearance:_toBrightness(encoded[1]['keyboardAppearance'])

    ));
  }


  static TextInputAction _toTextInputAction(String action) {
    switch (action) {
      case 'TextInputAction.none':
        return TextInputAction.none;
      case 'TextInputAction.unspecified':
        return TextInputAction.unspecified;
      case 'TextInputAction.go':
        return TextInputAction.go;
      case 'TextInputAction.search':
        return TextInputAction.search;
      case 'TextInputAction.send':
        return TextInputAction.send;
      case 'TextInputAction.next':
        return TextInputAction.next;
      case 'TextInputAction.previuos':
        return TextInputAction.previous;
      case 'TextInputAction.continue_action':
        return TextInputAction.continueAction;
      case 'TextInputAction.join':
        return TextInputAction.join;
      case 'TextInputAction.route':
        return TextInputAction.route;
      case 'TextInputAction.emergencyCall':
        return TextInputAction.emergencyCall;
      case 'TextInputAction.done':
        return TextInputAction.done;
      case 'TextInputAction.newline':
        return TextInputAction.newline;
    }
    throw FlutterError('Unknown text input action: $action');
  }


  static TextCapitalization _toTextCapitalization(String capitalization){
    switch(capitalization){
      case 'TextCapitalization.none':
        return TextCapitalization.none;
      case 'TextCapitalization.characters':
        return TextCapitalization.characters;
      case 'TextCapitalization.sentences':
        return TextCapitalization.sentences;
      case 'TextCapitalization.words':
        return TextCapitalization.words;
    }

    throw FlutterError('Unknown text capitalization: $capitalization');
  }

  static Brightness _toBrightness(String brightness){
    switch(brightness){
      case 'Brightness.dark':
        return Brightness.dark;
      case 'Brightness.light':
        return Brightness.light;
    }

    throw FlutterError('Unknown Brightness: $brightness');
  }
}

class CKTextInputType extends TextInputType{
  final String name;

  const CKTextInputType({this.name,bool signed,bool decimal}) : super.numberWithOptions(signed:signed,decimal:decimal);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'signed': signed,
      'decimal': decimal,
    };
  }

  factory CKTextInputType.fromJSON(Map<String,dynamic> encoded) {
    return CKTextInputType(
        name: encoded['name'],
        signed: encoded['signed'],
        decimal: encoded['decimal']
    );
  }
}

class KeyboardPage extends StatefulWidget{
  final Widget child;
  final double height;
  const KeyboardPage({this.child,this.height,Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() =>KeyboardPageState();

}

class KeyboardPageState extends State<KeyboardPage> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  Animation<double> doubleAnimation;
  double bottom;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = new AnimationController(duration: new Duration(milliseconds: 100),vsync: this)
      ..addListener(()=>setState((){}));
    doubleAnimation =
    new Tween(begin: 0.0, end: widget.height).animate(animationController)..addListener(()=>setState((){}));
    animationController.forward(from:0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: IntrinsicHeight(
            child: widget.child
        ),
        bottom: (widget.height - doubleAnimation.value) * -1
    );
  }


  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  exitKeyboard(){
    animationController.reverse();
  }
}


