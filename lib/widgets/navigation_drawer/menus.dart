import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gbanker/persistance/services/menu_service.dart';

import 'list_item.dart';
class Menus {

  List<Map<String,dynamic>> menus;
  List<Widget> transactionMenusWidgets = [];



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

  List<Widget> getUploadTransactionsMenuList(BuildContext context, Function callback) {
    List<Widget> uploadTransactMenuList = List<Widget>();
    uploadTransactMenuList.add(
        Container(
          child: Padding(padding: EdgeInsets.only(left: 20),
              child: Text("Upload Transactions")),
        )
    );
    uploadTransactMenuList.addAll(ListTile.divideTiles(context: context,
        color: Colors.white,
        tiles: [
          ListItem(
            name:'upload-collection',
            icon: Icons.cloud_upload,
            text: "Upload Collection",
            callback: callback,
          ),
          ListItem(
            name:'emergency-export',
            icon: Icons.cloud_upload,
            text: "Emergency Export",
            callback: callback,
          ),

          ListItem(
            name:'uploaded-history',
            icon: Icons.history,
            text: "Uploaded History",
            callback: callback,
          ),
          Divider()
        ]));
    return uploadTransactMenuList;
  }

  List<Widget> getReportsMenuList(BuildContext context,Function callback) {
    List<Widget> reportMenus = List<Widget>();
//    reportMenus.add(Container(
//      child: Padding(
//        padding: EdgeInsets.only(left: 20),
//        child: Text("Reports"),
//      ),
//    ));

//    reportMenus.addAll(ListTile.divideTiles(context: context,
//        color: Colors.white,
//        tiles: [
//          ListItem(
//            name:'collection-list',
//            icon: Icons.report,
//            text: "Collection List",
//            callback: callback
//          ),
//          ListItem(
//            name:'withdrawal-list',
//            icon: Icons.report,
//            text: "Withdrawal List",
//            callback: callback
//          ),
//          ListItem(
//            name:'collection-summary',
//            icon: Icons.report,
//            text: "Collection Summary",
//            callback: callback
//          ),
//          Divider()
//        ]));

    return reportMenus;
  }

  Future<List<Widget>> getTransactionMenuList(BuildContext context,Function callback) async {
    List<Widget> transactionMenus = List<Widget>();

    var _transactionMenus = await MenuService.getMenus(group: 'transactions');

    _transactionMenus.forEach((m){
      transactionMenusWidgets.add(
        ListItem(
          name: m['alias'],
          text: m['menu_name'],
        )
      );
    });
    transactionMenus.add(Container(
      child: Padding(padding: EdgeInsets.only(left: 20),
        child: Text("Transactions"),),
    ));

    transactionMenus.addAll(
        ListTile.divideTiles(context: context, color: Colors.white,
            tiles:transactionMenus
            //[

//              ListItem(
//                name: 'collection',
//                icon: Icons.monetization_on,
//                text: "Collection",
//                callback: callback,
//              ),
//
//              ListItem(
//                name: 'special-collection',
//                icon: Icons.monetization_on,
//                text: "Sp. Collection",
//                callback: callback,
//              ),
//              ListItem(
//                name: 'withdrawal',
//                icon: Icons.attach_money,
//                text: "Withdrawal",
//                callback: callback,
//              ),


        //    ]
        ).toList());
    return transactionMenus;
  }

  List<Widget> getEntryMenuList(BuildContext context,Function callback){
    List<Widget> entryMenuList = List<Widget>();
    entryMenuList.add(Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text("Online Entries"),
    ));
    entryMenuList.addAll(ListTile.divideTiles(
      context: context,
      color: Colors.white,
      tiles: [
        ListItem(
          name:'members',
          text:"Members",
          icon: Icons.people,
          callback: callback,
        ),
        ListItem(
          name: 'member-approvals',
          text: "Member Approval",
          icon: Icons.touch_app,
          callback: callback,
        ),
        ListItem(
          name:'savings-account',
          text:"Savings Account",
          icon: Icons.monetization_on,
          callback: callback,
        ),
        ListItem(
          name:'loan-proposal',
          text:"Loan Proposal",
          icon: Icons.monetization_on,
          callback: callback,
        ),
        ListItem(
          name: 'misc-entry',
          icon: Icons.attach_money,
          text: "Miscellaneous Entry",
          callback: callback,
        ),
        ListItem(
          name: 'cs-refund',
          icon: Icons.attach_money,
          text: "CS Refund",
          callback: callback,
        ),
        ListItem(
          name: 'rebate',
          icon: Icons.attach_money,
          text: "Rebate",
          callback: callback,
        ),
        ListItem(
          name:'scanner',
          text:"QR/BAR Code Scanner",
          icon: Icons.scanner,
          callback: callback,
        ),
        Divider()
      ]
    ).toList());

    return entryMenuList;
  }

  Future<List<Widget>> getMenuList(BuildContext context, Function callback) async {
    List<Widget> menuList = ListTile.divideTiles(

        context: context,
        tiles: [
          ListItem(
            name: 'home',
            icon: Icons.home,
            text: "Home",
            callback: callback,
          ),
          Padding(padding: EdgeInsets.only(top: 10),)
        ]).toList();

    menuList.addAll(await getTransactionMenuList(context,callback));
    menuList.addAll(getEntryMenuList(context,callback));
//    menuList.addAll(getReportsMenuList(context,callback));
    menuList.addAll(getUploadTransactionsMenuList(context,callback));
    menuList.addAll(getSettingsMenuList(context,callback));
    return menuList;
  }

}