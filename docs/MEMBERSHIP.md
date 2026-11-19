# SafeCircle membership

$0.99 a month, with a 3-day free trial for new members. Bought in the App
Store or Google Play and tracked by [RevenueCat](https://www.revenuecat.com).

## What it unlocks

| Without a membership | With a membership |
|---|---|
| SOS (Emergency tab), and cancelling it | Everything |
| Alerts from your circle (push, texts, alert details) | |
| Profile: account, emergency contacts, settings, log out, delete account | |
| Pausing location sharing with the safety or panic PIN | |
| Home, Circles and journeys show the membership screen | |

The app **fails open**: if no RevenueCat key is set for a platform, or the
store can't be reached at all, everyone keeps full access. A safety app should
never lock someone out because a server is down.

## How it works in the code

- `lib/features/membership/data/membership_config.dart` — the RevenueCat public
  keys and the entitlement id (`membership`). Empty key = membership off.
- `lib/features/membership/data/membership_store.dart` — RevenueCat calls
  (sign in with the Firebase uid, offerings, purchase, restore, sign out).
- `lib/features/membership/application/membership_controller.dart` — the
  status (`checking`, `active`, `inactive`, `unavailable`) the app watches.
- `lib/features/membership/presentation/membership_paywall.dart` — the
  membership screen, and `requireMembership()` for locked buttons.
- `lib/app/main_shell.dart` — locks Home and Circles, gates the journey button.
- Profile → Membership: shows the status and opens the store's subscription
  page to manage or cancel.

Purchases are tied to the SafeCircle account (RevenueCat app user id = Firebase
uid), so the membership follows the user to a new phone.

## Setup

### 1. App Store Connect

1. **Agreements, Tax, and Banking**: sign the Paid Apps agreement and add bank
   and tax details. Subscriptions can't be sold (or tested in TestFlight)
   until this is active.
2. App → **Subscriptions** → create a subscription group, e.g. *SafeCircle
   Membership*.
3. Add a subscription:
   - Reference name: *Monthly membership*
   - Product ID: `org.SafeCircle.membership.monthly`
   - Duration: 1 month · Price: $0.99 (tier 1)
   - Localization: display name *SafeCircle Membership*, description
     *Live location, journeys and circles.*
   - Review screenshot: a screenshot of the membership screen.
4. In that subscription → **Introductory offers** → *Free* for *3 days*, all
   countries, new subscribers.
5. **Users and Access → Integrations → In-App Purchase**: generate an
   In-App Purchase key (.p8) for RevenueCat. Keep the file private.

### 2. Google Play (when the app has a Play listing)

1. Play Console → Monetize → **Subscriptions** → create
   `membership_monthly`, base plan *monthly* (auto-renewing, 1 month, $0.99).
2. Add an **offer** to the base plan: free trial, 3 days, eligibility *new
   customers*.
3. Create a Google Cloud service account with access to the Play Developer
   API and invite it in Play Console (Users and permissions) — RevenueCat's
   guide walks through this.

### 3. RevenueCat

1. Create a project *SafeCircle*.
2. Add an **App Store** app: bundle id `org.SafeCircle`, upload the In-App
   Purchase key (.p8) with its Key ID and Issuer ID.
3. Add a **Play Store** app: package `com.safecircle26.app`, upload the
   service account JSON.
4. **Products**: import `org.SafeCircle.membership.monthly` (and later
   `membership_monthly:monthly`).
5. **Entitlements**: create `membership` and attach both products.
6. **Offerings**: the `default` offering with a **Monthly** package
   containing both products.
7. **API keys**: copy the public app keys (`appl_…`, `goog_…`) into
   `membership_config.dart`. They are public keys made to ship in the app.

### 4. Test

- **iPhone**: TestFlight builds use the sandbox, so purchases are free and a
  month renews every few minutes. Sign in with a sandbox tester
  (App Store Connect → Users and Access → Sandbox) when the purchase sheet asks.
- **Android**: add license testers in Play Console; needs an internal test
  track build.
- Check: the membership screen shows "3 days free, then $0.99/month", buying
  unlocks Home and Circles, Profile → Membership says Active, Restore works
  after reinstalling, and SOS works while not subscribed.

## App Review notes

- The membership screen shows the price, the trial length, that it renews
  automatically and how to cancel, plus Terms of Service and Privacy Policy
  links and Restore purchases — all required by App Review (guideline 3.1.2).
- SOS is free, so App Review can test the emergency feature without paying.
