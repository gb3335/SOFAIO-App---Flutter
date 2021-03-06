import 'package:flutter/material.dart';
import 'package:sofaio/models/theme.dart';

class CollapsingList extends StatefulWidget{
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;

  CollapsingList({@required this.title, @required this.icon, @required this.animationController, this.isSelected =false, this.onTap});
  @override
  CollapsingListState createState() {
    return new CollapsingListState();
  }
}

class CollapsingListState extends State<CollapsingList> {
  Animation<double> widthAnimation, sizeBoxAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widthAnimation = Tween<double> (begin: 250.0, end: 70.0).animate(widget.animationController);
    sizeBoxAnimation = Tween<double> (begin: 10.0, end: 0.0).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: widget.isSelected? Colors.transparent.withOpacity(0.3): Colors.transparent,
        ),
        width: widthAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(
              widget.icon,
              color: widget.isSelected? selectedColor: Colors.white30,
              size: 38.0,
            ),
            SizedBox(width: sizeBoxAnimation.value),
            (widthAnimation.value >=220)
              ?Text(widget.title, style: widget.isSelected
                ? listTitleSelectedTextStyle
                : listTitleDefaultTextStyle,)
              :Container()
          ],
        ),
      ),
    );
  }
}