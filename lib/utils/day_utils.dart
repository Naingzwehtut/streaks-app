/// Strips the time portion, keeping only year / month / day.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Adds [n] calendar days (DST-safe, unlike Duration arithmetic).
DateTime addDays(DateTime d, int n) => DateTime(d.year, d.month, d.day + n);

/// Stable storage key for a calendar day, e.g. `2026-10-13`.
String dayKey(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

/// Monday of the week containing [d].
DateTime startOfWeek(DateTime d) =>
    addDays(dateOnly(d), -(d.weekday - DateTime.monday));

const List<String> kMonthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const List<String> kWeekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

String prettyDate(DateTime d) =>
    '${kWeekdayNames[d.weekday - 1]}, ${kMonthNames[d.month - 1]} ${d.day}';
