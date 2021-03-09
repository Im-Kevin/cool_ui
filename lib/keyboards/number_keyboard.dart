part of cool_ui;

class NumberKeyboard extends StatelessWidget{
  static const CKTextInputType inputType = const CKTextInputType(name:'CKNumberKeyboard');
  static double getHeight(BuildContext ctx){
    MediaQueryData mediaQuery = MediaQuery.of(ctx);
    return mediaQuery.size.width / 3 / 2 * 4;
  }
  final KeyboardController controller ;
  const NumberKeyboard({required this.controller});

  static register(){
    CoolKeyboard.addKeyboard(NumberKeyboard.inputType,KeyboardConfig(builder: (context,controller, params){
      return NumberKeyboard(controller: controller);
    },getHeight: NumberKeyboard.getHeight));
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Material(
      child: DefaultTextStyle(style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 23.0), child: Container(
        height:getHeight(context),
        width: mediaQuery.size.width,
        decoration: BoxDecoration(
          color: Color(0xffafafaf),
        ),
        child: GridView.count(
            childAspectRatio: 2/1,
            mainAxisSpacing:0.5,
            crossAxisSpacing:0.5,
            padding: EdgeInsets.all(0.0),
            crossAxisCount: 3,
            children: <Widget>[
              buildButton('1'),
              buildButton('2'),
              buildButton('3'),
              buildButton('4'),
              buildButton('5'),
              buildButton('6'),
              buildButton('7'),
              buildButton('8'),
              buildButton('9'),
              Container(
                color: Color(0xFFd3d6dd),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Center(child: Icon(Icons.expand_more),),
                  onTap: (){
                    controller.doneAction();
                  },
                ),
              ),
              buildButton('0'),
              Container(
                color: Color(0xFFd3d6dd),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Center(child: Text('X'),),
                  onTap: (){
                    controller.deleteOne();
                  },
                ),
              ),
            ]),
      )),
    );
  }

  Widget buildButton(String title,{String? value}){
    return Container(
      color: Colors.white,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Center(child: Text(title),),
        onTap: (){
          controller.addText(value ?? title);
        },
      ),
    );
  }
}


