import 'package:flutter/material.dart';
import 'package:gbanker/helpers/adapter/adapter.dart';

class WithdrawalAdapter implements Adapter{
  int memberId;
  int centerId;
  int officeId;
  int orgId;
  int productId;
  int summaryId;
  double amount;
  double dueAmount;
  String token;
  int trxType;
  int productType;
  double loanInstallment;
  double intInstallment;
  double intCharge;
  TextEditingController amountController = TextEditingController();
  FocusNode amountInputFocus = FocusNode();
  FocusNode fineInputFocus = FocusNode();
  bool isChanged=false;

  WithdrawalAdapter({this.productId,this.amount});

  Map<String,dynamic> toMap(){
    return {
      'memberId':memberId,
      'centerId':centerId,
      'officeId':officeId,
      'orgId':orgId,
      'productId':productId,
      'summaryId':summaryId,
      'amount':amount,
      'due_amount':dueAmount,
      'token':token,
      'trxType':trxType,
      'productType':productType,
      'loanInstallment':loanInstallment,
      'intInstallment':intInstallment,
      'intCharge':intCharge
    };
  }
}