import 'package:flutter_test/flutter_test.dart';
import 'package:parenthug/core/utils/date_x.dart';
import 'package:parenthug/core/utils/validators.dart';
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

  group('PlanTier', () {
    test('ranking orders plans', () {
      expect(PlanTier.family.rank, greaterThan(PlanTier.plus.rank));
      expect(PlanTier.plus.rank, greaterThan(PlanTier.free.rank));
    });

    test('parses from string', () {
      expect(PlanTier.from('plus'), PlanTier.plus);
      expect(PlanTier.from('unknown'), PlanTier.free);
    });
  });
}
