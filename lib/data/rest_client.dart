// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../data/storage.dart';
import '../flavors.dart';
import '../globals.dart';
import '../models/survey.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'login.dart';
import 'registration.dart';
import 'rest_error.dart';
import 'survey.dart';

class RestClient {
  static final RestClient _instance = RestClient._internal();

  factory RestClient() {
    return _instance;
  }

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
      // handleRestError(e, null);
      return handler.reject(e);
    }, onResponse: (response, handler) async {
      // if (kDebugMode) await Future.delayed(Duration(seconds: 5));
      return handler.next(response);
    }));
  }

  init(BuildContext context) async {
    // Fix SSL certificate on old devices
    await _fixSslCertificate();

    try {
      // Try to read username from secure storage
      _accessToken = await MyStorage().read(key: 'accessToken');
      String? userData = await MyStorage().read(key: 'userData');
      if (_accessToken != null && userData != null) {
        User user = User.fromJson(jsonDecode(userData));
        context.read<UserProvider>().login(user);
      }
    } catch (e, s) {
      // Likely a secure storage issue (e.g. the app has been transferred to a new phone)
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      doLogout(context);
    }
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
    await MyStorage().write(key: 'accessToken', value: _accessToken);
    if (_accessToken == null) {
      await MyStorage().write(key: 'userData', value: null);
    }

    return _accessToken != null;
  }

  Future<User> doLogin(BuildContext context, LoginRequest data) async {
    // Clean old tokens and info
    await doLogout(context);
    context.read<UserProvider>().logout();

    // Do login
    LoginResponse loginResponse;
    Response<String> response =
        await _dio.post<String>('/authenticate', data: data.toJson());
    loginResponse = LoginResponse.fromJson(jsonDecode(response.data!));
    await saveTokens(loginResponse);

    // Get user data
    response = await _dio.get('/account');
    final user = User.fromJson(jsonDecode(response.data!));
    await MyStorage().write(key: 'userData', value: jsonEncode(user.toJson()));

    // Notify login to all consumers
    context.read<UserProvider>().login(user);

    return user;
  }

  Future<bool> doLogout(BuildContext context) async {
    _accessToken = null;
    context.read<UserProvider>().logout();
    return !(await saveTokens(null));
  }

  Future<User> doRegistration(
      BuildContext context, RegistrationRequest data) async {
    // Clean old tokens and info
    await doLogout(context);

    // Register user
    await _dio.post<String>('/register', data: data.toJson());

    // Login
    return doLogin(
      context,
      LoginRequest(username: data.email, password: data.password),
    );
  }

  Future<Survey> getSurvey() async {
    Response<String> response = await _dio.get('/user-survey');
    // await Future.delayed(Duration(seconds: 5)); // XXX
    return Survey.fromJson(jsonDecode(response.data!));
  }

  Future<SurveySubmissionResponse> createSurveyResult(
      SurveySubmissionRequest request) async {
    Response<String> response =
        await _dio.post<String>('/user-survey-result', data: request.toJson());

    return SurveySubmissionResponse.fromJson(jsonDecode(response.data!));
  }
}

String? handleRestError(e, s, {bool show = true}) {
  // Print the error
  debugPrint(e?.toString());
  debugPrintStack(stackTrace: s);

  // Show the error
  String? error = ErrorResponse.parse(e);
  if (show) showMessage(error!);

  return error;
}
