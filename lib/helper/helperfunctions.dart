import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {

  static String sharedPreferencedUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferencedUserNameKey = "USERNAMEKEY";
  static String sharedPreferencedFirstNameKey = "USERNAMEKEY";
  static String sharedPreferencedLastNameKey = "USERNAMEKEY";
  static String sharedPreferencedUserEmailKey = "USEREMAILKEY";

  static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferencedUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(sharedPreferencedUserNameKey, userName);
  }

  static Future<bool> saveFirstNameSharedPreference(String userName) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(sharedPreferencedFirstNameKey, userName);
  }

  static Future<bool> saveLastNameSharedPreference(String userName) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(sharedPreferencedLastNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencedUserEmailKey, userEmail);
  }

  static Future<bool> getUserLoggedInSharedPreference() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferencedUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPreference() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencedUserNameKey);
  }

  static Future<String> getFirstNameSharedPreference() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencedFirstNameKey);
  }

  static Future<String> getLastNameSharedPreference() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencedLastNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencedUserEmailKey);
  }
}
