import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gbanker/widgets/form/badge.dart';
import 'package:intl/intl.dart';

class MemberSearchListTile extends StatefulWidget{

  dynamic member;
  String imgSyncText;
  String sigImgSyncText;
  Color imgSyncColor;
  Color sigImgSyncColor;
  int index;
  Function callback;
  List<Map<String,dynamic>> menus;

  MemberSearchListTile({
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
  State<StatefulWidget> createState()=>_MemberSearchListTile();

}

class _MemberSearchListTile extends State<MemberSearchListTile>{


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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                            width:110,
                            height:130,
                            decoration: BoxDecoration(
                                border: Border.all(color:Colors.black45)
                            ),
                            margin:EdgeInsets.only(top: 8),
                            child:Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0),
                                  child:showImage(member),
                                ))

                        ),
                        Padding(padding:EdgeInsets.only(top:10,right: 10),
                          child: Badge(text: widget.imgSyncText,color:widget.imgSyncColor,isWarning: false,),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                            width:110,
                            height:130,
                            decoration: BoxDecoration(
                                border: Border.all(color:Colors.black45)
                            ),
                            margin:EdgeInsets.only(top: 8),
                            child:Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0),
                                  child:showSigImage(member),
                                ))

                        ),
                        Padding(padding:EdgeInsets.only(top:10,right: 10),
                          child: Badge(text: widget.sigImgSyncText,color:widget.sigImgSyncColor,isWarning: false,),
                        )
                      ],
                    ),
                    Container(
                        width: 75,
                        margin: EdgeInsets.only(left:0),
                        padding: EdgeInsets.only(bottom:75,right:0,left:40),
                        child:Align(
                          alignment: Alignment.topRight,
                          child: PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            onSelected: (value){
                              widget.callback(value,member);
                            },
                            offset:Offset(10,40),
                            itemBuilder: (BuildContext context)=> generatePopup(widget.menus),
                          ),
                        )
                    )
                    ]
                ),

                Container(
                  margin: EdgeInsets.only(left: 5,top:15),
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
                      Text("Samity : ${member['center_name']}",
                        style: TextStyle(
                            fontSize: 13
                        ),),
                      Text("Spouse Name : ${(member['spouse_name'] != null &&
                          member['spouse_name'].toString().length>0)?
                            member['spouse_name']:"N/A"}", style: TextStyle(
                        fontSize: 13,
                      ),),
                      Text("Join Date: ${DateFormat('d MMM y')
                          .format(DateTime.parse(member['admission_date']))}\nCategory: ${member['category_name']}",
                        style: TextStyle(
                            fontSize: 13
                        ),),
                      Text("NID: ${member['nid']}",
                        style: TextStyle(
                            fontSize: 13
                        ),),
                      Text("Present Address: ${member['present_address']}",
                        style: TextStyle(
                            fontSize: 13
                        ),),
                      Text("Contact No: ${member['contact_no']}",
                        style: TextStyle(
                            fontSize: 13
                        ),),
                    ],
                  ),
                ),


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
              width: 180,
              height: 180,)
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

  Widget showSigImage(Map<String, dynamic> member)   {
    //print("HERE"+member['img_path'].toString());
    if(member['sig_img_path'] != null && member['sig_img_path'] != ""){
      bool status = File(member['sig_img_path']).existsSync();
      //print(status);
      if(status){

        return Align(
            alignment:Alignment.center,
            child:Image.file(File(member['sig_img_path']),
              width: 180,
              height: 180,)
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