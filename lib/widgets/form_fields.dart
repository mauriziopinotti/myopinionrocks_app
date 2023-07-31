import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myopinionrocks_app/theme.dart';

import '../generated/locale_keys.g.dart';

class MyTextField extends StatelessWidget {
  final String? labelText;
  final String? helperText;
  final IconData? icon;
  final Widget? iconWidget;
  final dynamic initialValue;
  final bool? isRequired;
  final bool obscureText;
  final TextEditingController? controller;
  final TextEditingController textController;
  final int? maxLength;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final GestureTapCallback? onTap;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  MyTextField({
    super.key,
    required this.labelText,
    this.helperText,
    this.icon,
    this.iconWidget,
    this.initialValue,
    this.isRequired = true,
    this.obscureText = false,
    this.controller,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved,
    this.onTap,
    this.autofillHints,
    this.inputFormatters,
  }) : textController = controller ??
            TextEditingController(text: initialValue?.toString()) {
    textController.addListener(() => onSaved!(textController.text));
  }

  bool get isEmpty => textController.text.isNotEmpty != true && onTap == null;

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      key: key,
      decoration: InputDecoration(
        labelText: "$labelText ${isRequired! ? ' *' : ''}".trim(),
        helperText: helperText,
        helperMaxLines: 5,
        errorMaxLines: 5,
        helperStyle: const TextStyle(fontSize: 12, color: textColor),
        suffixIcon: iconWidget ?? (icon != null ? Icon(icon, size: 24) : null),
        labelStyle: textTheme.bodyLarge!.copyWith(color: Colors.black),
      ),
      style: textTheme.bodyLarge!.copyWith(color: primaryColor),
      controller: textController,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      onSaved: onSaved,
      onTap: onTap ?? () {},
      readOnly: onTap != null,
      showCursor: onTap == null,
      enableInteractiveSelection: onTap == null,
      validator: (value) {
        if (validator != null) {
          return validator!.call(value);
        } else if (isRequired! && value!.isEmpty) {
          return LocaleKeys.field_is_required.tr();
        }
        return null;
      },
      autofillHints: autofillHints,
    );

    return kIsWeb && onTap != null
        ? InkWell(onTap: onTap, child: AbsorbPointer(child: textField))
        : textField;
  }
}

class MyPasswordField extends StatefulWidget {
  final String? labelText;
  final String? helperText;
  final String? initialValue;
  final bool isRequired;
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;

  const MyPasswordField({
    super.key,
    this.labelText,
    this.helperText,
    this.initialValue,
    this.isRequired = true,
    required this.onSaved,
    this.onFieldSubmitted,
    this.autofillHints,
    this.validator,
  });

  @override
  State<StatefulWidget> createState() => MyPasswordFieldState();
}

class MyPasswordFieldState extends State<MyPasswordField> {
  bool _obscureText = true;
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    controller!.selection = TextSelection.fromPosition(
        TextPosition(offset: controller!.text.length));

    return MyTextField(
      labelText: widget.labelText ?? LocaleKeys.lbl_password.tr(),
      helperText: widget.helperText,
      iconWidget: GestureDetector(
        child: Icon(_obscureText
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined),
        onTap: () => setState(() => _obscureText = !_obscureText),
      ),
      obscureText: _obscureText,
      isRequired: widget.isRequired,
      maxLength: 64,
      onSaved: widget.onSaved,
      autofillHints: widget.autofillHints ?? [AutofillHints.password],
      validator: widget.validator,
      controller: controller,
    );
  }
}
