import 'package:flutter/foundation.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? get user => _user;
  User? _user;

  bool get isLogged => _user?.isLogged == true;

  User login(User user) {
    _user = user;
    notifyListeners();
    return user;
  }

  logout() {
    _user = null;
    notifyListeners();
  }
}
