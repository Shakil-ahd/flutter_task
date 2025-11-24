import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceInfoService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.app/device_info',
  );

  static void initDeepLinkListener() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "onDeepLink") {
        final uri = call.arguments as String;
        debugPrint("Received deep link: $uri");
      }
    });
  }

  static Future<String> getDeviceInfo() async {
    try {
      final String result = await _channel.invokeMethod('getDeviceInfo');
      return result;
    } on PlatformException catch (e) {
      return "Failed: ${e.message}";
    }
  }

  static Future<void> showDeviceInfo(BuildContext context) async {
    final deviceInfo = await getDeviceInfo();
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.smartphone,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Device Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                deviceInfo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
