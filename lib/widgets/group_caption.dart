import 'package:flutter/material.dart';

class GroupCaption extends StatefulWidget{
  String caption;
  double size;
  bool showDiverder;
  GroupCaption({this.caption,this.size,this.showDiverder});

  @override
  State<StatefulWidget> createState() => GroupCaptionState();

}

class GroupCaptionState extends State<GroupCaption>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(widget.caption,style: TextStyle(
                color: Colors.black54,
                fontSize: (widget.size != null)? widget.size : 18,
                fontWeight: FontWeight.w800
            ),),
          ),
        ),
        showDivider()
      ],
    );
  }

  Widget showDivider(){
    if(widget.showDiverder != null && widget.showDiverder == true){
      return SizedBox(
        width: MediaQuery.of(context).size.width-20,
        child: Divider(),
      );
    }
    return SizedBox.shrink();
  }

}