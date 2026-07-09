import '_parse.dart';

class Family {
  const Family({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String createdBy;
  final DateTime createdAt;

  factory Family.fromMap(Map<String, dynamic> m) => Family(
        id: m['id'] as String,
        name: (m['name'] as String?) ?? 'My Family',
        createdBy: m['created_by'] as String? ?? '',
        createdAt: asDateOr(m['created_at'], DateTime.now()),
      );
}
