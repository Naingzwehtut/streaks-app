import 'package:flutter/foundation.dart';

import '../models/habit.dart';
import '../services/habit_storage.dart';

class HabitProvider extends ChangeNotifier {
  HabitProvider({HabitStorage? storage}) : _storage = storage ?? HabitStorage();

  final HabitStorage _storage;
  final List<Habit> _habits = [];
  bool _loaded = false;

  bool get loaded => _loaded;
  List<Habit> get habits => List.unmodifiable(_habits);

  Habit? byId(String id) {
    for (final h in _habits) {
      if (h.id == id) return h;
    }
    return null;
  }

  int doneTodayCount([DateTime? today]) {
    final t = today ?? DateTime.now();
    return _habits.where((h) => h.isDoneOn(t)).length;
  }

  Future<void> load() async {
    _habits
      ..clear()
      ..addAll(await _storage.load());
    _loaded = true;
    notifyListeners();
  }

  Future<void> add({
    required String name,
    required String emoji,
    required int colorValue,
  }) async {
    _habits.add(Habit(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      emoji: emoji,
      colorValue: colorValue,
    ));
    await _persist();
  }

  Future<void> toggle(String id, [DateTime? day]) async {
    final habit = byId(id);
    if (habit == null) return;
    habit.toggle(day ?? DateTime.now());
    await _persist();
  }

  Future<void> remove(String id) async {
    _habits.removeWhere((h) => h.id == id);
    await _persist();
  }

  Future<void> _persist() async {
    notifyListeners();
    await _storage.save(_habits);
  }
}
