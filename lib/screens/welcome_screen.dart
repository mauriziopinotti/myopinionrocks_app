import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myopinionrocks_app/generated/locale_keys.g.dart';
import 'package:myopinionrocks_app/screens/registration_screen.dart';
import 'package:myopinionrocks_app/screens/survey_screen.dart';

import '../globals.dart';
import '../widgets/button.dart';
import '../widgets/scaffold.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        child: Column(
      children: [
        Text(LocaleKeys.msg_welcome.tr(), textAlign: TextAlign.center),
        MyButton(
          LocaleKeys.lbl_goto_survey.tr(),
          onPressed: () => push(context, const SurveyScreen()),
        ),
        MyButton(
          LocaleKeys.lbl_login.tr(),
          onPressed: () => push(context, const LoginScreen()),
        ),
        Text(LocaleKeys.msg_dont_have_account.tr()),
        MyButton(
          LocaleKeys.lbl_register.tr(),
          onPressed: () => push(context, const RegistrationScreen()),
        ),
      ],
    ));
  }
}
