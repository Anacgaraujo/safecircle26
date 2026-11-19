// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'SafeCircle';

  @override
  String get today => 'Hoy';

  @override
  String get tomorrow => 'Mañana';

  @override
  String get alertKindPanic => 'Pánico silencioso';

  @override
  String get alertKindOverdue => 'Check-in perdido';

  @override
  String get alertKindSos => 'SOS';

  @override
  String alertHeadlineOverdue(String name) {
    return '$name no hizo un check-in';
  }

  @override
  String alertHeadlineHelp(String name) {
    return '$name necesita ayuda';
  }

  @override
  String get someone => 'Alguien';

  @override
  String get aCircle => 'un círculo';

  @override
  String inviteSummary(String name, String circle) {
    return '$name te invitó a $circle';
  }

  @override
  String get circleOwner => 'Dueño del círculo';

  @override
  String lastSeenAt(String time) {
    return 'Visto por última vez a las $time';
  }

  @override
  String get enterYourName => 'Escribe tu nombre.';

  @override
  String get enterYourEmail => 'Escribe tu correo.';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden.';

  @override
  String get enterEmailAndPassword => 'Escribe tu correo y contraseña.';

  @override
  String get recoveryLinkSent =>
      'Enlace de recuperación enviado. Revisa tu bandeja de entrada.';

  @override
  String get couldNotSavePins =>
      'No se pudieron guardar tus PIN. Inténtalo de nuevo.';

  @override
  String get welcomeTo => 'Bienvenido a';

  @override
  String get welcomeTagline =>
      'Crea un círculo de confianza y que alguien siempre sepa que estás bien.';

  @override
  String get start => 'Empezar';

  @override
  String get skipIntro => 'Saltar introducción';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get joinInSeconds => 'Únete a SafeCircle en unos segundos.';

  @override
  String get name => 'Nombre';

  @override
  String get nameExample => 'p. ej. Alex Morgan';

  @override
  String get email => 'Correo';

  @override
  String get emailExample => 'nombre@ejemplo.com';

  @override
  String get phone => 'Teléfono';

  @override
  String get password => 'Contraseña';

  @override
  String get repeatPassword => 'Repite la contraseña';

  @override
  String get creatingAccount => 'Creando cuenta…';

  @override
  String get register => 'Registrarse';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get loginTagline => 'Alguien siempre sabe que estás bien.';

  @override
  String get forgotPassword => '¿La olvidaste?';

  @override
  String get loggingIn => 'Iniciando sesión…';

  @override
  String get orLoginWith => 'O inicia sesión con...';

  @override
  String get noAccountYet => '¿No tienes una cuenta? ';

  @override
  String get registerExclaim => '¡Regístrate!';

  @override
  String get socialLoginSoon =>
      'Inicio de sesión con redes sociales próximamente.';

  @override
  String get recoverPassword => 'Recuperar contraseña';

  @override
  String get recoverPasswordHint =>
      'Escribe el correo de tu cuenta y te enviaremos un enlace seguro para restablecer tu contraseña.';

  @override
  String get sending => 'Enviando…';

  @override
  String stepOf(int step, int total) {
    return 'PASO $step DE $total';
  }

  @override
  String get setPanicPin => 'Define tu PIN de pánico';

  @override
  String get setSafetyPin => 'Define tu PIN de seguridad';

  @override
  String get panicPinHint =>
      'Si te obligan a abrir la app, escribe este PIN. La pantalla se ve normal, pero tu círculo recibe una alerta en silencio.';

  @override
  String get safetyPinHint =>
      'Usa este PIN para confirmar que estás bien en los check-ins.';

  @override
  String get panicPinMatchesSafety =>
      'Es igual a tu PIN de seguridad. Elige otro código.';

  @override
  String get panicPinMustDiffer => 'Debe ser distinto de tu PIN de seguridad.';

  @override
  String get saving => 'Guardando…';

  @override
  String get finish => 'Terminar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get gettingStarted => 'PRIMEROS PASOS';

  @override
  String get createFirstCircle => 'Crea tu primer círculo';

  @override
  String get tapPrefix => 'Toca ';

  @override
  String get tabCircles => 'Círculos';

  @override
  String get createFirstCircleHint =>
      ' en la barra inferior, ponle un nombre y agrega a las personas en quienes confías. Recibirán una invitación para seguir tus trayectos.';

  @override
  String get next => 'Siguiente';

  @override
  String get allSet => '¡Todo listo!';

  @override
  String get allSetHint =>
      'Tu SafeCircle está listo. Planea tu primer trayecto cuando salgas.';

  @override
  String get enterSafeCircle => 'Entrar a SafeCircle';

  @override
  String get authInvalidEmail => 'Correo electrónico no válido.';

  @override
  String get authEmailInUse => 'Este correo ya está registrado.';

  @override
  String get authWeakPassword =>
      'Contraseña demasiado débil (mín. 6 caracteres).';

  @override
  String get authWrongCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get authTooManyAttempts => 'Demasiados intentos. Inténtalo más tarde.';

  @override
  String get authNetwork => 'Error de red. Revisa tu conexión.';

  @override
  String get authReloginNeeded => 'Vuelve a iniciar sesión para hacer esto.';

  @override
  String get authGenericError => 'Error de autenticación.';

  @override
  String get somethingWentWrong => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get settings => 'Ajustes';

  @override
  String get security => 'Seguridad';

  @override
  String get changeSafetyPin => 'Cambiar PIN de seguridad';

  @override
  String get changeSafetyPinSub => 'Confirma que estás bien en el check-in';

  @override
  String get changePanicPin => 'Cambiar PIN de pánico';

  @override
  String get changePanicPinSub =>
      'Código de coacción silencioso · envía una alerta oculta';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get checkInReminders => 'Recordatorios de check-in';

  @override
  String get checkInRemindersSub => 'Avísame cuando toque un check-in';

  @override
  String get overdueCheckIns => 'Check-ins atrasados';

  @override
  String get overdueCheckInsSub =>
      'Cuando un amigo no hace un check-in. Las alertas de pánico y SOS siempre están activas.';

  @override
  String get permissions => 'Permisos';

  @override
  String get permissionsSub => 'Ubicación, notificaciones, alarmas y batería';

  @override
  String get permissionsReason =>
      'SafeCircle solo los usa para protegerte a ti y a tu círculo.';

  @override
  String get done => 'Listo';

  @override
  String get sendTestNotification => 'Enviar una notificación de prueba';

  @override
  String get sendTestNotificationSub =>
      'Comprueba que las alertas lleguen a este teléfono';

  @override
  String get testNotificationSent => 'Enviada — revisa tus notificaciones.';

  @override
  String get testNotificationFailed =>
      'No se pudo enviar. Revisa el permiso de notificaciones en los ajustes del sistema.';

  @override
  String get account => 'Cuenta';

  @override
  String get changeEmail => 'Cambiar correo';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get logOutQuestion => '¿Cerrar sesión?';

  @override
  String get logOutBody =>
      'Dejarás de recibir alertas de tus círculos hasta que vuelvas a iniciar sesión.';

  @override
  String get loggedOut => 'Sesión cerrada.';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountSub => 'Borra para siempre tu círculo y tu historial';

  @override
  String get deleteAccountQuestion => '¿Eliminar cuenta?';

  @override
  String get deleteAccountBody =>
      'Esto borra para siempre tus círculos, contactos e historial de trayectos. No se puede deshacer.';

  @override
  String get accountDeleted => 'Cuenta eliminada.';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get termsOfService => 'Términos del servicio';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get aboutFooter =>
      'SafeCircle · Hecho para mantener seguro a tu círculo';

  @override
  String get cancel => 'Cancelar';

  @override
  String get beforeYouStart => 'Antes de empezar';

  @override
  String get journeyPermissionsReason =>
      'Un trayecto los necesita para que tus recordatorios de check-in suenen a tiempo y tu círculo vea dónde estás.';

  @override
  String get shareLiveLocation => 'Comparte tu ubicación en tiempo real';

  @override
  String get shareLiveLocationReason => 'Tu círculo ve dónde estás en el mapa.';

  @override
  String get notificationsOffWarning =>
      'No recibirás avisos de alertas — activa las notificaciones en Ajustes.';

  @override
  String get almostThere => 'CASI LISTO';

  @override
  String get allowPermissions => 'Permitir accesos';

  @override
  String get allowPermissionsHint =>
      'SafeCircle solo los usa para mantenerte seguro a ti y a tu círculo. Siempre tienes el control — cámbialos cuando quieras en Ajustes.';

  @override
  String get locationDenied =>
      'Ubicación denegada — actívala en los ajustes del sistema.';

  @override
  String get notificationsDenied =>
      'Notificaciones denegadas — actívalas en los ajustes del sistema.';

  @override
  String get turnOnAlarms =>
      'Activa \"Alarmas y recordatorios\" para SafeCircle y luego vuelve.';

  @override
  String get contactsDenied =>
      'Contactos denegados — actívalos en los ajustes del sistema.';

  @override
  String get location => 'Ubicación';

  @override
  String get locationPermissionSub =>
      'Para que tu círculo vea que llegaste bien.';

  @override
  String get notificationsPermissionSub =>
      'Para recordarte cuando toque un check-in.';

  @override
  String get alarmsAndReminders => 'Alarmas y recordatorios';

  @override
  String get alarmsPermissionSub =>
      'Para que los recordatorios de check-in suenen a la hora exacta.';

  @override
  String get backgroundActivity => 'Actividad en segundo plano (recomendado)';

  @override
  String get backgroundPermissionSub =>
      'Para que los recordatorios funcionen aunque el teléfono esté inactivo.';

  @override
  String get contactsOptional => 'Contactos (opcional)';

  @override
  String get contactsPermissionSub =>
      'Para invitar rápido a las personas en quienes confías.';

  @override
  String get locationAndNotificationsRequired =>
      'Ubicación y Notificaciones son necesarias para que SafeCircle te proteja.';

  @override
  String get locationRequired =>
      'La ubicación es necesaria para que SafeCircle te proteja.';

  @override
  String get setUpLater => 'Configurar después';

  @override
  String get openSystemSettings => 'Abrir ajustes del sistema';

  @override
  String get allowed => 'Permitido';

  @override
  String get allow => 'Permitir';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String verificationLinkSent(String email) {
    return 'Enlace de verificación enviado a $email — confírmalo para cambiar.';
  }

  @override
  String get passwordChanged => 'Contraseña cambiada';

  @override
  String get safetyPinUpdated => 'PIN de seguridad actualizado';

  @override
  String get panicPinUpdated => 'PIN de pánico actualizado';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get editProfileHint =>
      'Actualiza cómo te ve tu círculo. Tu teléfono permite que tus amigos te llamen durante un trayecto.';

  @override
  String changeEmailHint(String email) {
    return 'Enviaremos un enlace de verificación a la nueva dirección. El inicio de sesión y las invitaciones pasan a ella una vez confirmada. Actual: $email';
  }

  @override
  String get newEmail => 'Nuevo correo';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get useSixCharacters => 'Usa al menos 6 caracteres.';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirma la nueva contraseña';

  @override
  String get safetyPinHintShort =>
      'Este PIN confirma que estás bien en cada check-in.';

  @override
  String get currentPin => 'PIN actual';

  @override
  String get newPin => 'Nuevo PIN';

  @override
  String get panicPinHintShort =>
      'Escribir este PIN parece normal, pero alerta a tu círculo en silencio.';

  @override
  String get currentPanicPin => 'PIN de pánico actual';

  @override
  String get newPanicPin => 'Nuevo PIN de pánico';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String deleteCircleQuestion(String circle) {
    return '¿Eliminar $circle?';
  }

  @override
  String get deleteCircleBody =>
      'Todos en este círculo dejan de seguir tus trayectos y alertas. No se puede deshacer.';

  @override
  String get deleteCircle => 'Eliminar círculo';

  @override
  String get theOwner => 'el dueño';

  @override
  String leaveCircleQuestion(String circle) {
    return '¿Salir de $circle?';
  }

  @override
  String leaveCircleBody(String owner) {
    return 'Dejarás de seguir los trayectos y alertas de $owner, y este círculo dejará de ver tu ubicación. $owner puede volver a invitarte.';
  }

  @override
  String get leaveCircle => 'Salir del círculo';

  @override
  String get couldNotLeaveCircle =>
      'No se pudo salir del círculo. Inténtalo de nuevo.';

  @override
  String resendInvitationQuestion(String name) {
    return '¿Reenviar invitación a $name?';
  }

  @override
  String resendInvitationTextBody(String phone) {
    return 'Enviaremos otro SMS a $phone y un recordatorio en la app.';
  }

  @override
  String get resendInvitationAppBody =>
      'Enviaremos un recordatorio en la app. Agrega un teléfono para enviarle un SMS también.';

  @override
  String get resend => 'Reenviar';

  @override
  String get couldNotResendInvitation =>
      'No se pudo reenviar la invitación. Inténtalo de nuevo.';

  @override
  String removePersonQuestion(String name) {
    return '¿Quitar a $name?';
  }

  @override
  String get removePersonBody =>
      'Ya no seguirá tus trayectos ni recibirá tus alertas.';

  @override
  String get remove => 'Quitar';

  @override
  String get couldNotRemoveParticipant =>
      'No se pudo quitar al participante. Inténtalo de nuevo.';

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participantes',
      one: '1 participante',
    );
    return '$_temp0';
  }

  @override
  String get participants => 'Participantes';

  @override
  String get addMoreParticipants => 'Agregar más participantes';

  @override
  String get deleteThisCircle => 'Eliminar este círculo';

  @override
  String get leaveThisCircle => 'Salir de este círculo';

  @override
  String get deleteJourneyQuestion => '¿Eliminar este trayecto?';

  @override
  String deleteJourneyBody(String date) {
    return 'Esto quita el trayecto del $date de tu historial. No se puede deshacer.';
  }

  @override
  String get deleteJourneyBodyNoDate =>
      'Esto quita este trayecto de tu historial. No se puede deshacer.';

  @override
  String get deleteJourney => 'Eliminar trayecto';

  @override
  String get couldNotDeleteJourney =>
      'No se pudo eliminar el trayecto. Inténtalo de nuevo.';

  @override
  String get deleteAllJourneysQuestion => '¿Eliminar todos los trayectos?';

  @override
  String deleteAllJourneysBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Esto quita los $count trayectos de tu historial. No se puede deshacer.',
      one: 'Esto quita 1 trayecto de tu historial. No se puede deshacer.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAll => 'Eliminar todo';

  @override
  String journeysDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se eliminaron $count trayectos.',
      one: 'Se eliminó 1 trayecto.',
    );
    return '$_temp0';
  }

  @override
  String get couldNotDeleteJourneys =>
      'No se pudieron eliminar tus trayectos. Inténtalo de nuevo.';

  @override
  String get journeyHistory => 'Historial de trayectos';

  @override
  String get planNewJourney => 'Planear nuevo trayecto';

  @override
  String get noPastJourneys => 'Aún no hay trayectos anteriores';

  @override
  String get noPastJourneysHint =>
      'Tus trayectos completados aparecerán aquí cuando termines uno.';

  @override
  String get journey => 'Trayecto';

  @override
  String get completed => 'Completado';

  @override
  String get checkInOverdue => 'Check-in atrasado';

  @override
  String get checkInDueNow => 'Check-in ahora';

  @override
  String get journeyActive => 'Trayecto activo';

  @override
  String journeyActiveAt(String place) {
    return 'Trayecto activo · $place';
  }

  @override
  String get circleColon => 'Círculo:';

  @override
  String get checkIns => 'Check-ins';

  @override
  String get endJourney => 'Terminar trayecto';

  @override
  String get getMeOut => 'Sácame de aquí';

  @override
  String get messages => 'Mensajes';

  @override
  String get overdue => 'Atrasado';

  @override
  String get dueNow => 'Ahora';

  @override
  String get confirmed => 'Confirmado';

  @override
  String get confirm => 'Confirmar';

  @override
  String get upcoming => 'Próximo';

  @override
  String get missedCheckInTitle => 'No hiciste un check-in';

  @override
  String get checkInDueTitle => 'Hora del check-in — ¿estás bien?';

  @override
  String missedCheckInBody(String label, String time) {
    return '$label · $time. Tu círculo recibió una alerta — confirma ahora para avisar que estás bien.';
  }

  @override
  String confirmWithinBody(int minutes) {
    return 'Confirma en $minutes min o tu círculo recibirá una alerta.';
  }

  @override
  String get pickOneAlert => 'Elige al menos una alerta.';

  @override
  String get waitingForLocation =>
      'Esperando la ubicación — inténtalo en un momento.';

  @override
  String get newPlace => 'Nuevo lugar';

  @override
  String placeAdded(String name) {
    return '$name agregado · el círculo recibirá alertas';
  }

  @override
  String get couldNotSavePlace =>
      'No se pudo guardar el lugar. Inténtalo de nuevo.';

  @override
  String deleteNamedQuestion(String name) {
    return '¿Eliminar $name?';
  }

  @override
  String get deletePlaceBody =>
      'Tu círculo ya no recibirá alertas de llegadas y salidas aquí.';

  @override
  String get deletePlace => 'Eliminar lugar';

  @override
  String get editPlace => 'Editar lugar';

  @override
  String get placeNameExample => 'p. ej. Gimnasio, casa de la abuela';

  @override
  String get gettingLocation => 'Obteniendo tu ubicación…';

  @override
  String get noLocationYet => 'Aún no hay ubicación';

  @override
  String get useCurrentLocation => 'Usar mi ubicación actual';

  @override
  String get alertRadius => 'RADIO DE ALERTA';

  @override
  String get arrives => 'Llega';

  @override
  String get leaves => 'Sale';

  @override
  String get savePlace => 'Guardar lugar';

  @override
  String get you => 'Tú';

  @override
  String get locating => 'Localizando…';

  @override
  String tripHistoryToday(String today) {
    return 'Historial de viajes · $today';
  }

  @override
  String get pauseSharing => 'Pausar ubicación';

  @override
  String get resumeSharing => 'Reanudar ubicación';

  @override
  String get call => 'Llamar';

  @override
  String get message => 'Mensaje';

  @override
  String get sharingAgain =>
      'Compartiendo otra vez tu ubicación en tiempo real.';

  @override
  String get locationOffOnPhone =>
      'La ubicación está desactivada en este teléfono — actívala en Ajustes.';

  @override
  String get pauseSharingQuestion => '¿Pausar la ubicación compartida?';

  @override
  String get pauseSharingBody =>
      'Tu círculo no verá dónde estás hasta que la reanudes. Los trayectos, check-ins y el SOS siguen funcionando.';

  @override
  String get pause => 'Pausar';

  @override
  String get sharingPaused => 'Ubicación compartida en pausa.';

  @override
  String get charging => 'Cargando';

  @override
  String get lowBattery => 'Batería baja';

  @override
  String get battery => 'Batería';

  @override
  String get alertResolvedReturning => 'Alerta resuelta — volviendo al inicio…';

  @override
  String get markedResolved => 'Marcada como resuelta';

  @override
  String youConfirmedSafe(String name) {
    return 'Confirmaste que $name está bien · ahora mismo';
  }

  @override
  String get liveLocation => 'Ubicación en tiempo real';

  @override
  String get updating => 'Actualizando';

  @override
  String get atTimeOfAlert => 'Al momento de la alerta';

  @override
  String get locationUnavailable => 'Ubicación no disponible';

  @override
  String get pinnedOnMap => 'Marcado en el mapa';

  @override
  String get noPositionShared => 'No se compartió ninguna posición';

  @override
  String get lastRecordedCheckIn => 'Último check-in registrado';

  @override
  String callName(String name) {
    return 'Llamar a $name';
  }

  @override
  String get openInMaps => 'Abrir en Mapas';

  @override
  String get reopenAlert => 'Reabrir alerta';

  @override
  String get markAsResolved => 'Marcar como resuelta';

  @override
  String get tripHistoryEyebrow => 'HISTORIAL DE VIAJES';

  @override
  String get yourTrips => 'Tus viajes';

  @override
  String namesTrips(String name) {
    return 'Viajes de $name';
  }

  @override
  String get noTripsThisWeek => 'No hay viajes esta semana';

  @override
  String weekSummary(String miles, String speed) {
    return '$miles mi · Velocidad máx. $speed';
  }

  @override
  String allTripsCount(int count) {
    return 'Todos los viajes $count';
  }

  @override
  String overSpeedCount(String speed, int count) {
    return 'Más de $speed $count';
  }

  @override
  String tripsRecordedYou(int meters, int minutes) {
    return 'Los viajes se registran automáticamente cuando sales de un radio de $meters m y terminan tras $minutes minutos detenido.';
  }

  @override
  String tripsRecordedName(String name, int meters, int minutes) {
    return 'Los viajes se registran automáticamente cuando $name sale de un radio de $meters m y terminan tras $minutes minutos detenido.';
  }

  @override
  String get noTripsRecorded => 'No se registraron viajes esta semana.';

  @override
  String get noTripsMatch => 'Ningún viaje coincide con este filtro.';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get lastWeek => 'Semana pasada';

  @override
  String sinceDay(String day) {
    return 'Desde $day';
  }

  @override
  String get tripsPerWeek => 'VIAJES POR SEMANA';

  @override
  String get thisWeekShort => 'Esta\nsemana';

  @override
  String get lastWeekShort => 'Semana\npasada';

  @override
  String get termsServiceTitle => '1. El servicio';

  @override
  String get termsServiceBody =>
      'SafeCircle te ayuda a compartir trayectos planeados y check-ins con personas de confianza. Complementa — nunca reemplaza — a los servicios de emergencia.';

  @override
  String get termsResponsibilitiesTitle => '2. Tus responsabilidades';

  @override
  String get termsResponsibilitiesBody =>
      'Mantén en privado tu cuenta, tu PIN de seguridad y tu PIN de pánico, y agrega solo contactos de emergencia que hayan aceptado recibir alertas en tu nombre.';

  @override
  String get termsAlertsTitle => '3. Alertas';

  @override
  String get termsAlertsBody =>
      'Las alertas dependen de la conexión de tu dispositivo y de los permisos de ubicación. Ante una situación de riesgo de vida, contacta siempre primero a los servicios de emergencia locales.';

  @override
  String get privacyCollectTitle => 'Qué recopilamos';

  @override
  String get privacyCollectBody =>
      'Los datos de tu perfil, tus planes de trayecto, las confirmaciones de check-in y — solo mientras un trayecto está activo — tu ubicación.';

  @override
  String get privacyWhoTitle => 'Quién puede verlo';

  @override
  String get privacyWhoBody =>
      'Solo los círculos y contactos de emergencia que elijas. Tu ubicación nunca se vende ni se comparte con anunciantes.';

  @override
  String get privacyControlTitle => 'Tu control';

  @override
  String get privacyControlBody =>
      'Puedes dejar de compartir en cualquier momento, y eliminar tu cuenta borra para siempre tus círculos e historial de trayectos.';

  @override
  String get lastUpdatedJune2026 => 'Actualizado · junio de 2026';

  @override
  String get allCheckInsConfirmed =>
      'Todos los check-ins confirmados — termina el trayecto al llegar';

  @override
  String labelCheckInOverdue(String label) {
    return 'Check-in \"$label\" atrasado — tu círculo recibió una alerta';
  }

  @override
  String labelCheckInDueNow(String label) {
    return 'Check-in \"$label\" ahora — confirma que estás bien';
  }

  @override
  String nextCheckInLabel(String label, String time) {
    return 'Próximo check-in: $label · $time';
  }

  @override
  String yourJourneyWith(String circle) {
    return 'Tu trayecto · $circle';
  }

  @override
  String get noActiveFriendJourneys =>
      'Ningún amigo está en un trayecto en este momento';

  @override
  String get nextCheckInPrefix => 'Próximo check-in: ';

  @override
  String get panicAlert => 'Alerta de pánico';

  @override
  String get checkInDuePrefix => 'Check-in ahora: ';

  @override
  String get waiting => '· esperando';

  @override
  String journeyWith(String circle) {
    return 'Trayecto con $circle';
  }

  @override
  String get silentAlert => 'Alerta silenciosa';

  @override
  String get onTime => 'A tiempo';

  @override
  String usedPanicPin(String name, String emergency) {
    return '$name usó el PIN de pánico — podría estar en peligro. Llama a esa persona o al $emergency.';
  }

  @override
  String missedCheckInAt(String time, String name) {
    return 'Check-in perdido a las $time. Comunícate con $name.';
  }

  @override
  String aCheckInWasMissed(String name) {
    return 'No se hizo un check-in. Comunícate con $name.';
  }

  @override
  String get missed => 'Perdido';

  @override
  String get alertSent => 'Alerta enviada';

  @override
  String sentJustNow(String time) {
    return '$time · ahora mismo';
  }

  @override
  String get locationShared => 'Ubicación compartida';

  @override
  String get enableLocationToShare =>
      'Activa la ubicación para compartir dónde estás';

  @override
  String get live => 'En vivo';

  @override
  String alertedInApp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alertados en la app · $count personas',
      one: 'Alertado en la app · 1 persona',
    );
    return '$_temp0';
  }

  @override
  String get noOneToAlert => 'Aún no hay nadie en SafeCircle a quien alertar';

  @override
  String get textMyLocation => 'Enviar mi ubicación por SMS a mis contactos';

  @override
  String get emergencySmsNoLocation =>
      'EMERGENCIA — Necesito ayuda. Enviado desde SafeCircle.';

  @override
  String emergencySmsWithLocation(String link, String place) {
    return 'EMERGENCIA — Necesito ayuda. Mi ubicación: $link ($place)';
  }

  @override
  String alsoCall(String number) {
    return 'Llamar también al $number';
  }

  @override
  String get cancelAlertSafe => 'Cancelar alerta — estoy bien';

  @override
  String get callOrTextToCheck => 'Llama o escribe para asegurarte';

  @override
  String get newJourney => 'Nuevo trayecto';

  @override
  String get newJourneyHint =>
      'Programa cuándo harás check-in. Si no haces uno, tu círculo recibe una alerta.';

  @override
  String get selectTiming => 'Elige los horarios';

  @override
  String get otherInformation => 'Otra información';

  @override
  String get journeyNoteExample => 'Encuentro en el bar';

  @override
  String get addCheckIn => 'Agregar check-in';

  @override
  String get startJourney => 'Iniciar el trayecto';

  @override
  String get pickTimeOneMinute =>
      'Elige una hora al menos 1 minuto desde ahora.';

  @override
  String textInvitationsSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Invitación enviada por SMS a $count personas.',
      one: 'Invitación enviada por SMS a 1 persona.',
    );
    return '$_temp0';
  }

  @override
  String noAccountYetFor(String emails) {
    return 'Aún sin cuenta en SafeCircle: $emails';
  }

  @override
  String get couldNotSaveCircle =>
      'No se pudo guardar el círculo. Inténtalo de nuevo.';

  @override
  String get addParticipants => 'Agregar participantes';

  @override
  String get addingTo => 'Agregando a ';

  @override
  String get addingToHint =>
      '. Los participantes se unen con el correo de su cuenta de SafeCircle — así siguen tus trayectos.';

  @override
  String get saveParticipant => 'Guardar participante';

  @override
  String get add => 'Agregar';

  @override
  String participantsCount(int count) {
    return 'PARTICIPANTES · $count';
  }

  @override
  String get noParticipantsYet => 'Aún no hay participantes';

  @override
  String get saveCircle => 'Guardar círculo';

  @override
  String get createCircle => 'Crear círculo';

  @override
  String resendAlreadyJoined(String name) {
    return '$name ya se unió a este círculo.';
  }

  @override
  String resendTexted(String name) {
    return 'Invitación reenviada por SMS a $name.';
  }

  @override
  String resendTooSoon(String name, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other:
          'Acabas de enviarle un SMS a $name. Inténtalo en $minutes minutos.',
      one: 'Acabas de enviarle un SMS a $name. Inténtalo en 1 minuto.',
    );
    return '$_temp0';
  }

  @override
  String get resendLimited =>
      'Se alcanzó el límite diario de SMS. Inténtalo mañana.';

  @override
  String resendFailed(String name) {
    return 'No se pudo enviar el SMS a $name.';
  }

  @override
  String resendFailedInAppWaiting(String name) {
    return 'No se pudo enviar el SMS a $name. La invitación en la app sigue esperándole.';
  }

  @override
  String resendInApp(String name) {
    return 'Invitación en la app reenviada a $name.';
  }

  @override
  String resendNoAccount(String name) {
    return '$name aún no tiene cuenta en SafeCircle. Agrega un teléfono para enviarle un SMS.';
  }

  @override
  String circleNotifiedNextAt(String time) {
    return 'Tu círculo fue notificado. Próximo check-in a las $time.';
  }

  @override
  String get allCheckedIn =>
      'Ya hiciste todos los check-ins de este trayecto. Buen viaje.';

  @override
  String get checkInConfirmed => '¡Check-in confirmado!';

  @override
  String get backToJourney => 'Volver al trayecto';

  @override
  String get journeyFinished => 'Trayecto terminado';

  @override
  String get journeyFinishedHint =>
      'Estás bien y tu círculo fue notificado de que llegaste.';

  @override
  String get backHome => 'Volver al inicio';

  @override
  String get emergencyContacts => 'Contactos de emergencia';

  @override
  String get emergencyContactsHint =>
      'Ante cualquier alerta reciben un SMS con tu ubicación, y una notificación en la app si usan SafeCircle.';

  @override
  String get addTwoContacts =>
      'Agrega al menos 2 contactos de emergencia para iniciar un trayecto.';

  @override
  String alwaysAlerted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Siempre alertados · $count contactos',
      one: 'Siempre alertado · 1 contacto',
    );
    return '$_temp0';
  }

  @override
  String get removeContactBody =>
      'Ya no recibirá alertas cuando envíes un SOS.';

  @override
  String get removeContact => 'Quitar contacto';

  @override
  String get addEmergencyContact => 'Agregar contacto de emergencia';

  @override
  String get noPhoneNumber => 'No hay número de teléfono.';

  @override
  String get couldNotOpenDialer => 'No se pudo abrir el marcador.';

  @override
  String get couldNotOpenMessages => 'No se pudieron abrir los mensajes.';

  @override
  String get noPhoneNumbers => 'No hay números de teléfono.';

  @override
  String get noLocationYetShort => 'Aún no hay ubicación disponible.';

  @override
  String get couldNotOpenMaps => 'No se pudo abrir la app de mapas.';

  @override
  String replayOf(String day) {
    return '$day · Repetición';
  }

  @override
  String tripSummaryTop(
      String start, String end, String distance, String speed) {
    return '$start – $end · $distance · máx. $speed';
  }

  @override
  String get metricTime => 'HORA';

  @override
  String get metricSpeed => 'VELOCIDAD';

  @override
  String get metricDistance => 'DISTANCIA';

  @override
  String get unitMph => ' mph';

  @override
  String get unitMi => ' mi';

  @override
  String leftPlace(String place) {
    return 'Salió de $place';
  }

  @override
  String get theStart => 'el inicio';

  @override
  String speedingOver(String speed) {
    return 'Exceso de velocidad · más de $speed';
  }

  @override
  String arrivedAt(String place) {
    return 'Llegó a $place';
  }

  @override
  String get theEnd => 'el destino';

  @override
  String get editProfileSub => 'Nombre, foto y datos personales';

  @override
  String get myEmergencyContacts => 'Mis contactos de emergencia';

  @override
  String peopleWillBeAlerted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personas recibirán alertas',
      one: '1 persona recibirá alertas',
    );
    return '$_temp0';
  }

  @override
  String get myCircles => 'Mis círculos';

  @override
  String completedJourneys(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trayectos completados',
      one: '1 trayecto completado',
    );
    return '$_temp0';
  }

  @override
  String get profile => 'Perfil';

  @override
  String get me => 'Yo';

  @override
  String get couldNotUpdatePhoto => 'No se pudo actualizar la foto.';

  @override
  String get waitingFirstUpdate => 'Esperando la primera actualización';

  @override
  String get liveUpdatedJustNow => 'En vivo · actualizado ahora';

  @override
  String updatedMinAgo(int minutes) {
    return 'Actualizado hace $minutes min';
  }

  @override
  String get noRecentUpdate => 'Sin actualización reciente';

  @override
  String get moving => 'En movimiento';

  @override
  String movingAt(String speed) {
    return 'En movimiento · $speed';
  }

  @override
  String get stopped => 'Detenido';

  @override
  String atPlaceSince(String time) {
    return 'En el lugar desde las $time';
  }

  @override
  String friendsNeedAttention(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amigos necesitan atención',
      one: '1 amigo necesita atención',
    );
    return '$_temp0';
  }

  @override
  String namesCheckInDue(String name) {
    return 'Le toca el check-in a $name';
  }

  @override
  String checkInsAreDue(int count) {
    return '$count check-ins pendientes';
  }

  @override
  String friendsOnJourney(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amigos en trayecto',
      one: '1 amigo en un trayecto',
    );
    return '$_temp0';
  }

  @override
  String get whosWatching => '¿Quién te acompaña?';

  @override
  String get pickCircleHint => 'Elige el círculo que seguirá este trayecto.';

  @override
  String get nobodyAcceptedYet =>
      'Nadie en este círculo ha aceptado la invitación todavía, así que nadie vería este trayecto. Espera a que un miembro acepte antes de empezar.';

  @override
  String get addTwoContactsBeforeStart =>
      'Agrega 2 contactos de emergencia antes de empezar';

  @override
  String get schedule => 'HORARIO';

  @override
  String get starting => 'Iniciando…';

  @override
  String get startJourneyButton => 'Iniciar trayecto';

  @override
  String get needCircleFirst =>
      'Primero necesitas un círculo. Toca la pestaña Círculos abajo para crear uno.';

  @override
  String peopleWatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personas acompañando',
      one: '1 persona acompañando',
    );
    return '$_temp0';
  }

  @override
  String get couldNotOpenContacts => 'No se pudieron abrir tus contactos.';

  @override
  String get nameExampleContact => 'p. ej. Jessica Moreno';

  @override
  String get photo => 'Foto';

  @override
  String get couldNotOpenPhotos => 'No se pudo abrir la galería de fotos.';

  @override
  String get photoAdded => 'Foto agregada';

  @override
  String get addPhoto => 'Agregar una foto';

  @override
  String get emailRequired => 'Correo (obligatorio)';

  @override
  String get emailShouldMatch => 'El correo debe ser el de su cuenta';

  @override
  String get importFromContacts => 'Importar de contactos';

  @override
  String circlesSummary(int circles, int members) {
    String _temp0 = intl.Intl.pluralLogic(
      circles,
      locale: localeName,
      other: '$circles círculos',
      one: '1 círculo',
    );
    String _temp1 = intl.Intl.pluralLogic(
      members,
      locale: localeName,
      other: '$members miembros',
      one: '1 miembro',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get currentPinWrong => 'El PIN actual es incorrecto.';

  @override
  String get currentPanicPinWrong => 'El PIN de pánico actual es incorrecto.';

  @override
  String get newPinFourDigits => 'El nuevo PIN debe tener 4 dígitos.';

  @override
  String get mustDifferFromPanic => 'Debe ser distinto de tu PIN de pánico.';

  @override
  String get mustDifferFromSafety =>
      'Debe ser distinto de tu PIN de seguridad.';

  @override
  String get enterValidEmail => 'Escribe un correo válido.';

  @override
  String get enterCurrentPassword => 'Escribe tu contraseña actual.';

  @override
  String get newPasswordTooShort =>
      'La nueva contraseña debe tener al menos 6 caracteres.';

  @override
  String tripsToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viajes hoy',
      one: '1 viaje hoy',
    );
    return '$_temp0';
  }

  @override
  String tripsTodayMiles(int count, String miles) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viajes · $miles mi hoy',
      one: '1 viaje · $miles mi hoy',
    );
    return '$_temp0';
  }

  @override
  String get alertsOff => 'Alertas desactivadas';

  @override
  String get alertArriveLeave => 'Alerta al llegar y salir';

  @override
  String get alertArrive => 'Alerta al llegar';

  @override
  String get alertLeave => 'Alerta al salir';

  @override
  String get tripStart => 'Inicio';

  @override
  String get tripEnd => 'Fin';

  @override
  String arrivedAtPlace(String name, String place) {
    return '$name llegó a $place';
  }

  @override
  String leftPlaceNamed(String name, String place) {
    return '$name salió de $place';
  }

  @override
  String hasLowBattery(String name) {
    return '$name tiene poca batería';
  }

  @override
  String lowBatterySub(String level) {
    return '$level · La ubicación podría dejar de actualizarse pronto';
  }

  @override
  String get myCirclesTitle => 'Mis círculos';

  @override
  String get createNewCircle => 'Crear nuevo círculo';

  @override
  String get noCircleYet => 'Aún no has creado ningún círculo';

  @override
  String get noCircleYetHint =>
      'Crea un círculo para reunir a las personas en quienes confías y compartir tus trayectos con ellas.';

  @override
  String get newCircleInvite => 'Nueva invitación a un círculo';

  @override
  String get newBadge => 'NUEVO';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String get emergencySos => 'SOS de emergencia';

  @override
  String get sosHint =>
      'Esto alerta a tu círculo en la app y envía tu ubicación por SMS a tu círculo y a tus contactos de emergencia.';

  @override
  String get sosNeedsContact =>
      'Agrega al menos un contacto de emergencia antes de poder enviar una alerta.';

  @override
  String yourEmergencyContactsCount(int count) {
    return 'Tus contactos de emergencia · $count';
  }

  @override
  String get unavailable => 'No disponible';

  @override
  String get keepHolding => 'Sigue presionando…';

  @override
  String get holdToAlert => 'Mantén presionado para alertar';

  @override
  String get addContactBeforeAlert =>
      'Agrega un contacto de emergencia antes de enviar una alerta.';

  @override
  String get notificationChannelName => 'Alertas de SafeCircle';

  @override
  String get notificationChannelDescription =>
      'Recordatorios de check-in y alertas de seguridad';

  @override
  String get reminderDueTitle => 'Hora del check-in';

  @override
  String reminderDueBody(String label, String time) {
    return '$label · $time — abre SafeCircle y confirma que estás bien.';
  }

  @override
  String get reminderLastCallTitle => 'Último aviso: confirma tu check-in';

  @override
  String reminderLastCallBody(String label, String time) {
    return '$label · $time — tu círculo recibirá una alerta en 1 minuto.';
  }

  @override
  String get testNotificationTitle =>
      'Las notificaciones de SafeCircle funcionan';

  @override
  String get testNotificationBody =>
      'Recibirás alertas así para check-ins, amigos atrasados y emergencias.';

  @override
  String get circleInvite => 'Invitación a un círculo';

  @override
  String inviteNotificationBody(String summary) {
    return '$summary — abre SafeCircle para aceptar.';
  }

  @override
  String get speedAlertTitle => 'Alerta de velocidad en tu último viaje';

  @override
  String speedAlertBody(String trip, String speed) {
    return '$trip · máx. $speed';
  }

  @override
  String get checkIn => 'Check-in';

  @override
  String checkInOverdueReachOut(String label) {
    return '$label está atrasado — comunícate.';
  }

  @override
  String get places => 'Lugares';

  @override
  String get placesHint =>
      'Tu círculo recibe una alerta cuando alguien llega a estos lugares o sale de ellos.';

  @override
  String get noPlacesYet =>
      'Aún no hay lugares. Agrega casa, escuela o trabajo y el círculo sabrá cuando alguien llegue.';

  @override
  String get addPlace => 'Agregar lugar';

  @override
  String get savedLocation => 'Ubicación guardada';

  @override
  String get couldNotUpdatePlace => 'No se pudo actualizar el lugar.';

  @override
  String get sharingPausedBanner => 'Tu ubicación compartida está en pausa';

  @override
  String get turnOnLocation => 'Activa tu ubicación';

  @override
  String get sharingPausedBannerSub =>
      'Tu círculo no puede ver dónde estás. Toca para reanudar.';

  @override
  String get turnOnLocationSub =>
      'Tu círculo aún no puede verte. Toca para permitir la ubicación.';

  @override
  String get noOneSharing => 'Nadie está compartiendo todavía';

  @override
  String get noOneSharingHint =>
      'Invita a un círculo a las personas en quienes confías. Todos los que se unan y compartan su ubicación aparecen aquí.';

  @override
  String get goToCircles => 'Ir a círculos';

  @override
  String get firstCheckIn => 'Primer check-in';

  @override
  String get secondCheckIn => 'Segundo check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String numberedCheckIn(int number) {
    return 'Check-in $number';
  }

  @override
  String couldNotJoinNoAccess(String name) {
    return 'No te pudiste unir: la app aún no tiene acceso a este círculo. Pídele a $name que te envíe la invitación de nuevo.';
  }

  @override
  String get couldNotAcceptInvite =>
      'No se pudo aceptar la invitación. Inténtalo de nuevo.';

  @override
  String get circleInviteEyebrow => 'INVITACIÓN A UN CÍRCULO';

  @override
  String addedYouToCircle(String name, String circle) {
    return '$name te agregó al círculo $circle en SafeCircle.';
  }

  @override
  String joinHint(String name) {
    return 'Únete y $name podrá invitarte a seguir sus trayectos y recibir alertas si alguna vez se atrasa. Puedes salir del círculo cuando quieras.';
  }

  @override
  String get joining => 'Uniéndote…';

  @override
  String get accept => 'Aceptar';

  @override
  String get decline => 'Rechazar';

  @override
  String get confirmToEndJourney => 'Confirma para terminar el trayecto';

  @override
  String get confirmYourCheckIn => 'Confirma tu check-in';

  @override
  String get enterPinToEnd =>
      'Escribe tu PIN para terminar este trayecto de forma segura.';

  @override
  String get incorrectPin => 'PIN incorrecto. Inténtalo de nuevo.';

  @override
  String get friendsJourneys => 'Trayectos de amigos';

  @override
  String get noNewNotifications => 'No hay notificaciones nuevas.';

  @override
  String get renameCircle => 'Renombrar círculo';

  @override
  String get nameYourCircle => 'Ponle nombre a tu círculo';

  @override
  String get circleNameHint =>
      'Elige un nombre — agrega un emoji para encontrarlo fácil.';

  @override
  String get circlesName => 'Nombre del círculo';

  @override
  String get circleNameExample => 'p. ej. 🏠 Familia';

  @override
  String get save => 'Guardar';

  @override
  String get locationSharingChannel => 'Ubicación compartida';

  @override
  String get locationSharingChannelDescription =>
      'Se muestra mientras SafeCircle comparte tu ubicación con tu círculo.';

  @override
  String get sharingNotificationTitle =>
      'SafeCircle está compartiendo tu ubicación';

  @override
  String get sharingNotificationBody => 'Tu círculo puede ver dónde estás.';

  @override
  String checkInInPast(String label) {
    return '\"$label\" ya pasó — ajusta su hora.';
  }

  @override
  String get journeyStartsWithoutLocation =>
      'Ubicación no disponible — el trayecto empieza sin posición en el mapa.';

  @override
  String get couldNotStartJourney =>
      'No se pudo iniciar el trayecto. Inténtalo de nuevo.';

  @override
  String get createYourFirstCircle => 'Crea tu primer círculo';

  @override
  String get nothingNewYet => 'Nada nuevo todavía.';

  @override
  String get activity => 'Actividad';

  @override
  String get delete => 'Borrar';

  @override
  String get back => 'Atrás';

  @override
  String get checkConnection => 'Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get couldNotLoadThis => 'No se pudo cargar';

  @override
  String get couldNotLoadAccount => 'No pudimos cargar tu cuenta';

  @override
  String get checkInternet =>
      'Revisa tu conexión a internet e inténtalo de nuevo.';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get createACircle => 'Crear un círculo';

  @override
  String get journeysList => 'Lista de trayectos';

  @override
  String get couldNotSaveContact =>
      'No se pudo guardar el contacto. Inténtalo de nuevo.';

  @override
  String get editContact => 'Editar contacto';

  @override
  String get addContactHint =>
      'Recibirá alertas en cada trayecto, siempre. Le enviaremos un SMS una vez para avisarle que lo agregaste.';

  @override
  String get sharingWithCircles =>
      'Compartiendo tu ubicación en tiempo real con tus círculos.';

  @override
  String get locationOffEnable =>
      'La ubicación está desactivada — actívala para compartir tu posición.';

  @override
  String get positionNotShared => 'Tu posición aún no se está compartiendo.';

  @override
  String get tabMap => 'Mapa';

  @override
  String get tabJourneys => 'Trayectos';

  @override
  String get tabEmergency => 'Emergencia';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get planAJourney => 'Planear un trayecto';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get addYourFirstCircle => 'Agrega tu primer círculo';

  @override
  String get resendInvitation => 'Reenviar invitación';

  @override
  String get locationNotSharedYet => 'Ubicación aún no compartida';

  @override
  String get couldNotSendAlert =>
      'No se pudo enviar la alerta. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get journeys => 'Trayectos';

  @override
  String overSpeed(String speed) {
    return 'Más de $speed';
  }

  @override
  String get withinLimit => 'Dentro del límite';

  @override
  String friendsNeedAttentionActive(int count, int active) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amigos necesitan atención',
      one: '1 amigo necesita atención',
    );
    return '$_temp0 · $active activos';
  }

  @override
  String friendsOnJourneyNow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amigos en trayecto ahora',
      one: '1 amigo en un trayecto ahora',
    );
    return '$_temp0';
  }

  @override
  String get countryUS => 'Estados Unidos';

  @override
  String get countryBR => 'Brasil';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryGB => 'Reino Unido';

  @override
  String get countryES => 'España';

  @override
  String get countryAR => 'Argentina';

  @override
  String get countryFR => 'Francia';

  @override
  String get countryMX => 'México';

  @override
  String get countryCN => 'China';

  @override
  String get countryIN => 'India';

  @override
  String get enterPinToPause => 'Escribe tu PIN para pausar.';

  @override
  String get smsConsentLabel =>
      'Aceptó recibir mensajes de SafeCircle en este número (invitaciones y alertas de seguridad). Pueden aplicarse tarifas de mensajes y datos. Puede responder STOP para darse de baja.';

  @override
  String get profilePhoneSmsNote =>
      'Al añadir tu número, aceptas recibir mensajes de SafeCircle sobre las alertas de seguridad de tus círculos. Pueden aplicarse tarifas de mensajes y datos. Responde STOP para darte de baja.';

  @override
  String get privacySmsTitle => 'Mensajes de texto';

  @override
  String get privacySmsBody =>
      'Solo enviamos mensajes a un número después de que la persona lo acepte, y solo para invitaciones a círculos y alertas de seguridad, nunca publicidad. Los números de móvil y los consentimientos nunca se venden ni se comparten con terceros o afiliados con fines publicitarios. Responde STOP a cualquier mensaje para darte de baja, o HELP para obtener ayuda.';

  @override
  String resendNoConsent(String name) {
    return '$name aún no ha aceptado recibir mensajes. Cuando acepte, edita sus datos y marca la casilla de mensajes.';
  }
}
