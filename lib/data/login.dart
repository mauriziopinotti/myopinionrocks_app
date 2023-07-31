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

class LoginResponse {
  String? accessToken;

  LoginResponse({this.accessToken});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['id_token'];
  }

  @override
  String toString() {
    return 'LoginResponse{accessToken: $accessToken}';
  }
}
