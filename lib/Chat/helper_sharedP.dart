import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{


  static String userIdKey = 'USERKEY';
  static String userNameKey = 'USERNAMEKEY';
  static String displayNameKey = 'USERDISPLAYNAMEKEY';
  static String userEmailKey = 'USEREMAILKEY';
  static String userProfileKey = 'USERPROFILEKEY';

  //Save Data

  Future <bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future <bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future <bool> saveUserId (String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future <bool> saveDisplayName (String getDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displayNameKey, getDisplayName);
  }

  Future <bool> saveUserProfileUrl (String getUserProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfileKey, getUserProfile);
  }

  //GetData

  Future <String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }








}