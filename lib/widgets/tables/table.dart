part of cool_ui;

class CoolTable extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CoolTableState();
  }
}

class CoolTableState extends State<CoolTable>{
  ScrollController hTitle = ScrollController();
  ScrollController hBody = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectScroll(hTitle, hBody);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 50,
          child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          controller: hTitle,
          children: <Widget>[
            Text('1111111111111111111111111111111111111111111111111111111111111111111111111111')
          ],
        ),
        width: 375,),
        SizedBox(
          height: 50,
          child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: hBody,
          shrinkWrap: true,
          children: <Widget>[
            Text('1111111111111111111111111111111111111111111111111111111111111111111111111111')
          ],
        )),
      ],
    );
  }
}

class CoolColumnInfo{
  final double flex;
  final double width;
  final Widget title;

  const CoolColumnInfo({this.flex, this.width, this.title});
}