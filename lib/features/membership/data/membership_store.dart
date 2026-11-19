import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:safecircle/features/membership/data/membership_config.dart';
import 'package:safecircle/features/membership/domain/membership.dart';

/// The store the membership is bought in. An interface so tests can use a
/// fake instead of the App Store / Google Play.
abstract class MembershipStore {
  /// Billing is set up on this platform (a RevenueCat key exists for it).
  bool get supported;

  /// Ties purchases to the SafeCircle account, so the membership follows the
  /// user to a new phone. Returns whether the membership is active.
  Future<bool> signIn(String uid);
  Future<void> signOut();

  /// Emits whenever the store reports a change (renewal, expiry, refund…).
  Stream<bool> get activeChanges;

  Future<MembershipPlan?> plan();
  Future<PurchaseOutcome> subscribe();
  Future<PurchaseOutcome> restore();
}

class RevenueCatMembershipStore implements MembershipStore {
  RevenueCatMembershipStore._();
  static final instance = RevenueCatMembershipStore._();

  bool _configured = false;
  Package? _package;
  final _changes = StreamController<bool>.broadcast();

  String get _key {
    if (kIsWeb) return '';
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => kRevenueCatAppleKey,
      TargetPlatform.android => kRevenueCatGoogleKey,
      _ => '',
    };
  }

  @override
  bool get supported => _key.isNotEmpty;

  static bool _isActive(CustomerInfo info) =>
      info.entitlements.active.containsKey(kMembershipEntitlement);

  @override
  Stream<bool> get activeChanges => _changes.stream;

  @override
  Future<bool> signIn(String uid) async {
    if (!_configured) {
      await Purchases.setLogLevel(kDebugMode ? LogLevel.info : LogLevel.warn);
      await Purchases.configure(PurchasesConfiguration(_key)..appUserID = uid);
      Purchases.addCustomerInfoUpdateListener((info) => _changes.add(_isActive(info)));
      _configured = true;
      return _isActive(await Purchases.getCustomerInfo());
    }
    return _isActive((await Purchases.logIn(uid)).customerInfo);
  }

  @override
  Future<void> signOut() async {
    if (!_configured) return;
    try {
      if (!await Purchases.isAnonymous) await Purchases.logOut();
    } catch (e) {
      debugPrint('[SafeCircle] membership sign out: $e');
    }
  }

  @override
  Future<MembershipPlan?> plan() async {
    final offering = (await Purchases.getOfferings()).current;
    final package = offering?.monthly ??
        ((offering?.availablePackages.isNotEmpty ?? false) ? offering!.availablePackages.first : null);
    _package = package;
    if (package == null) return null;
    final product = package.storeProduct;
    final trial = product.introductoryPrice?.price == 0 || product.defaultOption?.freePhase != null;
    return MembershipPlan(price: product.priceString, hasFreeTrial: trial);
  }

  @override
  Future<PurchaseOutcome> subscribe() async {
    final package = _package ?? (await plan() == null ? null : _package);
    if (package == null) return PurchaseOutcome.failed;
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      return _isActive(result.customerInfo) ? PurchaseOutcome.subscribed : PurchaseOutcome.failed;
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) == PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseOutcome.cancelled;
      }
      debugPrint('[SafeCircle] subscribe: $e');
      return PurchaseOutcome.failed;
    }
  }

  @override
  Future<PurchaseOutcome> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      return _isActive(info) ? PurchaseOutcome.subscribed : PurchaseOutcome.nothingToRestore;
    } catch (e) {
      debugPrint('[SafeCircle] restore: $e');
      return PurchaseOutcome.failed;
    }
  }
}
