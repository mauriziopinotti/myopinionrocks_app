class RegistrationRequest {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? password;
  String? passwordConfirm;
  String? langKey;

  String? get username => email;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['login'] = data['email'] = email!.trim();
    data['telefono'] = phone;
    data['password'] = password!.trim();
    data['langKey'] = langKey;
    // data['authorities'] = [roleUser];
    return data;
  }
}
