import 'package:shared_preferences/shared_preferences.dart';

class StreakStorage {
  String _streakKey(String userId) => 'streak_$userId';

  String _lastVisitKey(String userId) => 'last_visit_$userId';

  Future<int> getStreak(String userId) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_streakKey(userId)) ?? 0;
  }

  Future<DateTime?> getLastVisit(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? value = prefs.getString(_lastVisitKey(userId));

    if (value == null) {
      return null;
    }

    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveStreak({
    required String userId,
    required int streak,
    required DateTime lastVisit,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_streakKey(userId), streak);
    await prefs.setString(_lastVisitKey(userId), lastVisit.toIso8601String());
  }

  Future<void> clearUserStreak(String userId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_streakKey(userId));
    await prefs.remove(_lastVisitKey(userId));
  }
}
