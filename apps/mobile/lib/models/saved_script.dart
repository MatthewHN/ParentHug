import '_parse.dart';

class SavedScript {
  const SavedScript({
    required this.id,
    required this.familyId,
    this.childId,
    required this.title,
    required this.body,
    this.source = 'manual',
    this.sourceId,
    required this.createdAt,
  });

  final String id;
  final String familyId;
  final String? childId;
  final String title;
  final String body;
  final String source; // 'hug' | 'repair' | 'manual'
  final String? sourceId;
  final DateTime createdAt;

  factory SavedScript.fromMap(Map<String, dynamic> m) => SavedScript(
        id: m['id'] as String,
        familyId: m['family_id'] as String,
        childId: m['child_id'] as String?,
        title: (m['title'] as String?) ?? 'Saved script',
        body: (m['body'] as String?) ?? '',
        source: (m['source'] as String?) ?? 'manual',
        sourceId: m['source_id'] as String?,
        createdAt: asDateOr(m['created_at'], DateTime.now()),
      );
}
