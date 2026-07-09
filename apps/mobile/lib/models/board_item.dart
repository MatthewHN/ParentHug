import '_parse.dart';
import 'enums.dart';

class BoardItem {
  const BoardItem({
    required this.id,
    required this.familyId,
    this.childId,
    required this.category,
    required this.title,
    this.body,
    required this.createdBy,
    this.pinned = false,
    this.archived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String familyId;
  final String? childId;
  final BoardCategory category;
  final String title;
  final String? body;
  final String createdBy;
  final bool pinned;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory BoardItem.fromMap(Map<String, dynamic> m) => BoardItem(
        id: m['id'] as String,
        familyId: m['family_id'] as String,
        childId: m['child_id'] as String?,
        category: BoardCategory.from(m['category'] as String?),
        title: (m['title'] as String?) ?? '',
        body: m['body'] as String?,
        createdBy: m['created_by'] as String? ?? '',
        pinned: asBool(m['pinned']),
        archived: asBool(m['archived']),
        createdAt: asDateOr(m['created_at'], DateTime.now()),
        updatedAt: asDateOr(m['updated_at'], DateTime.now()),
      );
}
