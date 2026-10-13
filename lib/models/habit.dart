import 'dart:convert';

import '../utils/day_utils.dart';

/// A habit and the days on which it was completed.
class Habit {
  Habit({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorValue,
    Set<String>? completedDays,
    DateTime? createdAt,
  })  : completedDays = completedDays ?? <String>{},
        createdAt = createdAt ?? DateTime.now();

  final String id;
  String name;
  String emoji;
  int colorValue;
  final Set<String> completedDays;
  final DateTime createdAt;

  bool isDoneOn(DateTime day) => completedDays.contains(dayKey(day));

  /// Marks [day] as done, or undoes it if it was already done.
  void toggle(DateTime day) {
    final key = dayKey(day);
    if (!completedDays.remove(key)) {
      completedDays.add(key);
    }
  }

  int get totalCompletions => completedDays.length;

  /// Consecutive days ending today. If today is not done yet, the streak
  /// that ended yesterday still counts, so it is not lost until the day ends.
  int currentStreak({DateTime? today}) {
    var cursor = dateOnly(today ?? DateTime.now());
    if (!isDoneOn(cursor)) {
      cursor = addDays(cursor, -1);
    }
    var streak = 0;
    while (isDoneOn(cursor)) {
      streak++;
      cursor = addDays(cursor, -1);
    }
    return streak;
  }

  /// Longest run of consecutive completed days ever.
  int get longestStreak {
    if (completedDays.isEmpty) return 0;
    final days = completedDays.map(DateTime.parse).toList()..sort();
    var best = 1;
    var run = 1;
    for (var i = 1; i < days.length; i++) {
      if (dayKey(addDays(days[i - 1], 1)) == dayKey(days[i])) {
        run++;
      } else {
        run = 1;
      }
      if (run > best) best = run;
    }
    return best;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'color': colorValue,
        'days': completedDays.toList()..sort(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        name: json['name'] as String,
        emoji: json['emoji'] as String,
        colorValue: json['color'] as int,
        completedDays:
            (json['days'] as List<dynamic>).map((e) => e as String).toSet(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  static String encodeList(List<Habit> habits) =>
      jsonEncode(habits.map((h) => h.toJson()).toList());

  static List<Habit> decodeList(String source) {
    final raw = jsonDecode(source) as List<dynamic>;
    return raw.map((e) => Habit.fromJson(e as Map<String, dynamic>)).toList();
  }
}
