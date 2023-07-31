/// REST model for registration requests.
class RegistrationRequest {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? passwordConfirm;
  String? langKey;

  String? get username => email;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['login'] = data['email'] = email!.trim();
    data['password'] = password!.trim();
    data['langKey'] = langKey;
    return data;
  }
}
