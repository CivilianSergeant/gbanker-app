import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin PortraitModeMixin on StatelessWidget{
  Widget build(BuildContext context){
    _portraitModeOnly();
    return null;
  }
}

void _portraitModeOnly(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
}