import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback? onPressed;

  const MyButton(
    this.label, {
    super.key,
    this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              onPressed != null
                  ? (color ?? primaryColor)
                  : Colors.grey.withOpacity(0.5),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(
              vertical: kIsWeb ? 14 : 10,
              horizontal: 20,
            ))),
        onPressed: onPressed,
        child: Text(label.toUpperCase()),
      ),
    );
  }
}
