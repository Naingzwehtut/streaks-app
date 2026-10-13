import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';

/// Persists habits as a JSON string in local storage.
class HabitStorage {
  static const _key = 'habits_v1';

  Future<List<Habit>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      return Habit.decodeList(raw);
    } catch (_) {
      // Corrupt data should never brick the app.
      return [];
    }
  }

  Future<void> save(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, Habit.encodeList(habits));
  }
}
