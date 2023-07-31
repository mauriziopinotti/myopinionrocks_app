import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myopinionrocks_app/data/registration.dart';
import 'package:myopinionrocks_app/data/rest_client.dart';
import 'package:myopinionrocks_app/generated/locale_keys.g.dart';
import 'package:myopinionrocks_app/screens/user_form.dart';
import 'package:myopinionrocks_app/widgets/scaffold.dart';

import '../validators.dart';
import '../widgets/form_fields.dart';

class RegistrationScreen extends StatelessWidget {
  final RegistrationRequest _registrationData = RegistrationRequest();

  RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _registrationData.langKey = Localizations.localeOf(context).countryCode;

    return MyScaffold(
        child: UserForm(
      formFields: [
        MyTextField(
          labelText: LocaleKeys.lbl_first_name.tr(),
          icon: Icons.person_outline,
          autofillHints: const [AutofillHints.givenName],
          initialValue: _registrationData.firstName,
          onSaved: (value) => _registrationData.firstName = value,
        ),
        MyTextField(
          labelText: LocaleKeys.lbl_last_name.tr(),
          icon: Icons.person_outline,
          autofillHints: const [AutofillHints.familyName],
          initialValue: _registrationData.lastName,
          onSaved: (value) => _registrationData.lastName = value,
        ),
        MyTextField(
          labelText: LocaleKeys.lbl_email.tr(),
          keyboardType: TextInputType.emailAddress,
          icon: Icons.email_outlined,
          autofillHints: const [AutofillHints.username, AutofillHints.email],
          initialValue: _registrationData.email,
          validator: (value) => validateEmail(value!)
              ? null
              : LocaleKeys.field_email_invalid.tr(),
          onSaved: (value) => _registrationData.email = value,
        ),
        MyPasswordField(
          initialValue: _registrationData.password,
          onSaved: (value) => _registrationData.password = value,
          autofillHints: const [AutofillHints.newPassword],
        ),
        MyPasswordField(
          labelText: LocaleKeys.lbl_password_confirm.tr(),
          initialValue: _registrationData.passwordConfirm,
          onSaved: (value) => _registrationData.passwordConfirm = value,
          autofillHints: const [AutofillHints.newPassword],
          validator: (value) =>
              _registrationData.password == _registrationData.passwordConfirm
                  ? null
                  : LocaleKeys.msg_check_passwords.tr(),
        ),
      ],
      actionLabel: LocaleKeys.lbl_register.tr(),
      actionCallback: () =>
          RestClient().doRegistration(context, _registrationData),
      actionWaitMessage: LocaleKeys.msg_registering.tr(),
      actionOkMessage: (user) =>
          LocaleKeys.msg_register_ok.tr(args: [user.fullName]),
    ));
  }
}
