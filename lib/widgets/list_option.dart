import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListOption extends StatefulWidget{

  List<Map<String,dynamic>> menus;
  Function callback;
  int index;

  ListOption({
    this.index,
    this.menus,
    this.callback
  });


  @override
  State<StatefulWidget> createState() => _ListOptionState();

}

class _ListOptionState extends State<ListOption>{
  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Colors.red,
        width: 35,
        height: 40,

        margin: EdgeInsets.only(left:0),
        padding: EdgeInsets.only(bottom:0,right:5,left:5),
        child:Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value){
              widget.callback(value);
            },
            offset:Offset(0,35),
            itemBuilder: (BuildContext context)=> generatePopup(widget.menus),
          ),
        )
    );

  }

  List<Widget> generatePopup(List<Map<String,dynamic>> menus){
    List<PopupMenuEntry<String>> popups = [];
    menus.forEach((m){
      if(m != null) {
        popups.add(
          PopupMenuItem<String>(
            height: 12,
            value: widget.index.toString() + m['route'],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(m['icon']),
                Text(" " + m['text'])
              ],
            ),
          ),

        );
        popups.add(PopupMenuDivider());
      }
    });
    return popups;
  }

}