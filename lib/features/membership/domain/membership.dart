/// Whether the signed-in user may use SafeCircle beyond SOS.
enum MembershipStatus {
  /// Still asking the store. Treated as access, so members never see a
  /// paywall flash on launch.
  checking,

  /// Subscribed, or in the free trial.
  active,

  /// No membership: everything but SOS shows the paywall.
  inactive,

  /// Billing isn't set up on this platform (no key, web, or the store
  /// couldn't be reached at all). A safety app fails open: full access.
  unavailable;

  bool get hasAccess => this != inactive;
}

/// The monthly plan as the store sells it, in the user's currency.
class MembershipPlan {
  const MembershipPlan({required this.price, required this.hasFreeTrial, this.trialDays = 3});

  /// Localized price, e.g. "$0.99".
  final String price;

  /// The store will give this user the free trial (new subscribers only).
  final bool hasFreeTrial;
  final int trialDays;
}

/// What a purchase or restore ended with.
enum PurchaseOutcome { subscribed, cancelled, nothingToRestore, failed }
