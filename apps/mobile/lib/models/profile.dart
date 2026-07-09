class Profile {
  const Profile({
    required this.id,
    this.email,
    this.fullName = '',
    this.avatarUrl,
  });

  final String id;
  final String? email;
  final String fullName;
  final String? avatarUrl;

  factory Profile.fromMap(Map<String, dynamic> m) => Profile(
        id: m['id'] as String,
        email: m['email'] as String?,
        fullName: (m['full_name'] as String?) ?? '',
        avatarUrl: m['avatar_url'] as String?,
      );

  String get displayName {
    final n = fullName.trim();
    if (n.isNotEmpty) return n;
    final e = email ?? '';
    return e.contains('@') ? e.split('@').first : 'Parent';
  }

  String get firstName => displayName.split(RegExp(r'\s+')).first;
}
