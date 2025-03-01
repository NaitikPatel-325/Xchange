import 'package:shared_preferences/shared_preferences.dart';

class UserPref {
  static Future<void> setUser(String displayName, String email, String mongoUserId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('DISPLAY_NAME', displayName);
    pref.setString('EMAIL', email);
    pref.setString('MONGO_USER_ID', mongoUserId);
  }

  static Future<Map<String, String>> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return {
      'DISPLAY_NAME': pref.getString('DISPLAY_NAME') ?? '',
      'EMAIL': pref.getString('EMAIL') ?? '',
      'MONGO_USER_ID': pref.getString('MONGO_USER_ID') ?? '',
    };
  }

  static Future<void> removeUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
