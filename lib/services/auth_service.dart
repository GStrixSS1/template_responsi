import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String userBoxName = 'news_users_box';
  static const String prefIsLoggedIn = 'is_logged_in';
  static const String prefUsername = 'logged_in_username';
  static const String prefFullName = 'logged_in_fullname';

  static Box<UserModel> get _userBox => Hive.box<UserModel>(userBoxName);

  static Future<bool> register({
    required String username,
    required String password,
    required String fullName,
  }) async {
    final cleanUsername = username.trim();
    if (_userBox.containsKey(cleanUsername)) {
      return false;
    }

    final newUser = UserModel(
      username: cleanUsername,
      password: password,
      fullName: fullName.trim(),
    );

    await _userBox.put(cleanUsername, newUser);
    return true;
  }

  static Future<void> seedDefaultUserIfEmpty() async {
    if (_userBox.isEmpty) {
      await register(
        username: 'admin',
        password: 'admin123',
        fullName: 'Redaktur Berita',
      );
    }
  }

  static Future<bool> login({
    required String username,
    required String password,
  }) async {
    final cleanUsername = username.trim();
    final user = _userBox.get(cleanUsername);

    if (user != null && user.password == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(prefIsLoggedIn, true);
      await prefs.setString(prefUsername, user.username);
      await prefs.setString(prefFullName, user.fullName);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefIsLoggedIn);
    await prefs.remove(prefUsername);
    await prefs.remove(prefFullName);
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(prefIsLoggedIn) ?? false;
  }

  static Future<Map<String, String>> getCurrentUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString(prefUsername) ?? '',
      'fullName': prefs.getString(prefFullName) ?? 'Pembaca Setia',
    };
  }
}
