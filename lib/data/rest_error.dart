import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';

import '../generated/locale_keys.g.dart';

/// Represents a REST error with it's message and details.
class ErrorResponse {
  String? entityName;
  String? errorKey;
  String? type;
  String? title;
  int? status;
  String? message;
  String? detail;
  String? params;

  static parse(e) {
    try {
      // Response may contain an error message
      dynamic map;
      try {
        map = e.response.data;
      } on NoSuchMethodError {
        // ignore
      }
      final data = map is Map ? map : jsonDecode(map);
      return ErrorResponse.fromJson(data).toString();
    } catch (_) {
      // Use a generic error
      try {
        if (e?.response?.data is String && e.response.data.isNotEmpty) {
          return e.response.data;
        }
      } catch (_) {}
      return LocaleKeys.msg_api_generic_error.tr();
    }
  }

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    entityName = json['entityName'];
    errorKey = json['errorKey'];
    type = json['type'];
    title = json['title'];
    status = json['status'];
    message = json['message'];
    detail = json['detail'];
    params = json['params'];
  }

  @override
  String toString() =>
      title! + (detail?.isNotEmpty ?? false ? ": $detail" : "");
}
