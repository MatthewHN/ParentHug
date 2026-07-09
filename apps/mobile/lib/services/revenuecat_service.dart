import 'dart:io' show Platform;

import 'package:purchases_flutter/purchases_flutter.dart';

import '../core/config/env.dart';

/// Wraps the RevenueCat SDK. Every method is a graceful no-op when RevenueCat
/// isn't configured, so the app runs (and demos premium features) without keys.
class RevenueCatService {
  RevenueCatService._();
  static final RevenueCatService instance = RevenueCatService._();

  bool _configured = false;
  bool get isConfigured => _configured;

  Future<void> init() async {
    if (!Env.isRevenueCatConfigured) return;
    try {
      final apiKey =
          Platform.isIOS ? Env.revenueCatIosKey : Env.revenueCatAndroidKey;
      if (apiKey.isEmpty) return;
      await Purchases.setLogLevel(LogLevel.warn);
      await Purchases.configure(PurchasesConfiguration(apiKey));
      _configured = true;
    } catch (_) {
      _configured = false; // never block app startup on billing
    }
  }

  /// Link RevenueCat to the Supabase user id so the webhook can map purchases
  /// to the right family (see revenuecat_webhook Edge Function).
  Future<void> login(String userId) async {
    if (!_configured) return;
    try {
      await Purchases.logIn(userId);
    } catch (_) {}
  }

  Future<void> logout() async {
    if (!_configured) return;
    try {
      await Purchases.logOut();
    } catch (_) {}
  }

  Future<CustomerInfo?> customerInfo() async {
    if (!_configured) return null;
    try {
      return await Purchases.getCustomerInfo();
    } catch (_) {
      return null;
    }
  }

  Future<Offerings?> offerings() async {
    if (!_configured) return null;
    try {
      return await Purchases.getOfferings();
    } catch (_) {
      return null;
    }
  }

  Future<CustomerInfo> purchase(Package package) =>
      Purchases.purchasePackage(package);

  Future<CustomerInfo?> restore() async {
    if (!_configured) return null;
    return Purchases.restorePurchases();
  }
}
