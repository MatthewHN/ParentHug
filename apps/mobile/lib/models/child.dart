import '../core/utils/date_x.dart';
import '_parse.dart';

class Child {
  const Child({
    required this.id,
    required this.familyId,
    required this.name,
    this.birthday,
    this.temperament,
    this.commonStruggles = const [],
    this.parentGoals = const [],
    this.notes,
    this.avatarUrl,
    required this.createdBy,
    required this.createdAt,
  });

  final String id;
  final String familyId;
  final String name;
  final DateTime? birthday;
  final String? temperament;
  final List<String> commonStruggles;
  final List<String> parentGoals;
  final String? notes;
  final String? avatarUrl;
  final String createdBy;
  final DateTime createdAt;

  int? get ageYears => birthday == null ? null : DateX.ageYears(birthday!);
  String? get ageLabel => birthday == null ? null : DateX.ageLabel(birthday!);

  factory Child.fromMap(Map<String, dynamic> m) => Child(
        id: m['id'] as String,
        familyId: m['family_id'] as String,
        name: (m['name'] as String?) ?? '',
        birthday: asDate(m['birthday']),
        temperament: m['temperament'] as String?,
        commonStruggles: asStringList(m['common_struggles']),
        parentGoals: asStringList(m['parent_goals']),
        notes: m['notes'] as String?,
        avatarUrl: m['avatar_url'] as String?,
        createdBy: m['created_by'] as String? ?? '',
        createdAt: asDateOr(m['created_at'], DateTime.now()),
      );

  /// Map for insert/update (family_id/created_by set by the repository).
  Map<String, dynamic> toWrite() => {
        'name': name,
        'birthday': birthday?.toIso8601String().split('T').first,
        'temperament': temperament,
        'common_struggles': commonStruggles,
        'parent_goals': parentGoals,
        'notes': notes,
        'avatar_url': avatarUrl,
      };
}
