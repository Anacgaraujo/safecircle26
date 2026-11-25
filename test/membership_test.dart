import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safecircle/features/membership/application/membership_controller.dart';
import 'package:safecircle/features/membership/data/membership_store.dart';
import 'package:safecircle/features/membership/domain/membership.dart';
import 'package:safecircle/features/membership/presentation/membership_paywall.dart';
import 'package:safecircle/l10n/l10n.dart';

class FakeStore implements MembershipStore {
  FakeStore({this.supported = true, this.active = false, this.plan_, this.signInError = false});

  @override
  final bool supported;
  bool active;
  MembershipPlan? plan_;
  bool signInError;
  PurchaseOutcome nextPurchase = PurchaseOutcome.subscribed;
  final changes = StreamController<bool>.broadcast();
  String? signedInAs;

  @override
  Stream<bool> get activeChanges => changes.stream;

  @override
  Future<bool> signIn(String uid) async {
    if (signInError) throw Exception('offline');
    signedInAs = uid;
    return active;
  }

  @override
  Future<void> signOut() async => signedInAs = null;

  @override
  Future<MembershipPlan?> plan() async => plan_;

  @override
  Future<PurchaseOutcome> subscribe() async => nextPurchase;

  @override
  Future<PurchaseOutcome> restore() async =>
      active ? PurchaseOutcome.subscribed : PurchaseOutcome.nothingToRestore;
}

const _plan = MembershipPlan(price: r'$0.99', hasFreeTrial: true);

ProviderContainer _container(FakeStore store) {
  final c = ProviderContainer(overrides: [membershipStoreProvider.overrideWithValue(store)]);
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('membership status', () {
    test('with no billing set up, everyone has access', () async {
      final c = _container(FakeStore(supported: false));
      expect(c.read(membershipProvider), MembershipStatus.unavailable);
      await c.read(membershipProvider.notifier).start('ana');
      expect(c.read(membershipProvider).hasAccess, isTrue);
    });

    test('members are let in, others see the paywall', () async {
      final member = _container(FakeStore(active: true));
      await member.read(membershipProvider.notifier).start('ana');
      expect(member.read(membershipProvider), MembershipStatus.active);

      final other = _container(FakeStore(plan_: _plan));
      await other.read(membershipProvider.notifier).start('zed');
      expect(other.read(membershipProvider), MembershipStatus.inactive);
      expect(other.read(membershipProvider).hasAccess, isFalse);
    });

    test('with nothing on sale yet, nobody is locked out', () async {
      final c = _container(FakeStore());
      await c.read(membershipProvider.notifier).start('ana');
      expect(c.read(membershipProvider), MembershipStatus.unavailable);
    });

    test('a store that cannot be reached never locks anyone out', () async {
      final c = _container(FakeStore(signInError: true));
      await c.read(membershipProvider.notifier).start('ana');
      expect(c.read(membershipProvider).hasAccess, isTrue);
    });

    test('renewals and expiries from the store update the status', () async {
      final store = FakeStore(active: true);
      final c = _container(store);
      await c.read(membershipProvider.notifier).start('ana');
      store.changes.add(false);
      await Future<void>.delayed(Duration.zero);
      expect(c.read(membershipProvider), MembershipStatus.inactive);
    });

    test('subscribing unlocks the app; cancelling the purchase does not', () async {
      final store = FakeStore(plan_: _plan)..nextPurchase = PurchaseOutcome.cancelled;
      final c = _container(store);
      final membership = c.read(membershipProvider.notifier);
      await membership.start('ana');
      expect(await membership.subscribe(), PurchaseOutcome.cancelled);
      expect(c.read(membershipProvider), MembershipStatus.inactive);

      store.nextPurchase = PurchaseOutcome.subscribed;
      expect(await membership.subscribe(), PurchaseOutcome.subscribed);
      expect(c.read(membershipProvider), MembershipStatus.active);
    });
  });

  group('paywall', () {
    Future<FakeStore> show(WidgetTester tester, {MembershipPlan? plan, VoidCallback? onOpenSos}) async {
      final store = FakeStore(plan_: plan);
      tester.view.physicalSize = const Size(1200, 3600);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        overrides: [membershipStoreProvider.overrideWithValue(store)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: MembershipPaywall(onOpenSos: onOpenSos)),
        ),
      ));
      await tester.pumpAndSettle();
      return store;
    }

    testWidgets('shows the trial and the price from the store', (tester) async {
      await show(tester, plan: const MembershipPlan(price: r'$0.99', hasFreeTrial: true));
      expect(find.text(r'3 days free, then $0.99/month'), findsOneWidget);
      expect(find.text('Start free trial'), findsOneWidget);
      expect(find.text('Restore purchases'), findsOneWidget);
      expect(find.textContaining('renews every month'), findsOneWidget);
    });

    testWidgets('people who already had the trial just subscribe', (tester) async {
      await show(tester, plan: const MembershipPlan(price: r'$0.99', hasFreeTrial: false));
      expect(find.text(r'$0.99/month'), findsOneWidget);
      expect(find.text('Subscribe'), findsOneWidget);
    });

    testWidgets('SOS stays one tap away', (tester) async {
      var opened = false;
      await show(tester,
          plan: const MembershipPlan(price: r'$0.99', hasFreeTrial: true),
          onOpenSos: () => opened = true);
      await tester.tap(find.text('Open SOS'));
      expect(opened, isTrue);
    });

    testWidgets('says so when the store has nothing to sell', (tester) async {
      await show(tester);
      expect(find.textContaining("can't be loaded right now"), findsOneWidget);
    });
  });
}
