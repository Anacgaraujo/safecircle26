// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'SafeCircle';

  @override
  String get today => 'Hoje';

  @override
  String get tomorrow => 'Amanhã';

  @override
  String get alertKindPanic => 'Pânico silencioso';

  @override
  String get alertKindOverdue => 'Check-in perdido';

  @override
  String get alertKindSos => 'SOS';

  @override
  String alertHeadlineOverdue(String name) {
    return '$name perdeu um check-in';
  }

  @override
  String alertHeadlineHelp(String name) {
    return '$name precisa de ajuda';
  }

  @override
  String get someone => 'Alguém';

  @override
  String get aCircle => 'um círculo';

  @override
  String inviteSummary(String name, String circle) {
    return '$name convidou você para $circle';
  }

  @override
  String get circleOwner => 'Dono do círculo';

  @override
  String lastSeenAt(String time) {
    return 'Visto por último às $time';
  }

  @override
  String get enterYourName => 'Digite seu nome.';

  @override
  String get enterYourEmail => 'Digite seu e-mail.';

  @override
  String get passwordTooShort => 'A senha deve ter pelo menos 6 caracteres.';

  @override
  String get passwordsDontMatch => 'As senhas não coincidem.';

  @override
  String get enterEmailAndPassword => 'Digite seu e-mail e senha.';

  @override
  String get recoveryLinkSent =>
      'Link de recuperação enviado. Confira sua caixa de entrada.';

  @override
  String get couldNotSavePins =>
      'Não foi possível salvar seus PINs. Tente novamente.';

  @override
  String get welcomeTo => 'Bem-vindo ao';

  @override
  String get welcomeTagline =>
      'Monte um círculo de confiança e deixe alguém sempre saber que você está bem.';

  @override
  String get start => 'Começar';

  @override
  String get skipIntro => 'Pular introdução';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get joinInSeconds => 'Entre no SafeCircle em poucos segundos.';

  @override
  String get name => 'Nome';

  @override
  String get nameExample => 'ex.: Alex Morgan';

  @override
  String get email => 'E-mail';

  @override
  String get emailExample => 'nome@exemplo.com';

  @override
  String get phone => 'Telefone';

  @override
  String get password => 'Senha';

  @override
  String get repeatPassword => 'Repita a senha';

  @override
  String get creatingAccount => 'Criando conta…';

  @override
  String get register => 'Cadastrar';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta? ';

  @override
  String get login => 'Entrar';

  @override
  String get loginTagline => 'Alguém sempre sabe que você está bem.';

  @override
  String get forgotPassword => 'Esqueceu?';

  @override
  String get loggingIn => 'Entrando…';

  @override
  String get orLoginWith => 'Ou entre com...';

  @override
  String get noAccountYet => 'Não tem uma conta? ';

  @override
  String get registerExclaim => 'Cadastre-se!';

  @override
  String get socialLoginSoon => 'Login social em breve.';

  @override
  String get recoverPassword => 'Recuperar senha';

  @override
  String get recoverPasswordHint =>
      'Digite o e-mail da sua conta e enviaremos um link seguro para redefinir sua senha.';

  @override
  String get sending => 'Enviando…';

  @override
  String stepOf(int step, int total) {
    return 'PASSO $step DE $total';
  }

  @override
  String get setPanicPin => 'Defina seu PIN de pânico';

  @override
  String get setSafetyPin => 'Defina seu PIN de segurança';

  @override
  String get panicPinHint =>
      'Se for forçado a abrir o app, digite este PIN. A tela parece normal, mas seu círculo é alertado em silêncio.';

  @override
  String get safetyPinHint =>
      'Use este PIN para confirmar que está bem durante os check-ins.';

  @override
  String get panicPinMatchesSafety =>
      'Esse é igual ao seu PIN de segurança. Escolha outro código.';

  @override
  String get panicPinMustDiffer =>
      'Deve ser diferente do seu PIN de segurança.';

  @override
  String get saving => 'Salvando…';

  @override
  String get finish => 'Concluir';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get gettingStarted => 'PRIMEIROS PASSOS';

  @override
  String get createFirstCircle => 'Crie seu primeiro círculo';

  @override
  String get tapPrefix => 'Toque em ';

  @override
  String get tabCircles => 'Círculos';

  @override
  String get createFirstCircleHint =>
      ' na barra inferior, dê um nome e adicione as pessoas em quem você confia. Elas receberão um convite para acompanhar suas jornadas.';

  @override
  String get next => 'Próximo';

  @override
  String get allSet => 'Tudo pronto!';

  @override
  String get allSetHint =>
      'Seu SafeCircle está pronto. Planeje sua primeira jornada quando for sair.';

  @override
  String get enterSafeCircle => 'Entrar no SafeCircle';

  @override
  String get authInvalidEmail => 'Endereço de e-mail inválido.';

  @override
  String get authEmailInUse => 'Este e-mail já está cadastrado.';

  @override
  String get authWeakPassword => 'Senha muito fraca (mín. 6 caracteres).';

  @override
  String get authWrongCredentials => 'E-mail ou senha incorretos.';

  @override
  String get authTooManyAttempts => 'Muitas tentativas. Tente mais tarde.';

  @override
  String get authNetwork => 'Erro de rede. Verifique sua conexão.';

  @override
  String get authReloginNeeded => 'Entre novamente para fazer isso.';

  @override
  String get authGenericError => 'Erro de autenticação.';

  @override
  String get somethingWentWrong => 'Algo deu errado. Tente novamente.';

  @override
  String get settings => 'Configurações';

  @override
  String get security => 'Segurança';

  @override
  String get changeSafetyPin => 'Alterar PIN de segurança';

  @override
  String get changeSafetyPinSub => 'Confirma que você está bem no check-in';

  @override
  String get changePanicPin => 'Alterar PIN de pânico';

  @override
  String get changePanicPinSub =>
      'Código de coação silencioso · envia um alerta oculto';

  @override
  String get notifications => 'Notificações';

  @override
  String get checkInReminders => 'Lembretes de check-in';

  @override
  String get checkInRemindersSub =>
      'Me avisar quando um check-in estiver na hora';

  @override
  String get overdueCheckIns => 'Check-ins atrasados';

  @override
  String get overdueCheckInsSub =>
      'Quando um amigo perde um check-in. Alertas de pânico e SOS estão sempre ativos.';

  @override
  String get permissions => 'Permissões';

  @override
  String get permissionsSub => 'Localização, notificações, alarmes e bateria';

  @override
  String get permissionsReason =>
      'O SafeCircle só usa isso para proteger você e seu círculo.';

  @override
  String get done => 'Pronto';

  @override
  String get sendTestNotification => 'Enviar notificação de teste';

  @override
  String get sendTestNotificationSub =>
      'Verifique se os alertas chegam a este celular';

  @override
  String get testNotificationSent => 'Enviada — confira suas notificações.';

  @override
  String get testNotificationFailed =>
      'Não foi possível enviar. Verifique a permissão de notificações nas configurações do sistema.';

  @override
  String get account => 'Conta';

  @override
  String get changeEmail => 'Alterar e-mail';

  @override
  String get changePassword => 'Alterar senha';

  @override
  String get logOut => 'Sair';

  @override
  String get logOutQuestion => 'Sair?';

  @override
  String get logOutBody =>
      'Você deixará de receber alertas dos seus círculos até entrar novamente.';

  @override
  String get loggedOut => 'Você saiu.';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get deleteAccountSub => 'Apaga para sempre seu círculo e histórico';

  @override
  String get deleteAccountQuestion => 'Excluir conta?';

  @override
  String get deleteAccountBody =>
      'Isso apaga para sempre seus círculos, contatos e histórico de jornadas. Não pode ser desfeito.';

  @override
  String get accountDeleted => 'Conta excluída.';

  @override
  String get about => 'Sobre';

  @override
  String get version => 'Versão';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get aboutFooter => 'SafeCircle · Feito para manter seu círculo seguro';

  @override
  String get cancel => 'Cancelar';

  @override
  String get beforeYouStart => 'Antes de começar';

  @override
  String get journeyPermissionsReason =>
      'Uma jornada precisa disso para que seus lembretes de check-in toquem na hora certa e seu círculo veja onde você está.';

  @override
  String get shareLiveLocation => 'Compartilhe sua localização em tempo real';

  @override
  String get shareLiveLocationReason =>
      'Seu círculo vê onde você está no mapa.';

  @override
  String get notificationsOffWarning =>
      'Você não será avisado sobre alertas — ative as notificações nas Configurações.';

  @override
  String get almostThere => 'QUASE LÁ';

  @override
  String get allowPermissions => 'Permitir acessos';

  @override
  String get allowPermissionsHint =>
      'O SafeCircle só usa isso para manter você e seu círculo seguros. Você está sempre no controle — altere quando quiser nas Configurações.';

  @override
  String get locationDenied =>
      'Localização negada — ative nas configurações do sistema.';

  @override
  String get notificationsDenied =>
      'Notificações negadas — ative nas configurações do sistema.';

  @override
  String get turnOnAlarms =>
      'Ative \"Alarmes e lembretes\" para o SafeCircle e depois volte.';

  @override
  String get contactsDenied =>
      'Contatos negados — ative nas configurações do sistema.';

  @override
  String get location => 'Localização';

  @override
  String get locationPermissionSub =>
      'Para que seu círculo veja que você chegou bem.';

  @override
  String get notificationsPermissionSub =>
      'Para lembrar você quando um check-in estiver na hora.';

  @override
  String get alarmsAndReminders => 'Alarmes e lembretes';

  @override
  String get alarmsPermissionSub =>
      'Para que os lembretes de check-in toquem na hora exata.';

  @override
  String get backgroundActivity => 'Atividade em segundo plano (recomendado)';

  @override
  String get backgroundPermissionSub =>
      'Para que os lembretes funcionem mesmo com o celular parado.';

  @override
  String get contactsOptional => 'Contatos (opcional)';

  @override
  String get contactsPermissionSub =>
      'Para convidar rapidamente as pessoas em quem você confia.';

  @override
  String get locationAndNotificationsRequired =>
      'Localização e Notificações são necessárias para o SafeCircle proteger você.';

  @override
  String get locationRequired =>
      'A localização é necessária para o SafeCircle proteger você.';

  @override
  String get setUpLater => 'Configurar depois';

  @override
  String get openSystemSettings => 'Abrir configurações do sistema';

  @override
  String get allowed => 'Permitido';

  @override
  String get allow => 'Permitir';

  @override
  String get profileUpdated => 'Perfil atualizado';

  @override
  String verificationLinkSent(String email) {
    return 'Link de verificação enviado para $email — confirme para trocar.';
  }

  @override
  String get passwordChanged => 'Senha alterada';

  @override
  String get safetyPinUpdated => 'PIN de segurança atualizado';

  @override
  String get panicPinUpdated => 'PIN de pânico atualizado';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get editProfileHint =>
      'Atualize como seu círculo vê você. Seu telefone permite que amigos liguem para você durante uma jornada.';

  @override
  String changeEmailHint(String email) {
    return 'Enviaremos um link de verificação para o novo endereço. O login e os convites passam para ele após a confirmação. Atual: $email';
  }

  @override
  String get newEmail => 'Novo e-mail';

  @override
  String get currentPassword => 'Senha atual';

  @override
  String get useSixCharacters => 'Use pelo menos 6 caracteres.';

  @override
  String get newPassword => 'Nova senha';

  @override
  String get confirmNewPassword => 'Confirme a nova senha';

  @override
  String get safetyPinHintShort =>
      'Este PIN confirma que você está bem em cada check-in.';

  @override
  String get currentPin => 'PIN atual';

  @override
  String get newPin => 'Novo PIN';

  @override
  String get panicPinHintShort =>
      'Digitar este PIN parece normal, mas alerta seu círculo em silêncio.';

  @override
  String get currentPanicPin => 'PIN de pânico atual';

  @override
  String get newPanicPin => 'Novo PIN de pânico';

  @override
  String get fullName => 'Nome completo';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String deleteCircleQuestion(String circle) {
    return 'Excluir $circle?';
  }

  @override
  String get deleteCircleBody =>
      'Todos neste círculo deixam de acompanhar suas jornadas e alertas. Não pode ser desfeito.';

  @override
  String get deleteCircle => 'Excluir círculo';

  @override
  String get theOwner => 'o dono';

  @override
  String leaveCircleQuestion(String circle) {
    return 'Sair de $circle?';
  }

  @override
  String leaveCircleBody(String owner) {
    return 'Você deixará de acompanhar as jornadas e alertas de $owner, e este círculo deixará de ver sua localização. $owner pode convidar você de novo.';
  }

  @override
  String get leaveCircle => 'Sair do círculo';

  @override
  String get couldNotLeaveCircle =>
      'Não foi possível sair do círculo. Tente novamente.';

  @override
  String resendInvitationQuestion(String name) {
    return 'Reenviar convite para $name?';
  }

  @override
  String resendInvitationTextBody(String phone) {
    return 'Enviaremos outro SMS para $phone e um lembrete no app.';
  }

  @override
  String get resendInvitationAppBody =>
      'Enviaremos um lembrete no app se a pessoa tiver o SafeCircle. Se não, você escolhe como enviar o convite.';

  @override
  String get resend => 'Reenviar';

  @override
  String get couldNotResendInvitation =>
      'Não foi possível reenviar o convite. Tente novamente.';

  @override
  String removePersonQuestion(String name) {
    return 'Remover $name?';
  }

  @override
  String get removePersonBody =>
      'A pessoa deixará de acompanhar suas jornadas e de receber seus alertas.';

  @override
  String get remove => 'Remover';

  @override
  String get couldNotRemoveParticipant =>
      'Não foi possível remover o participante. Tente novamente.';

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
  String get addMoreParticipants => 'Adicionar mais participantes';

  @override
  String get deleteThisCircle => 'Excluir este círculo';

  @override
  String get leaveThisCircle => 'Sair deste círculo';

  @override
  String get deleteJourneyQuestion => 'Excluir esta jornada?';

  @override
  String deleteJourneyBody(String date) {
    return 'Isso remove a jornada de $date do seu histórico. Não pode ser desfeito.';
  }

  @override
  String get deleteJourneyBodyNoDate =>
      'Isso remove esta jornada do seu histórico. Não pode ser desfeito.';

  @override
  String get deleteJourney => 'Excluir jornada';

  @override
  String get couldNotDeleteJourney =>
      'Não foi possível excluir a jornada. Tente novamente.';

  @override
  String get deleteAllJourneysQuestion => 'Excluir todas as jornadas?';

  @override
  String deleteAllJourneysBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Isso remove todas as $count jornadas do seu histórico. Não pode ser desfeito.',
      one: 'Isso remove 1 jornada do seu histórico. Não pode ser desfeito.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAll => 'Excluir tudo';

  @override
  String journeysDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jornadas excluídas.',
      one: '1 jornada excluída.',
    );
    return '$_temp0';
  }

  @override
  String get couldNotDeleteJourneys =>
      'Não foi possível excluir suas jornadas. Tente novamente.';

  @override
  String get journeyHistory => 'Histórico de jornadas';

  @override
  String get planNewJourney => 'Planejar nova jornada';

  @override
  String get noPastJourneys => 'Nenhuma jornada anterior';

  @override
  String get noPastJourneysHint =>
      'Suas jornadas concluídas aparecerão aqui quando você terminar uma.';

  @override
  String get journey => 'Jornada';

  @override
  String get completed => 'Concluída';

  @override
  String get checkInOverdue => 'Check-in atrasado';

  @override
  String get checkInDueNow => 'Check-in agora';

  @override
  String get journeyActive => 'Jornada ativa';

  @override
  String journeyActiveAt(String place) {
    return 'Jornada ativa · $place';
  }

  @override
  String get circleColon => 'Círculo:';

  @override
  String get checkIns => 'Check-ins';

  @override
  String get endJourney => 'Encerrar jornada';

  @override
  String get getMeOut => 'Me tire daqui';

  @override
  String get messages => 'Mensagens';

  @override
  String get overdue => 'Atrasado';

  @override
  String get dueNow => 'Agora';

  @override
  String get confirmed => 'Confirmado';

  @override
  String get confirm => 'Confirmar';

  @override
  String get upcoming => 'Próximo';

  @override
  String get missedCheckInTitle => 'Você perdeu um check-in';

  @override
  String get checkInDueTitle => 'Hora do check-in — você está bem?';

  @override
  String missedCheckInBody(String label, String time) {
    return '$label · $time. Seu círculo foi alertado — confirme agora para avisar que você está bem.';
  }

  @override
  String confirmWithinBody(int minutes) {
    return 'Confirme em até $minutes min ou seu círculo será alertado.';
  }

  @override
  String get pickOneAlert => 'Escolha pelo menos um alerta.';

  @override
  String get waitingForLocation =>
      'Aguardando a localização — tente de novo em instantes.';

  @override
  String get newPlace => 'Novo lugar';

  @override
  String placeAdded(String name) {
    return '$name adicionado · o círculo será alertado';
  }

  @override
  String get couldNotSavePlace =>
      'Não foi possível salvar o lugar. Tente novamente.';

  @override
  String deleteNamedQuestion(String name) {
    return 'Excluir $name?';
  }

  @override
  String get deletePlaceBody =>
      'Seu círculo não será mais alertado sobre chegadas e saídas aqui.';

  @override
  String get deletePlace => 'Excluir lugar';

  @override
  String get editPlace => 'Editar lugar';

  @override
  String get placeNameExample => 'ex.: Academia, casa da vovó';

  @override
  String get gettingLocation => 'Obtendo sua localização…';

  @override
  String get noLocationYet => 'Ainda sem localização';

  @override
  String get useCurrentLocation => 'Usar minha localização atual';

  @override
  String get alertRadius => 'RAIO DO ALERTA';

  @override
  String get arrives => 'Chega';

  @override
  String get leaves => 'Sai';

  @override
  String get savePlace => 'Salvar lugar';

  @override
  String get you => 'Você';

  @override
  String get locating => 'Localizando…';

  @override
  String tripHistoryToday(String today) {
    return 'Histórico de trajetos · $today';
  }

  @override
  String get pauseSharing => 'Pausar compartilhamento';

  @override
  String get resumeSharing => 'Retomar compartilhamento';

  @override
  String get call => 'Ligar';

  @override
  String get message => 'Mensagem';

  @override
  String get sharingAgain =>
      'Compartilhando sua localização em tempo real de novo.';

  @override
  String get locationOffOnPhone =>
      'A localização está desligada neste celular — ative nas Configurações.';

  @override
  String get pauseSharingQuestion => 'Pausar compartilhamento de localização?';

  @override
  String get pauseSharingBody =>
      'Seu círculo não verá onde você está até você retomar. Jornadas, check-ins e SOS continuam funcionando.';

  @override
  String get pause => 'Pausar';

  @override
  String get sharingPaused => 'Compartilhamento de localização pausado.';

  @override
  String get charging => 'Carregando';

  @override
  String get lowBattery => 'Bateria fraca';

  @override
  String get battery => 'Bateria';

  @override
  String get alertResolvedReturning => 'Alerta resolvido — voltando ao início…';

  @override
  String get markedResolved => 'Marcado como resolvido';

  @override
  String youConfirmedSafe(String name) {
    return 'Você confirmou que $name está bem · agora mesmo';
  }

  @override
  String get liveLocation => 'Localização em tempo real';

  @override
  String get updating => 'Atualizando';

  @override
  String get atTimeOfAlert => 'No momento do alerta';

  @override
  String get locationUnavailable => 'Localização indisponível';

  @override
  String get pinnedOnMap => 'Marcado no mapa';

  @override
  String get noPositionShared => 'Nenhuma posição compartilhada';

  @override
  String get lastRecordedCheckIn => 'Último check-in registrado';

  @override
  String callName(String name) {
    return 'Ligar para $name';
  }

  @override
  String get openInMaps => 'Abrir no Mapas';

  @override
  String get reopenAlert => 'Reabrir alerta';

  @override
  String get markAsResolved => 'Marcar como resolvido';

  @override
  String get tripHistoryEyebrow => 'HISTÓRICO DE TRAJETOS';

  @override
  String get yourTrips => 'Seus trajetos';

  @override
  String namesTrips(String name) {
    return 'Trajetos de $name';
  }

  @override
  String get noTripsThisWeek => 'Nenhum trajeto nesta semana';

  @override
  String weekSummary(String miles, String speed) {
    return '$miles mi · Velocidade máx. $speed';
  }

  @override
  String allTripsCount(int count) {
    return 'Todos os trajetos $count';
  }

  @override
  String overSpeedCount(String speed, int count) {
    return 'Acima de $speed $count';
  }

  @override
  String tripsRecordedYou(int meters, int minutes) {
    return 'Os trajetos são registrados automaticamente sempre que você sai de um raio de $meters m e terminam após $minutes minutos parado.';
  }

  @override
  String tripsRecordedName(String name, int meters, int minutes) {
    return 'Os trajetos são registrados automaticamente sempre que $name sai de um raio de $meters m e terminam após $minutes minutos parado.';
  }

  @override
  String get noTripsRecorded => 'Nenhum trajeto registrado nesta semana.';

  @override
  String get noTripsMatch => 'Nenhum trajeto corresponde a este filtro.';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get lastWeek => 'Semana passada';

  @override
  String sinceDay(String day) {
    return 'Desde $day';
  }

  @override
  String get tripsPerWeek => 'TRAJETOS POR SEMANA';

  @override
  String get thisWeekShort => 'Esta\nsemana';

  @override
  String get lastWeekShort => 'Semana\npassada';

  @override
  String get termsServiceTitle => '1. O serviço';

  @override
  String get termsServiceBody =>
      'O SafeCircle ajuda você a compartilhar jornadas planejadas e check-ins com pessoas de confiança. Ele complementa — nunca substitui — os serviços de emergência.';

  @override
  String get termsResponsibilitiesTitle => '2. Suas responsabilidades';

  @override
  String get termsResponsibilitiesBody =>
      'Mantenha sua conta, PIN de segurança e PIN de pânico em sigilo, e só adicione contatos de emergência que concordaram em receber alertas em seu nome.';

  @override
  String get termsAlertsTitle => '3. Alertas';

  @override
  String get termsAlertsBody =>
      'Os alertas dependem da conexão do seu aparelho e das permissões de localização. Em uma situação de risco de vida, sempre contate primeiro os serviços de emergência locais.';

  @override
  String get privacyCollectTitle => 'O que coletamos';

  @override
  String get privacyCollectBody =>
      'Seus dados de perfil, planos de jornada, confirmações de check-in e — só enquanto uma jornada está ativa — sua localização.';

  @override
  String get privacyWhoTitle => 'Quem pode ver';

  @override
  String get privacyWhoBody =>
      'Somente os círculos e contatos de emergência que você escolher. Sua localização nunca é vendida nem compartilhada com anunciantes.';

  @override
  String get privacyControlTitle => 'Seu controle';

  @override
  String get privacyControlBody =>
      'Você pode encerrar o compartilhamento a qualquer momento, e excluir sua conta apaga para sempre seus círculos e histórico de jornadas.';

  @override
  String get lastUpdatedJune2026 => 'Atualizado em · junho de 2026';

  @override
  String get allCheckInsConfirmed =>
      'Todos os check-ins confirmados — encerre a jornada ao chegar';

  @override
  String labelCheckInOverdue(String label) {
    return 'Check-in \"$label\" atrasado — seu círculo foi alertado';
  }

  @override
  String labelCheckInDueNow(String label) {
    return 'Check-in \"$label\" agora — confirme que você está bem';
  }

  @override
  String nextCheckInLabel(String label, String time) {
    return 'Próximo check-in: $label · $time';
  }

  @override
  String yourJourneyWith(String circle) {
    return 'Sua jornada · $circle';
  }

  @override
  String get noActiveFriendJourneys =>
      'Nenhum amigo está em uma jornada no momento';

  @override
  String get nextCheckInPrefix => 'Próximo check-in: ';

  @override
  String get panicAlert => 'Alerta de pânico';

  @override
  String get checkInDuePrefix => 'Check-in agora: ';

  @override
  String get waiting => '· aguardando';

  @override
  String journeyWith(String circle) {
    return 'Jornada com $circle';
  }

  @override
  String get silentAlert => 'Alerta silencioso';

  @override
  String get onTime => 'No horário';

  @override
  String usedPanicPin(String name, String emergency) {
    return '$name usou o PIN de pânico — pode estar em perigo. Ligue para essa pessoa ou para $emergency.';
  }

  @override
  String missedCheckInAt(String time, String name) {
    return 'Check-in perdido às $time. Entre em contato com $name.';
  }

  @override
  String aCheckInWasMissed(String name) {
    return 'Um check-in foi perdido. Entre em contato com $name.';
  }

  @override
  String get missed => 'Perdido';

  @override
  String get alertSent => 'Alerta enviado';

  @override
  String sentJustNow(String time) {
    return '$time · agora mesmo';
  }

  @override
  String get locationShared => 'Localização compartilhada';

  @override
  String get enableLocationToShare =>
      'Ative a localização para compartilhar onde você está';

  @override
  String get live => 'Ao vivo';

  @override
  String alertedInApp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alertados no app · $count pessoas',
      one: 'Alertado no app · 1 pessoa',
    );
    return '$_temp0';
  }

  @override
  String get noOneToAlert => 'Ninguém no SafeCircle para alertar ainda';

  @override
  String get textMyLocation => 'Enviar minha localização por SMS aos contatos';

  @override
  String get emergencySmsNoLocation =>
      'EMERGÊNCIA — Preciso de ajuda. Enviado pelo SafeCircle.';

  @override
  String emergencySmsWithLocation(String link, String place) {
    return 'EMERGÊNCIA — Preciso de ajuda. Minha localização: $link ($place)';
  }

  @override
  String alsoCall(String number) {
    return 'Ligar também para $number';
  }

  @override
  String get cancelAlertSafe => 'Cancelar alerta — estou bem';

  @override
  String get callOrTextToCheck => 'Ligue ou mande mensagem para confirmar';

  @override
  String get newJourney => 'Nova jornada';

  @override
  String get newJourneyHint =>
      'Agende quando você fará check-in. Se perder um, seu círculo é alertado.';

  @override
  String get selectTiming => 'Escolha os horários';

  @override
  String get otherInformation => 'Outras informações';

  @override
  String get journeyNoteExample => 'Encontro no bar';

  @override
  String get addCheckIn => 'Adicionar check-in';

  @override
  String get startJourney => 'Iniciar a jornada';

  @override
  String get pickTimeOneMinute =>
      'Escolha um horário com pelo menos 1 minuto a partir de agora.';

  @override
  String textInvitationsSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Convite enviado por SMS para $count pessoas.',
      one: 'Convite enviado por SMS para 1 pessoa.',
    );
    return '$_temp0';
  }

  @override
  String noAccountYetFor(String emails) {
    return 'Ainda sem conta no SafeCircle: $emails';
  }

  @override
  String get couldNotSaveCircle =>
      'Não foi possível salvar o círculo. Tente novamente.';

  @override
  String get addParticipants => 'Adicionar participantes';

  @override
  String get addingTo => 'Adicionando a ';

  @override
  String get addingToHint =>
      '. Os participantes entram com o e-mail da conta SafeCircle deles — é assim que acompanham suas jornadas.';

  @override
  String get saveParticipant => 'Salvar participante';

  @override
  String get add => 'Adicionar';

  @override
  String participantsCount(int count) {
    return 'PARTICIPANTES · $count';
  }

  @override
  String get noParticipantsYet => 'Nenhum participante ainda';

  @override
  String get saveCircle => 'Salvar círculo';

  @override
  String get createCircle => 'Criar círculo';

  @override
  String resendAlreadyJoined(String name) {
    return '$name já entrou neste círculo.';
  }

  @override
  String resendTexted(String name) {
    return 'Convite reenviado por SMS para $name.';
  }

  @override
  String resendTooSoon(String name, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other:
          'Você acabou de enviar um SMS para $name. Tente de novo em $minutes minutos.',
      one:
          'Você acabou de enviar um SMS para $name. Tente de novo em 1 minuto.',
    );
    return '$_temp0';
  }

  @override
  String get resendLimited => 'Limite diário de SMS atingido. Tente amanhã.';

  @override
  String resendFailed(String name) {
    return 'Não foi possível enviar SMS para $name.';
  }

  @override
  String resendFailedInAppWaiting(String name) {
    return 'Não foi possível enviar SMS para $name. O convite no app continua esperando.';
  }

  @override
  String resendInApp(String name) {
    return 'Convite no app reenviado para $name.';
  }

  @override
  String resendNoAccount(String name) {
    return '$name ainda não tem conta no SafeCircle. Adicione um telefone para enviar SMS.';
  }

  @override
  String circleNotifiedNextAt(String time) {
    return 'Seu círculo foi avisado. Próximo check-in às $time.';
  }

  @override
  String get allCheckedIn =>
      'Todos os check-ins desta jornada foram feitos. Boa viagem.';

  @override
  String get checkInConfirmed => 'Check-in confirmado!';

  @override
  String get backToJourney => 'Voltar à jornada';

  @override
  String get journeyFinished => 'Jornada encerrada';

  @override
  String get journeyFinishedHint =>
      'Você está bem e seu círculo foi avisado que você chegou.';

  @override
  String get backHome => 'Voltar ao início';

  @override
  String get emergencyContacts => 'Contatos de emergência';

  @override
  String get emergencyContactsHint =>
      'Em qualquer alerta, eles recebem um SMS com sua localização, e uma notificação no app se usarem o SafeCircle.';

  @override
  String get addTwoContacts =>
      'Adicione pelo menos 2 contatos de emergência para iniciar uma jornada.';

  @override
  String alwaysAlerted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sempre alertados · $count contatos',
      one: 'Sempre alertado · 1 contato',
    );
    return '$_temp0';
  }

  @override
  String get removeContactBody =>
      'A pessoa não será mais alertada quando você enviar um SOS.';

  @override
  String get removeContact => 'Remover contato';

  @override
  String get addEmergencyContact => 'Adicionar contato de emergência';

  @override
  String get noPhoneNumber => 'Nenhum telefone disponível.';

  @override
  String get couldNotOpenDialer => 'Não foi possível abrir o discador.';

  @override
  String get couldNotOpenMessages => 'Não foi possível abrir as mensagens.';

  @override
  String get noPhoneNumbers => 'Nenhum telefone disponível.';

  @override
  String get noLocationYetShort => 'Ainda não há localização disponível.';

  @override
  String get couldNotOpenMaps => 'Não foi possível abrir o app de mapas.';

  @override
  String replayOf(String day) {
    return '$day · Replay';
  }

  @override
  String tripSummaryTop(
      String start, String end, String distance, String speed) {
    return '$start – $end · $distance · máx. $speed';
  }

  @override
  String get metricTime => 'HORA';

  @override
  String get metricSpeed => 'VELOCIDADE';

  @override
  String get metricDistance => 'DISTÂNCIA';

  @override
  String get unitMph => ' mph';

  @override
  String get unitMi => ' mi';

  @override
  String leftPlace(String place) {
    return 'Saiu de $place';
  }

  @override
  String get theStart => 'o início';

  @override
  String speedingOver(String speed) {
    return 'Acima do limite · mais de $speed';
  }

  @override
  String arrivedAt(String place) {
    return 'Chegou a $place';
  }

  @override
  String get theEnd => 'o destino';

  @override
  String get editProfileSub => 'Nome, foto e dados pessoais';

  @override
  String get myEmergencyContacts => 'Meus contatos de emergência';

  @override
  String peopleWillBeAlerted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pessoas serão alertadas',
      one: '1 pessoa será alertada',
    );
    return '$_temp0';
  }

  @override
  String get myCircles => 'Meus círculos';

  @override
  String completedJourneys(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jornadas concluídas',
      one: '1 jornada concluída',
    );
    return '$_temp0';
  }

  @override
  String get profile => 'Perfil';

  @override
  String get me => 'Eu';

  @override
  String get couldNotUpdatePhoto => 'Não foi possível atualizar a foto.';

  @override
  String get waitingFirstUpdate => 'Aguardando a primeira atualização';

  @override
  String get liveUpdatedJustNow => 'Ao vivo · atualizado agora';

  @override
  String updatedMinAgo(int minutes) {
    return 'Atualizado há $minutes min';
  }

  @override
  String get noRecentUpdate => 'Sem atualização recente';

  @override
  String get moving => 'Em movimento';

  @override
  String movingAt(String speed) {
    return 'Em movimento · $speed';
  }

  @override
  String get stopped => 'Parado';

  @override
  String atPlaceSince(String time) {
    return 'No local desde $time';
  }

  @override
  String friendsNeedAttention(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amigos precisam de atenção',
      one: '1 amigo precisa de atenção',
    );
    return '$_temp0';
  }

  @override
  String namesCheckInDue(String name) {
    return 'Hora do check-in de $name';
  }

  @override
  String checkInsAreDue(int count) {
    return '$count check-ins na hora';
  }

  @override
  String friendsOnJourney(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amigos em jornada',
      one: '1 amigo em uma jornada',
    );
    return '$_temp0';
  }

  @override
  String get whosWatching => 'Quem está acompanhando?';

  @override
  String get pickCircleHint =>
      'Escolha o círculo que vai acompanhar esta jornada.';

  @override
  String get nobodyAcceptedYet =>
      'Ninguém neste círculo aceitou o convite ainda, então ninguém veria esta jornada. Espere um membro aceitar antes de começar.';

  @override
  String get addTwoContactsBeforeStart =>
      'Adicione 2 contatos de emergência antes de começar';

  @override
  String get schedule => 'AGENDA';

  @override
  String get starting => 'Iniciando…';

  @override
  String get startJourneyButton => 'Iniciar jornada';

  @override
  String get needCircleFirst =>
      'Primeiro você precisa de um círculo. Toque na aba Círculos abaixo para criar um.';

  @override
  String peopleWatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pessoas acompanhando',
      one: '1 pessoa acompanhando',
    );
    return '$_temp0';
  }

  @override
  String get couldNotOpenContacts => 'Não foi possível abrir seus contatos.';

  @override
  String get nameExampleContact => 'ex.: Jéssica Moura';

  @override
  String get photo => 'Foto';

  @override
  String get couldNotOpenPhotos => 'Não foi possível abrir a galeria de fotos.';

  @override
  String get photoAdded => 'Foto adicionada';

  @override
  String get addPhoto => 'Adicionar foto';

  @override
  String get emailRequired => 'E-mail (obrigatório)';

  @override
  String get emailShouldMatch => 'O e-mail deve ser o da conta da pessoa';

  @override
  String get importFromContacts => 'Importar dos contatos';

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
      other: '$members membros',
      one: '1 membro',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get currentPinWrong => 'O PIN atual está incorreto.';

  @override
  String get currentPanicPinWrong => 'O PIN de pânico atual está incorreto.';

  @override
  String get newPinFourDigits => 'O novo PIN deve ter 4 dígitos.';

  @override
  String get mustDifferFromPanic => 'Deve ser diferente do seu PIN de pânico.';

  @override
  String get mustDifferFromSafety =>
      'Deve ser diferente do seu PIN de segurança.';

  @override
  String get enterValidEmail => 'Digite um e-mail válido.';

  @override
  String get enterCurrentPassword => 'Digite sua senha atual.';

  @override
  String get newPasswordTooShort =>
      'A nova senha deve ter pelo menos 6 caracteres.';

  @override
  String tripsToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trajetos hoje',
      one: '1 trajeto hoje',
    );
    return '$_temp0';
  }

  @override
  String tripsTodayMiles(int count, String miles) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trajetos · $miles mi hoje',
      one: '1 trajeto · $miles mi hoje',
    );
    return '$_temp0';
  }

  @override
  String get alertsOff => 'Alertas desligados';

  @override
  String get alertArriveLeave => 'Alerta ao chegar e sair';

  @override
  String get alertArrive => 'Alerta ao chegar';

  @override
  String get alertLeave => 'Alerta ao sair';

  @override
  String get tripStart => 'Início';

  @override
  String get tripEnd => 'Fim';

  @override
  String arrivedAtPlace(String name, String place) {
    return '$name chegou a $place';
  }

  @override
  String leftPlaceNamed(String name, String place) {
    return '$name saiu de $place';
  }

  @override
  String hasLowBattery(String name) {
    return '$name está com bateria fraca';
  }

  @override
  String lowBatterySub(String level) {
    return '$level · A localização pode parar de atualizar em breve';
  }

  @override
  String get myCirclesTitle => 'Meus círculos';

  @override
  String get createNewCircle => 'Criar novo círculo';

  @override
  String get noCircleYet => 'Você ainda não criou nenhum círculo';

  @override
  String get noCircleYetHint =>
      'Crie um círculo para reunir as pessoas em quem confia e compartilhar suas jornadas com elas.';

  @override
  String get newCircleInvite => 'Novo convite de círculo';

  @override
  String get newBadge => 'NOVO';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membros',
      one: '1 membro',
    );
    return '$_temp0';
  }

  @override
  String get emergencySos => 'SOS de emergência';

  @override
  String get sosHint =>
      'Isso alerta seu círculo no app e envia sua localização por SMS ao seu círculo e aos contatos de emergência.';

  @override
  String get sosNeedsContact =>
      'Adicione pelo menos um contato de emergência antes de enviar um alerta.';

  @override
  String yourEmergencyContactsCount(int count) {
    return 'Seus contatos de emergência · $count';
  }

  @override
  String get unavailable => 'Indisponível';

  @override
  String get keepHolding => 'Continue segurando…';

  @override
  String get holdToAlert => 'Segure para alertar';

  @override
  String get addContactBeforeAlert =>
      'Adicione um contato de emergência antes de enviar um alerta.';

  @override
  String get notificationChannelName => 'Alertas do SafeCircle';

  @override
  String get notificationChannelDescription =>
      'Lembretes de check-in e alertas de segurança';

  @override
  String get reminderDueTitle => 'Hora do check-in';

  @override
  String reminderDueBody(String label, String time) {
    return '$label · $time — abra o SafeCircle e confirme que você está bem.';
  }

  @override
  String get reminderLastCallTitle => 'Última chamada: confirme seu check-in';

  @override
  String reminderLastCallBody(String label, String time) {
    return '$label · $time — seu círculo será alertado em 1 minuto.';
  }

  @override
  String get testNotificationTitle =>
      'As notificações do SafeCircle estão funcionando';

  @override
  String get testNotificationBody =>
      'Você será alertado assim para check-ins, amigos atrasados e emergências.';

  @override
  String get circleInvite => 'Convite de círculo';

  @override
  String inviteNotificationBody(String summary) {
    return '$summary — abra o SafeCircle para aceitar.';
  }

  @override
  String get speedAlertTitle => 'Alerta de velocidade no seu último trajeto';

  @override
  String speedAlertBody(String trip, String speed) {
    return '$trip · máx. $speed';
  }

  @override
  String get checkIn => 'Check-in';

  @override
  String checkInOverdueReachOut(String label) {
    return '$label está atrasado — entre em contato.';
  }

  @override
  String get places => 'Lugares';

  @override
  String get placesHint =>
      'Seu círculo recebe um alerta quando alguém chega ou sai destes lugares.';

  @override
  String get noPlacesYet =>
      'Nenhum lugar ainda. Adicione casa, escola ou trabalho e o círculo é avisado quando alguém chegar.';

  @override
  String get addPlace => 'Adicionar lugar';

  @override
  String get savedLocation => 'Local salvo';

  @override
  String get couldNotUpdatePlace => 'Não foi possível atualizar o lugar.';

  @override
  String get sharingPausedBanner =>
      'Seu compartilhamento de localização está pausado';

  @override
  String get turnOnLocation => 'Ative sua localização';

  @override
  String get sharingPausedBannerSub =>
      'Seu círculo não vê onde você está. Toque para retomar.';

  @override
  String get turnOnLocationSub =>
      'Seu círculo ainda não vê você. Toque para permitir a localização.';

  @override
  String get noOneSharing => 'Ninguém está compartilhando ainda';

  @override
  String get noOneSharingHint =>
      'Convide as pessoas em quem confia para um círculo. Todos que entrarem e compartilharem a localização aparecem aqui.';

  @override
  String get goToCircles => 'Ir para círculos';

  @override
  String get firstCheckIn => 'Primeiro check-in';

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
    return 'Não foi possível entrar: o app ainda não tem acesso a este círculo. Peça para $name enviar o convite de novo.';
  }

  @override
  String get couldNotAcceptInvite =>
      'Não foi possível aceitar o convite. Tente novamente.';

  @override
  String get circleInviteEyebrow => 'CONVITE DE CÍRCULO';

  @override
  String addedYouToCircle(String name, String circle) {
    return '$name adicionou você ao círculo $circle no SafeCircle.';
  }

  @override
  String joinHint(String name) {
    return 'Entre e $name poderá convidar você para acompanhar as jornadas dele(a) e ser alertado se houver atraso. Você pode sair do círculo a qualquer momento.';
  }

  @override
  String get joining => 'Entrando…';

  @override
  String get accept => 'Aceitar';

  @override
  String get decline => 'Recusar';

  @override
  String get confirmToEndJourney => 'Confirme para encerrar a jornada';

  @override
  String get confirmYourCheckIn => 'Confirme seu check-in';

  @override
  String get enterPinToEnd =>
      'Digite seu PIN para encerrar esta jornada com segurança.';

  @override
  String get incorrectPin => 'PIN incorreto. Tente novamente.';

  @override
  String get friendsJourneys => 'Jornadas dos amigos';

  @override
  String get noNewNotifications => 'Nenhuma notificação nova.';

  @override
  String get renameCircle => 'Renomear círculo';

  @override
  String get nameYourCircle => 'Dê um nome ao seu círculo';

  @override
  String get circleNameHint =>
      'Escolha um nome — adicione um emoji para encontrar fácil.';

  @override
  String get circlesName => 'Nome do círculo';

  @override
  String get circleNameExample => 'ex.: 🏠 Família';

  @override
  String get save => 'Salvar';

  @override
  String get locationSharingChannel => 'Compartilhamento de localização';

  @override
  String get locationSharingChannelDescription =>
      'Exibido enquanto o SafeCircle compartilha sua localização com seu círculo.';

  @override
  String get sharingNotificationTitle =>
      'O SafeCircle está compartilhando sua localização';

  @override
  String get sharingNotificationBody => 'Seu círculo pode ver onde você está.';

  @override
  String checkInInPast(String label) {
    return '\"$label\" já passou — ajuste o horário.';
  }

  @override
  String get journeyStartsWithoutLocation =>
      'Localização indisponível — a jornada começa sem posição no mapa.';

  @override
  String get couldNotStartJourney =>
      'Não foi possível iniciar a jornada. Tente novamente.';

  @override
  String get createYourFirstCircle => 'Crie seu primeiro círculo';

  @override
  String get nothingNewYet => 'Nada novo ainda.';

  @override
  String get activity => 'Atividade';

  @override
  String get delete => 'Apagar';

  @override
  String get back => 'Voltar';

  @override
  String get checkConnection => 'Verifique sua conexão e tente novamente.';

  @override
  String get couldNotLoadThis => 'Não foi possível carregar';

  @override
  String get couldNotLoadAccount => 'Não conseguimos carregar sua conta';

  @override
  String get checkInternet =>
      'Verifique sua conexão com a internet e tente novamente.';

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String get createACircle => 'Criar um círculo';

  @override
  String get journeysList => 'Lista de jornadas';

  @override
  String get couldNotSaveContact =>
      'Não foi possível salvar o contato. Tente novamente.';

  @override
  String get editContact => 'Editar contato';

  @override
  String get addContactHint =>
      'Essa pessoa será alertada em todas as jornadas, sempre. Enviaremos um SMS uma vez para avisar que você a adicionou.';

  @override
  String get sharingWithCircles =>
      'Compartilhando sua localização em tempo real com seus círculos.';

  @override
  String get locationOffEnable =>
      'A localização está desligada — ative para compartilhar sua posição.';

  @override
  String get positionNotShared =>
      'Sua posição ainda não está sendo compartilhada.';

  @override
  String get tabMap => 'Mapa';

  @override
  String get tabJourneys => 'Jornadas';

  @override
  String get tabEmergency => 'Emergência';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get planAJourney => 'Planejar uma jornada';

  @override
  String get phoneNumber => 'Telefone';

  @override
  String get addYourFirstCircle => 'Adicione seu primeiro círculo';

  @override
  String get resendInvitation => 'Reenviar convite';

  @override
  String get locationNotSharedYet => 'Localização ainda não compartilhada';

  @override
  String get couldNotSendAlert =>
      'Não foi possível enviar o alerta. Verifique sua conexão e tente novamente.';

  @override
  String get journeys => 'Jornadas';

  @override
  String overSpeed(String speed) {
    return 'Acima de $speed';
  }

  @override
  String get withinLimit => 'Dentro do limite';

  @override
  String friendsNeedAttentionActive(int count, int active) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amigos precisam de atenção',
      one: '1 amigo precisa de atenção',
    );
    return '$_temp0 · $active ativos';
  }

  @override
  String friendsOnJourneyNow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amigos em jornada agora',
      one: '1 amigo em uma jornada agora',
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
  String get countryES => 'Espanha';

  @override
  String get countryAR => 'Argentina';

  @override
  String get countryFR => 'França';

  @override
  String get countryMX => 'México';

  @override
  String get countryCN => 'China';

  @override
  String get countryIN => 'Índia';

  @override
  String get enterPinToPause => 'Digite seu PIN para pausar.';

  @override
  String get smsConsentLabel =>
      'A pessoa concordou em receber mensagens do SafeCircle neste número (convites e alertas de segurança). Podem ser cobradas tarifas de mensagens e dados. Ela pode responder STOP para cancelar.';

  @override
  String get profilePhoneSmsNote =>
      'Ao adicionar seu número, você concorda em receber mensagens do SafeCircle sobre os alertas de segurança dos seus círculos. Podem ser cobradas tarifas de mensagens e dados. Responda STOP para cancelar.';

  @override
  String get privacySmsTitle => 'Mensagens de texto';

  @override
  String get privacySmsBody =>
      'Só enviamos mensagens a um número depois que a pessoa concorda, e apenas para convites de círculo e alertas de segurança — nunca marketing. Números de celular e consentimentos nunca são vendidos nem compartilhados com terceiros ou afiliados para marketing. Responda STOP a qualquer mensagem para cancelar, ou HELP para ajuda.';

  @override
  String resendNoConsent(String name) {
    return '$name ainda não concordou em receber mensagens. Quando concordar, edite os dados e marque a caixa de mensagens.';
  }

  @override
  String inviteShareMessage(String circle, String link, String email) {
    return 'Adicionei você ao meu círculo do SafeCircle \"$circle\" para a gente cuidar uns dos outros. Baixe o app: $link e cadastre-se com $email para entrar.';
  }

  @override
  String inviteShareMessageNoEmail(String circle, String link) {
    return 'Adicionei você ao meu círculo do SafeCircle \"$circle\" para a gente cuidar uns dos outros. Baixe o app: $link para entrar.';
  }

  @override
  String get inviteShareSubject => 'Entre no meu círculo do SafeCircle';
}
