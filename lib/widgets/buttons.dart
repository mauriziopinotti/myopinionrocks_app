import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback? onPressed;
  final bool expanded;

  const MyButton(
    this.label, {
    super.key,
    this.color,
    required this.onPressed,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            onPressed != null
                ? (color ?? primaryColor)
                : Colors.grey.withOpacity(0.5),
          ),
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(
            vertical: kIsWeb ? 14 : 10,
            horizontal: 20,
          ))),
      onPressed: onPressed,
      child: Text(label.toUpperCase(), maxLines: 1),
    );

    // Expand
    if (expanded) {
      button = Container(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Row(children: [
            Expanded(child: button),
          ]));
    }

    // Add padding
    return Padding(
      padding: const EdgeInsets.all(4),
      child: button,
    );
  }
}

class MySecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const MySecondaryButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return icon != null
        ? TextButton.icon(
            icon: Icon(icon, color: textTheme.bodyMedium!.color),
            label: Text(label, style: textTheme.bodyMedium, maxLines: 1),
            onPressed: onPressed,
          )
        : TextButton(
            onPressed: onPressed,
            child: Text(label, style: textTheme.bodyMedium, maxLines: 1),
          );
  }
}
