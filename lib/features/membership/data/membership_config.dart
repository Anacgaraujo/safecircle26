/// RevenueCat setup for the SafeCircle membership ($0.99/month, 3-day free
/// trial). See docs/MEMBERSHIP.md.
///
/// These are RevenueCat's *public* app keys (they start with `appl_` and
/// `goog_`). They are meant to ship inside the app, so they live here rather
/// than in a secret store. While a key is empty the membership is switched
/// off on that platform and everyone keeps full access.
const kRevenueCatAppleKey = '';
const kRevenueCatGoogleKey = '';

/// The RevenueCat entitlement the monthly subscription grants.
const kMembershipEntitlement = 'membership';
