import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:package_info_plus/package_info_plus.dart';

import 'models/user.dart';

// Platform
final bool kIsAndroid = !kIsWeb && Platform.isAndroid;
final bool kIsIos = !kIsWeb && Platform.isIOS;
final bool kIsMobile = !kIsWeb && (kIsAndroid || kIsIos);
const int kLandscapeUiWidthBreakpoint = 1024;
const double kLandscapeRightSideBarWidth = 320;
const double kLandscapeLeftSideBarExpandedWidth = 240;
const double kLandscapeLeftSideBarCollapsedWidth = 54;
late bool kIsLandscapeUi;
late DeviceOrientation kDefaultOrientation;
late BoxConstraints boxConstraints;

// Date and time
// late DateFormat restDateFormat;

/// Supported languages
const supportedLanguages = [
  Locale('en', 'US'),
  Locale('en', 'UK'),
  Locale('en', 'IE'),
  Locale('it', 'IT'),
];

/// Navigation
// BuildContext? get navigatorContext => navigatorKey.currentState?.context;
// final navigatorKey = GlobalKey<NavigatorState>();
Future<T?> push<T extends Object?>(
  BuildContext context,
  Widget screen, {
  bool replace = false,
}) {
  final nav = Navigator.of(context);
  final route = MaterialPageRoute<T>(builder: (context) => screen);
  return replace ? nav.pushReplacement(route) : nav.push(route);
}

/// User and company info and config
User user = User();
late PackageInfo packageInfo;
// late DateFormat displayDateFormat;
// late DateFormat displayTimeFormat;
// late DateFormat displayNoYearDateFormat;
// late DateFormat displayMonthFormat;
// late DateFormat displayMonthYearFormat;
// late DateFormat dayNameFormat;
// late String deviceTimeZone;

String get userAgent => "MyOpinionRocksApp/${packageInfo.version} "
    "(${Platform.operatingSystem}/${Platform.operatingSystemVersion}; "
    "${packageInfo.appName}/${packageInfo.buildNumber})";

// showMessage(
//   String message, {
//   Duration? duration,
//   SnackBarAction? action,
//   bool removeCurrentMessage = true,
// }) {
//   if (navigatorContext == null) {
//     print("WARNING: trying to show a message before UI is ready!");
//     return;
//   }
//
//   final messenger = ScaffoldMessenger.of(navigatorContext!);
//   if (removeCurrentMessage) messenger.removeCurrentSnackBar();
//   messenger
//     ..showSnackBar(SnackBar(
//       content: Text(message, style: snackBarStyle),
//       behavior: SnackBarBehavior.floating /* for ConvexAppBar */,
//       duration: duration ?? Duration(seconds: 4),
//       width: kIsLandscapeUi
//           ? MediaQuery.of(navigatorContext!).size.width / 2
//           : null,
//       action: action ??
//           SnackBarAction(
//             label: LocaleKeys.label_ok.tr(),
//             textColor: Theme.of(navigatorContext!).primaryColor,
//             onPressed: () => messenger.hideCurrentSnackBar(),
//           ),
//     ));
// }
