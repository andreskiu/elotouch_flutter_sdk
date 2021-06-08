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
import com.elo.device.enums.Alignment;
import com.elo.device.enums.EloPlatform;
import com.elo.device.exceptions.UnsupportedEloPlatform;
import com.elo.device.peripherals.Printer;

import java.io.IOException;


/**
 * ElotouchFlutterPlugin
 */
public class ElotouchFlutterPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context applicationContext;
    private DeviceManager manager;
    private Printer printer;
    private boolean isDeviceSupported = true;
    static final String unsupportedDevice = "1";
    static final String errorInComunicationWithPrinter = "2";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        applicationContext = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "elotouch_flutter_plugin");
        channel.setMethodCallHandler(this);

        try {
            if (applicationContext == null) {
                Log.e("CONTEXT NULO?", "Context null");
            } else {
                manager = DeviceManager.getInstance(EloPlatform.PAYPOINT_REFRESH, applicationContext);
                printer = manager.getPrinter();
            }

        } catch (UnsupportedEloPlatform unsupportedEloPlatform) {
            unsupportedEloPlatform.printStackTrace();
            isDeviceSupported = false;

        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {


        if (!isDeviceSupported) {
            result.error(unsupportedDevice, "UnsupportedDevice", "");
        }

        switch (call.method) {
            case "print":
                printText(call.arguments.toString(), result);
                break;
            case "setBold":
                setBold((boolean) call.arguments, result);
                break;
            case "setAlignment":
                setAlignment(Alignment.values()[(int) call.arguments], result);
                break;
            case "feed":
                feed((int) call.arguments, result);
                break;
            case "setFontSize":
                setFontSize((int) call.argument("height"), (int) call.argument("width"), result);
                break;
            case "hasPaper":
                hasPaper(result);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void hasPaper(Result result) {
        try {
            final boolean hasPaper = printer.hasPaper();
            result.success(hasPaper);
        } catch (IOException e) {
            result.error(errorInComunicationWithPrinter, e.getMessage(), "");
        }

    }

    private void printText(String text, Result result) {
        printer.print(text);
        result.success(true);
    }

    private void feed(int lines, Result result) {
        printer.feed(lines);
        result.success(true);
    }

    private void setAlignment(Alignment alignment, Result result) {
        printer.setAlignment(alignment);
        result.success(true);
    }

    private void setBold(boolean boldOn, Result result) {
        printer.setBold(boldOn);
        result.success(true);
    }

    private void setFontSize(int height, int width, Result result) {
        printer.setFontSize(height, width);
        result.success(true);
    }
}
