import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';
import '../theme.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(
        Icons.heart_broken_rounded,
        size: 128,
        color: textTheme.bodyLarge!.color,
      ),
      const SizedBox(height: 16),
      Text(
        LocaleKeys.msg_api_generic_error.tr(),
        textAlign: TextAlign.center,
        style: textTheme.bodyLarge,
      ),
    ]);
  }
}
