package com.example.gbanker;

//import androidx.core.app.ActivityCompat;
//import androidx.core.content.ContextCompat;
//import android.support.v4.content.PermissionChecker;
import android.Manifest;
import android.content.pm.PackageManager;
import io.flutter.plugin.common.*;
import android.os.Bundle;
import android.media.MediaScannerConnection;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "gbanker/writefile";
  private static final int PERMISSION_REQUEST_RESULT = 0;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    MainActivity thisActivity = this;
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(),CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler(){
      public void onMethodCall(MethodCall call,MethodChannel.Result result){
        switch (call.method) {
          case "scanFile":
              MediaScannerConnection.scanFile(thisActivity,new String[]{call.argument("path")},null,null);
            break;
        }
      }
    });

  }

}
