import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/providers/supabase_providers.dart';

/// Thrown when an Edge Function returns a non-2xx response.
class EdgeFunctionException implements Exception {
  EdgeFunctionException(this.status, this.payload);

  final int status;
  final Map<String, dynamic> payload;

  bool get isUpgradeRequired =>
      status == 402 || payload['code'] == 'upgrade_required';

  String get message =>
      (payload['message'] ?? payload['error'] ?? 'Something went wrong')
          .toString();

  @override
  String toString() => 'EdgeFunctionException($status, $payload)';
}

/// Thin wrapper around Supabase Edge Function invocation. All AI + billing
/// server logic lives behind these functions - the app never holds AI keys.
class EdgeFunctionsService {
  EdgeFunctionsService(this._client);

  final SupabaseClient _client;

  Future<Map<String, dynamic>> invoke(
    String name,
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await _client.functions.invoke(name, body: body);
      final data = _asMap(res.data);
      if (res.status >= 400) {
        throw EdgeFunctionException(res.status, data);
      }
      return data;
    } on FunctionException catch (e) {
      throw EdgeFunctionException(e.status, _asMap(e.details));
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();
    return {'error': 'unexpected_response'};
  }
}

final edgeFunctionsServiceProvider = Provider<EdgeFunctionsService>(
  (ref) => EdgeFunctionsService(ref.watch(supabaseClientProvider)),
);
