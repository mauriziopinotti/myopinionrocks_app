import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

Future<bool?> showConfirmDialog(
  BuildContext context, {
  String? title,
  required String message,
  String? okText,
  String? cancelText,
}) =>
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: title != null ? Text(title) : null,
              content: Text(message),
              actions: [
                TextButton(
                  child: Text(cancelText ?? LocaleKeys.lbl_cancel.tr()),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text(okText ?? LocaleKeys.lbl_ok.tr()),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ]);
        });
