/// Validates an email address.
bool validateEmail(String? email, {bool allowEmpty = false}) {
  if (email == null || email.isEmpty) return allowEmpty;

  return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
      .hasMatch(email);
}

/// Validates an integer number.
bool validateInt(String text) => RegExp(r"^[0-9]+$").hasMatch(text);
