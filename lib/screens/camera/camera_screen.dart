import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbanker/config/app_config.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/services/member_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => _CameraScreenState();

}

class _CameraScreenState extends State<CameraScreen>{
  CameraController controller;
  String imagePath;
  static const int PHOTO=1;
  static const int SIG=2;

  List<CameraDescription> cameras = [];

  void loadCamera() async {
    var _cameras = await availableCameras();
    controller = CameraController(
        _cameras[0],
      ResolutionPreset.low,
      enableAudio: false
    );

    if(mounted) {
      controller.initialize().then((_){
        setState(() { });
      });

    }
  }

  @override
  void initState() {
    super.initState();

    loadCamera();
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> args = ModalRoute.of(context).settings.arguments;
    return WillPopScope(
      onWillPop: () async{
        Navigator.pushReplacementNamed(context, "/members");
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Column(

          children: <Widget>[
            Container(
              height: 80,
              child: Padding(
                padding: EdgeInsets.only(top:40,left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${args['member_code']} - ${args['first_name']}",
                    style: TextStyle(
                        color: Colors.blue
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child:Container(

                    child:Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Center(
                            child:_cameraPreviewWidget()
                        )
                    )
                )
            ),
            _captureControlRowWidget(args),
            Padding(
                padding: EdgeInsets.all(5.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _thumbnailWidget()
                  ],
                )
            )
          ],
        ),
      ),
    ) ;
  }

  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child:Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            imagePath == null?
              Container():
              SizedBox(
                child: Image.file(File(imagePath)),
                width: 64.0,
                height: 64.0,
              )
          ],
        )
      )
    );
  }

  Widget _cameraPreviewWidget() {
    if(controller == null || !controller.value.isInitialized){
      return Text(
        "Tap a Camera",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w800
        ),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width-130,

        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      );
    }
  }

  Widget _captureControlRowWidget(dynamic args){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.camera,color: Colors.white,),
              Text(" Photo",style: TextStyle(color: Colors.white),
              )
            ],
          ),


          color: Colors.blue,
          onPressed: (){
            if(controller != null && controller.value.isInitialized &&
            !controller.value.isRecordingPaused){
              handleSnapshot(args,type: PHOTO);
            }
          },
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)

          ),
          child: Row(
            children: <Widget>[
              Icon(Icons.camera,color: Colors.white,),
              Text(" Signature",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          color: Colors.blue,
          onPressed: (){
            if(controller != null && controller.value.isInitialized &&
                !controller.value.isRecordingPaused){
              handleSnapshot(args,type: SIG);
            }
          },
        )
      ],
    );
  }

  void handleSnapshot(dynamic args,{int type}) async{
    String filePath = await takePicture(args['id'],type);
    if(mounted){
      setState(() {
        imagePath = filePath;

      });
    }
  }

  Future<String> takePicture(int id, int type) async {
    MethodChannel platform = MethodChannel("gbanker/writefile");
    if(!controller.value.isInitialized){
      showErrorMessage("Error. select a camera first.", context);
      return null;
    }

    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (PermissionStatus.denied == permission) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
    }

    final Directory extDir = (await getExternalStorageDirectory());
    final String dirPath = '${extDir.path}${AppConfig.getImagePath()}'+((type==PHOTO)? 'images' : 'signatures');

    Directory directory = await Directory(dirPath).create(recursive: true);
    platform.invokeMethod("scanFile",{"path":extDir.path+'/Pictures'});
    platform.invokeMethod("scanFile",{"path":dirPath});

    final String filePath = '${dirPath}/${timestamp()}.jpg';

    if(controller.value.isTakingPicture){
      return null;
    }

    try{

      await controller.takePicture(filePath);

      platform.invokeMethod("scanFile",{"path":dirPath});
      platform.invokeMethod("scanFile",{"path":filePath});

//      print(dirPath+" "+filePath);

      // save memberImage
      if(type == PHOTO){
        await MemberService.updateImg(filePath, id);
      }
      if(type == SIG){
        await MemberService.updateSigImg(filePath, id);
      }



      Navigator.pushReplacementNamed(context,"/members");



    }on CameraException catch(e){
      showErrorMessage(e.description, context);
      return null;
    }
    return filePath;
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
}