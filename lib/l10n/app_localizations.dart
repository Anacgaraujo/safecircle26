import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('pt'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SafeCircle'**
  String get appTitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @alertKindPanic.
  ///
  /// In en, this message translates to:
  /// **'Silent panic'**
  String get alertKindPanic;

  /// No description provided for @alertKindOverdue.
  ///
  /// In en, this message translates to:
  /// **'Missed check-in'**
  String get alertKindOverdue;

  /// No description provided for @alertKindSos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get alertKindSos;

  /// No description provided for @alertHeadlineOverdue.
  ///
  /// In en, this message translates to:
  /// **'{name} missed a check-in'**
  String alertHeadlineOverdue(String name);

  /// No description provided for @alertHeadlineHelp.
  ///
  /// In en, this message translates to:
  /// **'{name} needs help'**
  String alertHeadlineHelp(String name);

  /// No description provided for @someone.
  ///
  /// In en, this message translates to:
  /// **'Someone'**
  String get someone;

  /// No description provided for @aCircle.
  ///
  /// In en, this message translates to:
  /// **'a circle'**
  String get aCircle;

  /// No description provided for @inviteSummary.
  ///
  /// In en, this message translates to:
  /// **'{name} invited you to {circle}'**
  String inviteSummary(String name, String circle);

  /// No description provided for @circleOwner.
  ///
  /// In en, this message translates to:
  /// **'Circle owner'**
  String get circleOwner;

  /// No description provided for @lastSeenAt.
  ///
  /// In en, this message translates to:
  /// **'Last seen {time}'**
  String lastSeenAt(String time);

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name.'**
  String get enterYourName;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email.'**
  String get enterYourEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must have at least 6 characters.'**
  String get passwordTooShort;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match.'**
  String get passwordsDontMatch;

  /// No description provided for @enterEmailAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password.'**
  String get enterEmailAndPassword;

  /// No description provided for @recoveryLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Recovery link sent. Check your inbox.'**
  String get recoveryLinkSent;

  /// No description provided for @couldNotSavePins.
  ///
  /// In en, this message translates to:
  /// **'Could not save your PINs. Try again.'**
  String get couldNotSavePins;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcomeTo;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Build a trusted circle and let someone always know you\'re safe.'**
  String get welcomeTagline;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @skipIntro.
  ///
  /// In en, this message translates to:
  /// **'Skip intro'**
  String get skipIntro;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @joinInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Join SafeCircle in a few seconds.'**
  String get joinInSeconds;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. Alex Morgan'**
  String get nameExample;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailExample.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get emailExample;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeatPassword;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account…'**
  String get creatingAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Someone always knows you\'re safe.'**
  String get loginTagline;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot?'**
  String get forgotPassword;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in…'**
  String get loggingIn;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or, login with...'**
  String get orLoginWith;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccountYet;

  /// No description provided for @registerExclaim.
  ///
  /// In en, this message translates to:
  /// **'Register!'**
  String get registerExclaim;

  /// No description provided for @socialLoginSoon.
  ///
  /// In en, this message translates to:
  /// **'Social login coming soon.'**
  String get socialLoginSoon;

  /// No description provided for @recoverPassword.
  ///
  /// In en, this message translates to:
  /// **'Recover password'**
  String get recoverPassword;

  /// No description provided for @recoverPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the email linked to your account and we\'ll send you a secure link to reset your password.'**
  String get recoverPasswordHint;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get sending;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'STEP {step} OF {total}'**
  String stepOf(int step, int total);

  /// No description provided for @setPanicPin.
  ///
  /// In en, this message translates to:
  /// **'Set your panic PIN'**
  String get setPanicPin;

  /// No description provided for @setSafetyPin.
  ///
  /// In en, this message translates to:
  /// **'Set your safety PIN'**
  String get setSafetyPin;

  /// No description provided for @panicPinHint.
  ///
  /// In en, this message translates to:
  /// **'If you\'re forced to open the app, enter this PIN. The screen looks normal, but your circle is silently alerted.'**
  String get panicPinHint;

  /// No description provided for @safetyPinHint.
  ///
  /// In en, this message translates to:
  /// **'Use this PIN to confirm you\'re safe during check-ins.'**
  String get safetyPinHint;

  /// No description provided for @panicPinMatchesSafety.
  ///
  /// In en, this message translates to:
  /// **'That matches your safety PIN. Choose a different code.'**
  String get panicPinMatchesSafety;

  /// No description provided for @panicPinMustDiffer.
  ///
  /// In en, this message translates to:
  /// **'Must be different from your safety PIN.'**
  String get panicPinMustDiffer;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @gettingStarted.
  ///
  /// In en, this message translates to:
  /// **'GETTING STARTED'**
  String get gettingStarted;

  /// No description provided for @createFirstCircle.
  ///
  /// In en, this message translates to:
  /// **'Create your first Circle'**
  String get createFirstCircle;

  /// No description provided for @tapPrefix.
  ///
  /// In en, this message translates to:
  /// **'Tap '**
  String get tapPrefix;

  /// No description provided for @tabCircles.
  ///
  /// In en, this message translates to:
  /// **'Circles'**
  String get tabCircles;

  /// No description provided for @createFirstCircleHint.
  ///
  /// In en, this message translates to:
  /// **' in the bottom bar, give it a name, and add the people you trust. They\'ll get an invite to follow your journeys.'**
  String get createFirstCircleHint;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @allSet.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get allSet;

  /// No description provided for @allSetHint.
  ///
  /// In en, this message translates to:
  /// **'Your SafeCircle is ready. Plan your first journey whenever you head out.'**
  String get allSetHint;

  /// No description provided for @enterSafeCircle.
  ///
  /// In en, this message translates to:
  /// **'Enter SafeCircle'**
  String get enterSafeCircle;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get authInvalidEmail;

  /// No description provided for @authEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get authEmailInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password too weak (min. 6 characters).'**
  String get authWeakPassword;

  /// No description provided for @authWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password.'**
  String get authWrongCredentials;

  /// No description provided for @authTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get authTooManyAttempts;

  /// No description provided for @authNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection.'**
  String get authNetwork;

  /// No description provided for @authReloginNeeded.
  ///
  /// In en, this message translates to:
  /// **'Please log in again to do this.'**
  String get authReloginNeeded;

  /// No description provided for @authGenericError.
  ///
  /// In en, this message translates to:
  /// **'Authentication error.'**
  String get authGenericError;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get somethingWentWrong;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @changeSafetyPin.
  ///
  /// In en, this message translates to:
  /// **'Change safety PIN'**
  String get changeSafetyPin;

  /// No description provided for @changeSafetyPinSub.
  ///
  /// In en, this message translates to:
  /// **'Confirms you\'re OK at check-in'**
  String get changeSafetyPinSub;

  /// No description provided for @changePanicPin.
  ///
  /// In en, this message translates to:
  /// **'Change panic PIN'**
  String get changePanicPin;

  /// No description provided for @changePanicPinSub.
  ///
  /// In en, this message translates to:
  /// **'Silent duress code · sends a hidden alert'**
  String get changePanicPinSub;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @checkInReminders.
  ///
  /// In en, this message translates to:
  /// **'Check-in reminders'**
  String get checkInReminders;

  /// No description provided for @checkInRemindersSub.
  ///
  /// In en, this message translates to:
  /// **'Nudge me when a check-in is due'**
  String get checkInRemindersSub;

  /// No description provided for @overdueCheckIns.
  ///
  /// In en, this message translates to:
  /// **'Overdue check-ins'**
  String get overdueCheckIns;

  /// No description provided for @overdueCheckInsSub.
  ///
  /// In en, this message translates to:
  /// **'When a friend misses a check-in. Panic and SOS alerts are always on.'**
  String get overdueCheckInsSub;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @permissionsSub.
  ///
  /// In en, this message translates to:
  /// **'Location, notifications, alarms and battery'**
  String get permissionsSub;

  /// No description provided for @permissionsReason.
  ///
  /// In en, this message translates to:
  /// **'SafeCircle only uses these to protect you and your circle.'**
  String get permissionsReason;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @sendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Send a test notification'**
  String get sendTestNotification;

  /// No description provided for @sendTestNotificationSub.
  ///
  /// In en, this message translates to:
  /// **'Check that alerts reach this phone'**
  String get sendTestNotificationSub;

  /// No description provided for @testNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Sent — check your notification shade.'**
  String get testNotificationSent;

  /// No description provided for @testNotificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send. Check notification permission in system settings.'**
  String get testNotificationFailed;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get changeEmail;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @logOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logOutQuestion;

  /// No description provided for @logOutBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll stop receiving alerts from your circles until you log back in.'**
  String get logOutBody;

  /// No description provided for @loggedOut.
  ///
  /// In en, this message translates to:
  /// **'Logged out.'**
  String get loggedOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSub.
  ///
  /// In en, this message translates to:
  /// **'Permanently erases your circle & history'**
  String get deleteAccountSub;

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountQuestion;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently erases your circles, contacts and journey history. This cannot be undone.'**
  String get deleteAccountBody;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted.'**
  String get accountDeleted;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @aboutFooter.
  ///
  /// In en, this message translates to:
  /// **'SafeCircle · Made to keep your circle safe'**
  String get aboutFooter;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @beforeYouStart.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get beforeYouStart;

  /// No description provided for @journeyPermissionsReason.
  ///
  /// In en, this message translates to:
  /// **'A journey needs these so your check-in reminders ring on time and your circle can see where you are.'**
  String get journeyPermissionsReason;

  /// No description provided for @shareLiveLocation.
  ///
  /// In en, this message translates to:
  /// **'Share your live location'**
  String get shareLiveLocation;

  /// No description provided for @shareLiveLocationReason.
  ///
  /// In en, this message translates to:
  /// **'Your circle sees where you are on the map.'**
  String get shareLiveLocationReason;

  /// No description provided for @notificationsOffWarning.
  ///
  /// In en, this message translates to:
  /// **'You won\'t be notified about alerts — enable notifications in Settings.'**
  String get notificationsOffWarning;

  /// No description provided for @almostThere.
  ///
  /// In en, this message translates to:
  /// **'ALMOST THERE'**
  String get almostThere;

  /// No description provided for @allowPermissions.
  ///
  /// In en, this message translates to:
  /// **'Allow permissions'**
  String get allowPermissions;

  /// No description provided for @allowPermissionsHint.
  ///
  /// In en, this message translates to:
  /// **'SafeCircle only uses these to keep you and your circle safe. You\'re always in control — change them anytime in Settings.'**
  String get allowPermissionsHint;

  /// No description provided for @locationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location denied — enable it in system settings.'**
  String get locationDenied;

  /// No description provided for @notificationsDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications denied — enable them in system settings.'**
  String get notificationsDenied;

  /// No description provided for @turnOnAlarms.
  ///
  /// In en, this message translates to:
  /// **'Turn on \"Alarms & reminders\" for SafeCircle, then come back.'**
  String get turnOnAlarms;

  /// No description provided for @contactsDenied.
  ///
  /// In en, this message translates to:
  /// **'Contacts denied — enable it in system settings.'**
  String get contactsDenied;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locationPermissionSub.
  ///
  /// In en, this message translates to:
  /// **'So your circle can see you\'ve arrived safely.'**
  String get locationPermissionSub;

  /// No description provided for @notificationsPermissionSub.
  ///
  /// In en, this message translates to:
  /// **'So we can remind you when a check-in is due.'**
  String get notificationsPermissionSub;

  /// No description provided for @alarmsAndReminders.
  ///
  /// In en, this message translates to:
  /// **'Alarms & reminders'**
  String get alarmsAndReminders;

  /// No description provided for @alarmsPermissionSub.
  ///
  /// In en, this message translates to:
  /// **'So check-in reminders ring exactly on time.'**
  String get alarmsPermissionSub;

  /// No description provided for @backgroundActivity.
  ///
  /// In en, this message translates to:
  /// **'Background activity (recommended)'**
  String get backgroundActivity;

  /// No description provided for @backgroundPermissionSub.
  ///
  /// In en, this message translates to:
  /// **'So reminders still fire when your phone is idle.'**
  String get backgroundPermissionSub;

  /// No description provided for @contactsOptional.
  ///
  /// In en, this message translates to:
  /// **'Contacts (optional)'**
  String get contactsOptional;

  /// No description provided for @contactsPermissionSub.
  ///
  /// In en, this message translates to:
  /// **'To quickly invite the people you trust.'**
  String get contactsPermissionSub;

  /// No description provided for @locationAndNotificationsRequired.
  ///
  /// In en, this message translates to:
  /// **'Location and Notifications are required for SafeCircle to protect you.'**
  String get locationAndNotificationsRequired;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location is required for SafeCircle to protect you.'**
  String get locationRequired;

  /// No description provided for @setUpLater.
  ///
  /// In en, this message translates to:
  /// **'Set up later'**
  String get setUpLater;

  /// No description provided for @openSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Open system settings'**
  String get openSystemSettings;

  /// No description provided for @allowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get allowed;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @verificationLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Verification link sent to {email} — confirm it to switch.'**
  String verificationLinkSent(String email);

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get passwordChanged;

  /// No description provided for @safetyPinUpdated.
  ///
  /// In en, this message translates to:
  /// **'Safety PIN updated'**
  String get safetyPinUpdated;

  /// No description provided for @panicPinUpdated.
  ///
  /// In en, this message translates to:
  /// **'Panic PIN updated'**
  String get panicPinUpdated;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @editProfileHint.
  ///
  /// In en, this message translates to:
  /// **'Update how your circle sees you. Your phone lets friends call you during a journey.'**
  String get editProfileHint;

  /// No description provided for @changeEmailHint.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a verification link to the new address. Sign-in and invites move to it once confirmed. Current: {email}'**
  String changeEmailHint(String email);

  /// No description provided for @newEmail.
  ///
  /// In en, this message translates to:
  /// **'New email'**
  String get newEmail;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @useSixCharacters.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters.'**
  String get useSixCharacters;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @safetyPinHintShort.
  ///
  /// In en, this message translates to:
  /// **'This PIN confirms you are OK at each check-in.'**
  String get safetyPinHintShort;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPin;

  /// No description provided for @panicPinHintShort.
  ///
  /// In en, this message translates to:
  /// **'Entering this PIN looks normal but silently alerts your circle.'**
  String get panicPinHintShort;

  /// No description provided for @currentPanicPin.
  ///
  /// In en, this message translates to:
  /// **'Current panic PIN'**
  String get currentPanicPin;

  /// No description provided for @newPanicPin.
  ///
  /// In en, this message translates to:
  /// **'New panic PIN'**
  String get newPanicPin;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @deleteCircleQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete {circle}?'**
  String deleteCircleQuestion(String circle);

  /// No description provided for @deleteCircleBody.
  ///
  /// In en, this message translates to:
  /// **'Everyone in this circle stops following your journeys and alerts. This can’t be undone.'**
  String get deleteCircleBody;

  /// No description provided for @deleteCircle.
  ///
  /// In en, this message translates to:
  /// **'Delete circle'**
  String get deleteCircle;

  /// No description provided for @theOwner.
  ///
  /// In en, this message translates to:
  /// **'the owner'**
  String get theOwner;

  /// No description provided for @leaveCircleQuestion.
  ///
  /// In en, this message translates to:
  /// **'Leave {circle}?'**
  String leaveCircleQuestion(String circle);

  /// No description provided for @leaveCircleBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll stop following {owner}\'s journeys and alerts, and this circle stops seeing your location. {owner} can invite you again.'**
  String leaveCircleBody(String owner);

  /// No description provided for @leaveCircle.
  ///
  /// In en, this message translates to:
  /// **'Leave circle'**
  String get leaveCircle;

  /// No description provided for @couldNotLeaveCircle.
  ///
  /// In en, this message translates to:
  /// **'Could not leave the circle. Try again.'**
  String get couldNotLeaveCircle;

  /// No description provided for @resendInvitationQuestion.
  ///
  /// In en, this message translates to:
  /// **'Resend invitation to {name}?'**
  String resendInvitationQuestion(String name);

  /// No description provided for @resendInvitationTextBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll text {phone} again and remind them in the app.'**
  String resendInvitationTextBody(String phone);

  /// No description provided for @resendInvitationAppBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind them in the app if they have SafeCircle. If not, you\'ll pick how to send them the invitation yourself.'**
  String get resendInvitationAppBody;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @couldNotResendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Could not resend the invitation. Try again.'**
  String get couldNotResendInvitation;

  /// No description provided for @removePersonQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String removePersonQuestion(String name);

  /// No description provided for @removePersonBody.
  ///
  /// In en, this message translates to:
  /// **'They will no longer follow your journeys or receive your alerts.'**
  String get removePersonBody;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @couldNotRemoveParticipant.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the participant. Try again.'**
  String get couldNotRemoveParticipant;

  /// No description provided for @participantCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 participant} other{{count} participants}}'**
  String participantCount(int count);

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @addMoreParticipants.
  ///
  /// In en, this message translates to:
  /// **'Add more participants'**
  String get addMoreParticipants;

  /// No description provided for @deleteThisCircle.
  ///
  /// In en, this message translates to:
  /// **'Delete this circle'**
  String get deleteThisCircle;

  /// No description provided for @leaveThisCircle.
  ///
  /// In en, this message translates to:
  /// **'Leave this circle'**
  String get leaveThisCircle;

  /// No description provided for @deleteJourneyQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this journey?'**
  String get deleteJourneyQuestion;

  /// No description provided for @deleteJourneyBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the journey from {date} from your history. This can’t be undone.'**
  String deleteJourneyBody(String date);

  /// No description provided for @deleteJourneyBodyNoDate.
  ///
  /// In en, this message translates to:
  /// **'This removes this journey from your history. This can’t be undone.'**
  String get deleteJourneyBodyNoDate;

  /// No description provided for @deleteJourney.
  ///
  /// In en, this message translates to:
  /// **'Delete journey'**
  String get deleteJourney;

  /// No description provided for @couldNotDeleteJourney.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the journey. Try again.'**
  String get couldNotDeleteJourney;

  /// No description provided for @deleteAllJourneysQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete all journeys?'**
  String get deleteAllJourneysQuestion;

  /// No description provided for @deleteAllJourneysBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This removes 1 journey from your history. This can’t be undone.} other{This removes all {count} journeys from your history. This can’t be undone.}}'**
  String deleteAllJourneysBody(int count);

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAll;

  /// No description provided for @journeysDeleted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Deleted 1 journey.} other{Deleted {count} journeys.}}'**
  String journeysDeleted(int count);

  /// No description provided for @couldNotDeleteJourneys.
  ///
  /// In en, this message translates to:
  /// **'Could not delete your journeys. Try again.'**
  String get couldNotDeleteJourneys;

  /// No description provided for @journeyHistory.
  ///
  /// In en, this message translates to:
  /// **'Journey history'**
  String get journeyHistory;

  /// No description provided for @planNewJourney.
  ///
  /// In en, this message translates to:
  /// **'Plan new journey'**
  String get planNewJourney;

  /// No description provided for @noPastJourneys.
  ///
  /// In en, this message translates to:
  /// **'No past journeys yet'**
  String get noPastJourneys;

  /// No description provided for @noPastJourneysHint.
  ///
  /// In en, this message translates to:
  /// **'Your completed journeys will show up here once you finish one.'**
  String get noPastJourneysHint;

  /// No description provided for @journey.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
  String get journey;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @checkInOverdue.
  ///
  /// In en, this message translates to:
  /// **'Check-in overdue'**
  String get checkInOverdue;

  /// No description provided for @checkInDueNow.
  ///
  /// In en, this message translates to:
  /// **'Check-in due now'**
  String get checkInDueNow;

  /// No description provided for @journeyActive.
  ///
  /// In en, this message translates to:
  /// **'Journey active'**
  String get journeyActive;

  /// No description provided for @journeyActiveAt.
  ///
  /// In en, this message translates to:
  /// **'Journey active · {place}'**
  String journeyActiveAt(String place);

  /// No description provided for @circleColon.
  ///
  /// In en, this message translates to:
  /// **'Circle:'**
  String get circleColon;

  /// No description provided for @checkIns.
  ///
  /// In en, this message translates to:
  /// **'Check-ins'**
  String get checkIns;

  /// No description provided for @endJourney.
  ///
  /// In en, this message translates to:
  /// **'End journey'**
  String get endJourney;

  /// No description provided for @getMeOut.
  ///
  /// In en, this message translates to:
  /// **'Get me out of here'**
  String get getMeOut;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @dueNow.
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get dueNow;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @missedCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'You missed a check-in'**
  String get missedCheckInTitle;

  /// No description provided for @checkInDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in due — are you safe?'**
  String get checkInDueTitle;

  /// No description provided for @missedCheckInBody.
  ///
  /// In en, this message translates to:
  /// **'{label} · {time}. Your circle has been alerted — confirm now to let them know you\'re okay.'**
  String missedCheckInBody(String label, String time);

  /// No description provided for @confirmWithinBody.
  ///
  /// In en, this message translates to:
  /// **'Confirm within {minutes} min or your circle will be alerted.'**
  String confirmWithinBody(int minutes);

  /// No description provided for @pickOneAlert.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one alert.'**
  String get pickOneAlert;

  /// No description provided for @waitingForLocation.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a location — try again in a moment.'**
  String get waitingForLocation;

  /// No description provided for @newPlace.
  ///
  /// In en, this message translates to:
  /// **'New place'**
  String get newPlace;

  /// No description provided for @placeAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added · circle will be alerted'**
  String placeAdded(String name);

  /// No description provided for @couldNotSavePlace.
  ///
  /// In en, this message translates to:
  /// **'Could not save the place. Try again.'**
  String get couldNotSavePlace;

  /// No description provided for @deleteNamedQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteNamedQuestion(String name);

  /// No description provided for @deletePlaceBody.
  ///
  /// In en, this message translates to:
  /// **'Your circle will no longer be alerted about arrivals and departures here.'**
  String get deletePlaceBody;

  /// No description provided for @deletePlace.
  ///
  /// In en, this message translates to:
  /// **'Delete place'**
  String get deletePlace;

  /// No description provided for @editPlace.
  ///
  /// In en, this message translates to:
  /// **'Edit place'**
  String get editPlace;

  /// No description provided for @placeNameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. Gym, Grandma\'s house'**
  String get placeNameExample;

  /// No description provided for @gettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting your location…'**
  String get gettingLocation;

  /// No description provided for @noLocationYet.
  ///
  /// In en, this message translates to:
  /// **'No location yet'**
  String get noLocationYet;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get useCurrentLocation;

  /// No description provided for @alertRadius.
  ///
  /// In en, this message translates to:
  /// **'ALERT RADIUS'**
  String get alertRadius;

  /// No description provided for @arrives.
  ///
  /// In en, this message translates to:
  /// **'Arrives'**
  String get arrives;

  /// No description provided for @leaves.
  ///
  /// In en, this message translates to:
  /// **'Leaves'**
  String get leaves;

  /// No description provided for @savePlace.
  ///
  /// In en, this message translates to:
  /// **'Save Place'**
  String get savePlace;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Locating…'**
  String get locating;

  /// No description provided for @tripHistoryToday.
  ///
  /// In en, this message translates to:
  /// **'Trip history · {today}'**
  String tripHistoryToday(String today);

  /// No description provided for @pauseSharing.
  ///
  /// In en, this message translates to:
  /// **'Pause sharing'**
  String get pauseSharing;

  /// No description provided for @resumeSharing.
  ///
  /// In en, this message translates to:
  /// **'Resume sharing'**
  String get resumeSharing;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @sharingAgain.
  ///
  /// In en, this message translates to:
  /// **'Sharing your live location again.'**
  String get sharingAgain;

  /// No description provided for @locationOffOnPhone.
  ///
  /// In en, this message translates to:
  /// **'Location is off on this phone — turn it on in Settings.'**
  String get locationOffOnPhone;

  /// No description provided for @pauseSharingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Pause location sharing?'**
  String get pauseSharingQuestion;

  /// No description provided for @pauseSharingBody.
  ///
  /// In en, this message translates to:
  /// **'Your circle won\'t see where you are until you resume. Journeys, check-ins and SOS keep working.'**
  String get pauseSharingBody;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @sharingPaused.
  ///
  /// In en, this message translates to:
  /// **'Location sharing paused.'**
  String get sharingPaused;

  /// No description provided for @charging.
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get charging;

  /// No description provided for @lowBattery.
  ///
  /// In en, this message translates to:
  /// **'Low battery'**
  String get lowBattery;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// No description provided for @alertResolvedReturning.
  ///
  /// In en, this message translates to:
  /// **'Alert resolved — returning home…'**
  String get alertResolvedReturning;

  /// No description provided for @markedResolved.
  ///
  /// In en, this message translates to:
  /// **'Marked as resolved'**
  String get markedResolved;

  /// No description provided for @youConfirmedSafe.
  ///
  /// In en, this message translates to:
  /// **'You confirmed {name} is safe · just now'**
  String youConfirmedSafe(String name);

  /// No description provided for @liveLocation.
  ///
  /// In en, this message translates to:
  /// **'Live location'**
  String get liveLocation;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get updating;

  /// No description provided for @atTimeOfAlert.
  ///
  /// In en, this message translates to:
  /// **'At the time of the alert'**
  String get atTimeOfAlert;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable'**
  String get locationUnavailable;

  /// No description provided for @pinnedOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pinned on the map'**
  String get pinnedOnMap;

  /// No description provided for @noPositionShared.
  ///
  /// In en, this message translates to:
  /// **'No position shared'**
  String get noPositionShared;

  /// No description provided for @lastRecordedCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Last recorded check-in'**
  String get lastRecordedCheckIn;

  /// No description provided for @callName.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String callName(String name);

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// No description provided for @reopenAlert.
  ///
  /// In en, this message translates to:
  /// **'Reopen alert'**
  String get reopenAlert;

  /// No description provided for @markAsResolved.
  ///
  /// In en, this message translates to:
  /// **'Mark as resolved'**
  String get markAsResolved;

  /// No description provided for @tripHistoryEyebrow.
  ///
  /// In en, this message translates to:
  /// **'TRIP HISTORY'**
  String get tripHistoryEyebrow;

  /// No description provided for @yourTrips.
  ///
  /// In en, this message translates to:
  /// **'Your trips'**
  String get yourTrips;

  /// No description provided for @namesTrips.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s trips'**
  String namesTrips(String name);

  /// No description provided for @noTripsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'No trips this week'**
  String get noTripsThisWeek;

  /// No description provided for @weekSummary.
  ///
  /// In en, this message translates to:
  /// **'{miles} mi · Top speed {speed}'**
  String weekSummary(String miles, String speed);

  /// No description provided for @allTripsCount.
  ///
  /// In en, this message translates to:
  /// **'All trips {count}'**
  String allTripsCount(int count);

  /// No description provided for @overSpeedCount.
  ///
  /// In en, this message translates to:
  /// **'Over {speed} {count}'**
  String overSpeedCount(String speed, int count);

  /// No description provided for @tripsRecordedYou.
  ///
  /// In en, this message translates to:
  /// **'Trips are recorded automatically whenever you leave a {meters} m radius and end after {minutes} minutes stopped.'**
  String tripsRecordedYou(int meters, int minutes);

  /// No description provided for @tripsRecordedName.
  ///
  /// In en, this message translates to:
  /// **'Trips are recorded automatically whenever {name} leaves a {meters} m radius and end after {minutes} minutes stopped.'**
  String tripsRecordedName(String name, int meters, int minutes);

  /// No description provided for @noTripsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No trips recorded this week.'**
  String get noTripsRecorded;

  /// No description provided for @noTripsMatch.
  ///
  /// In en, this message translates to:
  /// **'No trips match this filter.'**
  String get noTripsMatch;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get lastWeek;

  /// No description provided for @sinceDay.
  ///
  /// In en, this message translates to:
  /// **'Since {day}'**
  String sinceDay(String day);

  /// No description provided for @tripsPerWeek.
  ///
  /// In en, this message translates to:
  /// **'TRIPS PER WEEK'**
  String get tripsPerWeek;

  /// No description provided for @thisWeekShort.
  ///
  /// In en, this message translates to:
  /// **'This\nweek'**
  String get thisWeekShort;

  /// No description provided for @lastWeekShort.
  ///
  /// In en, this message translates to:
  /// **'Last\nweek'**
  String get lastWeekShort;

  /// No description provided for @termsServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'1. The service'**
  String get termsServiceTitle;

  /// No description provided for @termsServiceBody.
  ///
  /// In en, this message translates to:
  /// **'SafeCircle helps you share planned journeys and check-ins with people you trust. It complements — never replaces — emergency services.'**
  String get termsServiceBody;

  /// No description provided for @termsResponsibilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Your responsibilities'**
  String get termsResponsibilitiesTitle;

  /// No description provided for @termsResponsibilitiesBody.
  ///
  /// In en, this message translates to:
  /// **'Keep your account, safety PIN and panic PIN private, and only add emergency contacts who have agreed to receive alerts on your behalf.'**
  String get termsResponsibilitiesBody;

  /// No description provided for @termsAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Alerts'**
  String get termsAlertsTitle;

  /// No description provided for @termsAlertsBody.
  ///
  /// In en, this message translates to:
  /// **'Alerts depend on your device connectivity and location permissions. In a life-threatening situation, always contact local emergency services first.'**
  String get termsAlertsBody;

  /// No description provided for @privacyCollectTitle.
  ///
  /// In en, this message translates to:
  /// **'What we collect'**
  String get privacyCollectTitle;

  /// No description provided for @privacyCollectBody.
  ///
  /// In en, this message translates to:
  /// **'Your profile details, journey plans, check-in confirmations and — only while a journey is active — your location.'**
  String get privacyCollectBody;

  /// No description provided for @privacyWhoTitle.
  ///
  /// In en, this message translates to:
  /// **'Who can see it'**
  String get privacyWhoTitle;

  /// No description provided for @privacyWhoBody.
  ///
  /// In en, this message translates to:
  /// **'Only the circles and emergency contacts you choose. Your location is never sold or shared with advertisers.'**
  String get privacyWhoBody;

  /// No description provided for @privacyControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Your control'**
  String get privacyControlTitle;

  /// No description provided for @privacyControlBody.
  ///
  /// In en, this message translates to:
  /// **'You can end sharing at any time, and deleting your account permanently erases your circles and journey history.'**
  String get privacyControlBody;

  /// No description provided for @lastUpdatedJune2026.
  ///
  /// In en, this message translates to:
  /// **'Last updated · June 2026'**
  String get lastUpdatedJune2026;

  /// No description provided for @allCheckInsConfirmed.
  ///
  /// In en, this message translates to:
  /// **'All check-ins confirmed — end the journey when you arrive'**
  String get allCheckInsConfirmed;

  /// No description provided for @labelCheckInOverdue.
  ///
  /// In en, this message translates to:
  /// **'{label} check-in overdue — your circle has been alerted'**
  String labelCheckInOverdue(String label);

  /// No description provided for @labelCheckInDueNow.
  ///
  /// In en, this message translates to:
  /// **'{label} check-in due now — confirm you\'re safe'**
  String labelCheckInDueNow(String label);

  /// No description provided for @nextCheckInLabel.
  ///
  /// In en, this message translates to:
  /// **'Next check-in: {label} · {time}'**
  String nextCheckInLabel(String label, String time);

  /// No description provided for @yourJourneyWith.
  ///
  /// In en, this message translates to:
  /// **'Your journey · {circle}'**
  String yourJourneyWith(String circle);

  /// No description provided for @noActiveFriendJourneys.
  ///
  /// In en, this message translates to:
  /// **'There are no active journeys from your friends at this time'**
  String get noActiveFriendJourneys;

  /// No description provided for @nextCheckInPrefix.
  ///
  /// In en, this message translates to:
  /// **'Next check-in: '**
  String get nextCheckInPrefix;

  /// No description provided for @panicAlert.
  ///
  /// In en, this message translates to:
  /// **'Panic alert'**
  String get panicAlert;

  /// No description provided for @checkInDuePrefix.
  ///
  /// In en, this message translates to:
  /// **'Check-in due: '**
  String get checkInDuePrefix;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'· waiting'**
  String get waiting;

  /// No description provided for @journeyWith.
  ///
  /// In en, this message translates to:
  /// **'Journey with {circle}'**
  String journeyWith(String circle);

  /// No description provided for @silentAlert.
  ///
  /// In en, this message translates to:
  /// **'Silent alert'**
  String get silentAlert;

  /// No description provided for @onTime.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get onTime;

  /// No description provided for @usedPanicPin.
  ///
  /// In en, this message translates to:
  /// **'{name} used the panic PIN — they may be in danger. Call them or {emergency}.'**
  String usedPanicPin(String name, String emergency);

  /// No description provided for @missedCheckInAt.
  ///
  /// In en, this message translates to:
  /// **'Missed check-in at {time}. Reach out to {name}.'**
  String missedCheckInAt(String time, String name);

  /// No description provided for @aCheckInWasMissed.
  ///
  /// In en, this message translates to:
  /// **'A check-in was missed. Reach out to {name}.'**
  String aCheckInWasMissed(String name);

  /// No description provided for @missed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// No description provided for @alertSent.
  ///
  /// In en, this message translates to:
  /// **'Alert sent'**
  String get alertSent;

  /// No description provided for @sentJustNow.
  ///
  /// In en, this message translates to:
  /// **'{time} · just now'**
  String sentJustNow(String time);

  /// No description provided for @locationShared.
  ///
  /// In en, this message translates to:
  /// **'Location shared'**
  String get locationShared;

  /// No description provided for @enableLocationToShare.
  ///
  /// In en, this message translates to:
  /// **'Enable location to share where you are'**
  String get enableLocationToShare;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @alertedInApp.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Alerted in the app · 1 person} other{Alerted in the app · {count} people}}'**
  String alertedInApp(int count);

  /// No description provided for @noOneToAlert.
  ///
  /// In en, this message translates to:
  /// **'No one on SafeCircle to alert yet'**
  String get noOneToAlert;

  /// No description provided for @textMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Text my location to contacts'**
  String get textMyLocation;

  /// No description provided for @emergencySmsNoLocation.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY — I need help. Sent from SafeCircle.'**
  String get emergencySmsNoLocation;

  /// No description provided for @emergencySmsWithLocation.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY — I need help. My location: {link} ({place})'**
  String emergencySmsWithLocation(String link, String place);

  /// No description provided for @alsoCall.
  ///
  /// In en, this message translates to:
  /// **'Also call {number}'**
  String alsoCall(String number);

  /// No description provided for @cancelAlertSafe.
  ///
  /// In en, this message translates to:
  /// **'Cancel alert — I\'m safe'**
  String get cancelAlertSafe;

  /// No description provided for @callOrTextToCheck.
  ///
  /// In en, this message translates to:
  /// **'Call or text to make sure'**
  String get callOrTextToCheck;

  /// No description provided for @newJourney.
  ///
  /// In en, this message translates to:
  /// **'New journey'**
  String get newJourney;

  /// No description provided for @newJourneyHint.
  ///
  /// In en, this message translates to:
  /// **'Schedule when you\'ll check in. If you miss one, your circle is alerted.'**
  String get newJourneyHint;

  /// No description provided for @selectTiming.
  ///
  /// In en, this message translates to:
  /// **'Select the timing'**
  String get selectTiming;

  /// No description provided for @otherInformation.
  ///
  /// In en, this message translates to:
  /// **'Other information'**
  String get otherInformation;

  /// No description provided for @journeyNoteExample.
  ///
  /// In en, this message translates to:
  /// **'Meeting at the bar'**
  String get journeyNoteExample;

  /// No description provided for @addCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Add check-in'**
  String get addCheckIn;

  /// No description provided for @startJourney.
  ///
  /// In en, this message translates to:
  /// **'Start the journey'**
  String get startJourney;

  /// No description provided for @pickTimeOneMinute.
  ///
  /// In en, this message translates to:
  /// **'Pick a time at least 1 minute from now.'**
  String get pickTimeOneMinute;

  /// No description provided for @textInvitationsSent.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Text invitation sent to 1 person.} other{Text invitation sent to {count} people.}}'**
  String textInvitationsSent(int count);

  /// No description provided for @noAccountYetFor.
  ///
  /// In en, this message translates to:
  /// **'No SafeCircle account yet for: {emails}'**
  String noAccountYetFor(String emails);

  /// No description provided for @couldNotSaveCircle.
  ///
  /// In en, this message translates to:
  /// **'Could not save the circle. Try again.'**
  String get couldNotSaveCircle;

  /// No description provided for @addParticipants.
  ///
  /// In en, this message translates to:
  /// **'Add participants'**
  String get addParticipants;

  /// No description provided for @addingTo.
  ///
  /// In en, this message translates to:
  /// **'Adding to '**
  String get addingTo;

  /// No description provided for @addingToHint.
  ///
  /// In en, this message translates to:
  /// **'. Participants join with the email of their SafeCircle account — that\'s how they follow your journeys.'**
  String get addingToHint;

  /// No description provided for @saveParticipant.
  ///
  /// In en, this message translates to:
  /// **'Save participant'**
  String get saveParticipant;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @participantsCount.
  ///
  /// In en, this message translates to:
  /// **'PARTICIPANTS · {count}'**
  String participantsCount(int count);

  /// No description provided for @noParticipantsYet.
  ///
  /// In en, this message translates to:
  /// **'No participants yet'**
  String get noParticipantsYet;

  /// No description provided for @saveCircle.
  ///
  /// In en, this message translates to:
  /// **'Save circle'**
  String get saveCircle;

  /// No description provided for @createCircle.
  ///
  /// In en, this message translates to:
  /// **'Create circle'**
  String get createCircle;

  /// No description provided for @resendAlreadyJoined.
  ///
  /// In en, this message translates to:
  /// **'{name} already joined this circle.'**
  String resendAlreadyJoined(String name);

  /// No description provided for @resendTexted.
  ///
  /// In en, this message translates to:
  /// **'Invitation texted to {name} again.'**
  String resendTexted(String name);

  /// No description provided for @resendTooSoon.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{You just texted {name}. Try again in 1 minute.} other{You just texted {name}. Try again in {minutes} minutes.}}'**
  String resendTooSoon(String name, int minutes);

  /// No description provided for @resendLimited.
  ///
  /// In en, this message translates to:
  /// **'Daily text limit reached. Try again tomorrow.'**
  String get resendLimited;

  /// No description provided for @resendFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not text {name}.'**
  String resendFailed(String name);

  /// No description provided for @resendFailedInAppWaiting.
  ///
  /// In en, this message translates to:
  /// **'Could not text {name}. The in-app invitation is still waiting for them.'**
  String resendFailedInAppWaiting(String name);

  /// No description provided for @resendInApp.
  ///
  /// In en, this message translates to:
  /// **'In-app invitation sent to {name} again.'**
  String resendInApp(String name);

  /// No description provided for @resendNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No SafeCircle account yet for {name}. Add a phone number to text them.'**
  String resendNoAccount(String name);

  /// No description provided for @circleNotifiedNextAt.
  ///
  /// In en, this message translates to:
  /// **'Your circle has been notified. Next check-in at {time}.'**
  String circleNotifiedNextAt(String time);

  /// No description provided for @allCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'You\'re all checked in for this journey. Have a safe trip.'**
  String get allCheckedIn;

  /// No description provided for @checkInConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Check-in confirmed!'**
  String get checkInConfirmed;

  /// No description provided for @backToJourney.
  ///
  /// In en, this message translates to:
  /// **'Back to journey'**
  String get backToJourney;

  /// No description provided for @journeyFinished.
  ///
  /// In en, this message translates to:
  /// **'Journey finished'**
  String get journeyFinished;

  /// No description provided for @journeyFinishedHint.
  ///
  /// In en, this message translates to:
  /// **'You\'re safe and your circle has been notified that you\'ve arrived.'**
  String get journeyFinishedHint;

  /// No description provided for @backHome.
  ///
  /// In en, this message translates to:
  /// **'Back home'**
  String get backHome;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency contacts'**
  String get emergencyContacts;

  /// No description provided for @emergencyContactsHint.
  ///
  /// In en, this message translates to:
  /// **'On any alert they get a text with your location, and a notification in the app if they use SafeCircle.'**
  String get emergencyContactsHint;

  /// No description provided for @addTwoContacts.
  ///
  /// In en, this message translates to:
  /// **'Add at least 2 emergency contacts to start a journey.'**
  String get addTwoContacts;

  /// No description provided for @alwaysAlerted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Always alerted · 1 contact} other{Always alerted · {count} contacts}}'**
  String alwaysAlerted(int count);

  /// No description provided for @removeContactBody.
  ///
  /// In en, this message translates to:
  /// **'They will no longer be alerted when you send an SOS.'**
  String get removeContactBody;

  /// No description provided for @removeContact.
  ///
  /// In en, this message translates to:
  /// **'Remove contact'**
  String get removeContact;

  /// No description provided for @addEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Add emergency contact'**
  String get addEmergencyContact;

  /// No description provided for @noPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'No phone number available.'**
  String get noPhoneNumber;

  /// No description provided for @couldNotOpenDialer.
  ///
  /// In en, this message translates to:
  /// **'Could not open the dialer.'**
  String get couldNotOpenDialer;

  /// No description provided for @couldNotOpenMessages.
  ///
  /// In en, this message translates to:
  /// **'Could not open messages.'**
  String get couldNotOpenMessages;

  /// No description provided for @noPhoneNumbers.
  ///
  /// In en, this message translates to:
  /// **'No phone numbers available.'**
  String get noPhoneNumbers;

  /// No description provided for @noLocationYetShort.
  ///
  /// In en, this message translates to:
  /// **'No location available yet.'**
  String get noLocationYetShort;

  /// No description provided for @couldNotOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Could not open the maps app.'**
  String get couldNotOpenMaps;

  /// No description provided for @replayOf.
  ///
  /// In en, this message translates to:
  /// **'{day} · Replay'**
  String replayOf(String day);

  /// No description provided for @tripSummaryTop.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end} · {distance} · top {speed}'**
  String tripSummaryTop(
      String start, String end, String distance, String speed);

  /// No description provided for @metricTime.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get metricTime;

  /// No description provided for @metricSpeed.
  ///
  /// In en, this message translates to:
  /// **'SPEED'**
  String get metricSpeed;

  /// No description provided for @metricDistance.
  ///
  /// In en, this message translates to:
  /// **'DISTANCE'**
  String get metricDistance;

  /// No description provided for @unitMph.
  ///
  /// In en, this message translates to:
  /// **' mph'**
  String get unitMph;

  /// No description provided for @unitMi.
  ///
  /// In en, this message translates to:
  /// **' mi'**
  String get unitMi;

  /// No description provided for @leftPlace.
  ///
  /// In en, this message translates to:
  /// **'Left {place}'**
  String leftPlace(String place);

  /// No description provided for @theStart.
  ///
  /// In en, this message translates to:
  /// **'the start'**
  String get theStart;

  /// No description provided for @speedingOver.
  ///
  /// In en, this message translates to:
  /// **'Speeding · over {speed}'**
  String speedingOver(String speed);

  /// No description provided for @arrivedAt.
  ///
  /// In en, this message translates to:
  /// **'Arrived at {place}'**
  String arrivedAt(String place);

  /// No description provided for @theEnd.
  ///
  /// In en, this message translates to:
  /// **'the end'**
  String get theEnd;

  /// No description provided for @editProfileSub.
  ///
  /// In en, this message translates to:
  /// **'Name, photo & personal info'**
  String get editProfileSub;

  /// No description provided for @myEmergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'My emergency contacts'**
  String get myEmergencyContacts;

  /// No description provided for @peopleWillBeAlerted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person will be alerted} other{{count} people will be alerted}}'**
  String peopleWillBeAlerted(int count);

  /// No description provided for @myCircles.
  ///
  /// In en, this message translates to:
  /// **'My circles'**
  String get myCircles;

  /// No description provided for @completedJourneys.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 completed journey} other{{count} completed journeys}}'**
  String completedJourneys(int count);

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @couldNotUpdatePhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not update the photo.'**
  String get couldNotUpdatePhoto;

  /// No description provided for @waitingFirstUpdate.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the first update'**
  String get waitingFirstUpdate;

  /// No description provided for @liveUpdatedJustNow.
  ///
  /// In en, this message translates to:
  /// **'Live · updated just now'**
  String get liveUpdatedJustNow;

  /// No description provided for @updatedMinAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {minutes} min ago'**
  String updatedMinAgo(int minutes);

  /// No description provided for @noRecentUpdate.
  ///
  /// In en, this message translates to:
  /// **'No recent update'**
  String get noRecentUpdate;

  /// No description provided for @moving.
  ///
  /// In en, this message translates to:
  /// **'Moving'**
  String get moving;

  /// No description provided for @movingAt.
  ///
  /// In en, this message translates to:
  /// **'Moving · {speed}'**
  String movingAt(String speed);

  /// No description provided for @stopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get stopped;

  /// No description provided for @atPlaceSince.
  ///
  /// In en, this message translates to:
  /// **'At place since {time}'**
  String atPlaceSince(String time);

  /// No description provided for @friendsNeedAttention.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 friend needs attention} other{{count} friends need attention}}'**
  String friendsNeedAttention(int count);

  /// No description provided for @namesCheckInDue.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s check-in is due'**
  String namesCheckInDue(String name);

  /// No description provided for @checkInsAreDue.
  ///
  /// In en, this message translates to:
  /// **'{count} check-ins are due'**
  String checkInsAreDue(int count);

  /// No description provided for @friendsOnJourney.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 friend on a journey} other{{count} friends on a journey}}'**
  String friendsOnJourney(int count);

  /// No description provided for @whosWatching.
  ///
  /// In en, this message translates to:
  /// **'Who\'s watching?'**
  String get whosWatching;

  /// No description provided for @pickCircleHint.
  ///
  /// In en, this message translates to:
  /// **'Pick the circle that monitors this journey.'**
  String get pickCircleHint;

  /// No description provided for @nobodyAcceptedYet.
  ///
  /// In en, this message translates to:
  /// **'Nobody in this circle has accepted the invite yet, so no one could see this journey. Wait for a member to accept before starting.'**
  String get nobodyAcceptedYet;

  /// No description provided for @addTwoContactsBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'Add 2 emergency contacts before starting'**
  String get addTwoContactsBeforeStart;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'SCHEDULE'**
  String get schedule;

  /// No description provided for @starting.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get starting;

  /// No description provided for @startJourneyButton.
  ///
  /// In en, this message translates to:
  /// **'Start journey'**
  String get startJourneyButton;

  /// No description provided for @needCircleFirst.
  ///
  /// In en, this message translates to:
  /// **'You need a circle first. Tap the Circles tab below to create one.'**
  String get needCircleFirst;

  /// No description provided for @peopleWatching.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person watching} other{{count} people watching}}'**
  String peopleWatching(int count);

  /// No description provided for @couldNotOpenContacts.
  ///
  /// In en, this message translates to:
  /// **'Could not open your contacts.'**
  String get couldNotOpenContacts;

  /// No description provided for @nameExampleContact.
  ///
  /// In en, this message translates to:
  /// **'e.g. Jessica Moore'**
  String get nameExampleContact;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @couldNotOpenPhotos.
  ///
  /// In en, this message translates to:
  /// **'Could not open the photo library.'**
  String get couldNotOpenPhotos;

  /// No description provided for @photoAdded.
  ///
  /// In en, this message translates to:
  /// **'Photo added'**
  String get photoAdded;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get addPhoto;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'E-mail (required)'**
  String get emailRequired;

  /// No description provided for @emailShouldMatch.
  ///
  /// In en, this message translates to:
  /// **'Email should match their account'**
  String get emailShouldMatch;

  /// No description provided for @importFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Import from contacts'**
  String get importFromContacts;

  /// No description provided for @circlesSummary.
  ///
  /// In en, this message translates to:
  /// **'{circles, plural, =1{1 circle} other{{circles} circles}} · {members, plural, =1{1 member} other{{members} members}}'**
  String circlesSummary(int circles, int members);

  /// No description provided for @currentPinWrong.
  ///
  /// In en, this message translates to:
  /// **'Current PIN is incorrect.'**
  String get currentPinWrong;

  /// No description provided for @currentPanicPinWrong.
  ///
  /// In en, this message translates to:
  /// **'Current panic PIN is incorrect.'**
  String get currentPanicPinWrong;

  /// No description provided for @newPinFourDigits.
  ///
  /// In en, this message translates to:
  /// **'The new PIN must have 4 digits.'**
  String get newPinFourDigits;

  /// No description provided for @mustDifferFromPanic.
  ///
  /// In en, this message translates to:
  /// **'It must differ from your panic PIN.'**
  String get mustDifferFromPanic;

  /// No description provided for @mustDifferFromSafety.
  ///
  /// In en, this message translates to:
  /// **'It must differ from your safety PIN.'**
  String get mustDifferFromSafety;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get enterValidEmail;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password.'**
  String get enterCurrentPassword;

  /// No description provided for @newPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'New password must have at least 6 characters.'**
  String get newPasswordTooShort;

  /// No description provided for @tripsToday.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 trip today} other{{count} trips today}}'**
  String tripsToday(int count);

  /// No description provided for @tripsTodayMiles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 trip · {miles} mi today} other{{count} trips · {miles} mi today}}'**
  String tripsTodayMiles(int count, String miles);

  /// No description provided for @alertsOff.
  ///
  /// In en, this message translates to:
  /// **'Alerts off'**
  String get alertsOff;

  /// No description provided for @alertArriveLeave.
  ///
  /// In en, this message translates to:
  /// **'Alert on arrive & leave'**
  String get alertArriveLeave;

  /// No description provided for @alertArrive.
  ///
  /// In en, this message translates to:
  /// **'Alert on arrive'**
  String get alertArrive;

  /// No description provided for @alertLeave.
  ///
  /// In en, this message translates to:
  /// **'Alert on leave'**
  String get alertLeave;

  /// No description provided for @tripStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get tripStart;

  /// No description provided for @tripEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get tripEnd;

  /// No description provided for @arrivedAtPlace.
  ///
  /// In en, this message translates to:
  /// **'{name} arrived at {place}'**
  String arrivedAtPlace(String name, String place);

  /// No description provided for @leftPlaceNamed.
  ///
  /// In en, this message translates to:
  /// **'{name} left {place}'**
  String leftPlaceNamed(String name, String place);

  /// No description provided for @hasLowBattery.
  ///
  /// In en, this message translates to:
  /// **'{name} has a low battery'**
  String hasLowBattery(String name);

  /// No description provided for @lowBatterySub.
  ///
  /// In en, this message translates to:
  /// **'{level} · Location may stop updating soon'**
  String lowBatterySub(String level);

  /// No description provided for @myCirclesTitle.
  ///
  /// In en, this message translates to:
  /// **'My circles'**
  String get myCirclesTitle;

  /// No description provided for @createNewCircle.
  ///
  /// In en, this message translates to:
  /// **'Create new circle'**
  String get createNewCircle;

  /// No description provided for @noCircleYet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any circle created'**
  String get noCircleYet;

  /// No description provided for @noCircleYetHint.
  ///
  /// In en, this message translates to:
  /// **'Create a circle to gather the people you trust and share your journeys with them.'**
  String get noCircleYetHint;

  /// No description provided for @newCircleInvite.
  ///
  /// In en, this message translates to:
  /// **'New circle invite'**
  String get newCircleInvite;

  /// No description provided for @newBadge.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newBadge;

  /// No description provided for @memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String memberCount(int count);

  /// No description provided for @emergencySos.
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS'**
  String get emergencySos;

  /// No description provided for @sosHint.
  ///
  /// In en, this message translates to:
  /// **'This alerts your circle in the app and texts your circle and emergency contacts your location.'**
  String get sosHint;

  /// No description provided for @sosNeedsContact.
  ///
  /// In en, this message translates to:
  /// **'Add at least one emergency contact before you can send an alert.'**
  String get sosNeedsContact;

  /// No description provided for @yourEmergencyContactsCount.
  ///
  /// In en, this message translates to:
  /// **'Your emergency contacts · {count}'**
  String yourEmergencyContactsCount(int count);

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @keepHolding.
  ///
  /// In en, this message translates to:
  /// **'Keep holding…'**
  String get keepHolding;

  /// No description provided for @holdToAlert.
  ///
  /// In en, this message translates to:
  /// **'Hold to alert'**
  String get holdToAlert;

  /// No description provided for @addContactBeforeAlert.
  ///
  /// In en, this message translates to:
  /// **'Add an emergency contact before sending an alert.'**
  String get addContactBeforeAlert;

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'SafeCircle alerts'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Check-in reminders and safety alerts'**
  String get notificationChannelDescription;

  /// No description provided for @reminderDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in due now'**
  String get reminderDueTitle;

  /// No description provided for @reminderDueBody.
  ///
  /// In en, this message translates to:
  /// **'{label} · {time} — open SafeCircle and confirm you\'re safe.'**
  String reminderDueBody(String label, String time);

  /// No description provided for @reminderLastCallTitle.
  ///
  /// In en, this message translates to:
  /// **'Last call: confirm your check-in'**
  String get reminderLastCallTitle;

  /// No description provided for @reminderLastCallBody.
  ///
  /// In en, this message translates to:
  /// **'{label} · {time} — your circle will be alerted in 1 minute.'**
  String reminderLastCallBody(String label, String time);

  /// No description provided for @testNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'SafeCircle notifications are working'**
  String get testNotificationTitle;

  /// No description provided for @testNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'You will be alerted like this for check-ins, overdue friends and emergencies.'**
  String get testNotificationBody;

  /// No description provided for @circleInvite.
  ///
  /// In en, this message translates to:
  /// **'Circle invite'**
  String get circleInvite;

  /// No description provided for @inviteNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'{summary} — open SafeCircle to accept.'**
  String inviteNotificationBody(String summary);

  /// No description provided for @speedAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Speed alert on your last trip'**
  String get speedAlertTitle;

  /// No description provided for @speedAlertBody.
  ///
  /// In en, this message translates to:
  /// **'{trip} · top {speed}'**
  String speedAlertBody(String trip, String speed);

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @checkInOverdueReachOut.
  ///
  /// In en, this message translates to:
  /// **'{label} is overdue — reach out.'**
  String checkInOverdueReachOut(String label);

  /// No description provided for @places.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get places;

  /// No description provided for @placesHint.
  ///
  /// In en, this message translates to:
  /// **'Your circle gets an alert when someone arrives at or leaves these places.'**
  String get placesHint;

  /// No description provided for @noPlacesYet.
  ///
  /// In en, this message translates to:
  /// **'No places yet. Add home, school or work and the circle is told when someone gets there.'**
  String get noPlacesYet;

  /// No description provided for @addPlace.
  ///
  /// In en, this message translates to:
  /// **'Add Place'**
  String get addPlace;

  /// No description provided for @savedLocation.
  ///
  /// In en, this message translates to:
  /// **'Saved location'**
  String get savedLocation;

  /// No description provided for @couldNotUpdatePlace.
  ///
  /// In en, this message translates to:
  /// **'Could not update the place.'**
  String get couldNotUpdatePlace;

  /// No description provided for @sharingPausedBanner.
  ///
  /// In en, this message translates to:
  /// **'Your location sharing is paused'**
  String get sharingPausedBanner;

  /// No description provided for @turnOnLocation.
  ///
  /// In en, this message translates to:
  /// **'Turn on your location'**
  String get turnOnLocation;

  /// No description provided for @sharingPausedBannerSub.
  ///
  /// In en, this message translates to:
  /// **'Your circle can\'t see where you are. Tap to resume.'**
  String get sharingPausedBannerSub;

  /// No description provided for @turnOnLocationSub.
  ///
  /// In en, this message translates to:
  /// **'Your circle can\'t see you yet. Tap to allow location.'**
  String get turnOnLocationSub;

  /// No description provided for @noOneSharing.
  ///
  /// In en, this message translates to:
  /// **'No one is sharing yet'**
  String get noOneSharing;

  /// No description provided for @noOneSharingHint.
  ///
  /// In en, this message translates to:
  /// **'Invite the people you trust to a circle. Everyone who joins and shares their location appears here.'**
  String get noOneSharingHint;

  /// No description provided for @goToCircles.
  ///
  /// In en, this message translates to:
  /// **'Go to circles'**
  String get goToCircles;

  /// No description provided for @firstCheckIn.
  ///
  /// In en, this message translates to:
  /// **'First check-in'**
  String get firstCheckIn;

  /// No description provided for @secondCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Second check-in'**
  String get secondCheckIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOut;

  /// No description provided for @numberedCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in {number}'**
  String numberedCheckIn(int number);

  /// No description provided for @couldNotJoinNoAccess.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t join: the app doesn\'t have access to this circle yet. Ask {name} to send the invite again.'**
  String couldNotJoinNoAccess(String name);

  /// No description provided for @couldNotAcceptInvite.
  ///
  /// In en, this message translates to:
  /// **'Could not accept the invite. Try again.'**
  String get couldNotAcceptInvite;

  /// No description provided for @circleInviteEyebrow.
  ///
  /// In en, this message translates to:
  /// **'CIRCLE INVITE'**
  String get circleInviteEyebrow;

  /// No description provided for @addedYouToCircle.
  ///
  /// In en, this message translates to:
  /// **'{name} added you to the circle {circle} on SafeCircle.'**
  String addedYouToCircle(String name, String circle);

  /// No description provided for @joinHint.
  ///
  /// In en, this message translates to:
  /// **'Join and {name} will be able to invite you to follow their journeys and get alerted if they\'re ever overdue. You can leave the circle at any time.'**
  String joinHint(String name);

  /// No description provided for @joining.
  ///
  /// In en, this message translates to:
  /// **'Joining…'**
  String get joining;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @confirmToEndJourney.
  ///
  /// In en, this message translates to:
  /// **'Confirm to end journey'**
  String get confirmToEndJourney;

  /// No description provided for @confirmYourCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Confirm your check-in'**
  String get confirmYourCheckIn;

  /// No description provided for @enterPinToEnd.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to end this journey safely.'**
  String get enterPinToEnd;

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. Try again.'**
  String get incorrectPin;

  /// No description provided for @friendsJourneys.
  ///
  /// In en, this message translates to:
  /// **'Friends\' Journeys'**
  String get friendsJourneys;

  /// No description provided for @noNewNotifications.
  ///
  /// In en, this message translates to:
  /// **'No new notifications.'**
  String get noNewNotifications;

  /// No description provided for @renameCircle.
  ///
  /// In en, this message translates to:
  /// **'Rename circle'**
  String get renameCircle;

  /// No description provided for @nameYourCircle.
  ///
  /// In en, this message translates to:
  /// **'Name your circle'**
  String get nameYourCircle;

  /// No description provided for @circleNameHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a name — add an emoji to make it easy to spot.'**
  String get circleNameHint;

  /// No description provided for @circlesName.
  ///
  /// In en, this message translates to:
  /// **'Circle\'s name'**
  String get circlesName;

  /// No description provided for @circleNameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. 🏠 Family'**
  String get circleNameExample;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @locationSharingChannel.
  ///
  /// In en, this message translates to:
  /// **'Location sharing'**
  String get locationSharingChannel;

  /// No description provided for @locationSharingChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Shown while SafeCircle shares your location with your circle.'**
  String get locationSharingChannelDescription;

  /// No description provided for @sharingNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'SafeCircle is sharing your location'**
  String get sharingNotificationTitle;

  /// No description provided for @sharingNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Your circle can see where you are.'**
  String get sharingNotificationBody;

  /// No description provided for @checkInInPast.
  ///
  /// In en, this message translates to:
  /// **'\"{label}\" is already in the past — adjust its time.'**
  String checkInInPast(String label);

  /// No description provided for @journeyStartsWithoutLocation.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable — journey starts without a map position.'**
  String get journeyStartsWithoutLocation;

  /// No description provided for @couldNotStartJourney.
  ///
  /// In en, this message translates to:
  /// **'Could not start the journey. Try again.'**
  String get couldNotStartJourney;

  /// No description provided for @createYourFirstCircle.
  ///
  /// In en, this message translates to:
  /// **'Create your first circle'**
  String get createYourFirstCircle;

  /// No description provided for @nothingNewYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing new yet.'**
  String get nothingNewYet;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @checkConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get checkConnection;

  /// No description provided for @couldNotLoadThis.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this'**
  String get couldNotLoadThis;

  /// No description provided for @couldNotLoadAccount.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your account'**
  String get couldNotLoadAccount;

  /// No description provided for @checkInternet.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get checkInternet;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @createACircle.
  ///
  /// In en, this message translates to:
  /// **'Create a circle'**
  String get createACircle;

  /// No description provided for @journeysList.
  ///
  /// In en, this message translates to:
  /// **'Journeys list'**
  String get journeysList;

  /// No description provided for @couldNotSaveContact.
  ///
  /// In en, this message translates to:
  /// **'Could not save the contact. Try again.'**
  String get couldNotSaveContact;

  /// No description provided for @editContact.
  ///
  /// In en, this message translates to:
  /// **'Edit contact'**
  String get editContact;

  /// No description provided for @addContactHint.
  ///
  /// In en, this message translates to:
  /// **'They\'ll be alerted on every journey, always. We\'ll text them once to let them know you added them.'**
  String get addContactHint;

  /// No description provided for @sharingWithCircles.
  ///
  /// In en, this message translates to:
  /// **'Sharing your live location with your circles.'**
  String get sharingWithCircles;

  /// No description provided for @locationOffEnable.
  ///
  /// In en, this message translates to:
  /// **'Location is off — enable it to share your position.'**
  String get locationOffEnable;

  /// No description provided for @positionNotShared.
  ///
  /// In en, this message translates to:
  /// **'Your position is not being shared yet.'**
  String get positionNotShared;

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

  /// No description provided for @tabJourneys.
  ///
  /// In en, this message translates to:
  /// **'Journeys'**
  String get tabJourneys;

  /// No description provided for @tabEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get tabEmergency;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @planAJourney.
  ///
  /// In en, this message translates to:
  /// **'Plan a journey'**
  String get planAJourney;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @addYourFirstCircle.
  ///
  /// In en, this message translates to:
  /// **'Add your first circle'**
  String get addYourFirstCircle;

  /// No description provided for @resendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Resend invitation'**
  String get resendInvitation;

  /// No description provided for @locationNotSharedYet.
  ///
  /// In en, this message translates to:
  /// **'Location not shared yet'**
  String get locationNotSharedYet;

  /// No description provided for @couldNotSendAlert.
  ///
  /// In en, this message translates to:
  /// **'Could not send the alert. Check your connection and try again.'**
  String get couldNotSendAlert;

  /// No description provided for @journeys.
  ///
  /// In en, this message translates to:
  /// **'Journeys'**
  String get journeys;

  /// No description provided for @overSpeed.
  ///
  /// In en, this message translates to:
  /// **'Over {speed}'**
  String overSpeed(String speed);

  /// No description provided for @withinLimit.
  ///
  /// In en, this message translates to:
  /// **'Within limit'**
  String get withinLimit;

  /// No description provided for @friendsNeedAttentionActive.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 friend needs attention} other{{count} friends need attention}} · {active} active'**
  String friendsNeedAttentionActive(int count, int active);

  /// No description provided for @friendsOnJourneyNow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 friend currently on a journey} other{{count} friends currently on a journey}}'**
  String friendsOnJourneyNow(int count);

  /// No description provided for @countryUS.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get countryUS;

  /// No description provided for @countryBR.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get countryBR;

  /// No description provided for @countryPT.
  ///
  /// In en, this message translates to:
  /// **'Portugal'**
  String get countryPT;

  /// No description provided for @countryGB.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryGB;

  /// No description provided for @countryES.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get countryES;

  /// No description provided for @countryAR.
  ///
  /// In en, this message translates to:
  /// **'Argentina'**
  String get countryAR;

  /// No description provided for @countryFR.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryFR;

  /// No description provided for @countryMX.
  ///
  /// In en, this message translates to:
  /// **'Mexico'**
  String get countryMX;

  /// No description provided for @countryCN.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get countryCN;

  /// No description provided for @countryIN.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get countryIN;

  /// No description provided for @enterPinToPause.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to pause.'**
  String get enterPinToPause;

  /// No description provided for @smsConsentLabel.
  ///
  /// In en, this message translates to:
  /// **'They agreed to get SafeCircle texts at this number (invitations and safety alerts). Msg & data rates may apply. They can reply STOP to opt out.'**
  String get smsConsentLabel;

  /// No description provided for @profilePhoneSmsNote.
  ///
  /// In en, this message translates to:
  /// **'By adding your number, you agree to get SafeCircle texts about your circles\' safety alerts. Msg & data rates may apply. Reply STOP to opt out.'**
  String get profilePhoneSmsNote;

  /// No description provided for @privacySmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Text messages'**
  String get privacySmsTitle;

  /// No description provided for @privacySmsBody.
  ///
  /// In en, this message translates to:
  /// **'We text a number only after the person agreed to it, and only for circle invitations and safety alerts — never marketing. Mobile numbers and opt-in consent are never sold or shared with third parties or affiliates for marketing. Reply STOP to any text to opt out, or HELP for help.'**
  String get privacySmsBody;

  /// No description provided for @resendNoConsent.
  ///
  /// In en, this message translates to:
  /// **'{name} hasn\'t agreed to get texts yet. Once they agree, edit their details and tick the texting box.'**
  String resendNoConsent(String name);

  /// No description provided for @inviteShareMessage.
  ///
  /// In en, this message translates to:
  /// **'I added you to my SafeCircle circle \"{circle}\" so we can look out for each other. Get the app: {link} and sign up with {email} to join.'**
  String inviteShareMessage(String circle, String link, String email);

  /// No description provided for @inviteShareMessageNoEmail.
  ///
  /// In en, this message translates to:
  /// **'I added you to my SafeCircle circle \"{circle}\" so we can look out for each other. Get the app: {link} to join.'**
  String inviteShareMessageNoEmail(String circle, String link);

  /// No description provided for @inviteShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Join my SafeCircle circle'**
  String get inviteShareSubject;

  /// No description provided for @participantSavedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved to {circle}'**
  String participantSavedTo(String circle);

  /// No description provided for @participantRemovedFrom.
  ///
  /// In en, this message translates to:
  /// **'Removed from {circle}'**
  String participantRemovedFrom(String circle);

  /// No description provided for @notOnSafeCircleYet.
  ///
  /// In en, this message translates to:
  /// **'{name} isn\'t on SafeCircle yet'**
  String notOnSafeCircleYet(String name);

  /// No description provided for @inviteByTextBody.
  ///
  /// In en, this message translates to:
  /// **'Would you like to send them an invitation? A text message will open with the invitation ready to send.'**
  String get inviteByTextBody;

  /// No description provided for @inviteByShareBody.
  ///
  /// In en, this message translates to:
  /// **'Would you like to send them an invitation? You\'ll choose how to send it: Messages, WhatsApp, email…'**
  String get inviteByShareBody;

  /// No description provided for @sendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Send invitation'**
  String get sendInvitation;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @membershipTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your circle close'**
  String get membershipTitle;

  /// No description provided for @membershipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A SafeCircle membership unlocks everything that keeps you and your people connected.'**
  String get membershipSubtitle;

  /// No description provided for @membershipPerkMap.
  ///
  /// In en, this message translates to:
  /// **'Live location with your circles'**
  String get membershipPerkMap;

  /// No description provided for @membershipPerkJourneys.
  ///
  /// In en, this message translates to:
  /// **'Journeys with check-ins and overdue alerts'**
  String get membershipPerkJourneys;

  /// No description provided for @membershipPerkCircles.
  ///
  /// In en, this message translates to:
  /// **'Circles for family and friends'**
  String get membershipPerkCircles;

  /// No description provided for @membershipPerkAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts when someone in your circle needs help'**
  String get membershipPerkAlerts;

  /// No description provided for @membershipTrialPrice.
  ///
  /// In en, this message translates to:
  /// **'{days} days free, then {price}/month'**
  String membershipTrialPrice(int days, String price);

  /// No description provided for @membershipPrice.
  ///
  /// In en, this message translates to:
  /// **'{price}/month'**
  String membershipPrice(String price);

  /// No description provided for @membershipCancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime'**
  String get membershipCancelAnytime;

  /// No description provided for @membershipStartTrial.
  ///
  /// In en, this message translates to:
  /// **'Start free trial'**
  String get membershipStartTrial;

  /// No description provided for @membershipSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get membershipSubscribe;

  /// No description provided for @membershipWorking.
  ///
  /// In en, this message translates to:
  /// **'One moment…'**
  String get membershipWorking;

  /// No description provided for @membershipFinePrintTrial.
  ///
  /// In en, this message translates to:
  /// **'After the {days}-day free trial, payment is charged to your {store} account. The membership renews every month unless canceled at least 24 hours before the end of the current period. Manage or cancel it in your {store} account settings.'**
  String membershipFinePrintTrial(String store, int days);

  /// No description provided for @membershipFinePrint.
  ///
  /// In en, this message translates to:
  /// **'Payment is charged to your {store} account. The membership renews every month unless canceled at least 24 hours before the end of the current period. Manage or cancel it in your {store} account settings.'**
  String membershipFinePrint(String store);

  /// No description provided for @membershipStoreApple.
  ///
  /// In en, this message translates to:
  /// **'Apple ID'**
  String get membershipStoreApple;

  /// No description provided for @membershipStoreGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google Play'**
  String get membershipStoreGoogle;

  /// No description provided for @membershipUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The membership can\'t be loaded right now. Check your connection and try again.'**
  String get membershipUnavailable;

  /// No description provided for @membershipRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get membershipRestore;

  /// No description provided for @membershipSosFree.
  ///
  /// In en, this message translates to:
  /// **'SOS always works, even without a membership: your circle and emergency contacts are still alerted.'**
  String get membershipSosFree;

  /// No description provided for @membershipOpenSos.
  ///
  /// In en, this message translates to:
  /// **'Open SOS'**
  String get membershipOpenSos;

  /// No description provided for @membershipPauseSharing.
  ///
  /// In en, this message translates to:
  /// **'Pause location sharing'**
  String get membershipPauseSharing;

  /// No description provided for @membershipWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SafeCircle!'**
  String get membershipWelcome;

  /// No description provided for @membershipNothingToRestore.
  ///
  /// In en, this message translates to:
  /// **'No membership found for this account.'**
  String get membershipNothingToRestore;

  /// No description provided for @membershipPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'The purchase didn\'t go through. Please try again.'**
  String get membershipPurchaseFailed;

  /// No description provided for @membershipLabel.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membershipLabel;

  /// No description provided for @membershipActiveSub.
  ///
  /// In en, this message translates to:
  /// **'Active · manage or cancel'**
  String get membershipActiveSub;

  /// No description provided for @membershipInactiveSub.
  ///
  /// In en, this message translates to:
  /// **'Not active · start your free trial'**
  String get membershipInactiveSub;

  /// No description provided for @termsMembershipTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Membership'**
  String get termsMembershipTitle;

  /// No description provided for @termsMembershipBody.
  ///
  /// In en, this message translates to:
  /// **'Most of SafeCircle needs a monthly membership; SOS is always free. New members get a free trial. The membership renews automatically through the App Store or Google Play until you cancel it there, at least 24 hours before the end of the current period. Unused trial time ends when you subscribe.'**
  String get termsMembershipBody;

  /// Notification title when a friend's SOS or missed check-in is resolved.
  ///
  /// In en, this message translates to:
  /// **'{name} is OK'**
  String alertAllClearTitle(String name);

  /// No description provided for @placeAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get placeAddress;

  /// No description provided for @searchAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Type an address, then search'**
  String get searchAddressHint;

  /// No description provided for @addressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find that address'**
  String get addressNotFound;

  /// No description provided for @placeAlertsGoTo.
  ///
  /// In en, this message translates to:
  /// **'CIRCLE THAT GETS THE ALERTS'**
  String get placeAlertsGoTo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'es',
        'fr',
        'hi',
        'pt',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
