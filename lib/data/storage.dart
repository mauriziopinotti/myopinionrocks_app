import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cross-platform storage.
/// If possible always uses encrypted storage with fallback to clear-text on error.
/// Encryption may be slow, to bypass it access the `prefs` property directly.
class MyStorage {
  static final MyStorage _instance = MyStorage._internal();

  FlutterSecureStorage? _secureStorage;

  SharedPreferences get prefs => _preferences;
  late SharedPreferences _preferences;

  factory MyStorage() {
    return _instance;
  }

  Future<bool> init() async {
    // Init insecure storage
    _preferences = await SharedPreferences.getInstance();

    try {
      // Try to init secure storage as well
      _secureStorage = const FlutterSecureStorage();

      // Test if it works, or fallback to shared preferences
      _secureStorage!.write(key: 'test', value: 'test');
      final value = await _secureStorage!.read(key: 'test');
      if (value != 'test') throw Exception("invalid return value: $value");
      debugPrint("Secure storage init OK");

      return true;
    } catch (e) {
      debugPrint("Secure storage init ERROR: $e");
      _secureStorage = null;

      return false;
    }
  }

  MyStorage._internal();

  Future<String?> read({required String key}) => _secureStorage != null
      ? _secureStorage!.read(key: key)
      : Future.value(_preferences.getString(key) ?? "");

  Future write({required String key, required String? value}) {
    if (_secureStorage != null) {
      return _secureStorage!.write(key: key, value: value);
    } else {
      if (value != null) {
        return _preferences.setString(key, value);
      } else {
        return _preferences.remove(key);
      }
    }
  }
}
