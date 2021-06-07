package com.evertec.elotouch.elotouch_flutter_plugin;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.elo.device.DeviceManager;
import com.elo.device.enums.EloPlatform;
import com.elo.device.exceptions.UnsupportedEloPlatform;
import com.elo.device.peripherals.Printer;

/** ElotouchFlutterPlugin */
public class ElotouchFlutterPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context applicationContext;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    applicationContext = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "elotouch_flutter_plugin");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    System.out.println("LLAMADA RECIBIDA!!!");
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("print")) {

      try {
        if(applicationContext == null){
          Log.e("CONTEXT NULO?", "SI");
        }else{
          Log.e("CONTEXT NULO?", "NO");

          DeviceManager manager = DeviceManager.getInstance(EloPlatform.PAYPOINT_REFRESH,applicationContext);
          //manager.getPrinter().
          //manager.getPrinter()
          Log.e("CONTEXT NULO?", "MANAGER CONSEGUIDO? ");

          Printer printer = manager.getPrinter();

          if(printer == null){

            Log.e("Status","IMPRESORA NO ENCONTRADA");
          }else{
            Log.e("Status","CREAMOS LA IMPRESORA");
          }

          // Log.e("haspaper? " , hasPaper? "true":"false");
        }

      } catch (UnsupportedEloPlatform unsupportedEloPlatform) {
        unsupportedEloPlatform.printStackTrace();
      }
      result.success("Ok, vamos a imprimir: " + call.arguments().toString());
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
