import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static final PrefUtils _instance = PrefUtils._privateConstructor();

  factory PrefUtils() {
    return _instance;
  }

  SharedPreferences? _prefs;

  PrefUtils._privateConstructor() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
  }

  static Future<String> get authToken async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(prefAuthToken) ?? '';
  }

  static void setAuthToken(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(prefAuthToken, token);
  }

  static Future<bool> get isLoggedIn async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(prefLoggedIn) ?? false;
  }

  static void setLoggedIn(bool loggedIn) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(prefLoggedIn, loggedIn);
  }

  static Future<String> get deviceToken async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(prefLoggedIn) ?? '';
  }

  static void setDeviceToken(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(prefLoggedIn, token);
  }

  static Future<bool> get isFirstLoading async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(prefFirstLoading) ?? true;
  }

  static void setFirstLoading(bool forceSync) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(prefFirstLoading, forceSync);
  }

  static const prefLoggedIn = "logged_in";
  static const prefAuthToken = 'auth_token';
  static const prefDeviceToken = 'device_token';
  static const prefFirstLoading = "first_loading";
}
