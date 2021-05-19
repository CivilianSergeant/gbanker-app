import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/entities/MemberType.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/services/member_service.dart';
import 'package:gbanker/persistance/services/member_type_service.dart';
import 'package:gbanker/persistance/services/network_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'dart:io';

import 'package:intl/intl.dart';

class MemberApproveScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MemberApproveScreenState();

}

class _MemberApproveScreenState extends State<MemberApproveScreen>{

  Map<String,dynamic> member;
  List<dynamic> products = [];
  List<int> productCheckboxStatus = [];
  List<MemberType> memberTypes = [];
  bool netStatus;
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(bgColor: ColorList.Colors.primaryColor,
      title: "Member Approve",
      leadingWidget: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () async {
          Navigator.of(context).pushReplacementNamed("/member-approvals");
          return false;
        },
      )
    );
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed("/member-approvals");
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
        appBar: appTitleBar.build(context),
        body: SingleChildScrollView(
          child:(member == null || member.length==0)?
          Container(
            height: MediaQuery.of(context).size.height-10,
            child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                )
            )
          )
              :
          Column(
            children: <Widget>[
              showNetStatus(),
              showBasicInfo(),
              showPresentAddressInfo(),
              showPermanentAddressInfo(),
              showIdentificationInfo(),
              showOtherInformation(),
              showSignature(),
              showApprovalProductList()

            ],
          )
        ),
      ),
    );
  }

  @override
  void initState() {
    loadMemberTypes();
  }

  Widget memberThumbnail(){
    return Container(
        width:110,
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
            child:showImage(member,'img_path',false),
          ),
        )
    );
  }

  Widget showImage(Map<String, dynamic> member, String path, bool isSignature)   {

    if(member[path] != null && member[path] != ""){
      bool status = File(member[path]).existsSync();

      if(status){

        return Align(
            alignment:Alignment.center,
            child:Image.file(File(member[path]),
              width: 80,
              height: 80,)
        );
      }else{
        return Center(child:
        (isSignature)? Text("No Signature found") : Image(
          image:AssetImage("images/avatar.png"),
          width: 80,
          height: 80,
        ));
      }
    }else{
      return Center(
          child:(isSignature)? Text("No Signature found") : Image(
        image:AssetImage("images/avatar.png"),
        width:80,
        height: 80,
      ));
    }
  }

  Widget showPresentAddressInfo(){
    return Card(
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom:5),
                  child: Text("PRESENT ADDRESS",
                    style:TextStyle(
                        fontWeight: FontWeight.bold
                    ) ,),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Country",style: TextStyle(
                      color: Colors.black54
                    ),),
                    Text("${member['country_name']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Division",style: TextStyle(
                      color: Colors.black54
                    ),),
                    Text("${member['division_name']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("District",style: TextStyle(
                      color: Colors.black54
                    ),),
                    Text("${member['district_name']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Upozilla",style: TextStyle(
                      color: Colors.black54
                    ),),
                    Text("${member['sub_district_name']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Union",style: TextStyle(
                      color:Colors.black54
                    ),),
                    Text("${member['union_name']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Village",style: TextStyle(
                      color:Colors.black54
                    ),),
                    Text("${member['village_name']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Address",style: TextStyle(
                      color:Colors.black54
                    ),),
                    Text("${member['present_address']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Zip Code",style: TextStyle(
                      color: Colors.black54
                    ),),
                    Text("${member['zip_code']}")
                  ],
                )
              ],
            )
        )
    );
  }

  Widget showNetStatus(){
    return (netStatus) ?
        SizedBox.shrink() :
        Card(
          elevation: 2.5,
          margin: EdgeInsets.all(5),
          color: Colors.red,
          child: Padding(
            padding: EdgeInsets.all(5),
            child:Text("Sorry! Internet Required To Approve. "
              "Make sure you have internet connection available",
          style: TextStyle(color: Colors.white),),
        ));
  }

  Widget showPermanentAddressInfo(){
    return Card(
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text("PERMANENT ADDRESS",
                    style:TextStyle(
                        fontWeight: FontWeight.bold
                    ) ,),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Country",style: TextStyle(
                      color: Colors.black54
                    ),),
                    Text("${member['per_country_name']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Division",style: TextStyle(
                      color: Colors.black54
                    ),),
                    Text("${member['per_division_name']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("District",style: TextStyle(
                      color: Colors.black54
                    ),),
                    Text("${member['per_district_name']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Upozilla",style: TextStyle(
                      color:Colors.black54
                    ),),
                    Text("${member['per_sub_district_name']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Union",style: TextStyle(
                      color:Colors.black54
                    ),),
                    Text("${member['per_union_name']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start  ,
                  children: <Widget>[
                    Text("Village",style: TextStyle(
                      color:Colors.black54
                    ),),
                    Text("${member['per_village_name']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Address",style: TextStyle(
                      color: Colors.black54
                    ),),
                    Text("${member['permanent_address']}")
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Zip Code",style: TextStyle(
                      color:Colors.black54
                    ),),
                    Text("${member['per_zip_code']}")
                  ],
                )
              ],
            )
        )
    );
  }

  @override
  void didChangeDependencies() {


    Map<String,dynamic> args = ModalRoute.of(context).settings.arguments;
    if(args['memberCode'] == null){
      Navigator.of(context).pushReplacementNamed("/member-approvals");
    }else{
      loadMemberInfo(args['memberCode']);
    }

  }

  void loadMemberInfo(String memberCode) async {

    var _netStatus =  await NetworkService.check();

    setState(() {
     netStatus = _netStatus;
    });

    var _member = await MemberService.findMemberByCode(memberCode);
    if(_netStatus){
      int memberId = int.parse(_member['memberRemoteId'].toString());

      dynamic fetchResult = await MemberService.getApprovalProductsFromServer(memberId);


      if(fetchResult['status'] == "true"){
        if(mounted) {
          setState(() {
            products = fetchResult['products'];
          });
        }
      }

    }
//    print(_member);
     if(mounted){
       setState(() {
         member = _member;
       });
     }
  }

  Widget showApprovalProductList(){
    return Card(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(10),
        child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
          children: generateProductList()
        )
      )
    );
  }
  List<Widget> generateProductList(){
    List<Widget> widgetList=[];

    if(products.length>0){
      int i=0;
      for(dynamic p in products){
        widgetList.add(Row(
          children: <Widget>[
            Checkbox(
              onChanged: (value){
                setState(() {
                  if(value){
                    productCheckboxStatus.add(p["ProductID"]);
                  } else {
                    productCheckboxStatus.remove(p["ProductID"]);
                  }
                });
              },
              value: productCheckboxStatus.contains(p['ProductID']),
            ),
            Text(p['ProductName'])
          ],
        ));
        i++;
      }

      widgetList.add(RaisedButton(
        color: Colors.green,

        child: (loader)? Row(
          children: <Widget>[
            Text("Please Wait",style: TextStyle(
                color:Colors.white
            ),) ,
            SizedBox(
              height: 18.0,
              width: 28.0,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child:CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                )
              ))
          ],
        )
            : Text("Approve Member",style: TextStyle(
          color:Colors.white
        ),),
        onPressed: () async {
          if(loader){
            return;
          }

          setState(() {
            loader = true;
          });
          approveMember();
        },
      ));
    }
    return widgetList;
  }

  Future<void> approveMember () async {
    Setting setting = await SettingService.getSetting('transactionDate');
    DateTime dt = DateTime.now();
    var postData = {
      "officeId":member['office_id'],
      "memberId": int.parse(member["memberRemoteId"].toString()),
      "products":productCheckboxStatus,
      "createUser":member['created_user'].toString(),
      "createDate":member['created_date'].toString()
    };
    if(productCheckboxStatus.length<=0){
      showErrorMessage("Please Select Product To Approve Member", context);
      setState(() {
        loader = false;
      });
      return;
    }

    try {
      dynamic approveResult = await MemberService.approveMember(postData);
      setState(() {
        loader = false;
      });
      if(approveResult == true){

        Navigator.of(context).pushReplacementNamed("/member-approvals");
        showSuccessMessage("Member Approved Successfully", context);
      }
    } on CustomException catch(ex){
      showErrorMessage(ex.message, context);
    }

  }

  Widget showSignature(){
    if((member['sig_img_path'] == "" || member['sig_img_path'] == null)){
      return SizedBox.shrink();
    }else{
      return Card(
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(bottom: 10,top:10,left:10),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child:Text("SIGNATURE",style: TextStyle(
                  fontWeight: FontWeight.bold
                ),)
              ),
              showImage(member,'sig_img_path', true)
            ],
          )
        ),
      );
    }
  }

  Widget showBasicInfo() {
    return Card(
        child: Container(
            padding: EdgeInsets.all(10),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Container(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(member['first_name'],style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:18
                          ),),

                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Center",style: TextStyle(
                            color:Colors.black54
                          ),),
                          Text("${member['center_name']}")
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Member Category",style: TextStyle(
                              color:Colors.black54
                          ),),
                          Text("${member['category_name']}")
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Father Name",style: TextStyle(
                            color: Colors.black54
                          ),),
                          Text("${member['father_name']}")
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Mother Name",style: TextStyle(
                            color: Colors.black54
                          ),),
                          Text("${member['mother_name']}")
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Marital Status",style: TextStyle(
                            color: Colors.black54
                          ),),
                          Text("${member['marital_status']}")
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Spouse Name",style: TextStyle(
                            color:Colors.black54
                          ),),
                          Text("${member['spouse_name']}")
                        ],
                      ),

                    ],
                  ),

                ),
                SizedBox(width: 10,),
                memberThumbnail(),
              ],
            )
        )
    );
  }

  Widget showIdentificationInfo(){

    return Card(
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text("IDENTIFICATIONS",
                      style:TextStyle(
                          fontWeight: FontWeight.bold
                      ) ,),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("National ID",style: TextStyle(
                        color: Colors.black54
                      ),),
                      Text("${member['nid']}")
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Smart Card",style: TextStyle(
                          color: Colors.black54
                      ),),
                      Text("${(member['smart_card_no'].toString().length>0)? member['smart_card_no'] : 'N/A'}")
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Identity Type",style: TextStyle(
                        color: Colors.black54
                      ),),
                      Text("${getIdentityType(member['identity_type_id'])}")
                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Card Issue Date",style: TextStyle(
                        color: Colors.black54
                      ),),
                      Text("${DateFormat('d MMM y').format(DateTime.parse(member['issue_date']))}")
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Card Expire Date",style: TextStyle(
                        color: Colors.black54
                      ),),
                      Text("${DateFormat('d MMM y').format(DateTime.parse(member['expire_date']))}")
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Other Card No",style: TextStyle(
                        color:Colors.black54
                      ),),
                      Text("${member['other_id_no']}")
                    ],
                  )
                ]
            )
        )
    );
  }

  Widget showOtherInformation(){
    return Card(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(10),
        child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("OTHER INFORMATIONS",
                style:TextStyle(
                    fontWeight: FontWeight.bold
                ) ,),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Date Of Birth",style: TextStyle(
                    color: Colors.black54
                ),),
                Text("${DateFormat('MMM d, y').format(DateTime.parse(member['date_of_birth']))}")
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("As on date age",style: TextStyle(
                    color: Colors.black54
                ),),
                Text("${member['age']}")
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Place of birth",style: TextStyle(
                    color: Colors.black54
                ),),
                Text("${member['birth_place_id']}")
              ],
            ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Citizenship",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['citizenship']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Gender",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['Gender']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Admission Date",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${DateFormat('MMM d, y').format(DateTime.parse(member['admission_date']))}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Home Type",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['homeType']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Academic Qualification",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['Education']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Family member",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['family_member']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("E-mail",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['email']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Contact No",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['contact_no']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Family Contact No",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['family_contact_no']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Reference Name",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['reference_name']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Co Applicant Name",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['co_applicant_name']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Occupation",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['occupation']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Total Wealth",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['total_wealth']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Member Type",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${getMemberType(member['member_type_id'])}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("TIN",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['tin']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Tax Amount",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['tax_amount']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Use any financial service?",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${getIsAnyFs(member['is_any_fs'])}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Service Name",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${member['f_service_name']}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Service Type",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${getServiceType(member['fin_service_choice_id'])}")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Transaction Type",style: TextStyle(
                      color: Colors.black54
                  ),),
                  Text("${getTransactionType(member['transaction_choice_id'])}")
                ],
              )
          ]
        )
      )
    );
  }

  String getIdentityType(int id){
    //print("LS"+id.toString());
    if(id == 1){
      return "Passport";
    }else if(id == 2){
      return "Driving License";
    }else  if(id == 3){
      return "Birth Certificate";
    }else{
      return "N/A"; //id.toString();
    }
  }

  Future<void> loadMemberTypes() async {
    var _memberTypes = await MemberTypeService.getMemberTypes();
    if(mounted) {
      setState(() {
        memberTypes = _memberTypes;
      });
    }
  }

  String getMemberType(String id)  {


    String memberTypeText="";
    memberTypes.forEach((memberType){

      if(id == memberType.value.toString()){
        memberTypeText = memberType.text;
      }
    });

    return memberTypeText;
  }

  String getIsAnyFs(int id){
    if(id == 1){
      return 'YES';
    }
    return 'NO';
  }

  String getServiceType(int id){
    if(id == 1){
      return "Personal";
    }
    if(id == 2){
      return "Business";
    }
    if(id == 3){
      return "Remitance";
    }
    return "Others";
  }

  String getTransactionType(int id){
    if(id == 1){
      return "Cash";
    }
    if(id == 2){
      return "Cheque";
    }
    if(id == 3){
      return "Mobile Financial Service";
    }
    if(id == 4){
      return "Direct Transfer";
    }
    if(id == 5){
      return "Multiple";
    }

    return "Other";
  }
}

