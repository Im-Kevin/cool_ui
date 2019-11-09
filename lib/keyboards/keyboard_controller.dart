part of cool_ui;

class KeyboardController extends ValueNotifier<TextEditingValue>{
  final InputClient client;

  KeyboardController({TextEditingValue value,this.client})
      : super(value == null ? TextEditingValue.empty : value);


  /// The current string the user is editing.
  String get text => value.text;
  /// Setting this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this value should only be set between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  set text(String newText) {
    value = value.copyWith(text: newText,
        selection: const TextSelection.collapsed(offset: -1),
        composing: TextRange.empty);
  }

  /// The currently selected [text].
  ///
  /// If the selection is collapsed, then this property gives the offset of the
  /// cursor within the text.
  TextSelection get selection => value.selection;
  /// Setting this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this value should only be set between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  set selection(TextSelection newSelection) {
    if (newSelection.start > text.length || newSelection.end > text.length)
      throw FlutterError('invalid text selection: $newSelection');
    value = value.copyWith(selection: newSelection, composing: TextRange.empty);
  }

  set value(TextEditingValue newValue) {

    newValue = newValue.copyWith(  // 修正由于默认值导致的Bug
      composing: TextRange(
          start: newValue.composing.start < 0 ? 0: newValue.composing.start,
          end: newValue.composing.end < 0 ? 0: newValue.composing.end
      ),
      selection: newValue.selection.copyWith(
        baseOffset: newValue.selection.baseOffset < 0 ? 0: newValue.selection.baseOffset,
        extentOffset: newValue.selection.extentOffset < 0 ? 0: newValue.selection.extentOffset
      )
    );

    super.value = newValue;
  }

  /// Set the [value] to empty.
  ///
  /// After calling this function, [text] will be the empty string and the
  /// selection will be invalid.
  ///
  /// Calling this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this method should only be called between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  void clear() {
    value = TextEditingValue.empty;
  }

  /// Set the composing region to an empty range.
  ///
  /// The composing region is the range of text that is still being composed.
  /// Calling this function indicates that the user is done composing that
  /// region.
  ///
  /// Calling this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this method should only be called between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  clearComposing() {
    value = value.copyWith(composing: TextRange.empty);
  }
  ///删除一个字符,一般用于键盘的删除键
  deleteOne(){
    if(selection.baseOffset == 0)
      return;
    String newText = '';
    if(selection.baseOffset != selection.extentOffset)
    {
      newText = selection.textBefore(text)  + selection.textAfter(text);
      value = TextEditingValue(
          text: newText,
          selection: selection.copyWith(
              baseOffset:selection.baseOffset,
              extentOffset: selection.baseOffset)
      );
    }else{
      newText = text.substring(0,selection.baseOffset - 1) + selection.textAfter(text);
      value = TextEditingValue(
          text: newText,
          selection: selection.copyWith(
              baseOffset:selection.baseOffset - 1,
              extentOffset: selection.baseOffset - 1)
      );
    }
  }

  /// 在光标位置添加文字,一般用于键盘输入
  addText(String insertText){
    String newText = selection.textBefore(text) + insertText + selection.textAfter(text);
    value = TextEditingValue(
        text: newText,
        selection: selection.copyWith(
            baseOffset:selection.baseOffset + insertText.length,
            extentOffset: selection.baseOffset + insertText.length)
    );
  }

  /// 完成
  doneAction(){
    CoolKeyboard.sendPerformAction(TextInputAction.done);
  }

  /// 下一个
  nextAction(){
    CoolKeyboard.sendPerformAction(TextInputAction.next);
  }

  /// 换行
  newLineAction(){
    CoolKeyboard.sendPerformAction(TextInputAction.newline);
  }

  ///发送其他Action
  sendPerformAction(TextInputAction action){
    CoolKeyboard.sendPerformAction(action);
  }
}