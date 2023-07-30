import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import '../theme.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;

  const MyScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb || !kIsLandscapeUi,
        centerTitle: true,
        title: Hero(
          tag: 'my-app-bar',
          child: Image.asset('assets/images/logo.png'),
        ),
        iconTheme: const IconThemeData(color: primaryColor),
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
          kIsLandscapeUi =
              constraints.maxWidth >= kLandscapeUiWidthBreakpoint &&
                  MediaQuery.of(context).orientation == Orientation.landscape;
          boxConstraints = constraints;
          debugPrint(
              "maxWidth=${constraints.maxWidth}, isLandscapeUi=$kIsLandscapeUi");
          return SafeArea(child: child);
        }),
      ),
    );
  }
}
