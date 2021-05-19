import 'package:flutter/material.dart';
import 'package:gbanker/helpers/adapter/adapter.dart';
import 'package:gbanker/helpers/calculate.dart';
import 'package:gbanker/persistance/entities/MemberProduct.dart';

class CollectionAdapter implements Adapter{
  int memberId;
  int centerId;
  int officeId;
  int orgId;
  int productId;
  String productCode;
  int summaryId;
  double amount;
  double recoverable;
  double loanRecovery;
  String token;
  String installmentDate;
  int trxType;
  int productType;
  double loanInstallment;
  double intInstallment;
  double intCharge;

  int duration;
  double intDue;
  double loanDue;
  double principalLoan;
  double loanRepaid;
  double durationOverLoanDue;
  double durationOverIntDue;
  int installmentNo;
  double cumInterestPaid;
  double cumIntCharge;
  String interestCalculationMethod;
  int doc;
  double fine;
  double cumLoanDue;
  double cumIntDue;

  TextEditingController amountController = TextEditingController();
  TextEditingController fineController = TextEditingController();
  FocusNode amountInputFocus = FocusNode();
  FocusNode fineInputFocus=FocusNode();
  bool isChanged=false;

  CollectionAdapter({this.productId,this.amount});

  Map<String,dynamic> toMap(){
    return {
      'memberId':memberId,
      'centerId':centerId,
      'officeId':officeId,
      'orgId':orgId,
      'productId':productId,
      'productCode':productCode,
      'summaryId': summaryId,
      'amount':amount,
      'recoverable':recoverable,
      "loanRecovery":loanRecovery,
      'token':token,
      "installmentDate":installmentDate,
      'trxType': trxType,
      'productType': productType,
      'loanInstallment':loanInstallment,
      'intInstallment':intInstallment,
      'intCharge':intCharge,
      'duration':duration,
      'intDue':intDue,
      'loanDue':loanDue,
      'principalLoan':principalLoan,
      'loanRepaid':loanRepaid,
      'durationOverLoanDue':durationOverLoanDue,
      'durationOverIntDue':durationOverIntDue,
      'installmentNo':installmentNo,
      'cumInterestPaid': cumInterestPaid,
      'cumIntCharge': cumIntCharge,
      'interestCalculationMethod': interestCalculationMethod,
      'doc':doc,
      'fine':fine,
      'cumLoanDue':cumLoanDue,
      'cumIntDue':cumIntDue
    };
  }

  static void loadDataToAdapter(List<CollectionAdapter> collections,int index, MemberProduct info) {
    collections[index].officeId = info.officeId;
    collections[index].centerId = info.centerId;
    collections[index].memberId = info.memberId;
    collections[index].orgId = info.orgId;
    collections[index].productId = info.productId;
    collections[index].productCode = info.productCode;
    collections[index].summaryId = info.summaryId;
    collections[index].recoverable = info.recoverable;

    if(info.productType == 1) {
      var _amount = info.loanRecovery;// (info.loanRecovery + info.newDue);

      collections[index].amount = (_amount>0)? _amount : 0;

    }else{
      collections[index].amount = info.loanRecovery;
    }

    collections[index].loanRecovery = info.loanRecovery;
    collections[index].installmentDate = info.installmentDate;

  //  print("HERE ${collections[index].amount}");

    collections[index].loanInstallment = info.loanDue;
    collections[index].intInstallment = info.intDue;
    collections[index].intCharge = info.intCharge;
    collections[index].trxType = info.trxType;
    collections[index].productType = info.productType;

    collections[index].duration = info.duration;
    collections[index].intDue = info.intDue;
    collections[index].loanDue = info.loanDue;
    collections[index].principalLoan = info.principalLoan;
    collections[index].loanRepaid = info.loanRepaid;
    collections[index].durationOverLoanDue = info.durationOverLoanDue;
    collections[index].durationOverIntDue = info.durationOverIntDue;
    collections[index].installmentNo = info.installmentNo;
    collections[index].cumInterestPaid = info.cumInterestPaid;
    collections[index].cumIntCharge = info.cumIntCharge;
    collections[index].interestCalculationMethod =
        info.interestCalculationMethod;
    collections[index].doc = info.doc;
    collections[index].fine = 0;
    collections[index].cumLoanDue = info.cumLoanDue;
    collections[index].cumIntDue = info.cumIntDue;

    if (collections[index].productType == 1) {
      var loanInfo = Calculate.loan(
          total: collections[index].amount,
          duration:
          collections[index].duration,
          intDue: collections[index].intDue,
          loanDue:
          collections[index].loanDue,
          principalLoan: collections[index]
              .principalLoan,
          loanRepaid:
          collections[index].loanRepaid,
          durationOverLoanDue: collections[index]
              .durationOverLoanDue,
          durationOverIntDue: collections[index]
              .durationOverIntDue,
          installmentNo: collections[index]
              .installmentNo,
          cumInterestPaid: collections[index]
              .cumInterestPaid,
          cumIntCharge: collections[index]
              .cumIntCharge,
          calcMethod: collections[index]
              .interestCalculationMethod,
          doc: collections[index].doc,
          orgId: collections[index].orgId,
          summaryId: collections[index].summaryId,
          vCumLoanDue: collections[index].cumLoanDue,
          vCumIntDue: collections[index].cumIntDue
      );
      collections[index].loanInstallment =
      loanInfo[
      'loanInstallment'];
      collections[index].intInstallment =
      loanInfo[
      'intInstallment'];

    }


    
  }
}