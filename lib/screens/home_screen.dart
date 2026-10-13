import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/habit_provider.dart';
import '../utils/day_utils.dart';
import '../widgets/add_habit_sheet.dart';
import '../widgets/habit_card.dart';
import 'habit_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const AddHabitSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final habits = provider.habits;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Streaks',
            style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('New habit'),
      ),
      body: !provider.loaded
          ? const Center(child: CircularProgressIndicator())
          : habits.isEmpty
              ? _EmptyState(onAdd: () => _openAddSheet(context))
              : ListView(
                  padding: const EdgeInsets.only(bottom: 96),
                  children: [
                    _TodayHeader(
                      done: provider.doneTodayCount(),
                      total: habits.length,
                    ),
                    for (final habit in habits)
                      Dismissible(
                        key: ValueKey(habit.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          padding: const EdgeInsets.only(right: 24),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.delete_outline,
                              color: theme.colorScheme.onErrorContainer),
                        ),
                        confirmDismiss: (_) => _confirmDelete(context, habit.name),
                        onDismissed: (_) => provider.remove(habit.id),
                        child: HabitCard(
                          habit: habit,
                          onToggle: () => provider.toggle(habit.id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  HabitDetailScreen(habitId: habit.id),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, String name) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete habit?'),
        content: Text('"$name" and its history will be removed.'),
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
    return result ?? false;
  }
}

class _TodayHeader extends StatelessWidget {
  const _TodayHeader({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = total == 0 ? 0.0 : done / total;
    final allDone = total > 0 && done == total;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(prettyDate(DateTime.now()),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              )),
          const SizedBox(height: 4),
          Text(
            allDone ? 'All done today 🎉' : '$done of $total done today',
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌱', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text('No habits yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Small things, done every day, add up. Add your first habit to start a streak.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add a habit'),
            ),
          ],
        ),
      ),
    );
  }
}
