import 'package:flutter/material.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/services/member_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/custom_dialog.dart';
import 'package:gbanker/widgets/members/member_list_tile.dart';
import 'package:gbanker/widgets/members/member_search_list_title.dart';
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
class MemberApprovalListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MemberApprovalListScreenState();

}

class _MemberApprovalListScreenState extends State<MemberApprovalListScreen>{

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  int itemCount = 0;
  List<Map<String,dynamic>> members = [];
  List<Map<String,dynamic>> tempMembers = [];
  TextEditingController searchField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(bgColor: ColorList.Colors.primaryColor,
        title: "Member Approvals",
        actions: [
          Padding(
              padding: EdgeInsets.only(left: 10),
              child:InkWell(

                child: (tempMembers.length>0)? Icon(Icons.clear) : Icon(Icons.search),
                onTap: ()async{
                  if(tempMembers.length>0){
                    setState(() {
                      members = tempMembers;
                      itemCount = members.length;
                      tempMembers=[];
                    });
                  }else {
                    searchField.text = "";
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(searchField: searchField,
                            searchMemberCodeCallback: this.searchSubmit,);
                        });
                  }
                },
              )
          ),
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              offset:Offset(10,40),
              onSelected: (value){
                if(value==1){
                  _refreshIndicatorKey.currentState?.show();
                }
              },
              itemBuilder: (BuildContext context)=><PopupMenuEntry<int>>[
                PopupMenuItem(
                  height: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.refresh,color: Colors.black54,),
                      Text(" Refresh Members")
                    ],
                  ),
                  value: 1,
                ),
              ]
          )
        ]
    );
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/home");
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
        appBar: appTitleBar.build(context),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          child: Container(
            child: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context,i){
                var member = members[i];
                if(tempMembers != null && tempMembers.length > 0){
                  return searchResultListView(i, member);
                }
                return generalListView(i, member);
              }
            )
          ),
          onRefresh: () async {
            loadMemberList();
            return true;
          },
        ),
        drawer: SafeArea(child:NavigationDrawer()),
      ),
    );
  }

  Widget generalListView(int i, dynamic member){
    String imgSyncText = (member['img_sync']==1)? "Photo sync" : "Photo not sync";
    String sigImgSyncText = (member['sig_img_sync']==1)?
    "Signature Sync": "Signature not sync";
    Color imgSyncColor = (member['img_sync']==1)? Colors.green : Colors.red;
    Color sigImgSyncColor = (member['sig_img_sync']==1)? Colors.green : Colors.red;

    return MemberListTile(
      index: i,
      member: member,
      imgSyncText: imgSyncText,
      imgSyncColor: imgSyncColor,
      sigImgSyncText: sigImgSyncText,
      sigImgSyncColor: sigImgSyncColor,
      menus: [{"text":"Approve","icon":Icons.touch_app,
        "route":"#member-approve"}],
      callback: handleListOption,
    );
  }

  Widget searchResultListView(int i, dynamic member){
    String imgSyncText = (member['img_sync']==1)? "Photo sync" : "Photo not sync";
    String sigImgSyncText = (member['sig_img_sync']==1)?
    "Signature Sync": "Signature not sync";
    Color imgSyncColor = (member['img_sync']==1)? Colors.green : Colors.red;
    Color sigImgSyncColor = (member['sig_img_sync']==1)? Colors.green : Colors.red;

    return MemberSearchListTile(
      index: i,
      member: member,
      imgSyncText: imgSyncText,
      imgSyncColor: imgSyncColor,
      sigImgSyncText: sigImgSyncText,
      sigImgSyncColor: sigImgSyncColor,
      menus: [{"text":"Approve","icon":Icons.touch_app,
        "route":"#member-approve"}],
      callback: handleListOption,
    );
  }

  void searchSubmit(String memberCode) async {
    bool found = false;
    int i=0;
    List<Map<String,dynamic>> _members = await MemberService.searchMemberByCode(memberCode);
    tempMembers = members;
    setState(() {
      if(_members !=null && _members.length>0){
        members = _members;
        itemCount = members.length;
      }

    });


    if(_members == null || _members.length==0){
      showErrorMessage("Member Not found with Code [${memberCode}]", context);
    }

    Navigator.of(context).pop();

  }

  void handleListOption(value,member){
    if(value.toString().contains("#member-approve")){
      Navigator.pushReplacementNamed(context,
          "/member-approve",arguments:{"id":member['id'],"memberCode":member['member_code']});
    }
  }

  Future<void> loadMemberList() async{

    var _members = await MemberService.getMemberList(memberStatus: 0);

    if(mounted) {
      setState(() {
        itemCount = _members.length;
        members = _members;
        tempMembers = [];
      });
    }
  }

  @override
  void initState() {
    loadMemberList();
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  }
}