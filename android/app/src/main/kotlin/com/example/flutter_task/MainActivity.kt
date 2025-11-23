package com.example.flutter_task 

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build

class MainActivity: FlutterActivity() {
    
    private val CHANNEL = "com.example.app/device_info" 

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getDeviceInfo") {
                val deviceInfo = getDeviceInfo()
                result.success(deviceInfo)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getDeviceInfo(): String {
        val model = Build.MODEL
        val version = Build.VERSION.RELEASE
        return "Model: $model\nAndroid Version: $version"
    }
}