import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../utils/day_utils.dart';

/// A 5-week calendar heatmap, Monday-first, ending with the current week.
class Heatmap extends StatelessWidget {
  const Heatmap({super.key, required this.habit, this.weeks = 5});

  final Habit habit;
  final int weeks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(habit.colorValue);
    final today = dateOnly(DateTime.now());
    final start = addDays(startOfWeek(today), -7 * (weeks - 1));
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Column(
      children: [
        Row(
          children: [
            for (final l in labels)
              Expanded(
                child: Center(
                  child: Text(
                    l,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        for (var w = 0; w < weeks; w++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                for (var d = 0; d < 7; d++)
                  Expanded(
                    child: _Cell(
                      day: addDays(start, w * 7 + d),
                      today: today,
                      habit: habit,
                      color: color,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.day,
    required this.today,
    required this.habit,
    required this.color,
  });

  final DateTime day;
  final DateTime today;
  final Habit habit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFuture = day.isAfter(today);
    final done = habit.isDoneOn(day);
    final isToday = dayKey(day) == dayKey(today);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isFuture
                ? Colors.transparent
                : done
                    ? color
                    : theme.colorScheme.surfaceContainerHighest,
            border: isToday
                ? Border.all(color: theme.colorScheme.onSurface, width: 1.5)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '${day.day}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: isFuture
                  ? theme.colorScheme.outlineVariant
                  : done
                      ? Colors.white
                      : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
