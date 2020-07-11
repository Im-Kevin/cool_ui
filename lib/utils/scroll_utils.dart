part of cool_ui;

connectScroll(ScrollController scroll1, ScrollController scroll2){
  scroll1.addListener(() {
    if(scroll2.offset != scroll1.offset){
      scroll2.jumpTo(scroll1.offset);
    }
  });  
  scroll2.addListener(() {
    if(scroll1.offset != scroll2.offset){
      scroll1.jumpTo(scroll2.offset);
    }
  });  
}
