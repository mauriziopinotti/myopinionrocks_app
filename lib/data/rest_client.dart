import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import '../data/storage.dart';
import '../flavors.dart';
import '../generated/locale_keys.g.dart';
import '../globals.dart';
import '../models/user.dart';
import 'login_registration.dart';

class RestClient {
  static final RestClient _instance = RestClient._internal();

  factory RestClient() {
    return _instance;
  }

  bool get initOk => _initOk;
  bool _initOk = false;

  String? get username => _username;
  String? _username;

  String? get accessToken => _accessToken;
  String? _accessToken;

  final Dio _dio = Dio()
    ..options.baseUrl = ENV.baseUrl! + ENV.apiContext
    ..interceptors.add(LogInterceptor(
      request: kDebugMode,
      requestHeader: kDebugMode,
      requestBody: kDebugMode,
      responseHeader: kDebugMode,
      responseBody: kDebugMode,
      error: true,
      logPrint: kIsWeb ? (_) {} : print,
    ));

  RestClient._internal() {
    // Add auth token to each request
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers.addAll({
        if (_accessToken != null) "Authorization": "Bearer $_accessToken",
        Headers.contentTypeHeader: Headers.jsonContentType,
        if (kIsMobile) HttpHeaders.userAgentHeader: userAgent,
      });
      return handler.next(options);
    }, onError: (e, handler) async {
      // TODO
      // handleRestError(e, null);
      return handler.reject(e);
    }, onResponse: (response, handler) async {
      // if (kDebugMode) await Future.delayed(Duration(seconds: 5));
      return handler.next(response);
    }));
  }

  Future<bool> init({bool force = false}) async {
    if (_initOk && !force) return true;

    // Fix SSL certificate on old devices
    await _fixSslCertificate();

    try {
      // Try to read username from secure storage
      _username = await MyStorage().read(key: 'username');
      _accessToken = await MyStorage().read(key: 'accessToken');
    } catch (e, s) {
      // Likely a secure storage issue (e.g. the app has been transferred to a new phone)
      print(e);
      print(s);
      doLogout();
    }

    // If logged update UserInfo
    _initOk = isUserLogged ? await updateUser() : true;

    return _initOk;
  }

  _fixSslCertificate() async {
    // Ignore SSL cert on Android 7, see https://letsencrypt.org/docs/dst-root-ca-x3-expiration-september-2021/
    if (kIsAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 25 /* Android 7.1 */) {
        _dio.httpClientAdapter = IOHttpClientAdapter(
            createHttpClient: () => HttpClient()
              ..badCertificateCallback =
                  (X509Certificate cert, String host, int port) => true);
      }
    }
  }

  Future<bool> saveTokens(LoginResponse? response) async {
    _accessToken = response?.accessToken;

    await MyStorage().write(key: 'username', value: _username);
    await MyStorage().write(key: 'accessToken', value: _accessToken);

    return _accessToken != null;
  }

  bool get isUserLogged => _accessToken?.isNotEmpty == true;

  Future<String?> doLogin(LoginRequest data) async {
    // Clean old tokens and info
    await doLogout();
    _username = data.username?.trim();

    // try {
      LoginResponse loginResponse;
      Response<String> response =
          await _dio.post<String>('/authenticate', data: data.toJson());
      loginResponse = LoginResponse.fromJson(jsonDecode(response.data!));

      if (await saveTokens(loginResponse)) {
        // Also, wait for user information to be populated
        await updateUser();
        return null;
      } else {
        return LocaleKeys.api_generic_error.tr();
      }
    // } catch (e, s) {
    //   print(e);
    //   print(s);
    //
    //   return e is DioException && e.response?.statusCode == 401
    //       ? LocaleKeys.message_login_failed.tr()
    //       : parseRestError(e);
    // }
  }

  Future<bool> doLogout() async {
    _accessToken = null;
    user = User();
    // SideMenuState.selectedMenu = null;

    // Set default theme
    // navigatorContext?.read<EasyThemeProvider>().applyTheme();

    return !(await saveTokens(null));
  }

  Future<String?> doRegistration(RegistrationRequest data) async {
    // Clean old tokens and info
    await doLogout();
    _username = data.username!.trim();

    // try {
      await _dio.post<String>('/register', data: data.toJson());

      return null;
    // } catch (e, s) {
    //   print(e);
    //   print(s);
    //
    //   return parseRestError(e);
    // }
  }

  Future<bool> updateUser() async {
    try {
      // Update userInfo
      Response<String> response = await _dio.get('/user-info');
      user = UserResponse.fromJson(jsonDecode(response.data!)).user ?? User();
      return user.isLogged;
    } catch (e) {
      if (e is DioException &&
          (e.response?.statusCode == 400 || e.response?.statusCode == 401)) {
        // Bad token
        doLogout();
        // Return "ok": user is forced to login again
        return true;
      }
      // Return "error": user is sent to error screen and can try again
      return false;
    }
  }

  // Future<Survey> getSurvey() async {
  //   Response<String> response = await _dio.get('/user-survey');
  //   return Survey.fromJson(jsonDecode(response.data!));
  // }
  //
  // Future<bool> createSurveyResult(SurveyResult result) async {
  //   Response<String> response =
  //       await _dio.post<String>('/user-survey-result', data: result.toJson());
  //
  //   return SurveyResult.fromJson(jsonDecode(response.data!));
  // }
}

// String? parseRestError(e) {
//   try {
//     // Response may contain an error message
//     dynamic map;
//     try {
//       map = e.response.data;
//     } on NoSuchMethodError {}
//     final data = map is Map ? map : jsonDecode(map);
//     return ErrorResponse.fromJson(data).toString();
//   } catch (_) {
//     // Use a generic error
//     try {
//       if (e?.response?.data is String && e.response.data.isNotEmpty)
//         return e.response.data;
//     } catch (_) {}
//     return LocaleKeys.api_generic_error.tr();
//   }
// }

// String? handleRestError(e, s, {bool show = true}) {
//   // Print the error
//   print(e);
//   print(s);
//
//   // Show the error
//   String? error = parseRestError(e);
//   if (show) showMessage(error!);
//
//   return error;
// }
