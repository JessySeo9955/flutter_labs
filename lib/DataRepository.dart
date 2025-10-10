import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';


class DataRepository {

  static final String PREFERENCE_USERNAME_KEY = "userName";
  static final String PREFERENCE_PHONE_KEY = "phone";
  static final String PREFERENCE_EMAIL_KEY = "email";

  static Future<List<String>> loadData() async {
      var prefs = EncryptedSharedPreferences();
      List<String> results = await Future.wait([
        prefs.getString(PREFERENCE_USERNAME_KEY),
        prefs.getString(PREFERENCE_PHONE_KEY),
        prefs.getString(PREFERENCE_EMAIL_KEY),
      ]);
      return results;
  }

  static Future<void> saveData(String userName, {String? phone, String? email}) async {
    var prefs = EncryptedSharedPreferences();
    await prefs.setString(PREFERENCE_USERNAME_KEY, userName);
    if (phone != null) {
      await prefs.setString(PREFERENCE_PHONE_KEY, phone);
    }

    if (email != null) {
      await prefs.setString(PREFERENCE_EMAIL_KEY, email);
    }
  }

  Future<void> clearUserInfoToEncryptPreferences() async {
    var prefs = EncryptedSharedPreferences();
    prefs.clear();
  }
}