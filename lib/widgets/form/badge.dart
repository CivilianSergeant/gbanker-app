import 'package:flutter/material.dart';

class Badge extends StatefulWidget{

  String text;
  Color color;
  bool isWarning;
  Badge({this.text,this.color,this.isWarning});

  @override
  State<StatefulWidget> createState() => _BadgeState();

}

class _BadgeState extends State<Badge>{
  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        color: widget.color,
      ),

      child: Text(widget.text,style:TextStyle(
        fontSize: 8,
       fontWeight: FontWeight.bold,
       color: Colors.white
      ),),
    );
  }




}