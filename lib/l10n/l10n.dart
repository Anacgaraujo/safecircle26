import 'package:flutter/widgets.dart';

import 'package:safecircle/l10n/app_localizations.dart';

export 'package:safecircle/l10n/app_localizations.dart';

/// The app's text in the phone's language. Translations live in the
/// `app_<language>.arb` files next to this one; `app_en.arb` is the source.
extension L10nContext on BuildContext {
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ?? appL10n;
}

/// The phone's language, matched to one the app supports (English otherwise).
Locale get appLocale => basicLocaleListResolution(
    WidgetsBinding.instance.platformDispatcher.locales, AppLocalizations.supportedLocales);

/// For code without a BuildContext: services, notifications, model labels.
AppLocalizations get appL10n => lookupAppLocalizations(appLocale);
