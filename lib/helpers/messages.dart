import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void showSuccessMessage(String msg,BuildContext context){
  Toast.show(msg, context,
      duration: Toast.LENGTH_LONG,gravity: Toast.TOP,
      backgroundColor: Colors.green,
      textColor: Colors.white);
}

void showErrorMessage(String msg,BuildContext context){
  Toast.show(msg, context,
      duration: Toast.LENGTH_LONG,gravity: Toast.TOP,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}