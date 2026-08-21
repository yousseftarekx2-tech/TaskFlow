import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flow/features/auth/data/model/user_model.dart';

class UserStorage {
  static const String _userKey = 'registered_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  // ============================================================
  // REGISTERED USER
  // ============================================================

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final String? userJson = prefs.getString(_userKey);

    if (userJson == null) {
      return null;
    }

    try {
      final Map<String, dynamic> json =
          jsonDecode(userJson) as Map<String, dynamic>;

      return UserModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // LOGIN SESSION
  // ============================================================

  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isLoggedInKey, value);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isLoggedInKey, false);
  }

  // ============================================================
  // ONBOARDING
  // ============================================================

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_onboardingCompletedKey, true);
  }

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  // ============================================================
  // CLEAR EVERYTHING
  // ============================================================

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userKey);
    await prefs.remove(_isLoggedInKey);
  }
}
