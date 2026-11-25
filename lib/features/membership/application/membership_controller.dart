import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/features/membership/data/membership_store.dart';
import 'package:safecircle/features/membership/domain/membership.dart';

final membershipStoreProvider =
    Provider<MembershipStore>((ref) => RevenueCatMembershipStore.instance);

final membershipProvider =
    NotifierProvider<MembershipController, MembershipStatus>(MembershipController.new);

/// The user's membership: the paywall shows when it is [MembershipStatus.inactive].
class MembershipController extends Notifier<MembershipStatus> {
  MembershipStore get _store => ref.read(membershipStoreProvider);
  StreamSubscription<bool>? _sub;

  @override
  MembershipStatus build() {
    ref.onDispose(() => _sub?.cancel());
    return _store.supported ? MembershipStatus.checking : MembershipStatus.unavailable;
  }

  /// Signs the store in as [uid] and reads the membership.
  Future<void> start(String uid) async {
    if (!_store.supported || uid.isEmpty) {
      state = MembershipStatus.unavailable;
      return;
    }
    _sub ??= _store.activeChanges.listen(_set);
    try {
      if (await _store.signIn(uid)) {
        state = MembershipStatus.active;
        return;
      }
      // Only lock the app when there is a membership to buy. With nothing
      // on sale (store not set up yet, product not approved, store down) a
      // paywall would lock people out with no way in.
      state = await _store.plan() == null ? MembershipStatus.unavailable : MembershipStatus.inactive;
    } catch (e) {
      // The store couldn't be reached at all: don't lock anyone out of a
      // safety app for it. The listener corrects this once it can.
      debugPrint('[SafeCircle] membership: $e');
      state = MembershipStatus.unavailable;
    }
  }

  void _set(bool active) =>
      state = active ? MembershipStatus.active : MembershipStatus.inactive;

  Future<PurchaseOutcome> subscribe() => _apply(_store.subscribe());
  Future<PurchaseOutcome> restore() => _apply(_store.restore());

  Future<PurchaseOutcome> _apply(Future<PurchaseOutcome> action) async {
    final outcome = await action;
    if (outcome == PurchaseOutcome.subscribed) state = MembershipStatus.active;
    return outcome;
  }
}

/// The monthly plan for the paywall (price, trial), or null if the store
/// has none to offer.
final membershipPlanProvider = FutureProvider<MembershipPlan?>((ref) async {
  final store = ref.watch(membershipStoreProvider);
  if (!store.supported) return null;
  return store.plan();
});
