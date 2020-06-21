import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofaio/models/navigation_model.dart';
import 'package:sofaio/common/CollapsinList.dart';
import 'package:sofaio/models/theme.dart';
import 'package:sofaio/pages/login_signup_page.dart';

class CollapsingNavigationDrawer extends StatefulWidget {
  @override
  CollapsingNavigationDrawerState createState() {
    return new CollapsingNavigationDrawerState();
  }
}

class CollapsingNavigationDrawerState
    extends State<CollapsingNavigationDrawer> with SingleTickerProviderStateMixin{
  double maxWidth = 250.0;
  double minWidth = 70.0;
  bool isColapsed = false;
  AnimationController animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = 0;


  @override
  void initState(){
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    widthAnimation = Tween<double> (begin: maxWidth, end: minWidth).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedBuilder(
      animation: animationController, builder: (context, widget) => getWidget(context, widget),);
  }

  Widget getWidget(context, widget) {
    return Material(//3d effect
      elevation: 80.0,
      child: Container(//drawer container
          color: drawerBackgroundColor,
          width: widthAnimation.value,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50.0,),//giving space on top
              CollapsingList(//account details
                  title: "Giriraj Parihar",
                  icon: Icons.person,
                  animationController: animationController,
              ),
              Divider(color: Colors.grey, height: 40.0),//divider
              Expanded(
                child: ListView.separated(//list view divider for all tabs
                  separatorBuilder: (context, counter){
                    return Divider( height: 12.0);
                  },
                  itemBuilder: (context, counter) {//list view of all tabs
                    return CollapsingList(
                        onTap: () {
                          setState(() {
                            currentSelectedIndex = counter;//ontap color
                          });
                        },
                        isSelected: currentSelectedIndex == counter,
                        title: navigationItem[counter].title,
                        icon: navigationItem[counter].icon,
                        animationController: animationController,//animation for drawer
                    );

                  },
                  itemCount: navigationItem.length,
                ),
              ),
              Divider(color: Colors.grey, height: 40.0),//divider
              InkWell(
                onTap: (){
                  setState(() {

                    isColapsed = ! isColapsed;
                    isColapsed
                        ? animationController.forward()
                        : animationController.reverse();

                  });
                },

                child: AnimatedIcon(
                  icon: AnimatedIcons.close_menu,
                  progress: animationController,
                  color: Colors.white30,
                  size: 50.0,
                ),
              ),
              SizedBox(height: 50.0,)

            ],
          )),
    );
  }
}
