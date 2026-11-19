// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'SafeCircle';

  @override
  String get today => 'आज';

  @override
  String get tomorrow => 'कल';

  @override
  String get alertKindPanic => 'साइलेंट पैनिक';

  @override
  String get alertKindOverdue => 'चेक-इन छूटा';

  @override
  String get alertKindSos => 'SOS';

  @override
  String alertHeadlineOverdue(String name) {
    return '$name का एक चेक-इन छूट गया';
  }

  @override
  String alertHeadlineHelp(String name) {
    return '$name को मदद चाहिए';
  }

  @override
  String get someone => 'कोई';

  @override
  String get aCircle => 'एक सर्कल';

  @override
  String inviteSummary(String name, String circle) {
    return '$name ने आपको $circle में आमंत्रित किया';
  }

  @override
  String get circleOwner => 'सर्कल के मालिक';

  @override
  String lastSeenAt(String time) {
    return 'आखिरी बार $time पर देखा गया';
  }

  @override
  String get enterYourName => 'अपना नाम लिखें।';

  @override
  String get enterYourEmail => 'अपना ईमेल लिखें।';

  @override
  String get passwordTooShort => 'पासवर्ड में कम से कम 6 अक्षर होने चाहिए।';

  @override
  String get passwordsDontMatch => 'पासवर्ड मेल नहीं खाते।';

  @override
  String get enterEmailAndPassword => 'अपना ईमेल और पासवर्ड लिखें।';

  @override
  String get recoveryLinkSent =>
      'रिकवरी लिंक भेज दिया गया है। अपना इनबॉक्स देखें।';

  @override
  String get couldNotSavePins => 'आपके PIN सेव नहीं हो सके। फिर से कोशिश करें।';

  @override
  String get welcomeTo => 'आपका स्वागत है';

  @override
  String get welcomeTagline =>
      'भरोसेमंद लोगों का सर्कल बनाएं, ताकि किसी को हमेशा पता रहे कि आप सुरक्षित हैं।';

  @override
  String get start => 'शुरू करें';

  @override
  String get skipIntro => 'परिचय छोड़ें';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get joinInSeconds => 'कुछ ही सेकंड में SafeCircle से जुड़ें।';

  @override
  String get name => 'नाम';

  @override
  String get nameExample => 'जैसे: राहुल शर्मा';

  @override
  String get email => 'ईमेल';

  @override
  String get emailExample => 'name@example.com';

  @override
  String get phone => 'फ़ोन';

  @override
  String get password => 'पासवर्ड';

  @override
  String get repeatPassword => 'पासवर्ड दोबारा लिखें';

  @override
  String get creatingAccount => 'खाता बन रहा है…';

  @override
  String get register => 'रजिस्टर करें';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है? ';

  @override
  String get login => 'लॉग इन करें';

  @override
  String get loginTagline => 'किसी को हमेशा पता रहता है कि आप सुरक्षित हैं।';

  @override
  String get forgotPassword => 'भूल गए?';

  @override
  String get loggingIn => 'लॉग इन हो रहा है…';

  @override
  String get orLoginWith => 'या इससे लॉग इन करें...';

  @override
  String get noAccountYet => 'खाता नहीं है? ';

  @override
  String get registerExclaim => 'रजिस्टर करें!';

  @override
  String get socialLoginSoon => 'सोशल लॉग इन जल्द आ रहा है।';

  @override
  String get recoverPassword => 'पासवर्ड वापस पाएं';

  @override
  String get recoverPasswordHint =>
      'अपने खाते से जुड़ा ईमेल लिखें, हम पासवर्ड रीसेट करने के लिए एक सुरक्षित लिंक भेजेंगे।';

  @override
  String get sending => 'भेजा जा रहा है…';

  @override
  String stepOf(int step, int total) {
    return 'चरण $step / $total';
  }

  @override
  String get setPanicPin => 'अपना पैनिक PIN सेट करें';

  @override
  String get setSafetyPin => 'अपना सेफ़्टी PIN सेट करें';

  @override
  String get panicPinHint =>
      'अगर आपको ऐप खोलने के लिए मजबूर किया जाए, तो यह PIN डालें। स्क्रीन सामान्य दिखेगी, लेकिन आपके सर्कल को चुपचाप अलर्ट मिल जाएगा।';

  @override
  String get safetyPinHint =>
      'चेक-इन के समय यह PIN डालकर पुष्टि करें कि आप सुरक्षित हैं।';

  @override
  String get panicPinMatchesSafety =>
      'यह आपके सेफ़्टी PIN जैसा ही है। कोई दूसरा कोड चुनें।';

  @override
  String get panicPinMustDiffer => 'यह आपके सेफ़्टी PIN से अलग होना चाहिए।';

  @override
  String get saving => 'सेव हो रहा है…';

  @override
  String get finish => 'पूरा करें';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String get gettingStarted => 'शुरुआत';

  @override
  String get createFirstCircle => 'अपना पहला सर्कल बनाएं';

  @override
  String get tapPrefix => 'नीचे की पट्टी में ';

  @override
  String get tabCircles => 'सर्कल';

  @override
  String get createFirstCircleHint =>
      ' पर टैप करें, नाम दें और भरोसेमंद लोगों को जोड़ें। उन्हें आपकी यात्राएं देखने का आमंत्रण मिलेगा।';

  @override
  String get next => 'आगे';

  @override
  String get allSet => 'सब तैयार है!';

  @override
  String get allSetHint =>
      'आपका SafeCircle तैयार है। बाहर निकलते समय अपनी पहली यात्रा प्लान करें।';

  @override
  String get enterSafeCircle => 'SafeCircle खोलें';

  @override
  String get authInvalidEmail => 'ईमेल पता सही नहीं है।';

  @override
  String get authEmailInUse => 'यह ईमेल पहले से रजिस्टर है।';

  @override
  String get authWeakPassword => 'पासवर्ड बहुत कमज़ोर है (कम से कम 6 अक्षर)।';

  @override
  String get authWrongCredentials => 'ईमेल या पासवर्ड गलत है।';

  @override
  String get authTooManyAttempts =>
      'बहुत ज़्यादा कोशिशें। थोड़ी देर बाद कोशिश करें।';

  @override
  String get authNetwork => 'नेटवर्क में गड़बड़ी। अपना कनेक्शन जांचें।';

  @override
  String get authReloginNeeded => 'यह करने के लिए दोबारा लॉग इन करें।';

  @override
  String get authGenericError => 'पहचान की पुष्टि में गड़बड़ी।';

  @override
  String get somethingWentWrong => 'कुछ गड़बड़ हो गई। फिर से कोशिश करें।';

  @override
  String get settings => 'सेटिंग';

  @override
  String get security => 'सुरक्षा';

  @override
  String get changeSafetyPin => 'सेफ़्टी PIN बदलें';

  @override
  String get changeSafetyPinSub => 'चेक-इन पर पुष्टि करता है कि आप ठीक हैं';

  @override
  String get changePanicPin => 'पैनिक PIN बदलें';

  @override
  String get changePanicPinSub =>
      'साइलेंट मजबूरी कोड · छिपा हुआ अलर्ट भेजता है';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get checkInReminders => 'चेक-इन रिमाइंडर';

  @override
  String get checkInRemindersSub => 'चेक-इन का समय होने पर मुझे याद दिलाएं';

  @override
  String get overdueCheckIns => 'छूटे हुए चेक-इन';

  @override
  String get overdueCheckInsSub =>
      'जब किसी दोस्त का चेक-इन छूट जाए। पैनिक और SOS अलर्ट हमेशा चालू रहते हैं।';

  @override
  String get permissions => 'अनुमतियां';

  @override
  String get permissionsSub => 'लोकेशन, सूचनाएं, अलार्म और बैटरी';

  @override
  String get permissionsReason =>
      'SafeCircle इनका इस्तेमाल सिर्फ़ आपकी और आपके सर्कल की सुरक्षा के लिए करता है।';

  @override
  String get done => 'हो गया';

  @override
  String get sendTestNotification => 'टेस्ट सूचना भेजें';

  @override
  String get sendTestNotificationSub =>
      'जांचें कि अलर्ट इस फ़ोन तक पहुंचते हैं';

  @override
  String get testNotificationSent => 'भेज दी गई — अपनी सूचनाएं देखें।';

  @override
  String get testNotificationFailed =>
      'भेजी नहीं जा सकी। सिस्टम सेटिंग में सूचना की अनुमति जांचें।';

  @override
  String get account => 'खाता';

  @override
  String get changeEmail => 'ईमेल बदलें';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get logOut => 'लॉग आउट करें';

  @override
  String get logOutQuestion => 'लॉग आउट करें?';

  @override
  String get logOutBody =>
      'दोबारा लॉग इन करने तक आपको अपने सर्कल के अलर्ट नहीं मिलेंगे।';

  @override
  String get loggedOut => 'लॉग आउट हो गया।';

  @override
  String get deleteAccount => 'खाता हटाएं';

  @override
  String get deleteAccountSub =>
      'आपका सर्कल और इतिहास हमेशा के लिए मिटा देता है';

  @override
  String get deleteAccountQuestion => 'खाता हटाएं?';

  @override
  String get deleteAccountBody =>
      'इससे आपके सर्कल, संपर्क और यात्रा इतिहास हमेशा के लिए मिट जाएंगे। इसे वापस नहीं लिया जा सकता।';

  @override
  String get accountDeleted => 'खाता हटा दिया गया।';

  @override
  String get about => 'जानकारी';

  @override
  String get version => 'वर्शन';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get privacyPolicy => 'निजता नीति';

  @override
  String get aboutFooter => 'SafeCircle · आपके सर्कल को सुरक्षित रखने के लिए';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get beforeYouStart => 'शुरू करने से पहले';

  @override
  String get journeyPermissionsReason =>
      'यात्रा के लिए इनकी ज़रूरत है, ताकि चेक-इन रिमाइंडर समय पर बजें और आपका सर्कल देख सके कि आप कहां हैं।';

  @override
  String get shareLiveLocation => 'अपनी लाइव लोकेशन शेयर करें';

  @override
  String get shareLiveLocationReason =>
      'आपका सर्कल मैप पर देखता है कि आप कहां हैं।';

  @override
  String get notificationsOffWarning =>
      'आपको अलर्ट की सूचना नहीं मिलेगी — सेटिंग में सूचनाएं चालू करें।';

  @override
  String get almostThere => 'बस थोड़ा और';

  @override
  String get allowPermissions => 'अनुमतियां दें';

  @override
  String get allowPermissionsHint =>
      'SafeCircle इनका इस्तेमाल सिर्फ़ आपको और आपके सर्कल को सुरक्षित रखने के लिए करता है। नियंत्रण हमेशा आपके हाथ में है — सेटिंग में कभी भी बदलें।';

  @override
  String get locationDenied =>
      'लोकेशन की अनुमति नहीं मिली — सिस्टम सेटिंग में चालू करें।';

  @override
  String get notificationsDenied =>
      'सूचनाओं की अनुमति नहीं मिली — सिस्टम सेटिंग में चालू करें।';

  @override
  String get turnOnAlarms =>
      'SafeCircle के लिए \"अलार्म और रिमाइंडर\" चालू करें, फिर वापस आएं।';

  @override
  String get contactsDenied =>
      'संपर्कों की अनुमति नहीं मिली — सिस्टम सेटिंग में चालू करें।';

  @override
  String get location => 'लोकेशन';

  @override
  String get locationPermissionSub =>
      'ताकि आपका सर्कल देख सके कि आप सुरक्षित पहुंच गए हैं।';

  @override
  String get notificationsPermissionSub =>
      'ताकि चेक-इन का समय होने पर हम आपको याद दिला सकें।';

  @override
  String get alarmsAndReminders => 'अलार्म और रिमाइंडर';

  @override
  String get alarmsPermissionSub => 'ताकि चेक-इन रिमाइंडर ठीक समय पर बजें।';

  @override
  String get backgroundActivity => 'बैकग्राउंड गतिविधि (सुझाया गया)';

  @override
  String get backgroundPermissionSub =>
      'ताकि फ़ोन इस्तेमाल न होने पर भी रिमाइंडर आएं।';

  @override
  String get contactsOptional => 'संपर्क (वैकल्पिक)';

  @override
  String get contactsPermissionSub =>
      'भरोसेमंद लोगों को जल्दी आमंत्रित करने के लिए।';

  @override
  String get locationAndNotificationsRequired =>
      'आपकी सुरक्षा के लिए SafeCircle को लोकेशन और सूचनाओं की ज़रूरत है।';

  @override
  String get locationRequired =>
      'आपकी सुरक्षा के लिए SafeCircle को लोकेशन की ज़रूरत है।';

  @override
  String get setUpLater => 'बाद में सेट करें';

  @override
  String get openSystemSettings => 'सिस्टम सेटिंग खोलें';

  @override
  String get allowed => 'अनुमति है';

  @override
  String get allow => 'अनुमति दें';

  @override
  String get profileUpdated => 'प्रोफ़ाइल अपडेट हो गई';

  @override
  String verificationLinkSent(String email) {
    return 'पुष्टि लिंक $email पर भेजा गया — बदलने के लिए उसकी पुष्टि करें।';
  }

  @override
  String get passwordChanged => 'पासवर्ड बदल गया';

  @override
  String get safetyPinUpdated => 'सेफ़्टी PIN अपडेट हो गया';

  @override
  String get panicPinUpdated => 'पैनिक PIN अपडेट हो गया';

  @override
  String get editProfile => 'प्रोफ़ाइल बदलें';

  @override
  String get editProfileHint =>
      'बदलें कि आपका सर्कल आपको कैसे देखता है। आपके फ़ोन नंबर से दोस्त यात्रा के दौरान आपको कॉल कर सकते हैं।';

  @override
  String changeEmailHint(String email) {
    return 'हम नए पते पर पुष्टि लिंक भेजेंगे। पुष्टि होने के बाद लॉग इन और आमंत्रण उसी पर चले जाएंगे। मौजूदा: $email';
  }

  @override
  String get newEmail => 'नया ईमेल';

  @override
  String get currentPassword => 'मौजूदा पासवर्ड';

  @override
  String get useSixCharacters => 'कम से कम 6 अक्षर इस्तेमाल करें।';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get confirmNewPassword => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get safetyPinHintShort =>
      'यह PIN हर चेक-इन पर पुष्टि करता है कि आप ठीक हैं।';

  @override
  String get currentPin => 'मौजूदा PIN';

  @override
  String get newPin => 'नया PIN';

  @override
  String get panicPinHintShort =>
      'यह PIN डालना सामान्य लगता है, लेकिन आपके सर्कल को चुपचाप अलर्ट भेजता है।';

  @override
  String get currentPanicPin => 'मौजूदा पैनिक PIN';

  @override
  String get newPanicPin => 'नया पैनिक PIN';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get saveChanges => 'बदलाव सेव करें';

  @override
  String deleteCircleQuestion(String circle) {
    return '$circle हटाएं?';
  }

  @override
  String get deleteCircleBody =>
      'इस सर्कल में कोई भी आपकी यात्राएं और अलर्ट नहीं देख पाएगा। इसे वापस नहीं लिया जा सकता।';

  @override
  String get deleteCircle => 'सर्कल हटाएं';

  @override
  String get theOwner => 'मालिक';

  @override
  String leaveCircleQuestion(String circle) {
    return '$circle छोड़ें?';
  }

  @override
  String leaveCircleBody(String owner) {
    return 'आप $owner की यात्राएं और अलर्ट नहीं देख पाएंगे, और यह सर्कल आपकी लोकेशन नहीं देख पाएगा। $owner आपको फिर से आमंत्रित कर सकते हैं।';
  }

  @override
  String get leaveCircle => 'सर्कल छोड़ें';

  @override
  String get couldNotLeaveCircle =>
      'सर्कल छोड़ा नहीं जा सका। फिर से कोशिश करें।';

  @override
  String resendInvitationQuestion(String name) {
    return '$name को फिर से आमंत्रण भेजें?';
  }

  @override
  String resendInvitationTextBody(String phone) {
    return 'हम $phone पर फिर से SMS भेजेंगे और ऐप में याद दिलाएंगे।';
  }

  @override
  String get resendInvitationAppBody =>
      'अगर उनके पास SafeCircle है तो हम ऐप में याद दिलाएंगे। नहीं तो आप खुद चुनें कि निमंत्रण कैसे भेजना है।';

  @override
  String get resend => 'फिर से भेजें';

  @override
  String get couldNotResendInvitation =>
      'आमंत्रण फिर से नहीं भेजा जा सका। फिर से कोशिश करें।';

  @override
  String removePersonQuestion(String name) {
    return '$name को हटाएं?';
  }

  @override
  String get removePersonBody =>
      'वे अब आपकी यात्राएं नहीं देख पाएंगे और न ही आपके अलर्ट पाएंगे।';

  @override
  String get remove => 'हटाएं';

  @override
  String get couldNotRemoveParticipant =>
      'सदस्य को हटाया नहीं जा सका। फिर से कोशिश करें।';

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्य',
      one: '1 सदस्य',
    );
    return '$_temp0';
  }

  @override
  String get participants => 'सदस्य';

  @override
  String get addMoreParticipants => 'और सदस्य जोड़ें';

  @override
  String get deleteThisCircle => 'यह सर्कल हटाएं';

  @override
  String get leaveThisCircle => 'यह सर्कल छोड़ें';

  @override
  String get deleteJourneyQuestion => 'यह यात्रा हटाएं?';

  @override
  String deleteJourneyBody(String date) {
    return 'इससे $date की यात्रा आपके इतिहास से हट जाएगी। इसे वापस नहीं लिया जा सकता।';
  }

  @override
  String get deleteJourneyBodyNoDate =>
      'इससे यह यात्रा आपके इतिहास से हट जाएगी। इसे वापस नहीं लिया जा सकता।';

  @override
  String get deleteJourney => 'यात्रा हटाएं';

  @override
  String get couldNotDeleteJourney =>
      'यात्रा हटाई नहीं जा सकी। फिर से कोशिश करें।';

  @override
  String get deleteAllJourneysQuestion => 'सभी यात्राएं हटाएं?';

  @override
  String deleteAllJourneysBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'इससे सभी $count यात्राएं आपके इतिहास से हट जाएंगी। इसे वापस नहीं लिया जा सकता।',
      one: 'इससे 1 यात्रा आपके इतिहास से हट जाएगी। इसे वापस नहीं लिया जा सकता।',
    );
    return '$_temp0';
  }

  @override
  String get deleteAll => 'सब हटाएं';

  @override
  String journeysDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count यात्राएं हटाई गईं।',
      one: '1 यात्रा हटाई गई।',
    );
    return '$_temp0';
  }

  @override
  String get couldNotDeleteJourneys =>
      'आपकी यात्राएं हटाई नहीं जा सकीं। फिर से कोशिश करें।';

  @override
  String get journeyHistory => 'यात्रा इतिहास';

  @override
  String get planNewJourney => 'नई यात्रा प्लान करें';

  @override
  String get noPastJourneys => 'अभी कोई पिछली यात्रा नहीं';

  @override
  String get noPastJourneysHint => 'यात्रा पूरी करने के बाद वह यहां दिखेगी।';

  @override
  String get journey => 'यात्रा';

  @override
  String get completed => 'पूरी हुई';

  @override
  String get checkInOverdue => 'चेक-इन में देर';

  @override
  String get checkInDueNow => 'अभी चेक-इन करें';

  @override
  String get journeyActive => 'यात्रा चालू है';

  @override
  String journeyActiveAt(String place) {
    return 'यात्रा चालू है · $place';
  }

  @override
  String get circleColon => 'सर्कल:';

  @override
  String get checkIns => 'चेक-इन';

  @override
  String get endJourney => 'यात्रा खत्म करें';

  @override
  String get getMeOut => 'मुझे यहां से निकालो';

  @override
  String get messages => 'मैसेज';

  @override
  String get overdue => 'देर हो गई';

  @override
  String get dueNow => 'अभी';

  @override
  String get confirmed => 'पुष्टि हुई';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get upcoming => 'आने वाला';

  @override
  String get missedCheckInTitle => 'आपका एक चेक-इन छूट गया';

  @override
  String get checkInDueTitle => 'चेक-इन का समय — क्या आप सुरक्षित हैं?';

  @override
  String missedCheckInBody(String label, String time) {
    return '$label · $time। आपके सर्कल को अलर्ट भेजा गया है — अभी पुष्टि करें ताकि उन्हें पता चले कि आप ठीक हैं।';
  }

  @override
  String confirmWithinBody(int minutes) {
    return '$minutes मिनट में पुष्टि करें, वरना आपके सर्कल को अलर्ट भेजा जाएगा।';
  }

  @override
  String get pickOneAlert => 'कम से कम एक अलर्ट चुनें।';

  @override
  String get waitingForLocation =>
      'लोकेशन का इंतज़ार है — थोड़ी देर में फिर कोशिश करें।';

  @override
  String get newPlace => 'नई जगह';

  @override
  String placeAdded(String name) {
    return '$name जोड़ा गया · सर्कल को अलर्ट मिलेगा';
  }

  @override
  String get couldNotSavePlace => 'जगह सेव नहीं हो सकी। फिर से कोशिश करें।';

  @override
  String deleteNamedQuestion(String name) {
    return '$name हटाएं?';
  }

  @override
  String get deletePlaceBody =>
      'यहां आने-जाने पर आपके सर्कल को अब अलर्ट नहीं मिलेगा।';

  @override
  String get deletePlace => 'जगह हटाएं';

  @override
  String get editPlace => 'जगह बदलें';

  @override
  String get placeNameExample => 'जैसे: जिम, नानी का घर';

  @override
  String get gettingLocation => 'आपकी लोकेशन ली जा रही है…';

  @override
  String get noLocationYet => 'अभी कोई लोकेशन नहीं';

  @override
  String get useCurrentLocation => 'मेरी मौजूदा लोकेशन इस्तेमाल करें';

  @override
  String get alertRadius => 'अलर्ट का दायरा';

  @override
  String get arrives => 'पहुंचने पर';

  @override
  String get leaves => 'जाने पर';

  @override
  String get savePlace => 'जगह सेव करें';

  @override
  String get you => 'आप';

  @override
  String get locating => 'लोकेशन ढूंढ रहे हैं…';

  @override
  String tripHistoryToday(String today) {
    return 'सफ़र इतिहास · $today';
  }

  @override
  String get pauseSharing => 'शेयर करना रोकें';

  @override
  String get resumeSharing => 'शेयर करना फिर शुरू करें';

  @override
  String get call => 'कॉल करें';

  @override
  String get message => 'मैसेज';

  @override
  String get sharingAgain => 'आपकी लाइव लोकेशन फिर से शेयर हो रही है।';

  @override
  String get locationOffOnPhone =>
      'इस फ़ोन पर लोकेशन बंद है — सेटिंग में चालू करें।';

  @override
  String get pauseSharingQuestion => 'लोकेशन शेयर करना रोकें?';

  @override
  String get pauseSharingBody =>
      'फिर से शुरू करने तक आपका सर्कल नहीं देख पाएगा कि आप कहां हैं। यात्राएं, चेक-इन और SOS काम करते रहेंगे।';

  @override
  String get pause => 'रोकें';

  @override
  String get sharingPaused => 'लोकेशन शेयर करना रोक दिया गया।';

  @override
  String get charging => 'चार्ज हो रहा है';

  @override
  String get lowBattery => 'बैटरी कम है';

  @override
  String get battery => 'बैटरी';

  @override
  String get alertResolvedReturning => 'अलर्ट हल हो गया — होम पर लौट रहे हैं…';

  @override
  String get markedResolved => 'हल हुआ चिह्नित किया';

  @override
  String youConfirmedSafe(String name) {
    return 'आपने पुष्टि की कि $name सुरक्षित हैं · अभी';
  }

  @override
  String get liveLocation => 'लाइव लोकेशन';

  @override
  String get updating => 'अपडेट हो रहा है';

  @override
  String get atTimeOfAlert => 'अलर्ट के समय';

  @override
  String get locationUnavailable => 'लोकेशन उपलब्ध नहीं';

  @override
  String get pinnedOnMap => 'मैप पर पिन किया गया';

  @override
  String get noPositionShared => 'कोई लोकेशन शेयर नहीं हुई';

  @override
  String get lastRecordedCheckIn => 'आखिरी दर्ज चेक-इन';

  @override
  String callName(String name) {
    return '$name को कॉल करें';
  }

  @override
  String get openInMaps => 'मैप में खोलें';

  @override
  String get reopenAlert => 'अलर्ट फिर से खोलें';

  @override
  String get markAsResolved => 'हल हुआ चिह्नित करें';

  @override
  String get tripHistoryEyebrow => 'सफ़र इतिहास';

  @override
  String get yourTrips => 'आपके सफ़र';

  @override
  String namesTrips(String name) {
    return '$name के सफ़र';
  }

  @override
  String get noTripsThisWeek => 'इस हफ़्ते कोई सफ़र नहीं';

  @override
  String weekSummary(String miles, String speed) {
    return '$miles मील · सबसे तेज़ रफ़्तार $speed';
  }

  @override
  String allTripsCount(int count) {
    return 'सभी सफ़र $count';
  }

  @override
  String overSpeedCount(String speed, int count) {
    return '$speed से ज़्यादा $count';
  }

  @override
  String tripsRecordedYou(int meters, int minutes) {
    return 'जब भी आप $meters मी के दायरे से बाहर जाते हैं, सफ़र अपने-आप दर्ज होता है और $minutes मिनट रुकने के बाद खत्म होता है।';
  }

  @override
  String tripsRecordedName(String name, int meters, int minutes) {
    return 'जब भी $name $meters मी के दायरे से बाहर जाते हैं, सफ़र अपने-आप दर्ज होता है और $minutes मिनट रुकने के बाद खत्म होता है।';
  }

  @override
  String get noTripsRecorded => 'इस हफ़्ते कोई सफ़र दर्ज नहीं हुआ।';

  @override
  String get noTripsMatch => 'इस फ़िल्टर से कोई सफ़र मेल नहीं खाता।';

  @override
  String get thisWeek => 'इस हफ़्ते';

  @override
  String get lastWeek => 'पिछले हफ़्ते';

  @override
  String sinceDay(String day) {
    return '$day से';
  }

  @override
  String get tripsPerWeek => 'हर हफ़्ते के सफ़र';

  @override
  String get thisWeekShort => 'इस\nहफ़्ते';

  @override
  String get lastWeekShort => 'पिछले\nहफ़्ते';

  @override
  String get termsServiceTitle => '1. सेवा';

  @override
  String get termsServiceBody =>
      'SafeCircle आपको अपनी प्लान की गई यात्राएं और चेक-इन भरोसेमंद लोगों के साथ शेयर करने में मदद करता है। यह आपातकालीन सेवाओं की मदद करता है — उनकी जगह कभी नहीं लेता।';

  @override
  String get termsResponsibilitiesTitle => '2. आपकी ज़िम्मेदारियां';

  @override
  String get termsResponsibilitiesBody =>
      'अपना खाता, सेफ़्टी PIN और पैनिक PIN गोपनीय रखें, और सिर्फ़ उन्हीं आपातकालीन संपर्कों को जोड़ें जिन्होंने आपकी ओर से अलर्ट पाने के लिए हामी भरी है।';

  @override
  String get termsAlertsTitle => '3. अलर्ट';

  @override
  String get termsAlertsBody =>
      'अलर्ट आपके डिवाइस के कनेक्शन और लोकेशन अनुमतियों पर निर्भर करते हैं। जान के खतरे की स्थिति में हमेशा पहले स्थानीय आपातकालीन सेवाओं से संपर्क करें।';

  @override
  String get privacyCollectTitle => 'हम क्या जानकारी लेते हैं';

  @override
  String get privacyCollectBody =>
      'आपकी प्रोफ़ाइल जानकारी, यात्रा प्लान, चेक-इन की पुष्टि और — सिर्फ़ यात्रा चालू रहने पर — आपकी लोकेशन।';

  @override
  String get privacyWhoTitle => 'इसे कौन देख सकता है';

  @override
  String get privacyWhoBody =>
      'सिर्फ़ वे सर्कल और आपातकालीन संपर्क जिन्हें आप चुनते हैं। आपकी लोकेशन कभी बेची नहीं जाती और न ही विज्ञापनदाताओं के साथ शेयर की जाती है।';

  @override
  String get privacyControlTitle => 'आपका नियंत्रण';

  @override
  String get privacyControlBody =>
      'आप कभी भी शेयर करना बंद कर सकते हैं, और खाता हटाने से आपके सर्कल और यात्रा इतिहास हमेशा के लिए मिट जाते हैं।';

  @override
  String get lastUpdatedJune2026 => 'आखिरी अपडेट · जून 2026';

  @override
  String get allCheckInsConfirmed =>
      'सभी चेक-इन की पुष्टि हो गई — पहुंचने पर यात्रा खत्म करें';

  @override
  String labelCheckInOverdue(String label) {
    return '\"$label\" चेक-इन में देर — आपके सर्कल को अलर्ट भेजा गया है';
  }

  @override
  String labelCheckInDueNow(String label) {
    return '\"$label\" चेक-इन का समय — पुष्टि करें कि आप सुरक्षित हैं';
  }

  @override
  String nextCheckInLabel(String label, String time) {
    return 'अगला चेक-इन: $label · $time';
  }

  @override
  String yourJourneyWith(String circle) {
    return 'आपकी यात्रा · $circle';
  }

  @override
  String get noActiveFriendJourneys =>
      'अभी आपके किसी दोस्त की कोई यात्रा चालू नहीं है';

  @override
  String get nextCheckInPrefix => 'अगला चेक-इन: ';

  @override
  String get panicAlert => 'पैनिक अलर्ट';

  @override
  String get checkInDuePrefix => 'चेक-इन का समय: ';

  @override
  String get waiting => '· इंतज़ार';

  @override
  String journeyWith(String circle) {
    return '$circle के साथ यात्रा';
  }

  @override
  String get silentAlert => 'साइलेंट अलर्ट';

  @override
  String get onTime => 'समय पर';

  @override
  String usedPanicPin(String name, String emergency) {
    return '$name ने पैनिक PIN इस्तेमाल किया — वे खतरे में हो सकते हैं। उन्हें या $emergency पर कॉल करें।';
  }

  @override
  String missedCheckInAt(String time, String name) {
    return '$time का चेक-इन छूट गया। $name से संपर्क करें।';
  }

  @override
  String aCheckInWasMissed(String name) {
    return 'एक चेक-इन छूट गया। $name से संपर्क करें।';
  }

  @override
  String get missed => 'छूटा';

  @override
  String get alertSent => 'अलर्ट भेजा गया';

  @override
  String sentJustNow(String time) {
    return '$time · अभी';
  }

  @override
  String get locationShared => 'लोकेशन शेयर हुई';

  @override
  String get enableLocationToShare =>
      'आप कहां हैं यह शेयर करने के लिए लोकेशन चालू करें';

  @override
  String get live => 'लाइव';

  @override
  String alertedInApp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ऐप में अलर्ट भेजा गया · $count लोग',
      one: 'ऐप में अलर्ट भेजा गया · 1 व्यक्ति',
    );
    return '$_temp0';
  }

  @override
  String get noOneToAlert => 'SafeCircle पर अलर्ट भेजने के लिए अभी कोई नहीं है';

  @override
  String get textMyLocation => 'संपर्कों को मेरी लोकेशन SMS करें';

  @override
  String get emergencySmsNoLocation =>
      'आपातकाल — मुझे मदद चाहिए। SafeCircle से भेजा गया।';

  @override
  String emergencySmsWithLocation(String link, String place) {
    return 'आपातकाल — मुझे मदद चाहिए। मेरी लोकेशन: $link ($place)';
  }

  @override
  String alsoCall(String number) {
    return '$number पर भी कॉल करें';
  }

  @override
  String get cancelAlertSafe => 'अलर्ट रद्द करें — मैं सुरक्षित हूं';

  @override
  String get callOrTextToCheck => 'पक्का करने के लिए कॉल या मैसेज करें';

  @override
  String get newJourney => 'नई यात्रा';

  @override
  String get newJourneyHint =>
      'तय करें कि आप कब चेक-इन करेंगे। अगर कोई छूट गया, तो आपके सर्कल को अलर्ट मिलेगा।';

  @override
  String get selectTiming => 'समय चुनें';

  @override
  String get otherInformation => 'अन्य जानकारी';

  @override
  String get journeyNoteExample => 'कैफ़े में मुलाकात';

  @override
  String get addCheckIn => 'चेक-इन जोड़ें';

  @override
  String get startJourney => 'यात्रा शुरू करें';

  @override
  String get pickTimeOneMinute => 'अभी से कम से कम 1 मिनट बाद का समय चुनें।';

  @override
  String textInvitationsSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लोगों को SMS से आमंत्रण भेजा गया।',
      one: '1 व्यक्ति को SMS से आमंत्रण भेजा गया।',
    );
    return '$_temp0';
  }

  @override
  String noAccountYetFor(String emails) {
    return 'इनका अभी SafeCircle खाता नहीं है: $emails';
  }

  @override
  String get couldNotSaveCircle => 'सर्कल सेव नहीं हो सका। फिर से कोशिश करें।';

  @override
  String get addParticipants => 'सदस्य जोड़ें';

  @override
  String get addingTo => 'इसमें जोड़ रहे हैं: ';

  @override
  String get addingToHint =>
      '। सदस्य अपने SafeCircle खाते के ईमेल से जुड़ते हैं — इसी से वे आपकी यात्राएं देख पाते हैं।';

  @override
  String get saveParticipant => 'सदस्य सेव करें';

  @override
  String get add => 'जोड़ें';

  @override
  String participantsCount(int count) {
    return 'सदस्य · $count';
  }

  @override
  String get noParticipantsYet => 'अभी कोई सदस्य नहीं';

  @override
  String get saveCircle => 'सर्कल सेव करें';

  @override
  String get createCircle => 'सर्कल बनाएं';

  @override
  String resendAlreadyJoined(String name) {
    return '$name इस सर्कल से पहले ही जुड़ चुके हैं।';
  }

  @override
  String resendTexted(String name) {
    return '$name को फिर से SMS से आमंत्रण भेजा गया।';
  }

  @override
  String resendTooSoon(String name, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other:
          'आपने अभी-अभी $name को SMS भेजा है। $minutes मिनट बाद फिर कोशिश करें।',
      one: 'आपने अभी-अभी $name को SMS भेजा है। 1 मिनट बाद फिर कोशिश करें।',
    );
    return '$_temp0';
  }

  @override
  String get resendLimited => 'रोज़ की SMS सीमा पूरी हो गई। कल फिर कोशिश करें।';

  @override
  String resendFailed(String name) {
    return '$name को SMS नहीं भेजा जा सका।';
  }

  @override
  String resendFailedInAppWaiting(String name) {
    return '$name को SMS नहीं भेजा जा सका। ऐप वाला आमंत्रण अब भी उनका इंतज़ार कर रहा है।';
  }

  @override
  String resendInApp(String name) {
    return '$name को ऐप में फिर से आमंत्रण भेजा गया।';
  }

  @override
  String resendNoAccount(String name) {
    return '$name का अभी SafeCircle खाता नहीं है। SMS भेजने के लिए फ़ोन नंबर जोड़ें।';
  }

  @override
  String circleNotifiedNextAt(String time) {
    return 'आपके सर्कल को सूचना दे दी गई है। अगला चेक-इन $time पर।';
  }

  @override
  String get allCheckedIn => 'इस यात्रा के सभी चेक-इन हो गए। सफ़र शुभ हो।';

  @override
  String get checkInConfirmed => 'चेक-इन की पुष्टि हो गई!';

  @override
  String get backToJourney => 'यात्रा पर वापस जाएं';

  @override
  String get journeyFinished => 'यात्रा खत्म हुई';

  @override
  String get journeyFinishedHint =>
      'आप सुरक्षित हैं और आपके सर्कल को बता दिया गया है कि आप पहुंच गए।';

  @override
  String get backHome => 'होम पर वापस';

  @override
  String get emergencyContacts => 'आपातकालीन संपर्क';

  @override
  String get emergencyContactsHint =>
      'हर अलर्ट पर उन्हें आपकी लोकेशन के साथ SMS मिलता है, और अगर वे SafeCircle इस्तेमाल करते हैं तो ऐप में सूचना भी।';

  @override
  String get addTwoContacts =>
      'यात्रा शुरू करने के लिए कम से कम 2 आपातकालीन संपर्क जोड़ें।';

  @override
  String alwaysAlerted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हमेशा अलर्ट · $count संपर्क',
      one: 'हमेशा अलर्ट · 1 संपर्क',
    );
    return '$_temp0';
  }

  @override
  String get removeContactBody =>
      'आपके SOS भेजने पर अब उन्हें अलर्ट नहीं मिलेगा।';

  @override
  String get removeContact => 'संपर्क हटाएं';

  @override
  String get addEmergencyContact => 'आपातकालीन संपर्क जोड़ें';

  @override
  String get noPhoneNumber => 'कोई फ़ोन नंबर उपलब्ध नहीं है।';

  @override
  String get couldNotOpenDialer => 'डायलर नहीं खुल सका।';

  @override
  String get couldNotOpenMessages => 'मैसेज नहीं खुल सके।';

  @override
  String get noPhoneNumbers => 'कोई फ़ोन नंबर उपलब्ध नहीं है।';

  @override
  String get noLocationYetShort => 'अभी कोई लोकेशन उपलब्ध नहीं है।';

  @override
  String get couldNotOpenMaps => 'मैप ऐप नहीं खुल सका।';

  @override
  String replayOf(String day) {
    return '$day · रीप्ले';
  }

  @override
  String tripSummaryTop(
      String start, String end, String distance, String speed) {
    return '$start – $end · $distance · सबसे तेज़ $speed';
  }

  @override
  String get metricTime => 'समय';

  @override
  String get metricSpeed => 'रफ़्तार';

  @override
  String get metricDistance => 'दूरी';

  @override
  String get unitMph => ' mph';

  @override
  String get unitMi => ' मील';

  @override
  String leftPlace(String place) {
    return '$place से निकले';
  }

  @override
  String get theStart => 'शुरुआती जगह';

  @override
  String speedingOver(String speed) {
    return 'तेज़ रफ़्तार · $speed से ज़्यादा';
  }

  @override
  String arrivedAt(String place) {
    return '$place पहुंचे';
  }

  @override
  String get theEnd => 'मंज़िल';

  @override
  String get editProfileSub => 'नाम, फ़ोटो और निजी जानकारी';

  @override
  String get myEmergencyContacts => 'मेरे आपातकालीन संपर्क';

  @override
  String peopleWillBeAlerted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लोगों को अलर्ट मिलेगा',
      one: '1 व्यक्ति को अलर्ट मिलेगा',
    );
    return '$_temp0';
  }

  @override
  String get myCircles => 'मेरे सर्कल';

  @override
  String completedJourneys(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count यात्राएं पूरी हुईं',
      one: '1 यात्रा पूरी हुई',
    );
    return '$_temp0';
  }

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get me => 'मैं';

  @override
  String get couldNotUpdatePhoto => 'फ़ोटो अपडेट नहीं हो सकी।';

  @override
  String get waitingFirstUpdate => 'पहले अपडेट का इंतज़ार';

  @override
  String get liveUpdatedJustNow => 'लाइव · अभी अपडेट हुआ';

  @override
  String updatedMinAgo(int minutes) {
    return '$minutes मिनट पहले अपडेट हुआ';
  }

  @override
  String get noRecentUpdate => 'हाल में कोई अपडेट नहीं';

  @override
  String get moving => 'चल रहे हैं';

  @override
  String movingAt(String speed) {
    return 'चल रहे हैं · $speed';
  }

  @override
  String get stopped => 'रुके हुए';

  @override
  String atPlaceSince(String time) {
    return '$time से इस जगह पर';
  }

  @override
  String friendsNeedAttention(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दोस्तों पर ध्यान देना है',
      one: '1 दोस्त पर ध्यान देना है',
    );
    return '$_temp0';
  }

  @override
  String namesCheckInDue(String name) {
    return '$name के चेक-इन का समय है';
  }

  @override
  String checkInsAreDue(int count) {
    return '$count चेक-इन का समय है';
  }

  @override
  String friendsOnJourney(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दोस्त यात्रा पर',
      one: '1 दोस्त यात्रा पर',
    );
    return '$_temp0';
  }

  @override
  String get whosWatching => 'कौन नज़र रखेगा?';

  @override
  String get pickCircleHint => 'वह सर्कल चुनें जो इस यात्रा पर नज़र रखेगा।';

  @override
  String get nobodyAcceptedYet =>
      'इस सर्कल में अभी किसी ने आमंत्रण स्वीकार नहीं किया है, इसलिए कोई यह यात्रा नहीं देख पाएगा। शुरू करने से पहले किसी सदस्य के स्वीकार करने का इंतज़ार करें।';

  @override
  String get addTwoContactsBeforeStart =>
      'शुरू करने से पहले 2 आपातकालीन संपर्क जोड़ें';

  @override
  String get schedule => 'समय-सारणी';

  @override
  String get starting => 'शुरू हो रही है…';

  @override
  String get startJourneyButton => 'यात्रा शुरू करें';

  @override
  String get needCircleFirst =>
      'पहले आपको एक सर्कल चाहिए। नया बनाने के लिए नीचे सर्कल टैब पर टैप करें।';

  @override
  String peopleWatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लोग नज़र रख रहे हैं',
      one: '1 व्यक्ति नज़र रख रहा है',
    );
    return '$_temp0';
  }

  @override
  String get couldNotOpenContacts => 'आपके संपर्क नहीं खुल सके।';

  @override
  String get nameExampleContact => 'जैसे: प्रिया वर्मा';

  @override
  String get photo => 'फ़ोटो';

  @override
  String get couldNotOpenPhotos => 'फ़ोटो लाइब्रेरी नहीं खुल सकी।';

  @override
  String get photoAdded => 'फ़ोटो जोड़ी गई';

  @override
  String get addPhoto => 'फ़ोटो जोड़ें';

  @override
  String get emailRequired => 'ईमेल (ज़रूरी)';

  @override
  String get emailShouldMatch => 'ईमेल उनके खाते वाला होना चाहिए';

  @override
  String get importFromContacts => 'संपर्कों से जोड़ें';

  @override
  String circlesSummary(int circles, int members) {
    String _temp0 = intl.Intl.pluralLogic(
      circles,
      locale: localeName,
      other: '$circles सर्कल',
      one: '1 सर्कल',
    );
    String _temp1 = intl.Intl.pluralLogic(
      members,
      locale: localeName,
      other: '$members सदस्य',
      one: '1 सदस्य',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get currentPinWrong => 'मौजूदा PIN गलत है।';

  @override
  String get currentPanicPinWrong => 'मौजूदा पैनिक PIN गलत है।';

  @override
  String get newPinFourDigits => 'नए PIN में 4 अंक होने चाहिए।';

  @override
  String get mustDifferFromPanic => 'यह आपके पैनिक PIN से अलग होना चाहिए।';

  @override
  String get mustDifferFromSafety => 'यह आपके सेफ़्टी PIN से अलग होना चाहिए।';

  @override
  String get enterValidEmail => 'सही ईमेल लिखें।';

  @override
  String get enterCurrentPassword => 'अपना मौजूदा पासवर्ड लिखें।';

  @override
  String get newPasswordTooShort =>
      'नए पासवर्ड में कम से कम 6 अक्षर होने चाहिए।';

  @override
  String tripsToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आज $count सफ़र',
      one: 'आज 1 सफ़र',
    );
    return '$_temp0';
  }

  @override
  String tripsTodayMiles(int count, String miles) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आज $count सफ़र · $miles मील',
      one: 'आज 1 सफ़र · $miles मील',
    );
    return '$_temp0';
  }

  @override
  String get alertsOff => 'अलर्ट बंद';

  @override
  String get alertArriveLeave => 'पहुंचने और जाने पर अलर्ट';

  @override
  String get alertArrive => 'पहुंचने पर अलर्ट';

  @override
  String get alertLeave => 'जाने पर अलर्ट';

  @override
  String get tripStart => 'शुरुआत';

  @override
  String get tripEnd => 'मंज़िल';

  @override
  String arrivedAtPlace(String name, String place) {
    return '$name $place पहुंच गए';
  }

  @override
  String leftPlaceNamed(String name, String place) {
    return '$name $place से निकल गए';
  }

  @override
  String hasLowBattery(String name) {
    return '$name की बैटरी कम है';
  }

  @override
  String lowBatterySub(String level) {
    return '$level · लोकेशन जल्द अपडेट होना बंद हो सकती है';
  }

  @override
  String get myCirclesTitle => 'मेरे सर्कल';

  @override
  String get createNewCircle => 'नया सर्कल बनाएं';

  @override
  String get noCircleYet => 'आपने अभी कोई सर्कल नहीं बनाया है';

  @override
  String get noCircleYetHint =>
      'भरोसेमंद लोगों को एक साथ लाने और उनके साथ अपनी यात्राएं शेयर करने के लिए सर्कल बनाएं।';

  @override
  String get newCircleInvite => 'नया सर्कल आमंत्रण';

  @override
  String get newBadge => 'नया';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्य',
      one: '1 सदस्य',
    );
    return '$_temp0';
  }

  @override
  String get emergencySos => 'आपातकालीन SOS';

  @override
  String get sosHint =>
      'इससे ऐप में आपके सर्कल को अलर्ट जाता है और आपके सर्कल व आपातकालीन संपर्कों को SMS से आपकी लोकेशन भेजी जाती है।';

  @override
  String get sosNeedsContact =>
      'अलर्ट भेजने से पहले कम से कम एक आपातकालीन संपर्क जोड़ें।';

  @override
  String yourEmergencyContactsCount(int count) {
    return 'आपके आपातकालीन संपर्क · $count';
  }

  @override
  String get unavailable => 'उपलब्ध नहीं';

  @override
  String get keepHolding => 'दबाए रखें…';

  @override
  String get holdToAlert => 'अलर्ट के लिए दबाए रखें';

  @override
  String get addContactBeforeAlert =>
      'अलर्ट भेजने से पहले एक आपातकालीन संपर्क जोड़ें।';

  @override
  String get notificationChannelName => 'SafeCircle अलर्ट';

  @override
  String get notificationChannelDescription =>
      'चेक-इन रिमाइंडर और सुरक्षा अलर्ट';

  @override
  String get reminderDueTitle => 'चेक-इन का समय';

  @override
  String reminderDueBody(String label, String time) {
    return '$label · $time — SafeCircle खोलें और पुष्टि करें कि आप सुरक्षित हैं।';
  }

  @override
  String get reminderLastCallTitle => 'आखिरी मौका: अपने चेक-इन की पुष्टि करें';

  @override
  String reminderLastCallBody(String label, String time) {
    return '$label · $time — 1 मिनट में आपके सर्कल को अलर्ट भेजा जाएगा।';
  }

  @override
  String get testNotificationTitle => 'SafeCircle सूचनाएं काम कर रही हैं';

  @override
  String get testNotificationBody =>
      'चेक-इन, देर करने वाले दोस्तों और आपातकाल के लिए आपको इसी तरह अलर्ट मिलेगा।';

  @override
  String get circleInvite => 'सर्कल आमंत्रण';

  @override
  String inviteNotificationBody(String summary) {
    return '$summary — स्वीकार करने के लिए SafeCircle खोलें।';
  }

  @override
  String get speedAlertTitle => 'आपके पिछले सफ़र में तेज़ रफ़्तार';

  @override
  String speedAlertBody(String trip, String speed) {
    return '$trip · सबसे तेज़ $speed';
  }

  @override
  String get checkIn => 'चेक-इन';

  @override
  String checkInOverdueReachOut(String label) {
    return '$label में देर हो गई — संपर्क करें।';
  }

  @override
  String get places => 'जगहें';

  @override
  String get placesHint =>
      'जब कोई इन जगहों पर पहुंचता है या यहां से निकलता है, तो आपके सर्कल को अलर्ट मिलता है।';

  @override
  String get noPlacesYet =>
      'अभी कोई जगह नहीं। घर, स्कूल या दफ़्तर जोड़ें, किसी के पहुंचने पर सर्कल को पता चल जाएगा।';

  @override
  String get addPlace => 'जगह जोड़ें';

  @override
  String get savedLocation => 'सेव की गई जगह';

  @override
  String get couldNotUpdatePlace => 'जगह अपडेट नहीं हो सकी।';

  @override
  String get sharingPausedBanner => 'आपकी लोकेशन शेयरिंग रुकी हुई है';

  @override
  String get turnOnLocation => 'अपनी लोकेशन चालू करें';

  @override
  String get sharingPausedBannerSub =>
      'आपका सर्कल नहीं देख पा रहा कि आप कहां हैं। फिर शुरू करने के लिए टैप करें।';

  @override
  String get turnOnLocationSub =>
      'आपका सर्कल अभी आपको नहीं देख पा रहा। लोकेशन की अनुमति देने के लिए टैप करें।';

  @override
  String get noOneSharing => 'अभी कोई शेयर नहीं कर रहा';

  @override
  String get noOneSharingHint =>
      'भरोसेमंद लोगों को सर्कल में आमंत्रित करें। जुड़ने और लोकेशन शेयर करने वाले सभी लोग यहां दिखेंगे।';

  @override
  String get goToCircles => 'सर्कल पर जाएं';

  @override
  String get firstCheckIn => 'पहला चेक-इन';

  @override
  String get secondCheckIn => 'दूसरा चेक-इन';

  @override
  String get checkOut => 'चेक-आउट';

  @override
  String numberedCheckIn(int number) {
    return 'चेक-इन $number';
  }

  @override
  String couldNotJoinNoAccess(String name) {
    return 'जुड़ नहीं सके: ऐप को अभी इस सर्कल तक पहुंच नहीं है। $name से आमंत्रण फिर से भेजने को कहें।';
  }

  @override
  String get couldNotAcceptInvite =>
      'आमंत्रण स्वीकार नहीं हो सका। फिर से कोशिश करें।';

  @override
  String get circleInviteEyebrow => 'सर्कल आमंत्रण';

  @override
  String addedYouToCircle(String name, String circle) {
    return '$name ने आपको SafeCircle पर $circle सर्कल में जोड़ा है।';
  }

  @override
  String joinHint(String name) {
    return 'जुड़ने पर $name आपको अपनी यात्राएं देखने के लिए आमंत्रित कर सकेंगे, और देर होने पर आपको अलर्ट मिलेगा। आप कभी भी सर्कल छोड़ सकते हैं।';
  }

  @override
  String get joining => 'जुड़ रहे हैं…';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get decline => 'मना करें';

  @override
  String get confirmToEndJourney => 'यात्रा खत्म करने की पुष्टि करें';

  @override
  String get confirmYourCheckIn => 'अपने चेक-इन की पुष्टि करें';

  @override
  String get enterPinToEnd =>
      'यह यात्रा सुरक्षित रूप से खत्म करने के लिए अपना PIN डालें।';

  @override
  String get incorrectPin => 'PIN गलत है। फिर से कोशिश करें।';

  @override
  String get friendsJourneys => 'दोस्तों की यात्राएं';

  @override
  String get noNewNotifications => 'कोई नई सूचना नहीं।';

  @override
  String get renameCircle => 'सर्कल का नाम बदलें';

  @override
  String get nameYourCircle => 'अपने सर्कल को नाम दें';

  @override
  String get circleNameHint =>
      'एक नाम चुनें — आसानी से पहचानने के लिए इमोजी जोड़ें।';

  @override
  String get circlesName => 'सर्कल का नाम';

  @override
  String get circleNameExample => 'जैसे: 🏠 परिवार';

  @override
  String get save => 'सेव करें';

  @override
  String get locationSharingChannel => 'लोकेशन शेयरिंग';

  @override
  String get locationSharingChannelDescription =>
      'जब SafeCircle आपकी लोकेशन आपके सर्कल के साथ शेयर करता है, तब दिखता है।';

  @override
  String get sharingNotificationTitle =>
      'SafeCircle आपकी लोकेशन शेयर कर रहा है';

  @override
  String get sharingNotificationBody =>
      'आपका सर्कल देख सकता है कि आप कहां हैं।';

  @override
  String checkInInPast(String label) {
    return '\"$label\" का समय बीत चुका है — समय बदलें।';
  }

  @override
  String get journeyStartsWithoutLocation =>
      'लोकेशन उपलब्ध नहीं — यात्रा मैप पर जगह के बिना शुरू होगी।';

  @override
  String get couldNotStartJourney =>
      'यात्रा शुरू नहीं हो सकी। फिर से कोशिश करें।';

  @override
  String get createYourFirstCircle => 'अपना पहला सर्कल बनाएं';

  @override
  String get nothingNewYet => 'अभी कुछ नया नहीं।';

  @override
  String get activity => 'गतिविधि';

  @override
  String get delete => 'मिटाएं';

  @override
  String get back => 'वापस';

  @override
  String get checkConnection => 'अपना कनेक्शन जांचें और फिर कोशिश करें।';

  @override
  String get couldNotLoadThis => 'यह लोड नहीं हो सका';

  @override
  String get couldNotLoadAccount => 'हम आपका खाता लोड नहीं कर सके';

  @override
  String get checkInternet => 'अपना इंटरनेट कनेक्शन जांचें और फिर कोशिश करें।';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get createACircle => 'सर्कल बनाएं';

  @override
  String get journeysList => 'यात्राओं की सूची';

  @override
  String get couldNotSaveContact =>
      'संपर्क सेव नहीं हो सका। फिर से कोशिश करें।';

  @override
  String get editContact => 'संपर्क बदलें';

  @override
  String get addContactHint =>
      'उन्हें हर यात्रा पर, हमेशा अलर्ट मिलेगा। हम उन्हें एक बार SMS भेजकर बताएंगे कि आपने उन्हें जोड़ा है।';

  @override
  String get sharingWithCircles =>
      'आपकी लाइव लोकेशन आपके सर्कल के साथ शेयर हो रही है।';

  @override
  String get locationOffEnable =>
      'लोकेशन बंद है — अपनी जगह शेयर करने के लिए इसे चालू करें।';

  @override
  String get positionNotShared => 'आपकी लोकेशन अभी शेयर नहीं हो रही है।';

  @override
  String get tabMap => 'मैप';

  @override
  String get tabJourneys => 'यात्राएं';

  @override
  String get tabEmergency => 'आपातकाल';

  @override
  String get tabProfile => 'प्रोफ़ाइल';

  @override
  String get planAJourney => 'यात्रा प्लान करें';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get addYourFirstCircle => 'अपना पहला सर्कल जोड़ें';

  @override
  String get resendInvitation => 'आमंत्रण फिर से भेजें';

  @override
  String get locationNotSharedYet => 'लोकेशन अभी शेयर नहीं हुई';

  @override
  String get couldNotSendAlert =>
      'अलर्ट नहीं भेजा जा सका। अपना कनेक्शन जांचें और फिर कोशिश करें।';

  @override
  String get journeys => 'यात्राएं';

  @override
  String overSpeed(String speed) {
    return '$speed से ज़्यादा';
  }

  @override
  String get withinLimit => 'सीमा के अंदर';

  @override
  String friendsNeedAttentionActive(int count, int active) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दोस्तों पर ध्यान देना है',
      one: '1 दोस्त पर ध्यान देना है',
    );
    return '$_temp0 · $active चालू';
  }

  @override
  String friendsOnJourneyNow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'अभी $count दोस्त यात्रा पर हैं',
      one: 'अभी 1 दोस्त यात्रा पर है',
    );
    return '$_temp0';
  }

  @override
  String get countryUS => 'संयुक्त राज्य अमेरिका';

  @override
  String get countryBR => 'ब्राज़ील';

  @override
  String get countryPT => 'पुर्तगाल';

  @override
  String get countryGB => 'यूनाइटेड किंगडम';

  @override
  String get countryES => 'स्पेन';

  @override
  String get countryAR => 'अर्जेंटीना';

  @override
  String get countryFR => 'फ़्रांस';

  @override
  String get countryMX => 'मेक्सिको';

  @override
  String get countryCN => 'चीन';

  @override
  String get countryIN => 'भारत';

  @override
  String get enterPinToPause => 'रोकने के लिए अपना PIN डालें।';

  @override
  String get smsConsentLabel =>
      'इस व्यक्ति ने इस नंबर पर SafeCircle के संदेश (आमंत्रण और सुरक्षा अलर्ट) पाने की सहमति दी है। संदेश और डेटा शुल्क लग सकते हैं। वे सदस्यता छोड़ने के लिए STOP लिखकर जवाब दे सकते हैं।';

  @override
  String get profilePhoneSmsNote =>
      'अपना नंबर जोड़कर, आप अपने सर्कल के सुरक्षा अलर्ट के बारे में SafeCircle के संदेश पाने के लिए सहमत होते हैं। संदेश और डेटा शुल्क लग सकते हैं। सदस्यता छोड़ने के लिए STOP लिखकर जवाब दें।';

  @override
  String get privacySmsTitle => 'टेक्स्ट संदेश';

  @override
  String get privacySmsBody =>
      'हम किसी नंबर पर संदेश तभी भेजते हैं जब व्यक्ति ने सहमति दी हो, और केवल सर्कल आमंत्रण और सुरक्षा अलर्ट के लिए — कभी मार्केटिंग के लिए नहीं। मोबाइल नंबर और सहमति कभी भी मार्केटिंग के लिए तीसरे पक्ष या सहयोगियों को बेचे या साझा नहीं किए जाते। सदस्यता छोड़ने के लिए किसी भी संदेश का जवाब STOP से दें, या मदद के लिए HELP लिखें।';

  @override
  String resendNoConsent(String name) {
    return '$name ने अभी तक संदेश पाने की सहमति नहीं दी है। सहमति मिलने पर, उनकी जानकारी संपादित करें और संदेश वाला बॉक्स चुनें।';
  }

  @override
  String inviteShareMessage(String circle, String link, String email) {
    return 'मैंने आपको अपने SafeCircle सर्कल \"$circle\" में जोड़ा है ताकि हम एक-दूसरे का ध्यान रख सकें। ऐप डाउनलोड करें: $link और जुड़ने के लिए $email से साइन अप करें।';
  }

  @override
  String inviteShareMessageNoEmail(String circle, String link) {
    return 'मैंने आपको अपने SafeCircle सर्कल \"$circle\" में जोड़ा है ताकि हम एक-दूसरे का ध्यान रख सकें। जुड़ने के लिए ऐप डाउनलोड करें: $link';
  }

  @override
  String get inviteShareSubject => 'मेरे SafeCircle सर्कल से जुड़ें';

  @override
  String participantSavedTo(String circle) {
    return '$circle में सहेजा गया';
  }

  @override
  String participantRemovedFrom(String circle) {
    return '$circle से हटाया गया';
  }

  @override
  String notOnSafeCircleYet(String name) {
    return '$name अभी SafeCircle पर नहीं हैं';
  }

  @override
  String get inviteByTextBody =>
      'क्या आप उन्हें निमंत्रण भेजना चाहेंगे? निमंत्रण के साथ एक टेक्स्ट मैसेज खुलेगा, भेजने के लिए तैयार।';

  @override
  String get inviteByShareBody =>
      'क्या आप उन्हें निमंत्रण भेजना चाहेंगे? भेजने का तरीका चुनें: Messages, WhatsApp, ईमेल…';

  @override
  String get sendInvitation => 'निमंत्रण भेजें';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get membershipTitle => 'अपने सर्कल को पास रखें';

  @override
  String get membershipSubtitle =>
      'SafeCircle सदस्यता वह सब अनलॉक करती है जो आपको और आपके लोगों को जोड़े रखता है।';

  @override
  String get membershipPerkMap => 'अपने सर्कल के साथ लाइव लोकेशन';

  @override
  String get membershipPerkJourneys => 'चेक-इन और देरी अलर्ट के साथ यात्राएँ';

  @override
  String get membershipPerkCircles => 'परिवार और दोस्तों के लिए सर्कल';

  @override
  String get membershipPerkAlerts =>
      'जब आपके सर्कल में किसी को मदद चाहिए तो अलर्ट';

  @override
  String membershipTrialPrice(int days, String price) {
    return '$days दिन मुफ़्त, फिर $price/महीना';
  }

  @override
  String membershipPrice(String price) {
    return '$price/महीना';
  }

  @override
  String get membershipCancelAnytime => 'कभी भी रद्द करें';

  @override
  String get membershipStartTrial => 'मुफ़्त ट्रायल शुरू करें';

  @override
  String get membershipSubscribe => 'सदस्यता लें';

  @override
  String get membershipWorking => 'एक पल…';

  @override
  String membershipFinePrintTrial(String store, int days) {
    return '$days दिन के मुफ़्त ट्रायल के बाद भुगतान आपके $store खाते से लिया जाएगा। सदस्यता हर महीने अपने-आप नवीनीकृत होती है, जब तक कि मौजूदा अवधि खत्म होने से कम से कम 24 घंटे पहले रद्द न की जाए। इसे अपने $store खाते की सेटिंग में प्रबंधित या रद्द करें।';
  }

  @override
  String membershipFinePrint(String store) {
    return 'भुगतान आपके $store खाते से लिया जाता है। सदस्यता हर महीने अपने-आप नवीनीकृत होती है, जब तक कि मौजूदा अवधि खत्म होने से कम से कम 24 घंटे पहले रद्द न की जाए। इसे अपने $store खाते की सेटिंग में प्रबंधित या रद्द करें।';
  }

  @override
  String get membershipStoreApple => 'Apple ID';

  @override
  String get membershipStoreGoogle => 'Google Play';

  @override
  String get membershipUnavailable =>
      'सदस्यता अभी लोड नहीं हो सकी। अपना कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get membershipRestore => 'खरीदारी बहाल करें';

  @override
  String get membershipSosFree =>
      'SOS हमेशा काम करता है, सदस्यता के बिना भी: आपके सर्कल और आपातकालीन संपर्कों को फिर भी अलर्ट मिलता है।';

  @override
  String get membershipOpenSos => 'SOS खोलें';

  @override
  String get membershipPauseSharing => 'लोकेशन शेयरिंग रोकें';

  @override
  String get membershipWelcome => 'SafeCircle में आपका स्वागत है!';

  @override
  String get membershipNothingToRestore =>
      'इस खाते के लिए कोई सदस्यता नहीं मिली।';

  @override
  String get membershipPurchaseFailed =>
      'खरीदारी पूरी नहीं हुई। कृपया फिर से कोशिश करें।';

  @override
  String get membershipLabel => 'सदस्यता';

  @override
  String get membershipActiveSub => 'सक्रिय · प्रबंधित या रद्द करें';

  @override
  String get membershipInactiveSub =>
      'निष्क्रिय · अपना मुफ़्त ट्रायल शुरू करें';

  @override
  String get termsMembershipTitle => '4. सदस्यता';

  @override
  String get termsMembershipBody =>
      'SafeCircle के ज़्यादातर हिस्से के लिए मासिक सदस्यता चाहिए; SOS हमेशा मुफ़्त है। नए सदस्यों को मुफ़्त ट्रायल मिलता है। सदस्यता App Store या Google Play के ज़रिए अपने-आप नवीनीकृत होती है, जब तक कि आप मौजूदा अवधि खत्म होने से कम से कम 24 घंटे पहले वहाँ इसे रद्द न करें। सदस्यता लेने पर बचा हुआ ट्रायल समय खत्म हो जाता है।';
}
