// Enum types mirroring the Postgres enums, with UI labels/emoji.

enum MemberRole {
  admin('admin', 'Admin'),
  parent('parent', 'Parent'),
  caregiver('caregiver', 'Caregiver');

  const MemberRole(this.value, this.label);
  final String value;
  final String label;

  static MemberRole from(String? v) =>
      values.firstWhere((e) => e.value == v, orElse: () => parent);
}

enum BoardCategory {
  headsUp('heads_up', 'Heads Up', '⚡'),
  rules('rules', 'Rules', '📏'),
  wins('wins', 'Wins', '🌟'),
  wants('wants', 'Wants / Interests', '🎁'),
  triggers('triggers', 'Triggers', '⚠️'),
  savedScripts('saved_scripts', 'Saved Scripts', '💬');

  const BoardCategory(this.value, this.label, this.emoji);
  final String value;
  final String label;
  final String emoji;

  static BoardCategory from(String? v) =>
      values.firstWhere((e) => e.value == v, orElse: () => headsUp);
}

enum MilestoneType {
  first('first', 'First', '🎉'),
  birthday('birthday', 'Birthday', '🎂'),
  holiday('holiday', 'Holiday', '🎄'),
  achievement('achievement', 'Achievement', '🏆'),
  everyday('everyday', 'Everyday', '🌤️'),
  other('other', 'Moment', '✨');

  const MilestoneType(this.value, this.label, this.emoji);
  final String value;
  final String label;
  final String emoji;

  static MilestoneType from(String? v) =>
      values.firstWhere((e) => e.value == v, orElse: () => everyday);
}

enum HugTone {
  gentle('gentle', 'Gentle', '🫶'),
  firm('firm', 'Firm', '🧱'),
  calm('calm', 'Calm', '🌊'),
  quick('quick', 'Quick', '⚡');

  const HugTone(this.value, this.label, this.emoji);
  final String value;
  final String label;
  final String emoji;
}

enum RepairTone {
  short('short', 'Short'),
  gentle('gentle', 'Gentle'),
  honest('honest', 'Honest'),
  ageAppropriate('age_appropriate', 'Age-appropriate');

  const RepairTone(this.value, this.label);
  final String value;
  final String label;
}

enum ParentReaction {
  yelled('yelled', 'I yelled'),
  threatened('threatened', 'I threatened'),
  gaveIn('gave_in', 'I gave in'),
  shamed('shamed', 'I shamed'),
  ignored('ignored', 'I ignored'),
  overwhelmed('overwhelmed', 'I got overwhelmed'),
  other('other', 'Something else');

  const ParentReaction(this.value, this.label);
  final String value;
  final String label;
}

enum PlanTier {
  free('free', 'Free'),
  pro('pro', 'ParentHug Pro');

  const PlanTier(this.value, this.label);
  final String value;
  final String label;

  static PlanTier from(String? v) =>
      values.firstWhere((e) => e.value == v, orElse: () => free);

  bool get isPaid => this != free;

  /// Rank so we can compare entitlements (pro > free).
  int get rank => switch (this) {
        free => 0,
        pro => 1,
      };
}
