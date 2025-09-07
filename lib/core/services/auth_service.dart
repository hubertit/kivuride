import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userKey = 'logged_in_user';
  static const String _isLoggedInKey = 'is_logged_in';

  // Save user session
  static Future<void> saveUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  // Get current user data
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson != null) {
      try {
        return jsonDecode(userJson) as Map<String, dynamic>;
      } catch (e) {
        // If JSON is corrupted, clear the session
        await clearUserSession();
        return null;
      }
    }
    return null;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Clear user session (logout)
  static Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userKey);
  }

  // Update user data
  static Future<void> updateUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  // Get user account type
  static Future<String?> getUserAccountType() async {
    final user = await getCurrentUser();
    return user?['accountType'];
  }

  // Get user name
  static Future<String?> getUserName() async {
    final user = await getCurrentUser();
    return user?['name'];
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    final user = await getCurrentUser();
    return user?['email'];
  }

  // Get user phone
  static Future<String?> getUserPhone() async {
    final user = await getCurrentUser();
    return user?['phone'];
  }
}
