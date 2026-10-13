import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/habit_provider.dart';
import '../widgets/heatmap.dart';

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key, required this.habitId});

  final String habitId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final habit = provider.byId(habitId);
    final theme = Theme.of(context);

    // The habit may have been deleted from this screen.
    if (habit == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final color = Color(habit.colorValue);
    final doneToday = habit.isDoneOn(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('${habit.emoji}  ${habit.name}'),
        actions: [
          IconButton(
            tooltip: 'Delete habit',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete habit?'),
                  content: const Text('Its history will be removed.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                await provider.remove(habit.id);
                navigator.pop();
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Current',
                  value: '${habit.currentStreak()}',
                  suffix: 'days',
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  label: 'Best',
                  value: '${habit.longestStreak}',
                  suffix: 'days',
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  label: 'Total',
                  value: '${habit.totalCompletions}',
                  suffix: 'done',
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text('Last 5 weeks', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Heatmap(habit: habit),
          const SizedBox(height: 32),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: doneToday ? null : color,
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: () => provider.toggle(habit.id),
            icon: Icon(doneToday ? Icons.undo : Icons.check),
            label: Text(doneToday ? 'Undo today' : 'Mark done today'),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.suffix,
    required this.color,
  });

  final String label;
  final String value;
  final String suffix;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withAlpha(35),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(suffix, style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
