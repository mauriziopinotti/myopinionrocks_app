import '../models/user.dart';

class LoginRequest {
  String? username;
  String? password;

  LoginRequest({this.username, this.password});

  void clear() {
    username = null;
    password = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username!.trim();
    data['password'] = password?.trim();
    data['rememberMe'] = true;
    return data;
  }

  @override
  String toString() {
    return 'LoginRequest{username: $username, password: $password}';
  }
}

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

class LoginResponse {
  String? accessToken;

  LoginResponse({this.accessToken});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
  }

  @override
  String toString() {
    return 'LoginResponse{accessToken: $accessToken}';
  }
}

class UserResponse {
  User? user;

  UserResponse.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json);
  }
}
