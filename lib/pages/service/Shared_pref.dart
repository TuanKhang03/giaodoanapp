import 'package:shared_preferences/shared_preferences.dart';
class SharedPreferenceHelper {
  static String userIdKey = "USERIDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userWalletKey = "USERWALLETKEY";

  Future<bool> saveUserID(String getUserId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userIdKey, getUserId);
  }
  Future<bool> saveUserName(String getUserName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userNameKey, getUserName);
  }
  Future<bool> saveUserEmail(String getUserEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userEmailKey, getUserEmail);
  }
  Future<bool> saveUserWallet(String getUserWallet) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userWalletKey, getUserWallet);
  }

  Future<String?> getUserID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }
  Future<String?> getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }
  Future<String?> getUserEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }
  Future<String?> getUserWallet() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userWalletKey);
  }
}