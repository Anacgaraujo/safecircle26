// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'SafeCircle';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get tomorrow => 'Demain';

  @override
  String get alertKindPanic => 'Panique silencieuse';

  @override
  String get alertKindOverdue => 'Pointage manqué';

  @override
  String get alertKindSos => 'SOS';

  @override
  String alertHeadlineOverdue(String name) {
    return '$name a manqué un pointage';
  }

  @override
  String alertHeadlineHelp(String name) {
    return '$name a besoin d\'aide';
  }

  @override
  String get someone => 'Quelqu\'un';

  @override
  String get aCircle => 'un cercle';

  @override
  String inviteSummary(String name, String circle) {
    return '$name vous a invité à $circle';
  }

  @override
  String get circleOwner => 'Propriétaire du cercle';

  @override
  String lastSeenAt(String time) {
    return 'Vu pour la dernière fois à $time';
  }

  @override
  String get enterYourName => 'Saisissez votre nom.';

  @override
  String get enterYourEmail => 'Saisissez votre e-mail.';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères.';

  @override
  String get passwordsDontMatch => 'Les mots de passe ne correspondent pas.';

  @override
  String get enterEmailAndPassword =>
      'Saisissez votre e-mail et votre mot de passe.';

  @override
  String get recoveryLinkSent =>
      'Lien de récupération envoyé. Consultez votre boîte de réception.';

  @override
  String get couldNotSavePins =>
      'Impossible d\'enregistrer vos codes PIN. Réessayez.';

  @override
  String get welcomeTo => 'Bienvenue sur';

  @override
  String get welcomeTagline =>
      'Créez un cercle de confiance pour que quelqu\'un sache toujours que vous êtes en sécurité.';

  @override
  String get start => 'Commencer';

  @override
  String get skipIntro => 'Passer l\'introduction';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get joinInSeconds => 'Rejoignez SafeCircle en quelques secondes.';

  @override
  String get name => 'Nom';

  @override
  String get nameExample => 'ex. Alex Morgan';

  @override
  String get email => 'E-mail';

  @override
  String get emailExample => 'nom@exemple.com';

  @override
  String get phone => 'Téléphone';

  @override
  String get password => 'Mot de passe';

  @override
  String get repeatPassword => 'Répétez le mot de passe';

  @override
  String get creatingAccount => 'Création du compte…';

  @override
  String get register => 'S\'inscrire';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get login => 'Se connecter';

  @override
  String get loginTagline =>
      'Quelqu\'un sait toujours que vous êtes en sécurité.';

  @override
  String get forgotPassword => 'Oublié ?';

  @override
  String get loggingIn => 'Connexion…';

  @override
  String get orLoginWith => 'Ou connectez-vous avec...';

  @override
  String get noAccountYet => 'Pas encore de compte ? ';

  @override
  String get registerExclaim => 'Inscrivez-vous !';

  @override
  String get socialLoginSoon =>
      'Connexion via réseaux sociaux bientôt disponible.';

  @override
  String get recoverPassword => 'Récupérer le mot de passe';

  @override
  String get recoverPasswordHint =>
      'Saisissez l\'e-mail associé à votre compte et nous vous enverrons un lien sécurisé pour réinitialiser votre mot de passe.';

  @override
  String get sending => 'Envoi…';

  @override
  String stepOf(int step, int total) {
    return 'ÉTAPE $step SUR $total';
  }

  @override
  String get setPanicPin => 'Définissez votre PIN de panique';

  @override
  String get setSafetyPin => 'Définissez votre PIN de sécurité';

  @override
  String get panicPinHint =>
      'Si on vous force à ouvrir l\'app, saisissez ce PIN. L\'écran semble normal, mais votre cercle est alerté en silence.';

  @override
  String get safetyPinHint =>
      'Utilisez ce PIN pour confirmer que vous êtes en sécurité lors des pointages.';

  @override
  String get panicPinMatchesSafety =>
      'Il est identique à votre PIN de sécurité. Choisissez un autre code.';

  @override
  String get panicPinMustDiffer =>
      'Doit être différent de votre PIN de sécurité.';

  @override
  String get saving => 'Enregistrement…';

  @override
  String get finish => 'Terminer';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get gettingStarted => 'PREMIERS PAS';

  @override
  String get createFirstCircle => 'Créez votre premier cercle';

  @override
  String get tapPrefix => 'Touchez ';

  @override
  String get tabCircles => 'Cercles';

  @override
  String get createFirstCircleHint =>
      ' dans la barre du bas, donnez-lui un nom et ajoutez les personnes de confiance. Elles recevront une invitation pour suivre vos trajets.';

  @override
  String get next => 'Suivant';

  @override
  String get allSet => 'Tout est prêt !';

  @override
  String get allSetHint =>
      'Votre SafeCircle est prêt. Planifiez votre premier trajet dès que vous sortez.';

  @override
  String get enterSafeCircle => 'Entrer dans SafeCircle';

  @override
  String get authInvalidEmail => 'Adresse e-mail invalide.';

  @override
  String get authEmailInUse => 'Cet e-mail est déjà enregistré.';

  @override
  String get authWeakPassword =>
      'Mot de passe trop faible (6 caractères min.).';

  @override
  String get authWrongCredentials => 'E-mail ou mot de passe incorrect.';

  @override
  String get authTooManyAttempts => 'Trop de tentatives. Réessayez plus tard.';

  @override
  String get authNetwork => 'Erreur réseau. Vérifiez votre connexion.';

  @override
  String get authReloginNeeded =>
      'Reconnectez-vous pour effectuer cette action.';

  @override
  String get authGenericError => 'Erreur d\'authentification.';

  @override
  String get somethingWentWrong => 'Un problème est survenu. Réessayez.';

  @override
  String get settings => 'Réglages';

  @override
  String get security => 'Sécurité';

  @override
  String get changeSafetyPin => 'Changer le PIN de sécurité';

  @override
  String get changeSafetyPinSub =>
      'Confirme que vous allez bien lors d\'un pointage';

  @override
  String get changePanicPin => 'Changer le PIN de panique';

  @override
  String get changePanicPinSub =>
      'Code de contrainte silencieux · envoie une alerte cachée';

  @override
  String get notifications => 'Notifications';

  @override
  String get checkInReminders => 'Rappels de pointage';

  @override
  String get checkInRemindersSub => 'Me prévenir quand un pointage est prévu';

  @override
  String get overdueCheckIns => 'Pointages en retard';

  @override
  String get overdueCheckInsSub =>
      'Quand un ami manque un pointage. Les alertes de panique et SOS sont toujours actives.';

  @override
  String get permissions => 'Autorisations';

  @override
  String get permissionsSub => 'Position, notifications, alarmes et batterie';

  @override
  String get permissionsReason =>
      'SafeCircle les utilise uniquement pour vous protéger, vous et votre cercle.';

  @override
  String get done => 'OK';

  @override
  String get sendTestNotification => 'Envoyer une notification de test';

  @override
  String get sendTestNotificationSub =>
      'Vérifiez que les alertes arrivent sur ce téléphone';

  @override
  String get testNotificationSent => 'Envoyée — regardez vos notifications.';

  @override
  String get testNotificationFailed =>
      'Envoi impossible. Vérifiez l\'autorisation des notifications dans les réglages du système.';

  @override
  String get account => 'Compte';

  @override
  String get changeEmail => 'Changer d\'e-mail';

  @override
  String get changePassword => 'Changer de mot de passe';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get logOutQuestion => 'Se déconnecter ?';

  @override
  String get logOutBody =>
      'Vous ne recevrez plus les alertes de vos cercles jusqu\'à votre prochaine connexion.';

  @override
  String get loggedOut => 'Déconnecté.';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountSub =>
      'Efface définitivement votre cercle et votre historique';

  @override
  String get deleteAccountQuestion => 'Supprimer le compte ?';

  @override
  String get deleteAccountBody =>
      'Cela efface définitivement vos cercles, vos contacts et votre historique de trajets. Action irréversible.';

  @override
  String get accountDeleted => 'Compte supprimé.';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get aboutFooter => 'SafeCircle · Conçu pour protéger votre cercle';

  @override
  String get cancel => 'Annuler';

  @override
  String get beforeYouStart => 'Avant de commencer';

  @override
  String get journeyPermissionsReason =>
      'Un trajet en a besoin pour que vos rappels de pointage sonnent à l\'heure et que votre cercle voie où vous êtes.';

  @override
  String get shareLiveLocation => 'Partagez votre position en direct';

  @override
  String get shareLiveLocationReason =>
      'Votre cercle voit où vous êtes sur la carte.';

  @override
  String get notificationsOffWarning =>
      'Vous ne serez pas prévenu des alertes — activez les notifications dans les Réglages.';

  @override
  String get almostThere => 'PRESQUE FINI';

  @override
  String get allowPermissions => 'Autoriser les accès';

  @override
  String get allowPermissionsHint =>
      'SafeCircle les utilise uniquement pour vous protéger, vous et votre cercle. Vous gardez le contrôle — modifiez-les à tout moment dans les Réglages.';

  @override
  String get locationDenied =>
      'Position refusée — activez-la dans les réglages du système.';

  @override
  String get notificationsDenied =>
      'Notifications refusées — activez-les dans les réglages du système.';

  @override
  String get turnOnAlarms =>
      'Activez « Alarmes et rappels » pour SafeCircle, puis revenez.';

  @override
  String get contactsDenied =>
      'Contacts refusés — activez-les dans les réglages du système.';

  @override
  String get location => 'Position';

  @override
  String get locationPermissionSub =>
      'Pour que votre cercle voie que vous êtes bien arrivé.';

  @override
  String get notificationsPermissionSub =>
      'Pour vous rappeler quand un pointage est prévu.';

  @override
  String get alarmsAndReminders => 'Alarmes et rappels';

  @override
  String get alarmsPermissionSub =>
      'Pour que les rappels de pointage sonnent pile à l\'heure.';

  @override
  String get backgroundActivity => 'Activité en arrière-plan (recommandé)';

  @override
  String get backgroundPermissionSub =>
      'Pour que les rappels fonctionnent même quand le téléphone est en veille.';

  @override
  String get contactsOptional => 'Contacts (facultatif)';

  @override
  String get contactsPermissionSub =>
      'Pour inviter rapidement les personnes de confiance.';

  @override
  String get locationAndNotificationsRequired =>
      'La position et les notifications sont nécessaires pour que SafeCircle vous protège.';

  @override
  String get locationRequired =>
      'La position est nécessaire pour que SafeCircle vous protège.';

  @override
  String get setUpLater => 'Configurer plus tard';

  @override
  String get openSystemSettings => 'Ouvrir les réglages du système';

  @override
  String get allowed => 'Autorisé';

  @override
  String get allow => 'Autoriser';

  @override
  String get profileUpdated => 'Profil mis à jour';

  @override
  String verificationLinkSent(String email) {
    return 'Lien de vérification envoyé à $email — confirmez-le pour changer.';
  }

  @override
  String get passwordChanged => 'Mot de passe modifié';

  @override
  String get safetyPinUpdated => 'PIN de sécurité mis à jour';

  @override
  String get panicPinUpdated => 'PIN de panique mis à jour';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get editProfileHint =>
      'Modifiez la façon dont votre cercle vous voit. Votre numéro permet à vos amis de vous appeler pendant un trajet.';

  @override
  String changeEmailHint(String email) {
    return 'Nous enverrons un lien de vérification à la nouvelle adresse. La connexion et les invitations y seront transférées après confirmation. Actuelle : $email';
  }

  @override
  String get newEmail => 'Nouvel e-mail';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get useSixCharacters => 'Utilisez au moins 6 caractères.';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmez le nouveau mot de passe';

  @override
  String get safetyPinHintShort =>
      'Ce PIN confirme que vous allez bien à chaque pointage.';

  @override
  String get currentPin => 'PIN actuel';

  @override
  String get newPin => 'Nouveau PIN';

  @override
  String get panicPinHintShort =>
      'Saisir ce PIN semble normal, mais alerte votre cercle en silence.';

  @override
  String get currentPanicPin => 'PIN de panique actuel';

  @override
  String get newPanicPin => 'Nouveau PIN de panique';

  @override
  String get fullName => 'Nom complet';

  @override
  String get saveChanges => 'Enregistrer';

  @override
  String deleteCircleQuestion(String circle) {
    return 'Supprimer $circle ?';
  }

  @override
  String get deleteCircleBody =>
      'Tous les membres de ce cercle cessent de suivre vos trajets et alertes. Action irréversible.';

  @override
  String get deleteCircle => 'Supprimer le cercle';

  @override
  String get theOwner => 'le propriétaire';

  @override
  String leaveCircleQuestion(String circle) {
    return 'Quitter $circle ?';
  }

  @override
  String leaveCircleBody(String owner) {
    return 'Vous ne suivrez plus les trajets et alertes de $owner, et ce cercle ne verra plus votre position. $owner pourra vous réinviter.';
  }

  @override
  String get leaveCircle => 'Quitter le cercle';

  @override
  String get couldNotLeaveCircle =>
      'Impossible de quitter le cercle. Réessayez.';

  @override
  String resendInvitationQuestion(String name) {
    return 'Renvoyer l\'invitation à $name ?';
  }

  @override
  String resendInvitationTextBody(String phone) {
    return 'Nous enverrons un nouveau SMS au $phone et un rappel dans l\'app.';
  }

  @override
  String get resendInvitationAppBody =>
      'Nous lui enverrons un rappel dans l\'app s\'il a SafeCircle. Sinon, vous choisirez comment lui envoyer l\'invitation.';

  @override
  String get resend => 'Renvoyer';

  @override
  String get couldNotResendInvitation =>
      'Impossible de renvoyer l\'invitation. Réessayez.';

  @override
  String removePersonQuestion(String name) {
    return 'Retirer $name ?';
  }

  @override
  String get removePersonBody =>
      'Cette personne ne suivra plus vos trajets et ne recevra plus vos alertes.';

  @override
  String get remove => 'Retirer';

  @override
  String get couldNotRemoveParticipant =>
      'Impossible de retirer le participant. Réessayez.';

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
  String get addMoreParticipants => 'Ajouter des participants';

  @override
  String get deleteThisCircle => 'Supprimer ce cercle';

  @override
  String get leaveThisCircle => 'Quitter ce cercle';

  @override
  String get deleteJourneyQuestion => 'Supprimer ce trajet ?';

  @override
  String deleteJourneyBody(String date) {
    return 'Cela retire le trajet du $date de votre historique. Action irréversible.';
  }

  @override
  String get deleteJourneyBodyNoDate =>
      'Cela retire ce trajet de votre historique. Action irréversible.';

  @override
  String get deleteJourney => 'Supprimer le trajet';

  @override
  String get couldNotDeleteJourney =>
      'Impossible de supprimer le trajet. Réessayez.';

  @override
  String get deleteAllJourneysQuestion => 'Supprimer tous les trajets ?';

  @override
  String deleteAllJourneysBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Cela retire les $count trajets de votre historique. Action irréversible.',
      one: 'Cela retire 1 trajet de votre historique. Action irréversible.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String journeysDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trajets supprimés.',
      one: '1 trajet supprimé.',
    );
    return '$_temp0';
  }

  @override
  String get couldNotDeleteJourneys =>
      'Impossible de supprimer vos trajets. Réessayez.';

  @override
  String get journeyHistory => 'Historique des trajets';

  @override
  String get planNewJourney => 'Planifier un nouveau trajet';

  @override
  String get noPastJourneys => 'Aucun trajet passé';

  @override
  String get noPastJourneysHint =>
      'Vos trajets terminés apparaîtront ici une fois le premier terminé.';

  @override
  String get journey => 'Trajet';

  @override
  String get completed => 'Terminé';

  @override
  String get checkInOverdue => 'Pointage en retard';

  @override
  String get checkInDueNow => 'Pointage maintenant';

  @override
  String get journeyActive => 'Trajet en cours';

  @override
  String journeyActiveAt(String place) {
    return 'Trajet en cours · $place';
  }

  @override
  String get circleColon => 'Cercle :';

  @override
  String get checkIns => 'Pointages';

  @override
  String get endJourney => 'Terminer le trajet';

  @override
  String get getMeOut => 'Sortez-moi de là';

  @override
  String get messages => 'Messages';

  @override
  String get overdue => 'En retard';

  @override
  String get dueNow => 'Maintenant';

  @override
  String get confirmed => 'Confirmé';

  @override
  String get confirm => 'Confirmer';

  @override
  String get upcoming => 'À venir';

  @override
  String get missedCheckInTitle => 'Vous avez manqué un pointage';

  @override
  String get checkInDueTitle => 'Pointage prévu — tout va bien ?';

  @override
  String missedCheckInBody(String label, String time) {
    return '$label · $time. Votre cercle a été alerté — confirmez maintenant pour le rassurer.';
  }

  @override
  String confirmWithinBody(int minutes) {
    return 'Confirmez dans les $minutes min, sinon votre cercle sera alerté.';
  }

  @override
  String get pickOneAlert => 'Choisissez au moins une alerte.';

  @override
  String get waitingForLocation =>
      'En attente de la position — réessayez dans un instant.';

  @override
  String get newPlace => 'Nouveau lieu';

  @override
  String placeAdded(String name) {
    return '$name ajouté · le cercle sera alerté';
  }

  @override
  String get couldNotSavePlace =>
      'Impossible d\'enregistrer le lieu. Réessayez.';

  @override
  String deleteNamedQuestion(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get deletePlaceBody =>
      'Votre cercle ne sera plus alerté des arrivées et départs ici.';

  @override
  String get deletePlace => 'Supprimer le lieu';

  @override
  String get editPlace => 'Modifier le lieu';

  @override
  String get placeNameExample => 'ex. Salle de sport, chez Mamie';

  @override
  String get gettingLocation => 'Récupération de votre position…';

  @override
  String get noLocationYet => 'Pas encore de position';

  @override
  String get useCurrentLocation => 'Utiliser ma position actuelle';

  @override
  String get alertRadius => 'RAYON D\'ALERTE';

  @override
  String get arrives => 'Arrive';

  @override
  String get leaves => 'Part';

  @override
  String get savePlace => 'Enregistrer le lieu';

  @override
  String get you => 'Vous';

  @override
  String get locating => 'Localisation…';

  @override
  String tripHistoryToday(String today) {
    return 'Historique des déplacements · $today';
  }

  @override
  String get pauseSharing => 'Suspendre le partage';

  @override
  String get resumeSharing => 'Reprendre le partage';

  @override
  String get call => 'Appeler';

  @override
  String get message => 'Message';

  @override
  String get sharingAgain =>
      'Votre position en direct est de nouveau partagée.';

  @override
  String get locationOffOnPhone =>
      'La localisation est désactivée sur ce téléphone — activez-la dans les Réglages.';

  @override
  String get pauseSharingQuestion => 'Suspendre le partage de position ?';

  @override
  String get pauseSharingBody =>
      'Votre cercle ne verra pas où vous êtes tant que vous n\'aurez pas repris. Les trajets, pointages et le SOS continuent de fonctionner.';

  @override
  String get pause => 'Suspendre';

  @override
  String get sharingPaused => 'Partage de position suspendu.';

  @override
  String get charging => 'En charge';

  @override
  String get lowBattery => 'Batterie faible';

  @override
  String get battery => 'Batterie';

  @override
  String get alertResolvedReturning => 'Alerte résolue — retour à l\'accueil…';

  @override
  String get markedResolved => 'Marquée comme résolue';

  @override
  String youConfirmedSafe(String name) {
    return 'Vous avez confirmé que $name va bien · à l\'instant';
  }

  @override
  String get liveLocation => 'Position en direct';

  @override
  String get updating => 'Mise à jour';

  @override
  String get atTimeOfAlert => 'Au moment de l\'alerte';

  @override
  String get locationUnavailable => 'Position indisponible';

  @override
  String get pinnedOnMap => 'Épinglé sur la carte';

  @override
  String get noPositionShared => 'Aucune position partagée';

  @override
  String get lastRecordedCheckIn => 'Dernier pointage enregistré';

  @override
  String callName(String name) {
    return 'Appeler $name';
  }

  @override
  String get openInMaps => 'Ouvrir dans Plans';

  @override
  String get reopenAlert => 'Rouvrir l\'alerte';

  @override
  String get markAsResolved => 'Marquer comme résolue';

  @override
  String get tripHistoryEyebrow => 'HISTORIQUE DES DÉPLACEMENTS';

  @override
  String get yourTrips => 'Vos déplacements';

  @override
  String namesTrips(String name) {
    return 'Déplacements de $name';
  }

  @override
  String get noTripsThisWeek => 'Aucun déplacement cette semaine';

  @override
  String weekSummary(String miles, String speed) {
    return '$miles mi · Vitesse max. $speed';
  }

  @override
  String allTripsCount(int count) {
    return 'Tous les déplacements $count';
  }

  @override
  String overSpeedCount(String speed, int count) {
    return 'Plus de $speed $count';
  }

  @override
  String tripsRecordedYou(int meters, int minutes) {
    return 'Les déplacements sont enregistrés automatiquement dès que vous quittez un rayon de $meters m et se terminent après $minutes minutes à l\'arrêt.';
  }

  @override
  String tripsRecordedName(String name, int meters, int minutes) {
    return 'Les déplacements sont enregistrés automatiquement dès que $name quitte un rayon de $meters m et se terminent après $minutes minutes à l\'arrêt.';
  }

  @override
  String get noTripsRecorded => 'Aucun déplacement enregistré cette semaine.';

  @override
  String get noTripsMatch => 'Aucun déplacement ne correspond à ce filtre.';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get lastWeek => 'Semaine dernière';

  @override
  String sinceDay(String day) {
    return 'Depuis $day';
  }

  @override
  String get tripsPerWeek => 'DÉPLACEMENTS PAR SEMAINE';

  @override
  String get thisWeekShort => 'Cette\nsemaine';

  @override
  String get lastWeekShort => 'Sem.\ndernière';

  @override
  String get termsServiceTitle => '1. Le service';

  @override
  String get termsServiceBody =>
      'SafeCircle vous aide à partager vos trajets prévus et vos pointages avec des personnes de confiance. Il complète — sans jamais les remplacer — les services d\'urgence.';

  @override
  String get termsResponsibilitiesTitle => '2. Vos responsabilités';

  @override
  String get termsResponsibilitiesBody =>
      'Gardez votre compte, votre PIN de sécurité et votre PIN de panique confidentiels, et n\'ajoutez que des contacts d\'urgence qui ont accepté de recevoir des alertes en votre nom.';

  @override
  String get termsAlertsTitle => '3. Alertes';

  @override
  String get termsAlertsBody =>
      'Les alertes dépendent de la connexion de votre appareil et des autorisations de localisation. En cas de danger de mort, contactez toujours d\'abord les services d\'urgence locaux.';

  @override
  String get privacyCollectTitle => 'Ce que nous collectons';

  @override
  String get privacyCollectBody =>
      'Les informations de votre profil, vos plans de trajet, vos confirmations de pointage et — uniquement pendant un trajet — votre position.';

  @override
  String get privacyWhoTitle => 'Qui peut les voir';

  @override
  String get privacyWhoBody =>
      'Uniquement les cercles et contacts d\'urgence que vous choisissez. Votre position n\'est jamais vendue ni partagée avec des annonceurs.';

  @override
  String get privacyControlTitle => 'Votre contrôle';

  @override
  String get privacyControlBody =>
      'Vous pouvez arrêter le partage à tout moment, et supprimer votre compte efface définitivement vos cercles et votre historique de trajets.';

  @override
  String get lastUpdatedJune2026 => 'Mis à jour · juin 2026';

  @override
  String get allCheckInsConfirmed =>
      'Tous les pointages confirmés — terminez le trajet à l\'arrivée';

  @override
  String labelCheckInOverdue(String label) {
    return 'Pointage « $label » en retard — votre cercle a été alerté';
  }

  @override
  String labelCheckInDueNow(String label) {
    return 'Pointage « $label » maintenant — confirmez que tout va bien';
  }

  @override
  String nextCheckInLabel(String label, String time) {
    return 'Prochain pointage : $label · $time';
  }

  @override
  String yourJourneyWith(String circle) {
    return 'Votre trajet · $circle';
  }

  @override
  String get noActiveFriendJourneys =>
      'Aucun de vos amis n\'est en trajet pour le moment';

  @override
  String get nextCheckInPrefix => 'Prochain pointage : ';

  @override
  String get panicAlert => 'Alerte panique';

  @override
  String get checkInDuePrefix => 'Pointage prévu : ';

  @override
  String get waiting => '· en attente';

  @override
  String journeyWith(String circle) {
    return 'Trajet avec $circle';
  }

  @override
  String get silentAlert => 'Alerte silencieuse';

  @override
  String get onTime => 'À l\'heure';

  @override
  String usedPanicPin(String name, String emergency) {
    return '$name a utilisé le PIN de panique — cette personne est peut-être en danger. Appelez-la ou appelez le $emergency.';
  }

  @override
  String missedCheckInAt(String time, String name) {
    return 'Pointage manqué à $time. Contactez $name.';
  }

  @override
  String aCheckInWasMissed(String name) {
    return 'Un pointage a été manqué. Contactez $name.';
  }

  @override
  String get missed => 'Manqué';

  @override
  String get alertSent => 'Alerte envoyée';

  @override
  String sentJustNow(String time) {
    return '$time · à l\'instant';
  }

  @override
  String get locationShared => 'Position partagée';

  @override
  String get enableLocationToShare =>
      'Activez la localisation pour partager où vous êtes';

  @override
  String get live => 'En direct';

  @override
  String alertedInApp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alertés dans l\'app · $count personnes',
      one: 'Alerté dans l\'app · 1 personne',
    );
    return '$_temp0';
  }

  @override
  String get noOneToAlert =>
      'Personne sur SafeCircle à alerter pour l\'instant';

  @override
  String get textMyLocation => 'Envoyer ma position par SMS à mes contacts';

  @override
  String get emergencySmsNoLocation =>
      'URGENCE — J\'ai besoin d\'aide. Envoyé depuis SafeCircle.';

  @override
  String emergencySmsWithLocation(String link, String place) {
    return 'URGENCE — J\'ai besoin d\'aide. Ma position : $link ($place)';
  }

  @override
  String alsoCall(String number) {
    return 'Appeler aussi le $number';
  }

  @override
  String get cancelAlertSafe => 'Annuler l\'alerte — je vais bien';

  @override
  String get callOrTextToCheck => 'Appelez ou écrivez pour vérifier';

  @override
  String get newJourney => 'Nouveau trajet';

  @override
  String get newJourneyHint =>
      'Planifiez vos pointages. Si vous en manquez un, votre cercle est alerté.';

  @override
  String get selectTiming => 'Choisissez les horaires';

  @override
  String get otherInformation => 'Autres informations';

  @override
  String get journeyNoteExample => 'Rendez-vous au bar';

  @override
  String get addCheckIn => 'Ajouter un pointage';

  @override
  String get startJourney => 'Démarrer le trajet';

  @override
  String get pickTimeOneMinute =>
      'Choisissez une heure au moins 1 minute à partir de maintenant.';

  @override
  String textInvitationsSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Invitation envoyée par SMS à $count personnes.',
      one: 'Invitation envoyée par SMS à 1 personne.',
    );
    return '$_temp0';
  }

  @override
  String noAccountYetFor(String emails) {
    return 'Pas encore de compte SafeCircle pour : $emails';
  }

  @override
  String get couldNotSaveCircle =>
      'Impossible d\'enregistrer le cercle. Réessayez.';

  @override
  String get addParticipants => 'Ajouter des participants';

  @override
  String get addingTo => 'Ajout à ';

  @override
  String get addingToHint =>
      '. Les participants rejoignent le cercle avec l\'e-mail de leur compte SafeCircle — c\'est ainsi qu\'ils suivent vos trajets.';

  @override
  String get saveParticipant => 'Enregistrer le participant';

  @override
  String get add => 'Ajouter';

  @override
  String participantsCount(int count) {
    return 'PARTICIPANTS · $count';
  }

  @override
  String get noParticipantsYet => 'Aucun participant pour l\'instant';

  @override
  String get saveCircle => 'Enregistrer le cercle';

  @override
  String get createCircle => 'Créer le cercle';

  @override
  String resendAlreadyJoined(String name) {
    return '$name a déjà rejoint ce cercle.';
  }

  @override
  String resendTexted(String name) {
    return 'Invitation renvoyée par SMS à $name.';
  }

  @override
  String resendTooSoon(String name, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other:
          'Vous venez d\'envoyer un SMS à $name. Réessayez dans $minutes minutes.',
      one: 'Vous venez d\'envoyer un SMS à $name. Réessayez dans 1 minute.',
    );
    return '$_temp0';
  }

  @override
  String get resendLimited =>
      'Limite quotidienne de SMS atteinte. Réessayez demain.';

  @override
  String resendFailed(String name) {
    return 'Impossible d\'envoyer un SMS à $name.';
  }

  @override
  String resendFailedInAppWaiting(String name) {
    return 'Impossible d\'envoyer un SMS à $name. L\'invitation dans l\'app l\'attend toujours.';
  }

  @override
  String resendInApp(String name) {
    return 'Invitation dans l\'app renvoyée à $name.';
  }

  @override
  String resendNoAccount(String name) {
    return '$name n\'a pas encore de compte SafeCircle. Ajoutez un numéro pour lui envoyer un SMS.';
  }

  @override
  String circleNotifiedNextAt(String time) {
    return 'Votre cercle a été prévenu. Prochain pointage à $time.';
  }

  @override
  String get allCheckedIn =>
      'Vous avez fait tous les pointages de ce trajet. Bon voyage.';

  @override
  String get checkInConfirmed => 'Pointage confirmé !';

  @override
  String get backToJourney => 'Retour au trajet';

  @override
  String get journeyFinished => 'Trajet terminé';

  @override
  String get journeyFinishedHint =>
      'Vous êtes en sécurité et votre cercle sait que vous êtes arrivé.';

  @override
  String get backHome => 'Retour à l\'accueil';

  @override
  String get emergencyContacts => 'Contacts d\'urgence';

  @override
  String get emergencyContactsHint =>
      'À chaque alerte, ils reçoivent un SMS avec votre position, et une notification dans l\'app s\'ils utilisent SafeCircle.';

  @override
  String get addTwoContacts =>
      'Ajoutez au moins 2 contacts d\'urgence pour démarrer un trajet.';

  @override
  String alwaysAlerted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Toujours alertés · $count contacts',
      one: 'Toujours alerté · 1 contact',
    );
    return '$_temp0';
  }

  @override
  String get removeContactBody =>
      'Cette personne ne sera plus alertée quand vous enverrez un SOS.';

  @override
  String get removeContact => 'Retirer le contact';

  @override
  String get addEmergencyContact => 'Ajouter un contact d\'urgence';

  @override
  String get noPhoneNumber => 'Aucun numéro de téléphone disponible.';

  @override
  String get couldNotOpenDialer =>
      'Impossible d\'ouvrir le clavier téléphonique.';

  @override
  String get couldNotOpenMessages => 'Impossible d\'ouvrir les messages.';

  @override
  String get noPhoneNumbers => 'Aucun numéro de téléphone disponible.';

  @override
  String get noLocationYetShort =>
      'Aucune position disponible pour l\'instant.';

  @override
  String get couldNotOpenMaps => 'Impossible d\'ouvrir l\'app de cartes.';

  @override
  String replayOf(String day) {
    return '$day · Revoir';
  }

  @override
  String tripSummaryTop(
      String start, String end, String distance, String speed) {
    return '$start – $end · $distance · max. $speed';
  }

  @override
  String get metricTime => 'HEURE';

  @override
  String get metricSpeed => 'VITESSE';

  @override
  String get metricDistance => 'DISTANCE';

  @override
  String get unitMph => ' mph';

  @override
  String get unitMi => ' mi';

  @override
  String leftPlace(String place) {
    return 'Départ de $place';
  }

  @override
  String get theStart => 'le point de départ';

  @override
  String speedingOver(String speed) {
    return 'Excès de vitesse · plus de $speed';
  }

  @override
  String arrivedAt(String place) {
    return 'Arrivée à $place';
  }

  @override
  String get theEnd => 'la destination';

  @override
  String get editProfileSub => 'Nom, photo et infos personnelles';

  @override
  String get myEmergencyContacts => 'Mes contacts d\'urgence';

  @override
  String peopleWillBeAlerted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personnes seront alertées',
      one: '1 personne sera alertée',
    );
    return '$_temp0';
  }

  @override
  String get myCircles => 'Mes cercles';

  @override
  String completedJourneys(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trajets terminés',
      one: '1 trajet terminé',
    );
    return '$_temp0';
  }

  @override
  String get profile => 'Profil';

  @override
  String get me => 'Moi';

  @override
  String get couldNotUpdatePhoto => 'Impossible de mettre à jour la photo.';

  @override
  String get waitingFirstUpdate => 'En attente de la première mise à jour';

  @override
  String get liveUpdatedJustNow => 'En direct · mis à jour à l\'instant';

  @override
  String updatedMinAgo(int minutes) {
    return 'Mis à jour il y a $minutes min';
  }

  @override
  String get noRecentUpdate => 'Pas de mise à jour récente';

  @override
  String get moving => 'En mouvement';

  @override
  String movingAt(String speed) {
    return 'En mouvement · $speed';
  }

  @override
  String get stopped => 'À l\'arrêt';

  @override
  String atPlaceSince(String time) {
    return 'Sur place depuis $time';
  }

  @override
  String friendsNeedAttention(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amis ont besoin d\'attention',
      one: '1 ami a besoin d\'attention',
    );
    return '$_temp0';
  }

  @override
  String namesCheckInDue(String name) {
    return 'C\'est l\'heure du pointage de $name';
  }

  @override
  String checkInsAreDue(int count) {
    return '$count pointages sont prévus';
  }

  @override
  String friendsOnJourney(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amis en trajet',
      one: '1 ami en trajet',
    );
    return '$_temp0';
  }

  @override
  String get whosWatching => 'Qui veille sur vous ?';

  @override
  String get pickCircleHint => 'Choisissez le cercle qui suit ce trajet.';

  @override
  String get nobodyAcceptedYet =>
      'Personne dans ce cercle n\'a encore accepté l\'invitation, donc personne ne verrait ce trajet. Attendez qu\'un membre accepte avant de commencer.';

  @override
  String get addTwoContactsBeforeStart =>
      'Ajoutez 2 contacts d\'urgence avant de commencer';

  @override
  String get schedule => 'PROGRAMME';

  @override
  String get starting => 'Démarrage…';

  @override
  String get startJourneyButton => 'Démarrer le trajet';

  @override
  String get needCircleFirst =>
      'Il vous faut d\'abord un cercle. Touchez l\'onglet Cercles ci-dessous pour en créer un.';

  @override
  String peopleWatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personnes veillent',
      one: '1 personne veille',
    );
    return '$_temp0';
  }

  @override
  String get couldNotOpenContacts => 'Impossible d\'ouvrir vos contacts.';

  @override
  String get nameExampleContact => 'ex. Jessica Moreau';

  @override
  String get photo => 'Photo';

  @override
  String get couldNotOpenPhotos => 'Impossible d\'ouvrir la photothèque.';

  @override
  String get photoAdded => 'Photo ajoutée';

  @override
  String get addPhoto => 'Ajouter une photo';

  @override
  String get emailRequired => 'E-mail (obligatoire)';

  @override
  String get emailShouldMatch => 'L\'e-mail doit être celui de son compte';

  @override
  String get importFromContacts => 'Importer depuis les contacts';

  @override
  String circlesSummary(int circles, int members) {
    String _temp0 = intl.Intl.pluralLogic(
      circles,
      locale: localeName,
      other: '$circles cercles',
      one: '1 cercle',
    );
    String _temp1 = intl.Intl.pluralLogic(
      members,
      locale: localeName,
      other: '$members membres',
      one: '1 membre',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get currentPinWrong => 'Le PIN actuel est incorrect.';

  @override
  String get currentPanicPinWrong => 'Le PIN de panique actuel est incorrect.';

  @override
  String get newPinFourDigits => 'Le nouveau PIN doit comporter 4 chiffres.';

  @override
  String get mustDifferFromPanic =>
      'Il doit être différent de votre PIN de panique.';

  @override
  String get mustDifferFromSafety =>
      'Il doit être différent de votre PIN de sécurité.';

  @override
  String get enterValidEmail => 'Saisissez un e-mail valide.';

  @override
  String get enterCurrentPassword => 'Saisissez votre mot de passe actuel.';

  @override
  String get newPasswordTooShort =>
      'Le nouveau mot de passe doit contenir au moins 6 caractères.';

  @override
  String tripsToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count déplacements aujourd\'hui',
      one: '1 déplacement aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String tripsTodayMiles(int count, String miles) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count déplacements · $miles mi aujourd\'hui',
      one: '1 déplacement · $miles mi aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String get alertsOff => 'Alertes désactivées';

  @override
  String get alertArriveLeave => 'Alerte à l\'arrivée et au départ';

  @override
  String get alertArrive => 'Alerte à l\'arrivée';

  @override
  String get alertLeave => 'Alerte au départ';

  @override
  String get tripStart => 'Départ';

  @override
  String get tripEnd => 'Arrivée';

  @override
  String arrivedAtPlace(String name, String place) {
    return '$name est arrivé(e) à $place';
  }

  @override
  String leftPlaceNamed(String name, String place) {
    return '$name a quitté $place';
  }

  @override
  String hasLowBattery(String name) {
    return 'La batterie de $name est faible';
  }

  @override
  String lowBatterySub(String level) {
    return '$level · La position pourrait bientôt ne plus se mettre à jour';
  }

  @override
  String get myCirclesTitle => 'Mes cercles';

  @override
  String get createNewCircle => 'Créer un nouveau cercle';

  @override
  String get noCircleYet => 'Vous n\'avez encore créé aucun cercle';

  @override
  String get noCircleYetHint =>
      'Créez un cercle pour réunir les personnes de confiance et partager vos trajets avec elles.';

  @override
  String get newCircleInvite => 'Nouvelle invitation à un cercle';

  @override
  String get newBadge => 'NOUVEAU';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '1 membre',
    );
    return '$_temp0';
  }

  @override
  String get emergencySos => 'SOS d\'urgence';

  @override
  String get sosHint =>
      'Cela alerte votre cercle dans l\'app et envoie votre position par SMS à votre cercle et à vos contacts d\'urgence.';

  @override
  String get sosNeedsContact =>
      'Ajoutez au moins un contact d\'urgence avant de pouvoir envoyer une alerte.';

  @override
  String yourEmergencyContactsCount(int count) {
    return 'Vos contacts d\'urgence · $count';
  }

  @override
  String get unavailable => 'Indisponible';

  @override
  String get keepHolding => 'Maintenez…';

  @override
  String get holdToAlert => 'Maintenez pour alerter';

  @override
  String get addContactBeforeAlert =>
      'Ajoutez un contact d\'urgence avant d\'envoyer une alerte.';

  @override
  String get notificationChannelName => 'Alertes SafeCircle';

  @override
  String get notificationChannelDescription =>
      'Rappels de pointage et alertes de sécurité';

  @override
  String get reminderDueTitle => 'C\'est l\'heure du pointage';

  @override
  String reminderDueBody(String label, String time) {
    return '$label · $time — ouvrez SafeCircle et confirmez que tout va bien.';
  }

  @override
  String get reminderLastCallTitle =>
      'Dernier rappel : confirmez votre pointage';

  @override
  String reminderLastCallBody(String label, String time) {
    return '$label · $time — votre cercle sera alerté dans 1 minute.';
  }

  @override
  String get testNotificationTitle =>
      'Les notifications SafeCircle fonctionnent';

  @override
  String get testNotificationBody =>
      'Vous serez alerté ainsi pour les pointages, les amis en retard et les urgences.';

  @override
  String get circleInvite => 'Invitation à un cercle';

  @override
  String inviteNotificationBody(String summary) {
    return '$summary — ouvrez SafeCircle pour accepter.';
  }

  @override
  String get speedAlertTitle =>
      'Alerte de vitesse sur votre dernier déplacement';

  @override
  String speedAlertBody(String trip, String speed) {
    return '$trip · max. $speed';
  }

  @override
  String get checkIn => 'Pointage';

  @override
  String checkInOverdueReachOut(String label) {
    return '$label est en retard — prenez contact.';
  }

  @override
  String get places => 'Lieux';

  @override
  String get placesHint =>
      'Votre cercle reçoit une alerte quand quelqu\'un arrive à ces lieux ou les quitte.';

  @override
  String get noPlacesYet =>
      'Aucun lieu pour l\'instant. Ajoutez la maison, l\'école ou le travail et le cercle est prévenu quand quelqu\'un y arrive.';

  @override
  String get addPlace => 'Ajouter un lieu';

  @override
  String get savedLocation => 'Lieu enregistré';

  @override
  String get couldNotUpdatePlace => 'Impossible de mettre à jour le lieu.';

  @override
  String get sharingPausedBanner => 'Votre partage de position est suspendu';

  @override
  String get turnOnLocation => 'Activez votre position';

  @override
  String get sharingPausedBannerSub =>
      'Votre cercle ne voit pas où vous êtes. Touchez pour reprendre.';

  @override
  String get turnOnLocationSub =>
      'Votre cercle ne vous voit pas encore. Touchez pour autoriser la localisation.';

  @override
  String get noOneSharing => 'Personne ne partage encore';

  @override
  String get noOneSharingHint =>
      'Invitez les personnes de confiance dans un cercle. Tous ceux qui rejoignent et partagent leur position apparaissent ici.';

  @override
  String get goToCircles => 'Aller aux cercles';

  @override
  String get firstCheckIn => 'Premier pointage';

  @override
  String get secondCheckIn => 'Deuxième pointage';

  @override
  String get checkOut => 'Arrivée';

  @override
  String numberedCheckIn(int number) {
    return 'Pointage $number';
  }

  @override
  String couldNotJoinNoAccess(String name) {
    return 'Impossible de rejoindre : l\'app n\'a pas encore accès à ce cercle. Demandez à $name de renvoyer l\'invitation.';
  }

  @override
  String get couldNotAcceptInvite =>
      'Impossible d\'accepter l\'invitation. Réessayez.';

  @override
  String get circleInviteEyebrow => 'INVITATION À UN CERCLE';

  @override
  String addedYouToCircle(String name, String circle) {
    return '$name vous a ajouté au cercle $circle sur SafeCircle.';
  }

  @override
  String joinHint(String name) {
    return 'Rejoignez-le et $name pourra vous inviter à suivre ses trajets et à être alerté en cas de retard. Vous pouvez quitter le cercle à tout moment.';
  }

  @override
  String get joining => 'Connexion au cercle…';

  @override
  String get accept => 'Accepter';

  @override
  String get decline => 'Refuser';

  @override
  String get confirmToEndJourney => 'Confirmez pour terminer le trajet';

  @override
  String get confirmYourCheckIn => 'Confirmez votre pointage';

  @override
  String get enterPinToEnd =>
      'Saisissez votre PIN pour terminer ce trajet en toute sécurité.';

  @override
  String get incorrectPin => 'PIN incorrect. Réessayez.';

  @override
  String get friendsJourneys => 'Trajets des amis';

  @override
  String get noNewNotifications => 'Aucune nouvelle notification.';

  @override
  String get renameCircle => 'Renommer le cercle';

  @override
  String get nameYourCircle => 'Nommez votre cercle';

  @override
  String get circleNameHint =>
      'Choisissez un nom — ajoutez un emoji pour le repérer facilement.';

  @override
  String get circlesName => 'Nom du cercle';

  @override
  String get circleNameExample => 'ex. 🏠 Famille';

  @override
  String get save => 'Enregistrer';

  @override
  String get locationSharingChannel => 'Partage de position';

  @override
  String get locationSharingChannelDescription =>
      'Affiché pendant que SafeCircle partage votre position avec votre cercle.';

  @override
  String get sharingNotificationTitle => 'SafeCircle partage votre position';

  @override
  String get sharingNotificationBody => 'Votre cercle peut voir où vous êtes.';

  @override
  String checkInInPast(String label) {
    return '« $label » est déjà passé — modifiez son heure.';
  }

  @override
  String get journeyStartsWithoutLocation =>
      'Position indisponible — le trajet démarre sans position sur la carte.';

  @override
  String get couldNotStartJourney =>
      'Impossible de démarrer le trajet. Réessayez.';

  @override
  String get createYourFirstCircle => 'Créez votre premier cercle';

  @override
  String get nothingNewYet => 'Rien de nouveau pour l\'instant.';

  @override
  String get activity => 'Activité';

  @override
  String get delete => 'Effacer';

  @override
  String get back => 'Retour';

  @override
  String get checkConnection => 'Vérifiez votre connexion et réessayez.';

  @override
  String get couldNotLoadThis => 'Chargement impossible';

  @override
  String get couldNotLoadAccount => 'Impossible de charger votre compte';

  @override
  String get checkInternet => 'Vérifiez votre connexion Internet et réessayez.';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get createACircle => 'Créer un cercle';

  @override
  String get journeysList => 'Liste des trajets';

  @override
  String get couldNotSaveContact =>
      'Impossible d\'enregistrer le contact. Réessayez.';

  @override
  String get editContact => 'Modifier le contact';

  @override
  String get addContactHint =>
      'Cette personne sera alertée à chaque trajet, toujours. Nous lui enverrons un SMS une fois pour l\'informer que vous l\'avez ajoutée.';

  @override
  String get sharingWithCircles =>
      'Votre position en direct est partagée avec vos cercles.';

  @override
  String get locationOffEnable =>
      'La localisation est désactivée — activez-la pour partager votre position.';

  @override
  String get positionNotShared => 'Votre position n\'est pas encore partagée.';

  @override
  String get tabMap => 'Carte';

  @override
  String get tabJourneys => 'Trajets';

  @override
  String get tabEmergency => 'Urgence';

  @override
  String get tabProfile => 'Profil';

  @override
  String get planAJourney => 'Planifier un trajet';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get addYourFirstCircle => 'Ajoutez votre premier cercle';

  @override
  String get resendInvitation => 'Renvoyer l\'invitation';

  @override
  String get locationNotSharedYet => 'Position pas encore partagée';

  @override
  String get couldNotSendAlert =>
      'Impossible d\'envoyer l\'alerte. Vérifiez votre connexion et réessayez.';

  @override
  String get journeys => 'Trajets';

  @override
  String overSpeed(String speed) {
    return 'Plus de $speed';
  }

  @override
  String get withinLimit => 'Dans la limite';

  @override
  String friendsNeedAttentionActive(int count, int active) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amis ont besoin d\'attention',
      one: '1 ami a besoin d\'attention',
    );
    return '$_temp0 · $active actifs';
  }

  @override
  String friendsOnJourneyNow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amis actuellement en trajet',
      one: '1 ami actuellement en trajet',
    );
    return '$_temp0';
  }

  @override
  String get countryUS => 'États-Unis';

  @override
  String get countryBR => 'Brésil';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryGB => 'Royaume-Uni';

  @override
  String get countryES => 'Espagne';

  @override
  String get countryAR => 'Argentine';

  @override
  String get countryFR => 'France';

  @override
  String get countryMX => 'Mexique';

  @override
  String get countryCN => 'Chine';

  @override
  String get countryIN => 'Inde';

  @override
  String get enterPinToPause => 'Saisissez votre PIN pour suspendre.';

  @override
  String get smsConsentLabel =>
      'Cette personne a accepté de recevoir des SMS SafeCircle à ce numéro (invitations et alertes de sécurité). Des frais de messagerie et de données peuvent s\'appliquer. Elle peut répondre STOP pour se désabonner.';

  @override
  String get profilePhoneSmsNote =>
      'En ajoutant votre numéro, vous acceptez de recevoir des SMS SafeCircle concernant les alertes de sécurité de vos cercles. Des frais de messagerie et de données peuvent s\'appliquer. Répondez STOP pour vous désabonner.';

  @override
  String get privacySmsTitle => 'SMS';

  @override
  String get privacySmsBody =>
      'Nous n\'envoyons de SMS à un numéro qu\'après l\'accord de la personne, et uniquement pour les invitations à un cercle et les alertes de sécurité — jamais de marketing. Les numéros de mobile et les consentements ne sont jamais vendus ni partagés avec des tiers ou affiliés à des fins marketing. Répondez STOP à n\'importe quel SMS pour vous désabonner, ou HELP pour obtenir de l\'aide.';

  @override
  String resendNoConsent(String name) {
    return '$name n\'a pas encore accepté de recevoir des SMS. Une fois son accord donné, modifiez ses informations et cochez la case SMS.';
  }

  @override
  String inviteShareMessage(String circle, String link, String email) {
    return 'Je t\'ai ajouté à mon cercle SafeCircle « $circle » pour qu\'on veille les uns sur les autres. Télécharge l\'app : $link et inscris-toi avec $email pour rejoindre le cercle.';
  }

  @override
  String inviteShareMessageNoEmail(String circle, String link) {
    return 'Je t\'ai ajouté à mon cercle SafeCircle « $circle » pour qu\'on veille les uns sur les autres. Télécharge l\'app : $link pour rejoindre le cercle.';
  }

  @override
  String get inviteShareSubject => 'Rejoins mon cercle SafeCircle';

  @override
  String participantSavedTo(String circle) {
    return 'Enregistré dans $circle';
  }

  @override
  String participantRemovedFrom(String circle) {
    return 'Retiré de $circle';
  }

  @override
  String notOnSafeCircleYet(String name) {
    return '$name n\'est pas encore sur SafeCircle';
  }

  @override
  String get inviteByTextBody =>
      'Voulez-vous lui envoyer une invitation ? Un SMS s\'ouvrira avec l\'invitation prête à envoyer.';

  @override
  String get inviteByShareBody =>
      'Voulez-vous lui envoyer une invitation ? Choisissez comment l\'envoyer : Messages, WhatsApp, e-mail…';

  @override
  String get sendInvitation => 'Envoyer l\'invitation';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String get membershipTitle => 'Gardez votre cercle près de vous';

  @override
  String get membershipSubtitle =>
      'L\'abonnement SafeCircle débloque tout ce qui vous garde connecté à vos proches.';

  @override
  String get membershipPerkMap => 'Position en direct avec vos cercles';

  @override
  String get membershipPerkJourneys =>
      'Trajets avec points d\'étape et alertes de retard';

  @override
  String get membershipPerkCircles => 'Des cercles pour la famille et les amis';

  @override
  String get membershipPerkAlerts => 'Alertes quand un proche a besoin d\'aide';

  @override
  String membershipTrialPrice(int days, String price) {
    return '$days jours gratuits, puis $price/mois';
  }

  @override
  String membershipPrice(String price) {
    return '$price/mois';
  }

  @override
  String get membershipCancelAnytime => 'Résiliable à tout moment';

  @override
  String get membershipStartTrial => 'Commencer l\'essai gratuit';

  @override
  String get membershipSubscribe => 'S\'abonner';

  @override
  String get membershipWorking => 'Un instant…';

  @override
  String membershipFinePrintTrial(String store, int days) {
    return 'À la fin de l\'essai gratuit de $days jours, le paiement est débité sur votre compte $store. L\'abonnement se renouvelle chaque mois sauf résiliation au moins 24 heures avant la fin de la période en cours. Gérez-le ou résiliez-le dans les réglages de votre compte $store.';
  }

  @override
  String membershipFinePrint(String store) {
    return 'Le paiement est débité sur votre compte $store. L\'abonnement se renouvelle chaque mois sauf résiliation au moins 24 heures avant la fin de la période en cours. Gérez-le ou résiliez-le dans les réglages de votre compte $store.';
  }

  @override
  String get membershipStoreApple => 'identifiant Apple';

  @override
  String get membershipStoreGoogle => 'Google Play';

  @override
  String get membershipUnavailable =>
      'Impossible de charger l\'abonnement pour le moment. Vérifiez votre connexion et réessayez.';

  @override
  String get membershipRestore => 'Restaurer les achats';

  @override
  String get membershipSosFree =>
      'Le SOS fonctionne toujours, même sans abonnement : votre cercle et vos contacts d\'urgence sont quand même alertés.';

  @override
  String get membershipOpenSos => 'Ouvrir le SOS';

  @override
  String get membershipPauseSharing => 'Mettre en pause le partage de position';

  @override
  String get membershipWelcome => 'Bienvenue sur SafeCircle !';

  @override
  String get membershipNothingToRestore =>
      'Aucun abonnement trouvé pour ce compte.';

  @override
  String get membershipPurchaseFailed =>
      'L\'achat n\'a pas abouti. Veuillez réessayer.';

  @override
  String get membershipLabel => 'Abonnement';

  @override
  String get membershipActiveSub => 'Actif · gérer ou résilier';

  @override
  String get membershipInactiveSub => 'Inactif · commencez votre essai gratuit';

  @override
  String get termsMembershipTitle => '4. Abonnement';

  @override
  String get termsMembershipBody =>
      'La plupart de SafeCircle nécessite un abonnement mensuel ; le SOS reste toujours gratuit. Les nouveaux membres bénéficient d\'un essai gratuit. L\'abonnement se renouvelle automatiquement via l\'App Store ou Google Play jusqu\'à sa résiliation sur ces plateformes, au moins 24 heures avant la fin de la période en cours. La période d\'essai non utilisée prend fin lors de l\'abonnement.';
}
