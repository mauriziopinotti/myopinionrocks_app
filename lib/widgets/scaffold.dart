import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myopinionrocks_app/generated/locale_keys.g.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../providers/user_provider.dart';
import '../theme.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;

  const MyScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (_, userProvider, __) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: !kIsWeb || !kIsLandscapeUi,
                centerTitle: true,
                title: Hero(
                  tag: 'my-app-bar',
                  child: Image.asset('assets/images/logo.png'),
                ),
                iconTheme: const IconThemeData(color: primaryColor),
                backgroundColor: appBarColor,
                actions: userProvider.isLogged
                    ? [_buildUserIcon(userProvider)]
                    : null,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
                  kIsLandscapeUi =
                      constraints.maxWidth >= kLandscapeUiWidthBreakpoint &&
                          MediaQuery.of(context).orientation ==
                              Orientation.landscape;
                  debugPrint(
                      "maxWidth=${constraints.maxWidth}, isLandscapeUi=$kIsLandscapeUi");
                  return SafeArea(child: child);
                }),
              ),
            ));
  }

  Widget _buildUserIcon(UserProvider userProvider) => IconButton(
      icon: const Icon(Icons.person),
      onPressed: () => showMessage(
          LocaleKeys.lbl_logged_as.tr(args: [userProvider.user!.fullName])));
}
