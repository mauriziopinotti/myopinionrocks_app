import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'generated/locale_keys.g.dart';
import 'theme.dart';

// Platform
final bool kIsAndroid = !kIsWeb && Platform.isAndroid;
final bool kIsIos = !kIsWeb && Platform.isIOS;
final bool kIsMobile = !kIsWeb && (kIsAndroid || kIsIos);
const int kLandscapeUiWidthBreakpoint = 1024;
late bool kIsLandscapeUi;

/// Supported languages
const supportedLanguages = [
  Locale('en', 'US'),
  Locale('en', 'UK'),
  Locale('en', 'IE'),
  Locale('it', 'IT'),
];

/// Navigation
BuildContext? get navigatorContext => navigatorKey.currentState?.context;
final navigatorKey = GlobalKey<NavigatorState>();

Future<T?> push<T extends Object?>(
  Widget screen, {
  bool replace = false,
}) {
  final nav = Navigator.of(navigatorContext!);
  final route = MaterialPageRoute<T>(builder: (context) => screen);
  return replace ? nav.pushReplacement(route) : nav.push(route);
}

back() => Navigator.of(navigatorContext!).pop();

late PackageInfo packageInfo;

String get userAgent => "MyOpinionRocksApp/${packageInfo.version} "
    "(${Platform.operatingSystem}/${Platform.operatingSystemVersion}; "
    "${packageInfo.appName}/${packageInfo.buildNumber})";

showMessage(
  String message, {
  SnackBarAction? action,
  bool removeCurrentMessage = true,
}) {
  final messenger = ScaffoldMessenger.of(navigatorContext!);
  if (removeCurrentMessage) messenger.removeCurrentSnackBar();
  messenger.showSnackBar(SnackBar(
    content: Text(message, style: snackBarStyle),
    behavior: SnackBarBehavior.floating /* for ConvexAppBar */,
    duration: const Duration(seconds: 4),
    width:
        kIsLandscapeUi ? MediaQuery.of(navigatorContext!).size.width / 2 : null,
    action: action ??
        SnackBarAction(
          label: LocaleKeys.lbl_ok.tr(),
          textColor: Theme.of(navigatorContext!).primaryColor,
          onPressed: () => messenger.hideCurrentSnackBar(),
        ),
  ));
}

class WebAndMobileScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
