import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';
import '../theme.dart';

/// An error screen with message and icon.
class ErrorScreen extends StatelessWidget {
  final String? message;
  final String? error;
  final IconData? icon;

  const ErrorScreen({
    super.key,
    this.message,
    this.error,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(
        icon ?? Icons.heart_broken_rounded,
        size: 128,
        color: primaryColor,
      ),
      const SizedBox(height: 16),
      Text(
        message ?? LocaleKeys.msg_api_generic_error.tr(),
        textAlign: TextAlign.center,
        style: textTheme.bodyLarge,
      ),
      const SizedBox(height: 16),
      if (error != null)
        Text(
          error!,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall,
        ),
    ]);
  }
}
