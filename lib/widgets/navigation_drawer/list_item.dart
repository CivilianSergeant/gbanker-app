
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget{

  IconData icon;
  Color iconColor;
  String text;
  Color textColor;
  Function callback;
  String name;

  ListItem({this.name,this.icon,this.iconColor,this.text,this.textColor,this.callback});

  @override
  Widget build(BuildContext context) {

    return Container(

      height: 60,
      child:Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(0),
            child: ListTile(
              onTap: (){
                if(callback != null){
                  callback(context,name);
                }
              },
              leading: Icon(this.icon),
              title: Text(this.text),
            )
          )
        ],
      )
    );
  }

}