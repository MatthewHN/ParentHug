import 'package:flutter/services.dart' show MissingPluginException;
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Nudges happy users toward the native in-app review sheet — but only after a
/// few genuinely positive moments, and only once per install.
///
/// This is intentionally NOT wired to a button (the "Leave a review" card on
/// the Profile screen opens the store listing directly). Call
/// [recordPositiveAction] from the app's real "win" moments.
class ReviewPrompter {
  ReviewPrompter._();
  static final ReviewPrompter instance = ReviewPrompter._();

  static const _countKey = 'positive_actions_count';
  static const _askedKey = 'in_app_review_requested';

  /// How many positive actions before we ask.
  static const _threshold = 3;

  bool _asking = false;

  /// Record one positive action (a delivered Hug, a completed Repair, a saved
  /// memory…). Once [_threshold] have accumulated, request the native review
  /// sheet a single time for the lifetime of the install.
  Future<void> recordPositiveAction() async {
    if (_asking) return;
    _asking = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_askedKey) ?? false) return;

      final count = (prefs.getInt(_countKey) ?? 0) + 1;
      await prefs.setInt(_countKey, count);
      if (count < _threshold) return;

      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
        // Only mark as asked once the OS actually offered the sheet, so a
        // build without the plugin doesn't silently burn the one prompt.
        await prefs.setBool(_askedKey, true);
      }
    } on MissingPluginException {
      // Plugin not available in this build yet; try again next time.
    } catch (_) {
      // A review nudge must never interfere with the user's flow.
    } finally {
      _asking = false;
    }
  }
}
