import 'package:flutter_test/flutter_test.dart';
import 'package:parenthug/core/utils/date_x.dart';
import 'package:parenthug/core/utils/validators.dart';
import 'package:parenthug/features/library/data/game_word_bank.dart';
import 'package:parenthug/models/enums.dart';

void main() {
  group('Validators', () {
    test('email', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('nope'), isNotNull);
      expect(Validators.email('a@b.co'), isNull);
    });

    test('password requires 8+ chars', () {
      expect(Validators.password('short'), isNotNull);
      expect(Validators.password('longenough'), isNull);
    });
  });

  group('DateX.ageYears', () {
    test('computes whole years', () {
      final asOf = DateTime(2026, 7, 9);
      expect(DateX.ageYears(DateTime(2022, 7, 9), asOf: asOf), 4);
      expect(DateX.ageYears(DateTime(2022, 7, 10), asOf: asOf), 3);
    });
  });

  test('DateX.ageLabel adds old only to numeric ages', () {
    final asOf = DateTime(2026, 7, 12);
    expect(DateX.ageLabel(DateTime(2026, 7, 12), asOf: asOf), 'newborn');
    expect(DateX.ageLabel(DateTime(2026, 6, 12), asOf: asOf), '1 month old');
    expect(DateX.ageLabel(DateTime(2023, 7, 12), asOf: asOf), '3 years old');
  });

  group('PlanTier', () {
    test('pro ranks above free', () {
      expect(PlanTier.pro.rank, greaterThan(PlanTier.free.rank));
    });

    test('parses from string', () {
      expect(PlanTier.from('pro'), PlanTier.pro);
      expect(PlanTier.from('unknown'), PlanTier.free);
    });
  });

  test('game word bank contains 1,000 simple prompts', () {
    expect(GameWordBank.words, hasLength(1000));
    expect(
        GameWordBank.words, containsAll(['gardening', 'firefighter', 'lion']));
    expect(GameWordBank.words, isNot(contains('Gardening firefighter')));
  });
}
