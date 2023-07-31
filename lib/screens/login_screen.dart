import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myopinionrocks_app/data/login.dart';
import 'package:myopinionrocks_app/data/rest_client.dart';
import 'package:myopinionrocks_app/generated/locale_keys.g.dart';
import 'package:myopinionrocks_app/globals.dart';
import 'package:myopinionrocks_app/widgets/buttons.dart';
import 'package:myopinionrocks_app/widgets/loader.dart';
import 'package:myopinionrocks_app/widgets/scaffold.dart';

import '../validators.dart';
import '../widgets/form_fields.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(child: _LoginForm());
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final LoginRequest _loginData = LoginRequest();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return MyLoader(LocaleKeys.msg_loggin_in.tr());
    }
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          MyTextField(
            labelText: LocaleKeys.label_email.tr(),
            keyboardType: TextInputType.emailAddress,
            icon: Icons.email_outlined,
            autofillHints: const [AutofillHints.username],
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
          const Spacer(),
          MyButton(LocaleKeys.lbl_login.tr(), onPressed: _doLogin),
        ]));
  }

  _doLogin() async {
    final form = _formKey.currentState!..save();
    FocusScope.of(context).unfocus(); // close keyboard
    if (form.validate()) {
      try {
        setState(() => _loading = true);

        // Do login!
        final user = await RestClient().doLogin(context, _loginData);
        if (!mounted) return;

        // Go back to welcome page
        showMessage(LocaleKeys.msg_login_ok.tr(args: [user.fullName]));
        back();
      } catch (e, s) {
        handleRestError(e, s, show: false);
        showMessage(LocaleKeys.msg_error_user_pass.tr());
      } finally {
        setState(() => _loading = false);
      }
    }
  }
}
