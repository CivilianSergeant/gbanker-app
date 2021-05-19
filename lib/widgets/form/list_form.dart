import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:gbanker/helpers/adapter/adapter.dart';
import 'package:gbanker/helpers/adapter/collection_adapter.dart';
import 'package:gbanker/helpers/calculate.dart';
import 'package:gbanker/persistance/entities/DataSet.dart';

class ListForm<T> extends StatefulWidget{

  List<T> adapter;
  List<T> collections;
  double fontSize;
  Function calculateTotal;
  Function dataLoader;


  ListForm({
    this.collections,
    this.adapter,
    this.fontSize,
    this.calculateTotal,
    this.dataLoader
  });

  @override
  State<StatefulWidget> createState() => ListFormState();

}

class ListFormState extends State<ListForm>{

  double leftColWidth;
  double rightColWidth;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: MediaQuery.of(context).size.height - 320,
      child: ListView.builder(
        itemBuilder: (context, i) {
          var info = widget.collections[i];

          dynamic adapter = widget.adapter[i];
          dynamic nexAdapter = (widget.adapter.length > (i+1))? widget.adapter[i+1] : null;

          var index = i;
          try {
            if (widget.adapter.length > 0) {
              var l = widget.adapter.elementAt(index);

              if (l != null && l.isChanged == false) {

                widget.dataLoader(widget.adapter,index,info);



                widget.adapter[index].fineController.text =
                    0.toStringAsFixed(0);
                widget.adapter[index].amountController.text =
                    widget.adapter[index].amount.toStringAsFixed(0);



              }
            }
          } catch (ex) {
            //  print("ERROR: "+ex.toString());
          }
          return InkWell(
              onTap: () {
                if (widget.adapter[index]
                    .amountController
                    .text
                    .length >
                    0) {
                  FocusScope.of(context)
                      .requestFocus(FocusNode());
                }
//                print(widget.adapter[index].fine.toString());
              },
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    bottom: 2, left: 3, right: 3, top: 5),
                padding: EdgeInsets.only(
                    top: 5, left: 7, right: 7, bottom: 5),
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: (info.productType == 1)
                                ? Colors.redAccent
                                : Colors.blueAccent,
                            width: 2),
                        bottom: BorderSide(
                            color: Colors.black12,
                            width: 0.8),
                        top: BorderSide(
                          color: Colors.black12,
                          width: 0.5
                        )
                    )

                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Account No: ${info.accountNo}",
                          style: TextStyle(
                              fontSize: (Device.get().isTablet)? 16 : 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        Text(
                            "Installment No: ${info.installmentNo.toString()}",
                            style: TextStyle(
                                fontSize: widget.fontSize,
                                color: Colors.black))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin:EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Product: ${info.productName}",
                            style: TextStyle(
                                fontSize: widget.fontSize,
                                color: Colors.black),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: leftColWidth,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                              children: <Widget>[
                                Text(
                                    "${(info.productType == 1) ? 'Recoverable' : 'Installment'}: ",
                                    style: TextStyle(
                                        fontSize: widget.fontSize,
                                        color: Colors.black)
                                ),
                                Text("${info.recoverable.toStringAsFixed(0)}",style: TextStyle(
                                      fontSize: widget.fontSize
                                  ),
                                )
                              ],
                            ),
                          )
                          ,
                          SizedBox(
                            width: rightColWidth,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    "${(info.productType == 1) ? 'Total Balance' : 'Sav. Balance'}: ",
                                    style: TextStyle(
                                        fontSize: widget.fontSize,
                                        color: Colors.black)),
                                Text("${info.balance.toStringAsFixed(0)}",style: TextStyle(fontSize: widget.fontSize),)
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        SizedBox(
                        width: leftColWidth,
                        child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                        children: <Widget>[
                          Text(
                              "${(info.productType == 1) ? 'Prin. Balance' : 'Deposit'}: ",
                              style: TextStyle(
                                  fontSize: widget.fontSize,
                                  color: Colors.black)),
                          Text("${(info.productType == 1) ? info.prinBalance.toStringAsFixed(0) : info.personalSaving.toStringAsFixed(0)}",
                          style: TextStyle( fontSize: widget.fontSize,
                              color: Colors.black),)

                          ]))
                          ,
                          SizedBox(
                            width: rightColWidth,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    "${(info.productType == 1) ? '${showScOrInt(info, false)} Balance' : 'Cur. Int.'}: ",
                                    style: TextStyle(
                                        fontSize: widget.fontSize,
                                        color: Colors.black)),
                                Text("${info.serBalance.toStringAsFixed(0)}",
                                style: TextStyle(fontSize: widget.fontSize),)
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                          width: leftColWidth,
                          child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                          children: <Widget>[
                            Text(
                                "${(info.productType == 1) ? 'Due/O.Due/Adv' : '${showAppOrBank(info)} Interest'}:",
                                style: TextStyle(
                                    fontSize: widget.fontSize,
                                    color: (info.productType == 1 && info.newDue>0) ?Colors.red :
                                    ((info.productType == 1 && info.newDue<0)?Colors.green : Colors.black),
                                    fontWeight: (info.productType == 1 && (info.newDue>0 || info.newDue<0)) ? FontWeight.w800 : FontWeight.normal)),

                            Text("${info.newDue.toStringAsFixed(0)}",
                                style: TextStyle(
                                    fontSize: widget.fontSize,
                                    color: (info.productType == 1 && info.newDue>0) ?Colors.red :
                                    ((info.productType == 1 && info.newDue<0)?Colors.green : Colors.black),
                                    fontWeight: (info.productType == 1 && (info.newDue>0 || info.newDue<0)) ? FontWeight.w800 : FontWeight.normal))

                          ])),
                          SizedBox(
                            width: rightColWidth,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    "${(info.productType == 1) ? '${showScOrInt(info, false)} Paid' : 'P. Withdraw'}: ",
                                    style: TextStyle(
                                        fontSize: widget.fontSize,
                                        color: Colors.black)),

                                Text("${(info.productType == 1) ? info.scPaid.toStringAsFixed(0) : info.personalWithdraw.toStringAsFixed(0)}",
                                style: TextStyle(fontSize: widget.fontSize),)
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                    showDisburseInfo(info),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("Amount: ",
                                  style: TextStyle(
                                      fontSize: widget.fontSize,
                                      color: Colors.black)),
                              SizedBox(
                                width: 85,
                                height: 30,
                                child: TextFormField(
                                  focusNode: adapter.amountInputFocus,
                                  textInputAction: (nexAdapter!=null)? TextInputAction.next : TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  onFieldSubmitted: (term){
                                      var fineEnabled=0;
                                      if(info.productCode.substring(0,2)=="23"){
                                        fineEnabled = 1;
                                      }

                                      if(fineEnabled>0){
                                        FocusNode currentFocus = adapter.amountInputFocus;
                                        currentFocus.unfocus();
                                        FocusNode nextFocus = adapter.fineInputFocus;
                                        FocusScope.of(context).requestFocus(nextFocus);

                                      }else{
                                        if(nexAdapter!=null) {

                                          FocusNode currentFocus = adapter.amountInputFocus;
                                          currentFocus.unfocus();

                                          FocusNode nextFocus = nexAdapter.amountInputFocus;
                                          FocusScope.of(context).requestFocus(nextFocus);
                                        }
                                      }



                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                    EdgeInsets.only(
                                      bottom: 5,
                                      left: 10),
                                    border:
                                    OutlineInputBorder(
                                      gapPadding: 0,
                                      borderSide:
                                      BorderSide(
                                        color: Colors
                                            .black54,
                                        width: 1.0,
                                      ))),
                                  onTap: () {
                                    widget.adapter[index].isChanged = true;

                                    widget.adapter[index].amountController.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset:
                                            widget.adapter[ index] .amountController .text .length);
                                  },
                                  controller: (widget.adapter
                                      .length >
                                      0 &&
                                      widget.adapter[
                                      index] !=
                                          null)
                                      ? widget.adapter[index]
                                      .amountController
                                      : null,
                                  onChanged: (value) {
                                    if (widget.adapter.isNotEmpty &&
                                        value != null &&
                                        value != "") {
                                      try {
                                        widget.adapter[index].isChanged = true;
                                        widget.adapter[index].amount = double.parse(value);
                                        var amount = widget.adapter[ index] .amount;
                                        var lc = widget.adapter[index];
                                        if (lc.productType == 1) {
                                          var loanInfo = Calculate.loan(
                                              total: amount,
                                              duration:
                                              lc.duration,
                                              intDue: lc.intDue,
                                              loanDue:
                                              lc.loanDue,
                                              principalLoan: lc
                                                  .principalLoan,
                                              loanRepaid:
                                              lc.loanRepaid,
                                              durationOverLoanDue: lc
                                                  .durationOverLoanDue,
                                              durationOverIntDue: lc
                                                  .durationOverIntDue,
                                              installmentNo: lc
                                                  .installmentNo,
                                              cumInterestPaid: lc
                                                  .cumInterestPaid,
                                              cumIntCharge: lc
                                                  .cumIntCharge,
                                              calcMethod: lc
                                                  .interestCalculationMethod,
                                              doc: lc.doc,
                                              orgId: lc.orgId,
                                              summaryId: lc.summaryId,
                                              vCumLoanDue: lc.cumLoanDue,
                                              vCumIntDue: lc.cumIntDue
                                          );
                                          lc.loanInstallment =
                                          loanInfo[
                                          'loanInstallment'];
                                          lc.intInstallment =
                                          loanInfo[
                                          'intInstallment'];
                                          setState(() {
                                            widget.adapter[
                                            index] = lc;
                                          });
                                        }

                                        setState(() {
                                          widget.calculateTotal();
                                        });
                                      } catch (ex) {
                                        //  print(ex.getMessage());
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          showOptionalColumn(index, info),
                          showFineValue(info)
                        ],
                      ),
                    )
                  ],
                ),
              ));
        },
        itemCount: widget.collections.length,
      ),
    );
  }

  String showScOrInt(dynamic info,bool short){
    if(info !=null){
      if(info.orgId == 1){
        return (short)? "I": "Int";
      }else{
        return (short)? "S": "SC";
      }
    }
    return "";
  }

  String showAppOrBank(dynamic info){
    if(info !=null){
      if(info.orgId == 1){
        return "Bank";
      }else{
        return "App.";
      }
    }
    return "";
  }

  Widget showFineValue(dynamic info){
    if(info.orgId ==  54){
      return Container();
    }
    if(info.orgId == 1) {
      if(info.allowFine == 1) {
        return Text(
            "Fine: ${info.fine.toStringAsFixed(0)}",
            style: TextStyle(
                fontSize: widget.fontSize,
                color: Colors.black));
      }else{
        return SizedBox.shrink();
      }
    }
    else {
      return Text(
          "Fine: ${info.fine.toStringAsFixed(0)}",
          style: TextStyle(
              fontSize: widget.fontSize,
              color: Colors.black));

    }
  }

  Widget showDisburseInfo(dynamic info){
    if(info.productType==0){
        return Container();
    }
    return Container(
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
              width: leftColWidth,
              child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    Text(
                        "Disb. Amount: ",
                        style: TextStyle(
                            fontSize: widget.fontSize,
                    )),

                    Text("${info.disburseAmount.toStringAsFixed(0)}",
                        style: TextStyle(
                            fontSize: widget.fontSize,
                    ))

                  ])),
          SizedBox(
            width: rightColWidth,
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    "Disb. Date: ",
                    style: TextStyle(
                        fontSize: widget.fontSize,
                        color: Colors.black)),
                Text("${info.disburseDate.toString().substring(0,10)}",
                style: TextStyle(
                  fontSize: widget.fontSize
                ),)
              ],
            ),
          )

        ],
      ),
    );
  }



  Widget showPrincipalInfo(int index){
    var lc = widget.adapter[index];
    var principal = double.parse(lc.loanInstallment.toString()).round();
    var serviceCharge = double.parse(lc.intInstallment.toString()).round();
    return Text("P: ${principal.toString()}    ${showScOrInt(lc, true)}: ${serviceCharge.toString()}",
      style: TextStyle(fontSize: widget.fontSize),);
  }

  Widget showFineInfo(int index){
    dynamic adapter = widget.adapter[index];

    dynamic nexAdapter = (widget.adapter.length > (index+1))? widget.adapter[index+1] : null;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("Fine: ",
                  style: TextStyle(fontSize: widget.fontSize, color: Colors.black)),
              SizedBox(
                width: 65,
                height: 30,
                child: TextFormField(
                  focusNode: adapter.fineInputFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  textInputAction: (nexAdapter!=null)? TextInputAction.next:TextInputAction.done,
                  onFieldSubmitted: (term){
                    FocusNode currentFocus = adapter.fineInputFocus;
                    currentFocus.unfocus();

                    if(nexAdapter!=null) {
                      FocusNode nextFocus = nexAdapter.amountInputFocus;
                      FocusScope.of(context).requestFocus(nextFocus);
                    }
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 5, left: 10),
                      border: OutlineInputBorder(
                          gapPadding: 0,
                          borderSide: BorderSide(
                            color: Colors.black54,
                            width: 1.0,
                          ))),
                  onTap: () {
                    widget.adapter[index].fineController.selection =
                        TextSelection(
                            baseOffset: 0,
                            extentOffset: widget.adapter[index]
                                .fineController
                                .text
                                .length);
                  },
                  controller: (widget.adapter.length > 0 &&
                      widget.adapter[index] != null)
                      ? widget.adapter[index].fineController
                      : null,
                  onChanged: (value) {
                    if (widget.adapter.isNotEmpty &&
                        value != null &&
                        value != "") {
                      try {
                        widget.adapter[index].fine = double.parse(value);
                        widget.adapter[index].isChanged = true;
                      } catch (ex) {
                        //  print(ex.getMessage());
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget showOptionalColumn(int index, dynamic info) {
    if (info.productType == 1) {
      return showPrincipalInfo(index);
    }
    if(info.orgId == 1){
      if(info.allowFine == 1){
        return showFineInfo(index);
      }else{
        return SizedBox.shrink();
      }
    }else{
      if (info.productCode.substring(0, 2) == "23") {
        return (info.orgId==54)? SizedBox.shrink() : showFineInfo(index);
      } else {
        return SizedBox.shrink();
      }
    }

  }

  @override
  void initState() {
    setState(() {
      leftColWidth = (Device.get().isTablet)? 150 : 130;
      rightColWidth = (Device.get().isTablet)? 150 : 130;
    });
  }

}