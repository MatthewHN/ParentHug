import '../core/utils/date_x.dart';
import '_parse.dart';
import 'enums.dart';

class Memory {
  const Memory({
    required this.id,
    required this.familyId,
    this.childId,
    required this.uploadedBy,
    required this.storagePath,
    this.title,
    this.description,
    required this.memoryDate,
    this.milestoneType = MilestoneType.everyday,
    required this.createdAt,
    this.signedUrl,
  });

  final String id;
  final String familyId;
  final String? childId;
  final String uploadedBy;
  final String storagePath;
  final String? title;
  final String? description;
  final DateTime memoryDate;
  final MilestoneType milestoneType;
  final DateTime createdAt;

  /// Transient - resolved on demand for private-bucket display.
  final String? signedUrl;

  String get monthYear => DateX.monthYear(memoryDate);

  /// User-facing caption for memory cards and search results.
  String get displayTitle {
    final value = title?.trim();
    return value == null || value.isEmpty
        ? 'A moment worth remembering'
        : value;
  }

  factory Memory.fromMap(Map<String, dynamic> m) => Memory(
        id: m['id'] as String,
        familyId: m['family_id'] as String,
        childId: m['child_id'] as String?,
        uploadedBy: m['uploaded_by'] as String? ?? '',
        storagePath: (m['storage_path'] as String?) ?? '',
        title: m['title'] as String?,
        description: m['description'] as String?,
        memoryDate: asDateOr(m['memory_date'], DateTime.now()),
        milestoneType: MilestoneType.from(m['milestone_type'] as String?),
        createdAt: asDateOr(m['created_at'], DateTime.now()),
      );

  Memory copyWith({String? signedUrl}) => Memory(
        id: id,
        familyId: familyId,
        childId: childId,
        uploadedBy: uploadedBy,
        storagePath: storagePath,
        title: title,
        description: description,
        memoryDate: memoryDate,
        milestoneType: milestoneType,
        createdAt: createdAt,
        signedUrl: signedUrl ?? this.signedUrl,
      );
}
