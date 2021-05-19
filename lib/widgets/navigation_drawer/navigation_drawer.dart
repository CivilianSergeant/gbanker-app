import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gbanker/config/app_config.dart';
import 'package:gbanker/helpers/custom_launcher.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/services/menu_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/widgets/custom_dialog.dart';
import 'package:gbanker/widgets/navigation_drawer/list_item.dart';
import 'menus.dart';

class NavigationDrawer extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new NavigationDrawerState();

}

class NavigationDrawerState extends State<NavigationDrawer>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> menus = [];
  List<Map<String,dynamic>> transactionMenuData = [];
  List<Map<String,dynamic>> reportMenuData = [];
  List<Map<String,dynamic>> uploadTransactionMenuData = [];
  List<Map<String,dynamic>> onlineEntryMenuData = [];


  void triggerAction(BuildContext context, String actionName){
    Navigator.popUntil(context, (route){
      switch(actionName){
        case "home":
          if(route.settings.name != "/home"){
            Navigator.pushReplacementNamed(context, '/home');
          }else{
            Navigator.pop(context);
          }
          break;
        case "members":
          if(route.settings.name != "/members"){
            Navigator.pushReplacementNamed(context, '/members');
          }else{
            Navigator.pop(context);
          }
          break;
        case "member-approvals":
          if(route.settings.name != "/member-approvals"){
            Navigator.pushReplacementNamed(context, '/member-approvals');
          }else{
            Navigator.pop(context);
          }
          break;
        case "loginweb":
          if(route.settings.name != "/loginweb"){
            CustomLauncher.launchURL(url:AppConfig.getDefaultUrl());
          }else{
            Navigator.pop(context);
          }
          break;
        case "collection":

          if(route.settings.name != "/collection"){
            Navigator.pushReplacementNamed(context, '/collection');
          }else{
            Navigator.pop(context);
          }
          break;
        case "special-collection":

          if(route.settings.name != "/special-collection"){
            Navigator.pushReplacementNamed(context, '/special-collection');
          }else{
            Navigator.pop(context);
          }
          break;
        case "withdrawal":

          if(route.settings.name != "/withdrawal"){
            Navigator.pushReplacementNamed(context, '/withdrawal');
          }else{
            Navigator.pop(context);
          }
          break;

        case "dmd":
          if(route.settings.name != "/login"){
            setDownloadSettings(option:"isDownload");
            Navigator.pushReplacementNamed(context, "/login");
          }else{
            Navigator.pop(context);
          }
          break;

        case "ds":
          if(route.settings.name != "/login"){
            setDownloadSettings(option: "isDownloadSavings");
            Navigator.pushReplacementNamed(context, "/login");
          }else{
            Navigator.pop(context);
          }
          break;

        case "setup":
          if(route.settings.name != "/setup"){
            Navigator.pushReplacementNamed(context, "/setup");
          }else{
            Navigator.pop(context);
          }
          break;
        case "collection-list":
          if(route.settings.name != "/collection-list"){
            Navigator.pushReplacementNamed(context, "/collection-list");
          }else{
            Navigator.pop(context);
          }
          break;
        case "withdrawal-list":
          if(route.settings.name != "/withdrawal-list"){
            Navigator.pushReplacementNamed(context, "/withdrawal-list");
          }else{
            Navigator.pop(context);
          }
          break;
        case "collection-summary":

          if(route.settings.name != "/collection-summary"){
            Navigator.pushReplacementNamed(context, "/collection-summary");
          }else{
            Navigator.pop(context);
          }
          break;

        case "upload-collection":
          if(route.settings.name != "/upload-collection"){
            Navigator.pushReplacementNamed(context, "/upload-collection");
          }else{
            Navigator.pop(context);
          }
          break;
        case "emergency-export":
          if(route.settings.name != "/emergency-export"){
            Navigator.pushReplacementNamed(context, "/emergency-export");
          }else{
            Navigator.pop(context);
          }
          break;
        case "uploaded-history":
          if(route.settings.name != "/uploaded-history"){
            Navigator.pushReplacementNamed(context, "/uploaded-history");
          }else{
            Navigator.pop(context);
          }
          break;
        case "savings-account":
          if(route.settings.name != "/savings-account"){
            Navigator.pushReplacementNamed(context, "/savings-account");
          }else{
            Navigator.pop(context);
          }
          break;
        case "loan-proposal":
          if(route.settings.name != "/loan-proposal"){
            Navigator.pushReplacementNamed(context, "/loan-proposal");
          }else{
            Navigator.pop(context);
          }
          break;
        case "misc-entry":
          if(route.settings.name != "/misc-entry"){
            Navigator.pushReplacementNamed(context, "/misc-entry");
          }else{
            Navigator.pop(context);
          }
          break;
        case "scanner":
          if(route.settings.name != "/scanner"){
            Navigator.pushReplacementNamed(context, "/scanner");
          }else{
            Navigator.pop(context);
          }
          break;
        case "about":
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(showAbout: true,);
              });
          break;
        case "cs-refund":
          if(route.settings.name != "/cs-refund"){
            Navigator.pushReplacementNamed(context, "/cs-refund");
          }else{
            Navigator.pop(context);
          }
          break;
        case "rebate":
          if(route.settings.name != "/rebate"){
            Navigator.pushReplacementNamed(context, "/rebate");
          }else{
            Navigator.pop(context);
          }
          break;
        case "exit":
          exit(0);
          break;

      }
      return true;
    });
  }

  Future<void> setDownloadSettings({String option}) async {

    SettingService.getSetting("fromSplash").then((Setting s){
      if(s != null){
        SettingService.updateSetting({"value":"false"}, "id=?", [s.id]);
      }
    });
    if(option != null){
      Setting isDownload = await SettingService.getSetting(option);
      if(isDownload != null){
        await SettingService.updateSetting({"value":"true"},"id=?", [isDownload.id]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      key: _scaffoldKey,
      child: new Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children:  drawMenu(),
              ),
            )
          ],
        ),
      )
    );
  }

  List<Widget> drawMenu(){
    List<Widget> menuWidgets = ListTile.divideTiles(

        context: context,
        tiles: [
          ListItem(
            name: 'home',
            icon: Icons.home,
            text: "Home",
            callback: this.triggerAction,
          ),
          Padding(padding: EdgeInsets.only(top: 10),)
        ]).toList();
    menuWidgets.addAll(getTransactionMenuList(context,transactionMenuData));
    menuWidgets.addAll(getEntryMenuList(context, onlineEntryMenuData));
    menuWidgets.addAll(getReportsMenuList(context,reportMenuData ));
    menuWidgets.addAll(getUploadTransactionsMenuList(context, uploadTransactionMenuData));
    menuWidgets.addAll(getSettingsMenuList(context,this.triggerAction));
    return menuWidgets;
  }

  loadMenus()async{


    var transactionMenus =  await MenuService.getMenus(group: 'transactions');
    var reportMenus = await MenuService.getMenus(group:'reports');
    var uploadTransactionMenus = await MenuService.getMenus(group: 'upload-transactions');
    var onlineEntryMenus = await MenuService.getMenus(group: 'online-entries');



    if(mounted) {
     setState(() {
       transactionMenuData = transactionMenus;
       reportMenuData = reportMenus;
       uploadTransactionMenuData = uploadTransactionMenus;
       onlineEntryMenuData = onlineEntryMenus;


     });
    }
  }

  List<Widget> getTransactionMenuList(BuildContext context, List<Map<String,dynamic>> menus) {
    List<Widget> transactionMenus = List<Widget>();
    List<Widget> subMenus = [];

    if(menus.length==0){
      return transactionMenus;
    }
    transactionMenus.add(Container(
      child: Padding(padding: EdgeInsets.only(left: 20),
        child: Text("Transactions"),),
    ));
    menus.forEach((m){
      subMenus.add(
        ListItem(
          name: m['alias'],
          text: m['menu_name'],
          callback: this.triggerAction,
          icon: getIcon(m['alias']),
        ),
      );
    });

    subMenus.add(Divider());

    transactionMenus.addAll(
        ListTile.divideTiles(context: context, color: Colors.white,
            tiles:subMenus).toList());
    return transactionMenus;
  }

  List<Widget> getEntryMenuList(BuildContext context,List<Map<String,dynamic>> menus){

    List<Widget> entryMenuList = List<Widget>();
    List<Widget> subMenus = [];

    if(menus.length==0){
      return entryMenuList;
    }
    entryMenuList.add(Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text("Online Entries"),
    ));

    menus.forEach((m){
      subMenus.add(
        ListItem(
          name: m['alias'],
          text: m['menu_name'],
          callback: this.triggerAction,
          icon: getIcon(m['alias']),
        ),
      );
    });

    subMenus.add(Divider());
    entryMenuList.addAll(ListTile.divideTiles(
        context: context,
        color: Colors.white,
        tiles: subMenus
    ).toList());

    return entryMenuList;
  }

  List<Widget> getReportsMenuList(BuildContext context,List<Map<String,dynamic>> menus) {
    List<Widget> reportMenus = List<Widget>();
    List<Widget> subMenus = [];

    if(menus.length==0){
      return reportMenus;
    }
    reportMenus.add(Container(
      child: Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text("Reports"),
      ),
    ));

    menus.forEach((m){

      subMenus.add(
        ListItem(
          name: m['alias'],
          text: m['menu_name'],
          callback: this.triggerAction,
          icon: Icons.report,
        ),
      );
    });
    subMenus.add(Divider());
    reportMenus.addAll(ListTile.divideTiles(context: context,
        color: Colors.white,
        tiles: subMenus
    ));

    return reportMenus;
  }

  List<Widget> getUploadTransactionsMenuList(BuildContext context, List<Map<String,dynamic>> menus) {
    List<Widget> uploadTransactMenus = List<Widget>();
    List<Widget> subMenus = [];

    if(menus.length==0){
      return uploadTransactMenus;
    }

    uploadTransactMenus.add(
        Container(
          child: Padding(padding: EdgeInsets.only(left: 20),
              child: Text("Upload Transactions")),
        )
    );

    menus.forEach((m){
      subMenus.add(
        ListItem(
          name: m['alias'],
          text: m['menu_name'],
          callback: this.triggerAction,
          icon: getIcon(m['alias']),
        ),
      );
    });
    subMenus.add(Divider());

    uploadTransactMenus.addAll(ListTile.divideTiles(context: context,
        color: Colors.white,
        tiles: subMenus));


    return uploadTransactMenus;
  }

  List<Widget> getSettingsMenuList(BuildContext context, Function callback) {
    List<Widget> settingsMenuList = List<Widget>();

    settingsMenuList.add(Container(
      child: Padding(
          padding: EdgeInsets.only(left: 20), child: Text("Settings")),
    ));

    settingsMenuList.addAll(ListTile.divideTiles(
        context: context,
        color: Colors.white,
        tiles: [
          ListItem(
            name:'dmd',
            icon: Icons.cloud_download,
            text: "Download Master Data",
            callback: callback,
          ),
          ListItem(
            name:'ds',
            icon: Icons.cloud_download,
            text: "Download Savings",
            callback: callback,
          ),
          ListItem(
            name: 'setup',
            icon: Icons.settings,
            text: "Setup Url",
            callback: callback,
          ),
          ListItem(
            name:'about',
            icon: Icons.info,
            text: "About",
            callback: callback,
          ),
          ListItem(
              name:'exit',
              icon: Icons.exit_to_app,
              text: "Exit",
              callback: callback
          )
        ]));

    return settingsMenuList;
  }




  IconData getIcon(String alias){
    IconData iconData;
    if(alias == "collection" || alias == "special-collection"){
      iconData = Icons.monetization_on;
    }
    if(alias == "withdrawal"){
      iconData = Icons.attach_money;
    }

    if(alias == "upload-collection" || alias == 'emergency-export'){
      iconData = Icons.cloud_upload;
    }
    if(alias == 'uploaded-history'){
      iconData = Icons.history;
    }
    if(alias == 'members'){
      return Icons.people;
    }
    if(alias == "loginweb"){
      return Icons.open_in_browser;
    }
    if(alias == "member-approvals"){
      return Icons.touch_app;
    }
    if(alias == 'savings-account' || alias == 'loan-proposal'){
      return Icons.monetization_on;
    }
    if(alias == 'scanner'){
      return Icons.scanner;
    }
    if(alias == 'cs-refund' || alias == 'misc-entry' || alias == 'rebate'){
      return Icons.attach_money;
    }
    return iconData;
  }

  @override
  void initState() {
    loadMenus();
  }
}