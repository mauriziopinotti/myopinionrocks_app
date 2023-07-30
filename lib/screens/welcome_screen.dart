import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myopinionrocks_app/generated/locale_keys.g.dart';
import 'package:myopinionrocks_app/screens/registration_screen.dart';
import 'package:myopinionrocks_app/screens/survey_screen.dart';

import '../data/welcome.dart';
import '../globals.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/scaffold.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        child: Column(children: [
      // Text(LocaleKeys.msg_welcome.tr(), textAlign: TextAlign.center),
      // const SizedBox(height: 32),
      Expanded(child: _WelcomeIntro()),
      const SizedBox(height: 32),
      MyButton(
        LocaleKeys.lbl_goto_survey.tr(),
        color: primaryColor,
        onPressed: () => push(context, const SurveyScreen()),
      ),
      const Divider(height: 32),
      MyButton(
        LocaleKeys.lbl_login.tr(),
        color: secondaryColor,
        onPressed: () => push(context, const LoginScreen()),
      ),
      const SizedBox(height: 8),
      Text(LocaleKeys.msg_dont_have_account.tr()),
      MyButton(
        LocaleKeys.lbl_register.tr(),
        color: tertiaryColor,
        onPressed: () => push(context, const RegistrationScreen()),
      ),
    ]));
  }
}

class _WelcomeIntro extends StatefulWidget {
  @override
  State<_WelcomeIntro> createState() => _WelcomeIntroState();
}

class _WelcomeIntroState extends State<_WelcomeIntro> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: PageView.builder(
        itemCount: welcomeItems.length,
        itemBuilder: (_, index) => _buildIntroItem(
          title: welcomeItems[index].title,
          subtitle: welcomeItems[index].subtitle,
          image: welcomeItems[index].image,
        ),
        onPageChanged: (page) => setState(() => _currentPage = page),
      )),
      const SizedBox(height: 16),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            welcomeItems.length,
            (index) => _buildDot(index == _currentPage),
          )),
    ]);
  }

  Widget _buildIntroItem({
    required String title,
    required String subtitle,
    required String image,
  }) =>
      Column(children: [
        Expanded(
          child: Image.asset(
            'assets/images/$image',
            fit: BoxFit.fitHeight,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ]);

  Widget _buildDot(bool highlight) => Padding(
      padding: const EdgeInsets.all(6),
      child: ClipOval(
          child: Container(
        width: 16,
        height: 16,
        color: highlight ? textColor : Colors.grey.shade300,
      )));
}
