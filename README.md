# 🔥 Streaks

A clean, offline-first habit tracker built with Flutter. Add habits, check them off each day, and watch your streaks grow.

## Features

- Create habits with an emoji and a color
- One-tap daily check-off with a progress bar for today
- Current streak, best streak and total completions per habit
- 5-week calendar heatmap on each habit's detail screen
- Swipe a habit left to delete it (with confirmation)
- Data stored locally on-device (`shared_preferences`), no account or network needed
- Material 3 with automatic light and dark themes
- Unit tests for streak logic, JSON round-tripping and the provider
- GitHub Actions CI (analyze + test)

## Getting started

Requires Flutter 3.27 or newer.

```bash
# 1. Generate the platform folders (android/, ios/, web/ ...) once
flutter create --project-name streaks --org dev.yourname .

# 2. Install dependencies
flutter pub get

# 3. Run
flutter run

# 4. Test
flutter analyze
flutter test
```

`flutter create .` only adds missing platform files. It will not overwrite `lib/` or `pubspec.yaml`.

## Project structure

```
lib/
  main.dart                    App entry, theme, provider setup
  models/habit.dart            Habit model, streak math, JSON
  services/habit_storage.dart  shared_preferences persistence
  providers/habit_provider.dart State management (ChangeNotifier)
  screens/
    home_screen.dart           Habit list, today's progress, add/delete
    habit_detail_screen.dart   Stats, heatmap, mark done
  widgets/
    habit_card.dart            List item with animated check
    add_habit_sheet.dart       New habit bottom sheet
    heatmap.dart               Calendar heatmap
  utils/day_utils.dart         Date helpers
test/habit_test.dart           Unit tests
```

## How streaks work

A streak is the number of consecutive completed days ending today. If you haven't checked a habit off yet today, yesterday's streak still counts, so you don't lose it until the day is over.

## Ideas for next steps

- Daily reminder notifications
- Edit habits and custom weekly schedules
- Cloud sync or export/import
- Home-screen widget

## License

MIT
