import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/habit_provider.dart';

const kHabitEmojis = ['💧', '📚', '🏃', '🧘', '💪', '🥗', '😴', '✍️', '🎸', '🧹'];

const kHabitColors = <Color>[
  Color(0xFF00897B),
  Color(0xFF3949AB),
  Color(0xFF8E24AA),
  Color(0xFFE53935),
  Color(0xFFF4511E),
  Color(0xFFFB8C00),
  Color(0xFF43A047),
  Color(0xFF546E7A),
];

/// Bottom sheet for creating a new habit.
class AddHabitSheet extends StatefulWidget {
  const AddHabitSheet({super.key});

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final _controller = TextEditingController();
  String _emoji = kHabitEmojis.first;
  Color _color = kHabitColors.first;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _valid => _controller.text.trim().isNotEmpty;

  Future<void> _submit() async {
    if (!_valid) return;
    final navigator = Navigator.of(context);
    await context.read<HabitProvider>().add(
          name: _controller.text,
          emoji: _emoji,
          colorValue: _color.toARGB32(),
        );
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        8,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New habit', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 40,
              decoration: const InputDecoration(
                labelText: 'What do you want to build?',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 8),
            Text('Icon', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final e in kHabitEmojis)
                  ChoiceChip(
                    label: Text(e, style: const TextStyle(fontSize: 20)),
                    selected: e == _emoji,
                    onSelected: (_) => setState(() => _emoji = e),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Color', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final c in kHabitColors)
                  GestureDetector(
                    onTap: () => setState(() => _color = c),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 3,
                          color: c == _color
                              ? theme.colorScheme.onSurface
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _valid ? _submit : null,
                child: const Text('Create habit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
