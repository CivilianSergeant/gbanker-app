import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbanker/helpers/custom_launcher.dart';

class CustomDialog extends StatefulWidget {

  TextEditingController searchField;
  bool showAbout;
  bool showProgress;
  Function searchMemberCodeCallback;
  Function progressCallback;
  double width;
  double height;

  CustomDialog({this.searchField,this.showAbout,this.showProgress,this.width,
    this.height,
  this.searchMemberCodeCallback,this.progressCallback});

  @override
  State<StatefulWidget> createState() => CustomDialogState();




}

class CustomDialogState extends State<CustomDialog> {


  @override
  Widget build(BuildContext context) {
    if(widget.showAbout != null && widget.showAbout==true){
      return showAboutDialog(context);
    }else if(widget.showProgress!= null && widget.showProgress==true){
      return showProgressDialog(context);
    }
    return showSearchMemberCodeDialog(context);
  }

  Widget showProgressDialog(BuildContext context){
    return Dialog(

        shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20.0)), //this right here
        child: Container(
          width: (widget.width != null)? widget.width : 150,
          height: (widget.height != null)? widget.height:50,
          child:widget.progressCallback()
        )
    );
  }
  Widget showAboutDialog(BuildContext context){
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20.0)), //this right here
      child: Container(
        width: 300,
        height: 130,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("gBanker",style:
              TextStyle(fontSize: 26,fontWeight: FontWeight.w800),),
              Text("version no: 119",style:
              TextStyle(fontSize: 16,
                  color: Colors.black54,fontWeight: FontWeight.w800),),
              SizedBox(height: 10,),
              Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child:SizedBox(

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: <Widget>[
                        RaisedButton(
                          onPressed: () async {
                            await CustomLauncher.launchURL();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Check For Update",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                        ),
                        RaisedButton(
                          onPressed: () {

                            Navigator.pop(context);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: const Color(0xFF1BC0C5),
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

   Widget showSearchMemberCodeDialog(BuildContext context){
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(10.0)), //this right here
      child: Container(
        width: 300,
        height: 170,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10,bottom: 5,left: 10),
                child: Text("Search Member",style:
                TextStyle(fontSize: 18,fontWeight: FontWeight.w800,
                color: Colors.black54),),
              ),
              Divider(),
              Spacer(),
              Center(
                child: SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width-100,
                    child:Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            hintText: "Type Member Code"
                        ),
                        controller: widget.searchField,
                      ),
                    )

                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width-100,
                    child: Padding(
                        padding: EdgeInsets.only(left: 0,bottom: 10),
                        child:RaisedButton(
                          child: Text("Search"),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () async {
                            widget.searchMemberCodeCallback(widget.searchField.text);
                          },
                        ))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



