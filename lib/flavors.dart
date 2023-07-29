import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../globals.dart';

// ignore: non_constant_identifier_names
late Env ENV;

class Env {
  static AndroidDeviceInfo? _androidInfo;

  static init() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsAndroid) _androidInfo = await deviceInfo.androidInfo;

    // https://www.chwe.at/2020/10/flutter-flavors/
    String flavor = kIsWeb
        ? const String.fromEnvironment("flavor")
        : (await const MethodChannel('flavor')
            .invokeMethod<String>('getFlavor'))!;
    ENV = Env.fromFlavor(flavor);
    print("Env from flavor $flavor: $ENV");
  }

  static fromFlavor(String flavor) {
    switch (flavor) {
      case 'local':
        return Env.local();
      case 'prod':
      default:
        return const Env.prod();
    }
  }

  static String? androidEmulatorFix(String? url) => kIsAndroid && kDebugMode
      ? url?.replaceAll(
          "http://localhost",
          _androidInfo?.isPhysicalDevice == true
              ? "http://192.168.1.68"
              : "http://10.0.2.2")
      : url;

  final String? baseUrl;
  final String apiContext;
  final String webContext;

  const Env({
    required this.baseUrl,
    this.apiContext = '/',
    this.webContext = '/web',
  });

  /// Local server from browser or Android emulator
  Env.local()
      : this(
          baseUrl: androidEmulatorFix('http://localhost:8080'),
          apiContext: '/api',
        );

  /// Prod server
  const Env.prod()
      : this(
          baseUrl: 'https://easyhour.app',
          apiContext: '/api',
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Env &&
          runtimeType == other.runtimeType &&
          baseUrl == other.baseUrl;

  @override
  int get hashCode => baseUrl.hashCode;

  @override
  String toString() {
    return '\n*** Env{baseUrl: $baseUrl, apiContext: $apiContext} ***\n';
  }
}
