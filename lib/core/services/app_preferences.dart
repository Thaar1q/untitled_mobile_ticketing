import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences._();

  static const _themeIsDarkKey = 'theme_is_dark';
  static const _authSessionKey = 'auth_session';
  static const _customAccountsKey = 'custom_accounts';

  static Future<bool?> getThemeIsDark() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeIsDarkKey);
  }

  static Future<void> setThemeIsDark(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeIsDarkKey, isDark);
  }

  static Future<Map<String, dynamic>?> getAuthSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_authSessionKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> setAuthSession(Map<String, dynamic> session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authSessionKey, jsonEncode(session));
  }

  static Future<void> clearAuthSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authSessionKey);
  }

  static Future<List<Map<String, dynamic>>> getCustomAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_customAccountsKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const [];
      }

      final result = <Map<String, dynamic>>[];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          result.add(item);
        } else if (item is Map) {
          result.add(Map<String, dynamic>.from(item));
        }
      }
      return result;
    } catch (_) {
      return const [];
    }
  }

  static Future<void> setCustomAccounts(
    List<Map<String, dynamic>> accounts,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customAccountsKey, jsonEncode(accounts));
  }
}
