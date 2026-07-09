// Small parsing helpers shared by model `fromMap` factories.

DateTime? asDate(dynamic v) =>
    v == null ? null : DateTime.tryParse(v.toString())?.toLocal();

DateTime asDateOr(dynamic v, DateTime fallback) => asDate(v) ?? fallback;

List<String> asStringList(dynamic v) {
  if (v is List) return v.map((e) => e.toString()).toList();
  return const [];
}

bool asBool(dynamic v, [bool fallback = false]) {
  if (v is bool) return v;
  if (v is String) return v.toLowerCase() == 'true';
  return fallback;
}

int asInt(dynamic v, [int fallback = 0]) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse('$v') ?? fallback;
}
