import 'package:flutter/material.dart';
import 'package:myopinionrocks_app/data/rest_client.dart';
import 'package:myopinionrocks_app/globals.dart';
import 'package:myopinionrocks_app/widgets/buttons.dart';
import 'package:myopinionrocks_app/widgets/loader.dart';

import '../models/user.dart';

/// A generic form to be used for login and registration.
/// Provides basic functionality with options to override action button label and rest call.
class UserForm extends StatefulWidget {
  final List<Widget> formFields;
  final String actionLabel;
  final Future<User> Function() actionCallback;
  final String? actionWaitMessage;
  final String Function(User)? actionOkMessage;
  final String? actionErrorMessage;

  const UserForm({
    super.key,
    required this.formFields,
    required this.actionLabel,
    required this.actionCallback,
    this.actionWaitMessage,
    this.actionOkMessage,
    this.actionErrorMessage,
  });

  @override
  State<UserForm> createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return MyLoader(widget.actionWaitMessage ?? "");
    }

    return Form(
      key: _formKey,
      child: ListView(shrinkWrap: true, children: [
        ...widget.formFields,
        const Spacer(),
        MyButton(widget.actionLabel, onPressed: _doAction),
      ]),
    );
  }

  _doAction() async {
    final form = _formKey.currentState!..save();
    FocusScope.of(context).unfocus(); // close keyboard
    if (form.validate()) {
      try {
        setState(() => _loading = true);

        // Do action
        final user = await widget.actionCallback();
        if (!mounted) return;

        // Go back to welcome page
        if (widget.actionOkMessage != null) {
          showMessage(widget.actionOkMessage!.call(user));
        }
        back();
      } catch (e, s) {
        handleRestError(e, s, show: widget.actionErrorMessage == null);
        if (widget.actionErrorMessage != null) {
          showMessage(widget.actionErrorMessage!);
        }
      } finally {
        setState(() => _loading = false);
      }
    }
  }
}
