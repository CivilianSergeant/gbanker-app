import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gbanker/widgets/form/badge.dart';
import 'package:intl/intl.dart';

class MemberListTile extends StatefulWidget{

  dynamic member;
  String imgSyncText;
  String sigImgSyncText;
  Color imgSyncColor;
  Color sigImgSyncColor;
  int index;
  Function callback;
  List<Map<String,dynamic>> menus;

  MemberListTile({
    this.index,
    this.member,
    this.imgSyncText,
    this.sigImgSyncText,
    this.imgSyncColor,
    this.sigImgSyncColor,
    this.menus,
    this.callback
  });

  @override
  State createState() => _MemberListTileState();
}

class _MemberListTileState extends State<MemberListTile>{


  @override
  Widget build(BuildContext context) {

    var member = widget.member;

    return InkWell(
      onTap: (){

      },
      child: Card(

          margin: EdgeInsets.only(left:5,right:5,top:3,bottom:2),

          child:
          Padding(
            padding:EdgeInsets.only(left:5,bottom: 8),
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width:107,
                    height:130,
                    decoration: BoxDecoration(
                        border: Border.all(color:Colors.black45)
                    ),
                    //color:Colors.black87,
                    margin:EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(left:0),
                        child:showImage(member),
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
//                            color:Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Padding(
                        padding:EdgeInsets.only(top: 5),
                        child:Text("${member['first_name']}",style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16
                        ),),
                      ),
                      Text("Member Code: ${member['member_code']}",
                        style: TextStyle(
                            fontSize: 13
                        ),),
                      Container(
                        width: 155,
                        child:Text('''Samity : ${member['center_name']}''',
                          style: TextStyle(
                              fontSize: 13
                          ),)
                      ),
                      Text("Join Date: ${DateFormat('d MMM y')
                          .format(DateTime.parse(member['admission_date']))}\nCategory: ${member['category_name']}",
                        style: TextStyle(
                            fontSize: 13
                        ),),
                      Text("NID: ${member['nid']}",
                        style: TextStyle(
                            fontSize: 13
                        ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(padding:EdgeInsets.only(top:10,right: 10),
                            child: Badge(text: widget.imgSyncText,color:widget.imgSyncColor,isWarning: false,),
                          ),
                          Padding(padding:EdgeInsets.only(top:10,right: 10),
                            child: Badge(text: widget.sigImgSyncText,color:widget.sigImgSyncColor,isWarning: false,),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
//                            color: Colors.red,
                    width: 75,
                    margin: EdgeInsets.only(left:0),
                    padding: EdgeInsets.only(bottom:75,right:0,left:40),
                    child:Align(
                      alignment: Alignment.topRight,
                      child: (widget.menus.length>0)? PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        onSelected: (value){
                          widget.callback(value,member);
//                          if(value.toString().contains("#camera")) {
//                            Navigator.pushReplacementNamed(context,
//                                "/camera", arguments: member);
//                          }else if(value.toString().contains("#member-approve")){
//                            Navigator.pushReplacementNamed(context,
//                                "/member-approve",arguments:member);
//                          }
                        },
                        offset:Offset(10,40),
                        itemBuilder: (BuildContext context)=> generatePopup(widget.menus),
                      ): SizedBox.shrink(),
                    )
                )

              ],
            ),
          )
      ),
    );
  }

  List<Widget> generatePopup(List<Map<String,dynamic>> menus){
    List<PopupMenuEntry<String>> popups = [];
    menus.forEach((m){
      popups.add(
          PopupMenuItem<String>(
            height: 12,
            value: widget.index.toString()+m['route'],
            child: Row(
              children: <Widget>[
                Icon(m['icon']),
                Text(m['text'])
              ],
            ),
          )
      );
    });
    return popups;
  }

  Widget showImage(Map<String, dynamic> member)   {
    //print("HERE"+member['img_path'].toString());
    if(member['img_path'] != null && member['img_path'] != ""){
      bool status = File(member['img_path']).existsSync();
      //print(status);
      if(status){

        return Align(
            alignment:Alignment.center,
            child:Image.file(File(member['img_path']),
              width: 80,
              height: 80,)
        );
      }else{
        return Center(child:Image(
          image:AssetImage("images/avatar.png"),
          width: 80,
          height: 80,
        ));
      }
    }else{
      return Center(child:Image(
        image:AssetImage("images/avatar.png"),
        width:90,
        height: 70,
      ));
    }
  }

}