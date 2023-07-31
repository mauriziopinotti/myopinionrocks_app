import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:myopinionrocks_app/theme.dart';

/// A loader to show while performing REST requests or other long operations.
class MyLoader extends StatelessWidget {
  final String message;

  const MyLoader(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            Container(
                constraints: const BoxConstraints(maxWidth: 150),
                child: const LoadingIndicator(
                  indicatorType: Indicator.audioEqualizer,
                  colors: [
                    primaryColor,
                    secondaryColor,
                    tertiaryColor,
                    textColor,
                  ],
                ))
          ]),
    );
  }
}
