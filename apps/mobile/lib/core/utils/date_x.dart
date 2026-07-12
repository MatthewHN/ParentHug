import 'package:intl/intl.dart';

/// Date helpers for ages, timelines, and "this day last year".
class DateX {
  DateX._();

  /// Whole years old on [asOf] (default today).
  static int ageYears(DateTime birthday, {DateTime? asOf}) {
    final now = asOf ?? DateTime.now();
    var age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }
    return age < 0 ? 0 : age;
  }

  /// Friendly age: "newborn", "8 months old", "1 year old".
  static String ageLabel(DateTime birthday, {DateTime? asOf}) {
    final now = asOf ?? DateTime.now();
    final years = ageYears(birthday, asOf: now);
    if (years >= 1) return years == 1 ? '1 year old' : '$years years old';
    var months = (now.year - birthday.year) * 12 + (now.month - birthday.month);
    if (now.day < birthday.day) months--;
    if (months <= 0) return 'newborn';
    return months == 1 ? '1 month old' : '$months months old';
  }

  /// Days until the next birthday.
  static int daysUntilBirthday(DateTime birthday, {DateTime? asOf}) {
    final now = asOf ?? DateTime.now();
    var next = DateTime(now.year, birthday.month, birthday.day);
    if (next.isBefore(DateTime(now.year, now.month, now.day))) {
      next = DateTime(now.year + 1, birthday.month, birthday.day);
    }
    return next.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  static String monthDay(DateTime d) => DateFormat('MMM d').format(d);
  static String fullDate(DateTime d) => DateFormat('MMMM d, y').format(d);
  static String monthYear(DateTime d) => DateFormat('MMMM y').format(d);

  /// e.g. "Today", "Yesterday", or "Mar 3".
  static String relativeDay(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(d.year, d.month, d.day);
    final diff = today.difference(that).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff == -1) return 'Tomorrow';
    return monthDay(d);
  }

  static String greetingForNow([DateTime? now]) {
    final h = (now ?? DateTime.now()).hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
