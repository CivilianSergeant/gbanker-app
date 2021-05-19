

import 'package:flutter/material.dart';

class AppTitleBar{

  Color bgColor;
  String title="";
  List<Widget> actions;
  double fontSize;
  Widget leadingWidget;

  AppTitleBar({Key key,this.title="gBanker",this.bgColor,this.actions,
  this.fontSize,this.leadingWidget});

  void setTitle(String t){
    this.title =t;
  }

  PreferredSizeWidget build(BuildContext context){
    fontSize = (fontSize!=null)? fontSize : 17;
    return AppBar(
      backgroundColor: this.bgColor,
      title: Text(this.title,style: TextStyle(fontSize: fontSize),),
      centerTitle: true,
      actions: this.actions,
      leading: leadingWidget,
    );
  }
}