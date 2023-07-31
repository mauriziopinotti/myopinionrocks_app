import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myopinionrocks_app/data/login.dart';
import 'package:myopinionrocks_app/data/rest_client.dart';
import 'package:myopinionrocks_app/generated/locale_keys.g.dart';
import 'package:myopinionrocks_app/screens/user_form.dart';
import 'package:myopinionrocks_app/widgets/scaffold.dart';

import '../validators.dart';
import '../widgets/form_fields.dart';

/// The login screen.
class LoginScreen extends StatelessWidget {
  final LoginRequest _loginData = LoginRequest();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        child: UserForm(
      formFields: [
        MyTextField(
          labelText: LocaleKeys.lbl_email.tr(),
          keyboardType: TextInputType.emailAddress,
          icon: Icons.email_outlined,
          autofillHints: const [AutofillHints.username, AutofillHints.email],
          initialValue: _loginData.username,
          validator: (value) => validateEmail(value!)
              ? null
              : LocaleKeys.field_email_invalid.tr(),
          onSaved: (value) => _loginData.username = value,
        ),
        MyPasswordField(
          initialValue: _loginData.password,
          onSaved: (value) => _loginData.password = value,
        ),
      ],
      actionLabel: LocaleKeys.lbl_login.tr(),
      actionCallback: () => RestClient().doLogin(context, _loginData),
      actionWaitMessage: LocaleKeys.msg_loggin_in.tr(),
      actionOkMessage: (user) =>
          LocaleKeys.msg_login_ok.tr(args: [user.fullName]),
      actionErrorMessage: LocaleKeys.msg_error_user_pass.tr(),
    ));
  }
}
