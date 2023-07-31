class User {
  int? id;
  String? login;
  String? firstName;
  String? lastName;
  String? email;
  String? langKey;

  User();

  bool get isLogged => id != null;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    langKey = json['langKey'];
  }

  get fullName => "$firstName $lastName";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    data['fistName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['langKey'] = langKey;
    return data;
  }

  @override
  String toString() {
    return 'User{id: $id, login: $login, fistName: $firstName, lastName: $lastName, email: $email, langKey: $langKey}';
  }
}
