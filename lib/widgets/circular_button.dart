import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbanker/helpers/exceptions/custom_exception.dart';

class CircularButton extends StatelessWidget{

  Function callback;

  CircularButton({this.callback});

  @override
  Widget build(BuildContext context) {

    return Center(
      child: InkWell(
        onTap: (){
          if(this.callback != null){
            try {
              this.callback();
            }catch(ex){
              print(ex);
            }
          }else{
            throw CustomException("Callback required",500);
          }
        },
        onTapDown: (detail){
          print(detail.localPosition);
        },
          child: Container(

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  offset: Offset(5.0, 5.0),
                  spreadRadius: -2.0)],
              ),
              height: 180.0,
              width: 180.0,
                child:
                Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      boxShadow: [BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.0,
                          offset: Offset(5.0, 5.0),
                          spreadRadius: -2.0)],
                    ),
                    height: 150.0,
                    width: 150.0,
                  child:Center(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Scan",style: TextStyle(fontSize: 28,color: Colors.white),),
                      Text("QR / Barcode",style: TextStyle(color: Colors.white),)
                    ],
                  ))
                )
            ),
          ),


    );
  }

}