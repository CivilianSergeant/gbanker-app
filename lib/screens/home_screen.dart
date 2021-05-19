import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/entities/User.dart';
import 'package:gbanker/persistance/services/center_service.dart';
import 'package:gbanker/persistance/services/group_service.dart';
import 'package:gbanker/persistance/services/loan_collection_service.dart';
import 'package:gbanker/persistance/services/member_service.dart';
import 'package:gbanker/persistance/services/menu_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/stats_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return HomePageWidget();
  }
}

class HomePageWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new HomePageWidgetState();

}

class HomePageWidgetState extends State<HomePageWidget>{

  User user;
  int memberInfoCollected;
  double totalCollectedAmount;
  Setting trxDateSetting;
  List<Map<String,dynamic>> menus = [];
  List<Map<String,dynamic>> stats = [];
  List<Widget> statsWidgets = [];

  void loadUser() async {
    Setting setting = await SettingService.getSetting("guid");
    User user = await UserService.getUserByGuid(setting.value);
    var _memberInfoCollected = await LoanCollectionService.getCollectionCount();
    var _totalCollectedAmount = await LoanCollectionService.getCollectionAmount();
    Setting _trxDateSetting = await SettingService.getSetting("transactionDate");
    var _centers = await CenterService.getCenters(trxType: 1);

    for(dynamic c in _centers){
      int memberCount = (await MemberService.getMembersByCenter(c.id,trxType: 1)).length;
      int borrowerCount = (await StatsService.getBorrowerCount(c.id));
      double recoverableAmount = (await StatsService.getRecoverableCount(c.id));
      double totalLoan = (await StatsService.getTotalLoanOutstanding(c.id));
      double totalSavings = (await StatsService.getTotalSavingsAmount(c.id));
      double dueAmount = (await StatsService.getTotalDueAmount(c.id));

      this._addWidget(centerName: c.centerCode+ ' - '+c.centerName,
      memberCount: memberCount,borrowerCount: borrowerCount,
          recoverable: recoverableAmount,
          totalLoan: totalLoan,
          totalSavings: totalSavings,
          totalDue: dueAmount
      );

    };

    print(stats);

    if(this.mounted) {
      setState(() {
        this.user = user;
        this.memberInfoCollected = _memberInfoCollected;
        this.totalCollectedAmount = _totalCollectedAmount;
        trxDateSetting = _trxDateSetting;
      });
    }
  }

  @override
  void initState() {

    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {

    String trxDate = (trxDateSetting != null)? DateFormat('d MMM, y').format(DateTime.parse(trxDateSetting.value)) : "";
    var appTitleBar = AppTitleBar(bgColor: ColorList.Colors.primaryColor);
    return Scaffold(
      key: Key("home"),
      appBar: appTitleBar.build(context),
      drawer:SafeArea(
        child: NavigationDrawer(),
      ) ,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(5),
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(

                  elevation: 2,
                  color: Colors.blueGrey,

                  child: Padding(padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Logged In: "+((this.user != null)? this.user.username.toString()+"-"+this.user.firstname.toString():""),
                            style: TextStyle(color: Colors.white), textAlign: TextAlign.left,),
                          SizedBox(height: 10,),
                          Text("Office: "+((this.user != null)? this.user.officeName.toString():""),
                            style: TextStyle(color: Colors.white), textAlign: TextAlign.left,),
                          SizedBox(height: 10,),
                          Text("Transaction Date: "+trxDate,
                            style: TextStyle(color: Colors.white), textAlign: TextAlign.left,),
                        ],
                      )
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        getStats((memberInfoCollected != null)? memberInfoCollected.toString():"0",Colors.green,isVertical: false),
                        getStats((totalCollectedAmount != null && totalCollectedAmount>0)? totalCollectedAmount.toStringAsFixed(2):"0",Colors.deepOrangeAccent,isVertical: true)
                      ],
                    ),

