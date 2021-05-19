import 'package:flutter/material.dart';
import 'package:gbanker/helpers/portrait_mode_mixin.dart';
import 'package:gbanker/screens/camera/camera_screen.dart';
import 'package:gbanker/screens/entries/loan_proposal_approve_screen.dart';
import 'package:gbanker/screens/entries/loan_proposal_disburse_screen.dart';
import 'package:gbanker/screens/entries/loan_proposal_screen.dart';
import 'package:gbanker/screens/entries/member_approval_list_screen.dart';
import 'package:gbanker/screens/entries/member_approve_screen.dart';
import 'package:gbanker/screens/entries/member_screen.dart';
import 'package:gbanker/screens/entries/savings_account_screen.dart';
import 'package:gbanker/screens/entries/scanner_screen.dart';
import 'package:gbanker/screens/home_screen.dart';
import 'package:gbanker/screens/login_screen.dart';
import 'package:gbanker/screens/reports/collection_list.dart';
import 'package:gbanker/screens/reports/collection_summary.dart';
import 'package:gbanker/screens/reports/withdrawal_list.dart';
import 'package:gbanker/screens/settings/setup_screen.dart';
import 'package:gbanker/screens/splash_screen.dart';
import 'package:gbanker/screens/transactions/collection_screen.dart';
import 'package:gbanker/screens/transactions/cs_refund_screen.dart';
import 'package:gbanker/screens/transactions/misc_entry_screen.dart';
import 'package:gbanker/screens/transactions/rebate_screen.dart';
import 'package:gbanker/screens/transactions/special_collection_screen.dart';
import 'package:gbanker/screens/transactions/withdrawal_screen.dart';
import 'package:gbanker/screens/uploads/emergency_export.dart';
import 'package:gbanker/screens/uploads/upload_collection_screen.dart';
import 'package:gbanker/screens/uploads/uploaded_history_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget with PortraitModeMixin{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      title: 'gBanker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/setup': (context) => SetupScreen(),
        '/home': (context) => HomeScreen(),
        '/collection': (context) => CollectionScreen(),
        '/special-collection': (context) => SpecialCollectionScreen(),
        '/withdrawal' : (context) => WithdrawalScreen(),
        '/members': (context) => MemberScreen(),
        '/member-approvals': (context) => MemberApprovalListScreen(),
        '/member-approve':(context) => MemberApproveScreen(),
        '/collection-list': (context) => CollectionListScreen(),
        '/withdrawal-list': (context) => WithdrawalListScreen(),
        '/collection-summary': (context) => CollectionSummaryScreen(),
        '/upload-collection': (context) => UploadCollectionScreen(),
        '/emergency-export': (context) => EmergencyExportScreen(),
        '/uploaded-history': (context) => UploadedHistoryScreen(),
        '/scanner': (context) => ScannerScreen(),
        '/savings-account': (context)=> SavingsAccountScreen(),
        '/loan-proposal': (context)=> LoanProposalScreen(),
        '/loan-proposal-approve': (context)=> LoanProposalApproveScreen(),
        '/loan-proposal-disburse': (context) => LoanProposalDisburseScreen(),
        '/misc-entry': (context) => MiscellaneousEntryScreen(),
        '/cs-refund': (context) => CsRefundScreen(),
        '/camera':(context)=>CameraScreen(),
        '/rebate': (context)=>RebateScreen()
      },
      debugShowCheckedModeBanner:false
    );
  }
}


