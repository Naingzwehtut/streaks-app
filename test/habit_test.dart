import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaks/models/habit.dart';
import 'package:streaks/providers/habit_provider.dart';
import 'package:streaks/utils/day_utils.dart';

Habit _habit([Set<String>? days]) => Habit(
      id: '1',
      name: 'Read',
      emoji: '📚',
      colorValue: 0xFF00897B,
      completedDays: days,
    );

void main() {
  final today = DateTime(2026, 10, 13);

  group('Habit streaks', () {
    test('empty habit has zero streaks', () {
      final h = _habit();
      expect(h.currentStreak(today: today), 0);
      expect(h.longestStreak, 0);
    });

    test('counts consecutive days ending today', () {
      final h = _habit({'2026-10-11', '2026-10-12', '2026-10-13'});
      expect(h.currentStreak(today: today), 3);
    });

    test('streak survives until the day ends', () {
      final h = _habit({'2026-10-11', '2026-10-12'});
      expect(h.currentStreak(today: today), 2);
    });

    test('streak breaks after a missed day', () {
      final h = _habit({'2026-10-09', '2026-10-10'});
      expect(h.currentStreak(today: today), 0);
    });

    test('longest streak finds the best run', () {
      final h = _habit({
        '2026-09-01',
        '2026-09-02',
        '2026-09-03',
        '2026-09-04',
        '2026-10-12',
        '2026-10-13',
      });
      expect(h.longestStreak, 4);
    });

    test('streak crosses month boundaries', () {
      final h = _habit({'2026-09-30', '2026-10-01', '2026-10-02'});
      expect(h.currentStreak(today: DateTime(2026, 10, 2)), 3);
    });

    test('toggle adds then removes a day', () {
      final h = _habit();
      h.toggle(today);
      expect(h.isDoneOn(today), isTrue);
      h.toggle(today);
      expect(h.isDoneOn(today), isFalse);
    });
  });

  group('Habit JSON', () {
    test('round-trips through encode/decode', () {
      final h = _habit({'2026-10-12', '2026-10-13'});
      final decoded = Habit.decodeList(Habit.encodeList([h])).single;
      expect(decoded.id, h.id);
      expect(decoded.name, h.name);
      expect(decoded.completedDays, h.completedDays);
    });
  });

  group('Day utils', () {
    test('dayKey pads month and day', () {
      expect(dayKey(DateTime(2026, 1, 5)), '2026-01-05');
    });

    test('startOfWeek returns Monday', () {
      // 2026-10-13 is a Tuesday.
      expect(dayKey(startOfWeek(today)), '2026-10-12');
    });
  });

  group('HabitProvider', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('add, toggle, persist and reload', () async {
      final provider = HabitProvider();
      await provider.load();
      await provider.add(name: ' Meditate ', emoji: '🧘', colorValue: 0xFF3949AB);

      expect(provider.habits.single.name, 'Meditate');

      final id = provider.habits.single.id;
      await provider.toggle(id);
      expect(provider.doneTodayCount(), 1);

      final reloaded = HabitProvider();
      await reloaded.load();
      expect(reloaded.habits.length, 1);
      expect(reloaded.doneTodayCount(), 1);
    });

    test('remove deletes the habit', () async {
      final provider = HabitProvider();
      await provider.load();
      await provider.add(name: 'Walk', emoji: '🏃', colorValue: 0xFF43A047);
      await provider.remove(provider.habits.single.id);
      expect(provider.habits, isEmpty);
    });
  });
}