                    Card(
                      elevation: 2.5,
                      child:Container(
                        color: Color(0xffeeeeff),
                        width:MediaQuery.of(context).size.width,
                        child: Column(
                          children: statsWidgets,
                        ),
                      )
                    )
                  ],
                ),
              )


            ],
          ),
        ),
      ),


    );
  }

  void _addWidget({String centerName,int memberCount, int borrowerCount,
  double recoverable, double totalLoan, double totalSavings, double totalDue}){
    statsWidgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("${centerName.toUpperCase()}",style: TextStyle(
        fontWeight: FontWeight.w700,fontSize: 18

      ),),
    ));
    statsWidgets.add(Padding(
      padding: const EdgeInsets.only(left:8.0,bottom: 5.0,right:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Align(alignment:Alignment.centerLeft,child: Text("Total Member: ",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black54
            ),)),
          Align(alignment:Alignment.centerLeft,child: Text("${memberCount}",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black54
            ),))
        ]
      ),
    ));

    statsWidgets.add(Padding(
      padding: const EdgeInsets.only(left:8.0,bottom: 5.0,right:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(alignment:Alignment.centerLeft,child: Text("Total Borrower: ",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54
              ))),
          Align(alignment:Alignment.centerLeft,child: Text("${borrowerCount}",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54
              )))
        ],
      ),
    ));

    statsWidgets.add(Padding(
      padding: const EdgeInsets.only(left:8.0,bottom: 5.0,right:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(alignment:Alignment.centerLeft,child: Text("Total Recoverable:",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54
              )
          )),
          Align(alignment:Alignment.centerLeft,child: Text("${recoverable.round()}",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54
              )
          ))
        ],
      ),
    ));

    statsWidgets.add(Padding(
      padding: const EdgeInsets.only(left:8.0,bottom: 5.0,right:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(alignment:Alignment.centerLeft,child: Text("Loan Balance:",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54
              )
          )),
          Align(alignment:Alignment.centerLeft,child: Text("${totalLoan.round()}",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54
              )
          ))
        ],
      ),
    ));

    statsWidgets.add(Padding(
      padding: const EdgeInsets.only(left:8.0,bottom: 5.0,right:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(alignment:Alignment.centerLeft,child: Text("Savings Balance:",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54
              )
          )),
          Align(alignment:Alignment.centerLeft,child: Text("${totalSavings.round()}",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54
              )
          ))
        ],
      ),
    ));

    statsWidgets.add(Padding(
      padding: const EdgeInsets.only(left:8.0,bottom: 5.0,right:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(alignment:Alignment.centerLeft,child: Text("Due/Over Due:",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54
              )
          )),
          Align(alignment:Alignment.centerLeft,child: Text("${totalDue.round()}",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54
              )
          ))
        ],
      ),
    ));
    return;
  }

  Widget getStats(String data,Color color,{bool isVertical}){
    Widget widget = Container();
    if(data.length>0 && data =="0"){
      return widget;
    }
    if(isVertical != null && !isVertical){
      widget = Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 8,bottom: 5,left: 8),
                child:Text("Total \r\nCollection",
                    style: TextStyle(color: Colors.white, fontSize: 14)),),
              Padding(padding: EdgeInsets.only(bottom: 8,left: 12),
                  child:Text("(Member wise)",style: TextStyle(fontSize: 11,color: Colors.white),))
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 8,bottom: 8,),
              child: Text((data != null
                  && data.length>0)?
              " ${data} ": "",
                style: TextStyle(color: Colors.white, fontSize:30),)),

        ],
      );
    }else{
      widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 8,bottom: 8,),
              child: Text((data != null
                  && data.length>0)?
              " ${data} ": "",
                style: TextStyle(color: Colors.white, fontSize:25),)),
          Padding(padding: EdgeInsets.only(bottom: 5,left: 12),
              child:Text("Total Amount Collected",style: TextStyle(fontSize: 11,color: Colors.white),))
        ],
      );
    }
    return SizedBox(
        width: MediaQuery.of(context).size.width/2.10,
        child: Card(

            elevation: 2,
            color: color,
            child: widget
        )
    );
  }

}