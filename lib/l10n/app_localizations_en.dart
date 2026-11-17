// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SafeCircle';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get alertKindPanic => 'Silent panic';

  @override
  String get alertKindOverdue => 'Missed check-in';

  @override
  String get alertKindSos => 'SOS';

  @override
  String alertHeadlineOverdue(String name) {
    return '$name missed a check-in';
  }

  @override
  String alertHeadlineHelp(String name) {
    return '$name needs help';
  }

  @override
  String get someone => 'Someone';

  @override
  String get aCircle => 'a circle';

  @override
  String inviteSummary(String name, String circle) {
    return '$name invited you to $circle';
  }

  @override
  String get circleOwner => 'Circle owner';

  @override
  String lastSeenAt(String time) {
    return 'Last seen $time';
  }

  @override
  String get enterYourName => 'Enter your name.';

  @override
  String get enterYourEmail => 'Enter your email.';

  @override
  String get passwordTooShort => 'Password must have at least 6 characters.';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match.';

  @override
  String get enterEmailAndPassword => 'Enter your email and password.';

  @override
  String get recoveryLinkSent => 'Recovery link sent. Check your inbox.';

  @override
  String get couldNotSavePins => 'Could not save your PINs. Try again.';

  @override
  String get welcomeTo => 'Welcome to';

  @override
  String get welcomeTagline =>
      'Build a trusted circle and let someone always know you\'re safe.';

  @override
  String get start => 'Start';

  @override
  String get skipIntro => 'Skip intro';

  @override
  String get createAccount => 'Create account';

  @override
  String get joinInSeconds => 'Join SafeCircle in a few seconds.';

  @override
  String get name => 'Name';

  @override
  String get nameExample => 'e.g. Alex Morgan';

  @override
  String get email => 'Email';

  @override
  String get emailExample => 'name@example.com';

  @override
  String get phone => 'Phone';

  @override
  String get password => 'Password';

  @override
  String get repeatPassword => 'Repeat password';

  @override
  String get creatingAccount => 'Creating account…';

  @override
  String get register => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get login => 'Login';

  @override
  String get loginTagline => 'Someone always knows you\'re safe.';

  @override
  String get forgotPassword => 'Forgot?';

  @override
  String get loggingIn => 'Logging in…';

  @override
  String get orLoginWith => 'Or, login with...';

  @override
  String get noAccountYet => 'Don\'t have an account? ';

  @override
  String get registerExclaim => 'Register!';

  @override
  String get socialLoginSoon => 'Social login coming soon.';

  @override
  String get recoverPassword => 'Recover password';

  @override
  String get recoverPasswordHint =>
      'Enter the email linked to your account and we\'ll send you a secure link to reset your password.';

  @override
  String get sending => 'Sending…';

  @override
  String stepOf(int step, int total) {
    return 'STEP $step OF $total';
  }

  @override
  String get setPanicPin => 'Set your panic PIN';

  @override
  String get setSafetyPin => 'Set your safety PIN';

  @override
  String get panicPinHint =>
      'If you\'re forced to open the app, enter this PIN. The screen looks normal, but your circle is silently alerted.';

  @override
  String get safetyPinHint =>
      'Use this PIN to confirm you\'re safe during check-ins.';

  @override
  String get panicPinMatchesSafety =>
      'That matches your safety PIN. Choose a different code.';

  @override
  String get panicPinMustDiffer => 'Must be different from your safety PIN.';

  @override
  String get saving => 'Saving…';

  @override
  String get finish => 'Finish';

  @override
  String get continueLabel => 'Continue';

  @override
  String get gettingStarted => 'GETTING STARTED';

  @override
  String get createFirstCircle => 'Create your first Circle';

  @override
  String get tapPrefix => 'Tap ';

  @override
  String get tabCircles => 'Circles';

  @override
  String get createFirstCircleHint =>
      ' in the bottom bar, give it a name, and add the people you trust. They\'ll get an invite to follow your journeys.';

  @override
  String get next => 'Next';

  @override
  String get allSet => 'You\'re all set!';

  @override
  String get allSetHint =>
      'Your SafeCircle is ready. Plan your first journey whenever you head out.';

  @override
  String get enterSafeCircle => 'Enter SafeCircle';

  @override
  String get authInvalidEmail => 'Invalid email address.';

  @override
  String get authEmailInUse => 'This email is already registered.';

  @override
  String get authWeakPassword => 'Password too weak (min. 6 characters).';

  @override
  String get authWrongCredentials => 'Wrong email or password.';

  @override
  String get authTooManyAttempts => 'Too many attempts. Try again later.';

  @override
  String get authNetwork => 'Network error. Check your connection.';

  @override
  String get authReloginNeeded => 'Please log in again to do this.';

  @override
  String get authGenericError => 'Authentication error.';

  @override
  String get somethingWentWrong => 'Something went wrong. Try again.';

  @override
  String get settings => 'Settings';

  @override
  String get security => 'Security';

  @override
  String get changeSafetyPin => 'Change safety PIN';

  @override
  String get changeSafetyPinSub => 'Confirms you\'re OK at check-in';

  @override
  String get changePanicPin => 'Change panic PIN';

  @override
  String get changePanicPinSub => 'Silent duress code · sends a hidden alert';

  @override
  String get notifications => 'Notifications';

  @override
  String get checkInReminders => 'Check-in reminders';

  @override
  String get checkInRemindersSub => 'Nudge me when a check-in is due';

  @override
  String get overdueCheckIns => 'Overdue check-ins';

  @override
  String get overdueCheckInsSub =>
      'When a friend misses a check-in. Panic and SOS alerts are always on.';

  @override
  String get permissions => 'Permissions';

  @override
  String get permissionsSub => 'Location, notifications, alarms and battery';

  @override
  String get permissionsReason =>
      'SafeCircle only uses these to protect you and your circle.';

  @override
  String get done => 'Done';

  @override
  String get sendTestNotification => 'Send a test notification';

  @override
  String get sendTestNotificationSub => 'Check that alerts reach this phone';

  @override
  String get testNotificationSent => 'Sent — check your notification shade.';

  @override
  String get testNotificationFailed =>
      'Could not send. Check notification permission in system settings.';

  @override
  String get account => 'Account';

  @override
  String get changeEmail => 'Change email';

  @override
  String get changePassword => 'Change password';

  @override
  String get logOut => 'Log out';

  @override
  String get logOutQuestion => 'Log out?';

  @override
  String get logOutBody =>
      'You\'ll stop receiving alerts from your circles until you log back in.';

  @override
  String get loggedOut => 'Logged out.';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountSub => 'Permanently erases your circle & history';

  @override
  String get deleteAccountQuestion => 'Delete account?';

  @override
  String get deleteAccountBody =>
      'This permanently erases your circles, contacts and journey history. This cannot be undone.';

  @override
  String get accountDeleted => 'Account deleted.';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get aboutFooter => 'SafeCircle · Made to keep your circle safe';

  @override
  String get cancel => 'Cancel';

  @override
  String get beforeYouStart => 'Before you start';

  @override
  String get journeyPermissionsReason =>
      'A journey needs these so your check-in reminders ring on time and your circle can see where you are.';

  @override
  String get shareLiveLocation => 'Share your live location';

  @override
  String get shareLiveLocationReason =>
      'Your circle sees where you are on the map.';

  @override
  String get notificationsOffWarning =>
      'You won\'t be notified about alerts — enable notifications in Settings.';

  @override
  String get almostThere => 'ALMOST THERE';

  @override
  String get allowPermissions => 'Allow permissions';

  @override
  String get allowPermissionsHint =>
      'SafeCircle only uses these to keep you and your circle safe. You\'re always in control — change them anytime in Settings.';

  @override
  String get locationDenied =>
      'Location denied — enable it in system settings.';

  @override
  String get notificationsDenied =>
      'Notifications denied — enable them in system settings.';

  @override
  String get turnOnAlarms =>
      'Turn on \"Alarms & reminders\" for SafeCircle, then come back.';

  @override
  String get contactsDenied =>
      'Contacts denied — enable it in system settings.';

  @override
  String get location => 'Location';

  @override
  String get locationPermissionSub =>
      'So your circle can see you\'ve arrived safely.';

  @override
  String get notificationsPermissionSub =>
      'So we can remind you when a check-in is due.';

  @override
  String get alarmsAndReminders => 'Alarms & reminders';

  @override
  String get alarmsPermissionSub =>
      'So check-in reminders ring exactly on time.';

  @override
  String get backgroundActivity => 'Background activity (recommended)';

  @override
  String get backgroundPermissionSub =>
      'So reminders still fire when your phone is idle.';

  @override
  String get contactsOptional => 'Contacts (optional)';

  @override
  String get contactsPermissionSub => 'To quickly invite the people you trust.';

  @override
  String get locationAndNotificationsRequired =>
      'Location and Notifications are required for SafeCircle to protect you.';

  @override
  String get locationRequired =>
      'Location is required for SafeCircle to protect you.';

  @override
  String get setUpLater => 'Set up later';

  @override
  String get openSystemSettings => 'Open system settings';

  @override
  String get allowed => 'Allowed';

  @override
  String get allow => 'Allow';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String verificationLinkSent(String email) {
    return 'Verification link sent to $email — confirm it to switch.';
  }

  @override
  String get passwordChanged => 'Password changed';

  @override
  String get safetyPinUpdated => 'Safety PIN updated';

  @override
  String get panicPinUpdated => 'Panic PIN updated';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get editProfileHint =>
      'Update how your circle sees you. Your phone lets friends call you during a journey.';

  @override
  String changeEmailHint(String email) {
    return 'We\'ll send a verification link to the new address. Sign-in and invites move to it once confirmed. Current: $email';
  }

  @override
  String get newEmail => 'New email';

  @override
  String get currentPassword => 'Current password';

  @override
  String get useSixCharacters => 'Use at least 6 characters.';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get safetyPinHintShort =>
      'This PIN confirms you are OK at each check-in.';

  @override
  String get currentPin => 'Current PIN';

  @override
  String get newPin => 'New PIN';

  @override
  String get panicPinHintShort =>
      'Entering this PIN looks normal but silently alerts your circle.';

  @override
  String get currentPanicPin => 'Current panic PIN';

  @override
  String get newPanicPin => 'New panic PIN';

  @override
  String get fullName => 'Full name';

  @override
  String get saveChanges => 'Save changes';

  @override
  String deleteCircleQuestion(String circle) {
    return 'Delete $circle?';
  }

  @override
  String get deleteCircleBody =>
      'Everyone in this circle stops following your journeys and alerts. This can’t be undone.';

  @override
  String get deleteCircle => 'Delete circle';

  @override
  String get theOwner => 'the owner';

  @override
  String leaveCircleQuestion(String circle) {
    return 'Leave $circle?';
  }

  @override
  String leaveCircleBody(String owner) {
    return 'You\'ll stop following $owner\'s journeys and alerts, and this circle stops seeing your location. $owner can invite you again.';
  }

  @override
  String get leaveCircle => 'Leave circle';

  @override
  String get couldNotLeaveCircle => 'Could not leave the circle. Try again.';

  @override
  String resendInvitationQuestion(String name) {
    return 'Resend invitation to $name?';
  }

  @override
  String resendInvitationTextBody(String phone) {
    return 'We\'ll text $phone again and remind them in the app.';
  }

  @override
  String get resendInvitationAppBody =>
      'We\'ll remind them in the app. Add a phone number to text them too.';

  @override
  String get resend => 'Resend';

  @override
  String get couldNotResendInvitation =>
      'Could not resend the invitation. Try again.';

  @override
  String removePersonQuestion(String name) {
    return 'Remove $name?';
  }

  @override
  String get removePersonBody =>
      'They will no longer follow your journeys or receive your alerts.';

  @override
  String get remove => 'Remove';

  @override
  String get couldNotRemoveParticipant =>
      'Could not remove the participant. Try again.';

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participants',
      one: '1 participant',
    );
    return '$_temp0';
  }

  @override
  String get participants => 'Participants';

  @override
  String get addMoreParticipants => 'Add more participants';

  @override
  String get deleteThisCircle => 'Delete this circle';

  @override
  String get leaveThisCircle => 'Leave this circle';

  @override
  String get deleteJourneyQuestion => 'Delete this journey?';

  @override
  String deleteJourneyBody(String date) {
    return 'This removes the journey from $date from your history. This can’t be undone.';
  }

  @override
  String get deleteJourneyBodyNoDate =>
      'This removes this journey from your history. This can’t be undone.';

  @override
  String get deleteJourney => 'Delete journey';

  @override
  String get couldNotDeleteJourney =>
      'Could not delete the journey. Try again.';

  @override
  String get deleteAllJourneysQuestion => 'Delete all journeys?';

  @override
  String deleteAllJourneysBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'This removes all $count journeys from your history. This can’t be undone.',
      one: 'This removes 1 journey from your history. This can’t be undone.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAll => 'Delete all';

  @override
  String journeysDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deleted $count journeys.',
      one: 'Deleted 1 journey.',
    );
    return '$_temp0';
  }

  @override
  String get couldNotDeleteJourneys =>
      'Could not delete your journeys. Try again.';

  @override
  String get journeyHistory => 'Journey history';

  @override
  String get planNewJourney => 'Plan new journey';

  @override
  String get noPastJourneys => 'No past journeys yet';

  @override
  String get noPastJourneysHint =>
      'Your completed journeys will show up here once you finish one.';

  @override
  String get journey => 'Journey';

  @override
  String get completed => 'Completed';

  @override
  String get checkInOverdue => 'Check-in overdue';

  @override
  String get checkInDueNow => 'Check-in due now';

  @override
  String get journeyActive => 'Journey active';

  @override
  String journeyActiveAt(String place) {
    return 'Journey active · $place';
  }

  @override
  String get circleColon => 'Circle:';

  @override
  String get checkIns => 'Check-ins';

  @override
  String get endJourney => 'End journey';

  @override
  String get getMeOut => 'Get me out of here';

  @override
  String get messages => 'Messages';

  @override
  String get overdue => 'Overdue';

  @override
  String get dueNow => 'Due now';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get confirm => 'Confirm';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get missedCheckInTitle => 'You missed a check-in';

  @override
  String get checkInDueTitle => 'Check-in due — are you safe?';

  @override
  String missedCheckInBody(String label, String time) {
    return '$label · $time. Your circle has been alerted — confirm now to let them know you\'re okay.';
  }

  @override
  String confirmWithinBody(int minutes) {
    return 'Confirm within $minutes min or your circle will be alerted.';
  }

  @override
  String get pickOneAlert => 'Pick at least one alert.';

  @override
  String get waitingForLocation =>
      'Waiting for a location — try again in a moment.';

  @override
  String get newPlace => 'New place';

  @override
  String placeAdded(String name) {
    return '$name added · circle will be alerted';
  }

  @override
  String get couldNotSavePlace => 'Could not save the place. Try again.';

  @override
  String deleteNamedQuestion(String name) {
    return 'Delete $name?';
  }

  @override
  String get deletePlaceBody =>
      'Your circle will no longer be alerted about arrivals and departures here.';

  @override
  String get deletePlace => 'Delete place';

  @override
  String get editPlace => 'Edit place';

  @override
  String get placeNameExample => 'e.g. Gym, Grandma\'s house';

  @override
  String get gettingLocation => 'Getting your location…';

  @override
  String get noLocationYet => 'No location yet';

  @override
  String get useCurrentLocation => 'Use my current location';

  @override
  String get alertRadius => 'ALERT RADIUS';

  @override
  String get arrives => 'Arrives';

  @override
  String get leaves => 'Leaves';

  @override
  String get savePlace => 'Save Place';

  @override
  String get you => 'You';

  @override
  String get locating => 'Locating…';

  @override
  String tripHistoryToday(String today) {
    return 'Trip history · $today';
  }

  @override
  String get pauseSharing => 'Pause sharing';

  @override
  String get resumeSharing => 'Resume sharing';

  @override
  String get call => 'Call';

  @override
  String get message => 'Message';

  @override
  String get sharingAgain => 'Sharing your live location again.';

  @override
  String get locationOffOnPhone =>
      'Location is off on this phone — turn it on in Settings.';

  @override
  String get pauseSharingQuestion => 'Pause location sharing?';

  @override
  String get pauseSharingBody =>
      'Your circle won\'t see where you are until you resume. Journeys, check-ins and SOS keep working.';

  @override
  String get pause => 'Pause';

  @override
  String get sharingPaused => 'Location sharing paused.';

  @override
  String get charging => 'Charging';

  @override
  String get lowBattery => 'Low battery';

  @override
  String get battery => 'Battery';

  @override
  String get alertResolvedReturning => 'Alert resolved — returning home…';

  @override
  String get markedResolved => 'Marked as resolved';

  @override
  String youConfirmedSafe(String name) {
    return 'You confirmed $name is safe · just now';
  }

  @override
  String get liveLocation => 'Live location';

  @override
  String get updating => 'Updating';

  @override
  String get atTimeOfAlert => 'At the time of the alert';

  @override
  String get locationUnavailable => 'Location unavailable';

  @override
  String get pinnedOnMap => 'Pinned on the map';

  @override
  String get noPositionShared => 'No position shared';

  @override
  String get lastRecordedCheckIn => 'Last recorded check-in';

  @override
  String callName(String name) {
    return 'Call $name';
  }

  @override
  String get openInMaps => 'Open in Maps';

  @override
  String get reopenAlert => 'Reopen alert';

  @override
  String get markAsResolved => 'Mark as resolved';

  @override
  String get tripHistoryEyebrow => 'TRIP HISTORY';

  @override
  String get yourTrips => 'Your trips';

  @override
  String namesTrips(String name) {
    return '$name\'s trips';
  }

  @override
  String get noTripsThisWeek => 'No trips this week';

  @override
  String weekSummary(String miles, String speed) {
    return '$miles mi · Top speed $speed';
  }

  @override
  String allTripsCount(int count) {
    return 'All trips $count';
  }

  @override
  String overSpeedCount(String speed, int count) {
    return 'Over $speed $count';
  }

  @override
  String tripsRecordedYou(int meters, int minutes) {
    return 'Trips are recorded automatically whenever you leave a $meters m radius and end after $minutes minutes stopped.';
  }

  @override
  String tripsRecordedName(String name, int meters, int minutes) {
    return 'Trips are recorded automatically whenever $name leaves a $meters m radius and end after $minutes minutes stopped.';
  }

  @override
  String get noTripsRecorded => 'No trips recorded this week.';

  @override
  String get noTripsMatch => 'No trips match this filter.';

  @override
  String get thisWeek => 'This week';

  @override
  String get lastWeek => 'Last week';

  @override
  String sinceDay(String day) {
    return 'Since $day';
  }

  @override
  String get tripsPerWeek => 'TRIPS PER WEEK';

  @override
  String get thisWeekShort => 'This\nweek';

  @override
  String get lastWeekShort => 'Last\nweek';

  @override
  String get termsServiceTitle => '1. The service';

  @override
  String get termsServiceBody =>
      'SafeCircle helps you share planned journeys and check-ins with people you trust. It complements — never replaces — emergency services.';

  @override
  String get termsResponsibilitiesTitle => '2. Your responsibilities';

  @override
  String get termsResponsibilitiesBody =>
      'Keep your account, safety PIN and panic PIN private, and only add emergency contacts who have agreed to receive alerts on your behalf.';

  @override
  String get termsAlertsTitle => '3. Alerts';

  @override
  String get termsAlertsBody =>
      'Alerts depend on your device connectivity and location permissions. In a life-threatening situation, always contact local emergency services first.';

  @override
  String get privacyCollectTitle => 'What we collect';

  @override
  String get privacyCollectBody =>
      'Your profile details, journey plans, check-in confirmations and — only while a journey is active — your location.';

  @override
  String get privacyWhoTitle => 'Who can see it';

  @override
  String get privacyWhoBody =>
      'Only the circles and emergency contacts you choose. Your location is never sold or shared with advertisers.';

  @override
  String get privacyControlTitle => 'Your control';

  @override
  String get privacyControlBody =>
      'You can end sharing at any time, and deleting your account permanently erases your circles and journey history.';

  @override
  String get lastUpdatedJune2026 => 'Last updated · June 2026';

  @override
  String get allCheckInsConfirmed =>
      'All check-ins confirmed — end the journey when you arrive';

  @override
  String labelCheckInOverdue(String label) {
    return '$label check-in overdue — your circle has been alerted';
  }

  @override
  String labelCheckInDueNow(String label) {
    return '$label check-in due now — confirm you\'re safe';
  }

  @override
  String nextCheckInLabel(String label, String time) {
    return 'Next check-in: $label · $time';
  }

  @override
  String yourJourneyWith(String circle) {
    return 'Your journey · $circle';
  }

  @override
  String get noActiveFriendJourneys =>
      'There are no active journeys from your friends at this time';

  @override
  String get nextCheckInPrefix => 'Next check-in: ';

  @override
  String get panicAlert => 'Panic alert';

  @override
  String get checkInDuePrefix => 'Check-in due: ';

  @override
  String get waiting => '· waiting';

  @override
  String journeyWith(String circle) {
    return 'Journey with $circle';
  }

  @override
  String get silentAlert => 'Silent alert';

  @override
  String get onTime => 'On time';

  @override
  String usedPanicPin(String name, String emergency) {
    return '$name used the panic PIN — they may be in danger. Call them or $emergency.';
  }

  @override
  String missedCheckInAt(String time, String name) {
    return 'Missed check-in at $time. Reach out to $name.';
  }

  @override
  String aCheckInWasMissed(String name) {
    return 'A check-in was missed. Reach out to $name.';
  }

  @override
  String get missed => 'Missed';

  @override
  String get alertSent => 'Alert sent';

  @override
  String sentJustNow(String time) {
    return '$time · just now';
  }

  @override
  String get locationShared => 'Location shared';

  @override
  String get enableLocationToShare => 'Enable location to share where you are';

  @override
  String get live => 'Live';

  @override
  String alertedInApp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alerted in the app · $count people',
      one: 'Alerted in the app · 1 person',
    );
    return '$_temp0';
  }

  @override
  String get noOneToAlert => 'No one on SafeCircle to alert yet';

  @override
  String get textMyLocation => 'Text my location to contacts';

  @override
  String get emergencySmsNoLocation =>
      'EMERGENCY — I need help. Sent from SafeCircle.';

  @override
  String emergencySmsWithLocation(String link, String place) {
    return 'EMERGENCY — I need help. My location: $link ($place)';
  }

  @override
  String alsoCall(String number) {
    return 'Also call $number';
  }

  @override
  String get cancelAlertSafe => 'Cancel alert — I\'m safe';

  @override
  String get callOrTextToCheck => 'Call or text to make sure';

  @override
  String get newJourney => 'New journey';

  @override
  String get newJourneyHint =>
      'Schedule when you\'ll check in. If you miss one, your circle is alerted.';

  @override
  String get selectTiming => 'Select the timing';

  @override
  String get otherInformation => 'Other information';

  @override
  String get journeyNoteExample => 'Meeting at the bar';

  @override
  String get addCheckIn => 'Add check-in';

  @override
  String get startJourney => 'Start the journey';

  @override
  String get pickTimeOneMinute => 'Pick a time at least 1 minute from now.';

  @override
  String textInvitationsSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Text invitation sent to $count people.',
      one: 'Text invitation sent to 1 person.',
    );
    return '$_temp0';
  }

  @override
  String noAccountYetFor(String emails) {
    return 'No SafeCircle account yet for: $emails';
  }

  @override
  String get couldNotSaveCircle => 'Could not save the circle. Try again.';

  @override
  String get addParticipants => 'Add participants';

  @override
  String get addingTo => 'Adding to ';

  @override
  String get addingToHint =>
      '. Participants join with the email of their SafeCircle account — that\'s how they follow your journeys.';

  @override
  String get saveParticipant => 'Save participant';

  @override
  String get add => 'Add';

  @override
  String participantsCount(int count) {
    return 'PARTICIPANTS · $count';
  }

  @override
  String get noParticipantsYet => 'No participants yet';

  @override
  String get saveCircle => 'Save circle';

  @override
  String get createCircle => 'Create circle';

  @override
  String resendAlreadyJoined(String name) {
    return '$name already joined this circle.';
  }

  @override
  String resendTexted(String name) {
    return 'Invitation texted to $name again.';
  }

  @override
  String resendTooSoon(String name, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'You just texted $name. Try again in $minutes minutes.',
      one: 'You just texted $name. Try again in 1 minute.',
    );
    return '$_temp0';
  }

  @override
  String get resendLimited => 'Daily text limit reached. Try again tomorrow.';

  @override
  String resendFailed(String name) {
    return 'Could not text $name.';
  }

  @override
  String resendFailedInAppWaiting(String name) {
    return 'Could not text $name. The in-app invitation is still waiting for them.';
  }

  @override
  String resendInApp(String name) {
    return 'In-app invitation sent to $name again.';
  }

  @override
  String resendNoAccount(String name) {
    return 'No SafeCircle account yet for $name. Add a phone number to text them.';
  }

  @override
  String circleNotifiedNextAt(String time) {
    return 'Your circle has been notified. Next check-in at $time.';
  }

  @override
  String get allCheckedIn =>
      'You\'re all checked in for this journey. Have a safe trip.';

  @override
  String get checkInConfirmed => 'Check-in confirmed!';

  @override
  String get backToJourney => 'Back to journey';

  @override
  String get journeyFinished => 'Journey finished';

  @override
  String get journeyFinishedHint =>
      'You\'re safe and your circle has been notified that you\'ve arrived.';

  @override
  String get backHome => 'Back home';

  @override
  String get emergencyContacts => 'Emergency contacts';

  @override
  String get emergencyContactsHint =>
      'On any alert they get a text with your location, and a notification in the app if they use SafeCircle.';

  @override
  String get addTwoContacts =>
      'Add at least 2 emergency contacts to start a journey.';

  @override
  String alwaysAlerted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Always alerted · $count contacts',
      one: 'Always alerted · 1 contact',
    );
    return '$_temp0';
  }

  @override
  String get removeContactBody =>
      'They will no longer be alerted when you send an SOS.';

  @override
  String get removeContact => 'Remove contact';

  @override
  String get addEmergencyContact => 'Add emergency contact';

  @override
  String get noPhoneNumber => 'No phone number available.';

  @override
  String get couldNotOpenDialer => 'Could not open the dialer.';

  @override
  String get couldNotOpenMessages => 'Could not open messages.';

  @override
  String get noPhoneNumbers => 'No phone numbers available.';

  @override
  String get noLocationYetShort => 'No location available yet.';

  @override
  String get couldNotOpenMaps => 'Could not open the maps app.';

  @override
  String replayOf(String day) {
    return '$day · Replay';
  }

  @override
  String tripSummaryTop(
      String start, String end, String distance, String speed) {
    return '$start – $end · $distance · top $speed';
  }

  @override
  String get metricTime => 'TIME';

  @override
  String get metricSpeed => 'SPEED';

  @override
  String get metricDistance => 'DISTANCE';

  @override
  String get unitMph => ' mph';

  @override
  String get unitMi => ' mi';

  @override
  String leftPlace(String place) {
    return 'Left $place';
  }

  @override
  String get theStart => 'the start';

  @override
  String speedingOver(String speed) {
    return 'Speeding · over $speed';
  }

  @override
  String arrivedAt(String place) {
    return 'Arrived at $place';
  }

  @override
  String get theEnd => 'the end';

  @override
  String get editProfileSub => 'Name, photo & personal info';

  @override
  String get myEmergencyContacts => 'My emergency contacts';

  @override
  String peopleWillBeAlerted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people will be alerted',
      one: '1 person will be alerted',
    );
    return '$_temp0';
  }

  @override
  String get myCircles => 'My circles';

  @override
  String completedJourneys(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count completed journeys',
      one: '1 completed journey',
    );
    return '$_temp0';
  }

  @override
  String get profile => 'Profile';

  @override
  String get me => 'Me';

  @override
  String get couldNotUpdatePhoto => 'Could not update the photo.';

  @override
  String get waitingFirstUpdate => 'Waiting for the first update';

  @override
  String get liveUpdatedJustNow => 'Live · updated just now';

  @override
  String updatedMinAgo(int minutes) {
    return 'Updated $minutes min ago';
  }

  @override
  String get noRecentUpdate => 'No recent update';

  @override
  String get moving => 'Moving';

  @override
  String movingAt(String speed) {
    return 'Moving · $speed';
  }

  @override
  String get stopped => 'Stopped';

  @override
  String atPlaceSince(String time) {
    return 'At place since $time';
  }

  @override
  String friendsNeedAttention(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends need attention',
      one: '1 friend needs attention',
    );
    return '$_temp0';
  }

  @override
  String namesCheckInDue(String name) {
    return '$name\'s check-in is due';
  }

  @override
  String checkInsAreDue(int count) {
    return '$count check-ins are due';
  }

  @override
  String friendsOnJourney(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends on a journey',
      one: '1 friend on a journey',
    );
    return '$_temp0';
  }

  @override
  String get whosWatching => 'Who\'s watching?';

  @override
  String get pickCircleHint => 'Pick the circle that monitors this journey.';

  @override
  String get nobodyAcceptedYet =>
      'Nobody in this circle has accepted the invite yet, so no one could see this journey. Wait for a member to accept before starting.';

  @override
  String get addTwoContactsBeforeStart =>
      'Add 2 emergency contacts before starting';

  @override
  String get schedule => 'SCHEDULE';

  @override
  String get starting => 'Starting…';

  @override
  String get startJourneyButton => 'Start journey';

  @override
  String get needCircleFirst =>
      'You need a circle first. Tap the Circles tab below to create one.';

  @override
  String peopleWatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people watching',
      one: '1 person watching',
    );
    return '$_temp0';
  }

  @override
  String get couldNotOpenContacts => 'Could not open your contacts.';

  @override
  String get nameExampleContact => 'e.g. Jessica Moore';

  @override
  String get photo => 'Photo';

  @override
  String get couldNotOpenPhotos => 'Could not open the photo library.';

  @override
  String get photoAdded => 'Photo added';

  @override
  String get addPhoto => 'Add a photo';

  @override
  String get emailRequired => 'E-mail (required)';

  @override
  String get emailShouldMatch => 'Email should match their account';

  @override
  String get importFromContacts => 'Import from contacts';

  @override
  String circlesSummary(int circles, int members) {
    String _temp0 = intl.Intl.pluralLogic(
      circles,
      locale: localeName,
      other: '$circles circles',
      one: '1 circle',
    );
    String _temp1 = intl.Intl.pluralLogic(
      members,
      locale: localeName,
      other: '$members members',
      one: '1 member',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get currentPinWrong => 'Current PIN is incorrect.';

  @override
  String get currentPanicPinWrong => 'Current panic PIN is incorrect.';

  @override
  String get newPinFourDigits => 'The new PIN must have 4 digits.';

  @override
  String get mustDifferFromPanic => 'It must differ from your panic PIN.';

  @override
  String get mustDifferFromSafety => 'It must differ from your safety PIN.';

  @override
  String get enterValidEmail => 'Enter a valid email.';

  @override
  String get enterCurrentPassword => 'Enter your current password.';

  @override
  String get newPasswordTooShort =>
      'New password must have at least 6 characters.';

  @override
  String tripsToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trips today',
      one: '1 trip today',
    );
    return '$_temp0';
  }

  @override
  String tripsTodayMiles(int count, String miles) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trips · $miles mi today',
      one: '1 trip · $miles mi today',
    );
    return '$_temp0';
  }

  @override
  String get alertsOff => 'Alerts off';

  @override
  String get alertArriveLeave => 'Alert on arrive & leave';

  @override
  String get alertArrive => 'Alert on arrive';

  @override
  String get alertLeave => 'Alert on leave';

  @override
  String get tripStart => 'Start';

  @override
  String get tripEnd => 'End';

  @override
  String arrivedAtPlace(String name, String place) {
    return '$name arrived at $place';
  }

  @override
  String leftPlaceNamed(String name, String place) {
    return '$name left $place';
  }

  @override
  String hasLowBattery(String name) {
    return '$name has a low battery';
  }

  @override
  String lowBatterySub(String level) {
    return '$level · Location may stop updating soon';
  }

  @override
  String get myCirclesTitle => 'My circles';

  @override
  String get createNewCircle => 'Create new circle';

  @override
  String get noCircleYet => 'You don\'t have any circle created';

  @override
  String get noCircleYetHint =>
      'Create a circle to gather the people you trust and share your journeys with them.';

  @override
  String get newCircleInvite => 'New circle invite';

  @override
  String get newBadge => 'NEW';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get emergencySos => 'Emergency SOS';

  @override
  String get sosHint =>
      'This alerts your circle in the app and texts your circle and emergency contacts your location.';

  @override
  String get sosNeedsContact =>
      'Add at least one emergency contact before you can send an alert.';

  @override
  String yourEmergencyContactsCount(int count) {
    return 'Your emergency contacts · $count';
  }

  @override
  String get unavailable => 'Unavailable';

  @override
  String get keepHolding => 'Keep holding…';

  @override
  String get holdToAlert => 'Hold to alert';

  @override
  String get addContactBeforeAlert =>
      'Add an emergency contact before sending an alert.';

  @override
  String get notificationChannelName => 'SafeCircle alerts';

  @override
  String get notificationChannelDescription =>
      'Check-in reminders and safety alerts';

  @override
  String get reminderDueTitle => 'Check-in due now';

  @override
  String reminderDueBody(String label, String time) {
    return '$label · $time — open SafeCircle and confirm you\'re safe.';
  }

  @override
  String get reminderLastCallTitle => 'Last call: confirm your check-in';

  @override
  String reminderLastCallBody(String label, String time) {
    return '$label · $time — your circle will be alerted in 1 minute.';
  }

  @override
  String get testNotificationTitle => 'SafeCircle notifications are working';

  @override
  String get testNotificationBody =>
      'You will be alerted like this for check-ins, overdue friends and emergencies.';

  @override
  String get circleInvite => 'Circle invite';

  @override
  String inviteNotificationBody(String summary) {
    return '$summary — open SafeCircle to accept.';
  }

  @override
  String get speedAlertTitle => 'Speed alert on your last trip';

  @override
  String speedAlertBody(String trip, String speed) {
    return '$trip · top $speed';
  }

  @override
  String get checkIn => 'Check-in';

  @override
  String checkInOverdueReachOut(String label) {
    return '$label is overdue — reach out.';
  }

  @override
  String get places => 'Places';

  @override
  String get placesHint =>
      'Your circle gets an alert when someone arrives at or leaves these places.';

  @override
  String get noPlacesYet =>
      'No places yet. Add home, school or work and the circle is told when someone gets there.';

  @override
  String get addPlace => 'Add Place';

  @override
  String get savedLocation => 'Saved location';

  @override
  String get couldNotUpdatePlace => 'Could not update the place.';

  @override
  String get sharingPausedBanner => 'Your location sharing is paused';

  @override
  String get turnOnLocation => 'Turn on your location';

  @override
  String get sharingPausedBannerSub =>
      'Your circle can\'t see where you are. Tap to resume.';

  @override
  String get turnOnLocationSub =>
      'Your circle can\'t see you yet. Tap to allow location.';

  @override
  String get noOneSharing => 'No one is sharing yet';

  @override
  String get noOneSharingHint =>
      'Invite the people you trust to a circle. Everyone who joins and shares their location appears here.';

  @override
  String get goToCircles => 'Go to circles';

  @override
  String get firstCheckIn => 'First check-in';

  @override
  String get secondCheckIn => 'Second check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String numberedCheckIn(int number) {
    return 'Check-in $number';
  }

  @override
  String couldNotJoinNoAccess(String name) {
    return 'Couldn\'t join: the app doesn\'t have access to this circle yet. Ask $name to send the invite again.';
  }

  @override
  String get couldNotAcceptInvite => 'Could not accept the invite. Try again.';

  @override
  String get circleInviteEyebrow => 'CIRCLE INVITE';

  @override
  String addedYouToCircle(String name, String circle) {
    return '$name added you to the circle $circle on SafeCircle.';
  }

  @override
  String joinHint(String name) {
    return 'Join and $name will be able to invite you to follow their journeys and get alerted if they\'re ever overdue. You can leave the circle at any time.';
  }

  @override
  String get joining => 'Joining…';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get confirmToEndJourney => 'Confirm to end journey';

  @override
  String get confirmYourCheckIn => 'Confirm your check-in';

  @override
  String get enterPinToEnd => 'Enter your PIN to end this journey safely.';

  @override
  String get incorrectPin => 'Incorrect PIN. Try again.';

  @override
  String get friendsJourneys => 'Friends\' Journeys';

  @override
  String get noNewNotifications => 'No new notifications.';

  @override
  String get renameCircle => 'Rename circle';

  @override
  String get nameYourCircle => 'Name your circle';

  @override
  String get circleNameHint =>
      'Pick a name — add an emoji to make it easy to spot.';

  @override
  String get circlesName => 'Circle\'s name';

  @override
  String get circleNameExample => 'e.g. 🏠 Family';

  @override
  String get save => 'Save';

  @override
  String get locationSharingChannel => 'Location sharing';

  @override
  String get locationSharingChannelDescription =>
      'Shown while SafeCircle shares your location with your circle.';

  @override
  String get sharingNotificationTitle => 'SafeCircle is sharing your location';

  @override
  String get sharingNotificationBody => 'Your circle can see where you are.';

  @override
  String checkInInPast(String label) {
    return '\"$label\" is already in the past — adjust its time.';
  }

  @override
  String get journeyStartsWithoutLocation =>
      'Location unavailable — journey starts without a map position.';

  @override
  String get couldNotStartJourney => 'Could not start the journey. Try again.';

  @override
  String get createYourFirstCircle => 'Create your first circle';

  @override
  String get nothingNewYet => 'Nothing new yet.';

  @override
  String get activity => 'Activity';

  @override
  String get delete => 'Delete';

  @override
  String get back => 'Back';

  @override
  String get checkConnection => 'Check your connection and try again.';

  @override
  String get couldNotLoadThis => 'Couldn\'t load this';

  @override
  String get couldNotLoadAccount => 'We couldn\'t load your account';

  @override
  String get checkInternet => 'Check your internet connection and try again.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get createACircle => 'Create a circle';

  @override
  String get journeysList => 'Journeys list';

  @override
  String get couldNotSaveContact => 'Could not save the contact. Try again.';

  @override
  String get editContact => 'Edit contact';

  @override
  String get addContactHint =>
      'They\'ll be alerted on every journey, always. We\'ll text them once to let them know you added them.';

  @override
  String get sharingWithCircles =>
      'Sharing your live location with your circles.';

  @override
  String get locationOffEnable =>
      'Location is off — enable it to share your position.';

  @override
  String get positionNotShared => 'Your position is not being shared yet.';

  @override
  String get tabMap => 'Map';

  @override
  String get tabJourneys => 'Journeys';

  @override
  String get tabEmergency => 'Emergency';

  @override
  String get tabProfile => 'Profile';

  @override
  String get planAJourney => 'Plan a journey';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get addYourFirstCircle => 'Add your first circle';

  @override
  String get resendInvitation => 'Resend invitation';

  @override
  String get locationNotSharedYet => 'Location not shared yet';

  @override
  String get couldNotSendAlert =>
      'Could not send the alert. Check your connection and try again.';

  @override
  String get journeys => 'Journeys';

  @override
  String overSpeed(String speed) {
    return 'Over $speed';
  }

  @override
  String get withinLimit => 'Within limit';

  @override
  String friendsNeedAttentionActive(int count, int active) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends need attention',
      one: '1 friend needs attention',
    );
    return '$_temp0 · $active active';
  }

  @override
  String friendsOnJourneyNow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends currently on a journey',
      one: '1 friend currently on a journey',
    );
    return '$_temp0';
  }

  @override
  String get countryUS => 'United States';

  @override
  String get countryBR => 'Brazil';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryGB => 'United Kingdom';

  @override
  String get countryES => 'Spain';

  @override
  String get countryAR => 'Argentina';

  @override
  String get countryFR => 'France';

  @override
  String get countryMX => 'Mexico';

  @override
  String get countryCN => 'China';

  @override
  String get countryIN => 'India';

  @override
  String get enterPinToPause => 'Enter your PIN to pause.';
}
