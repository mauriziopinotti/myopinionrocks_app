import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:myopinionrocks_app/data/rest_client.dart';
import 'package:myopinionrocks_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';
import '../globals.dart';
import '../providers/user_provider.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';
import '../theme.dart';
import 'buttons.dart';

class LoginPanel extends StatelessWidget {
  const LoginPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (_, userProvider, __) => userProvider.isLogged
            ? Column(children: [
                Text(
                  LocaleKeys.lbl_logged_as
                      .tr(args: [userProvider.user!.email!]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                MyButton(
                  LocaleKeys.lbl_logout.tr(),
                  color: secondaryColor,
                  onPressed: () => _doLogout(context),
                ),
              ])
            : Column(children: [
                MyButton(
                  LocaleKeys.lbl_login.tr(),
                  color: secondaryColor,
                  onPressed: () => push(const LoginScreen()),
                ),
                const SizedBox(height: 8),
                Text(LocaleKeys.msg_dont_have_account.tr()),
                MyButton(
                  LocaleKeys.lbl_register.tr(),
                  color: tertiaryColor,
                  onPressed: () => push(const RegistrationScreen()),
                ),
              ]));
  }

  _doLogout(BuildContext context) async {
    // Do logout
    await RestClient().doLogout(context);

    // Go back to welcome screen
    push(const WelcomeScreen(), replace: true);
  }
}
