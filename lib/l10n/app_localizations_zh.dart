// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'SafeCircle';

  @override
  String get today => '今天';

  @override
  String get tomorrow => '明天';

  @override
  String get alertKindPanic => '无声求救';

  @override
  String get alertKindOverdue => '错过报平安';

  @override
  String get alertKindSos => 'SOS';

  @override
  String alertHeadlineOverdue(String name) {
    return '$name错过了一次报平安';
  }

  @override
  String alertHeadlineHelp(String name) {
    return '$name需要帮助';
  }

  @override
  String get someone => '有人';

  @override
  String get aCircle => '一个圈子';

  @override
  String inviteSummary(String name, String circle) {
    return '$name邀请你加入$circle';
  }

  @override
  String get circleOwner => '圈子创建者';

  @override
  String lastSeenAt(String time) {
    return '最后更新于 $time';
  }

  @override
  String get enterYourName => '请输入你的姓名。';

  @override
  String get enterYourEmail => '请输入你的邮箱。';

  @override
  String get passwordTooShort => '密码至少需要 6 个字符。';

  @override
  String get passwordsDontMatch => '两次输入的密码不一致。';

  @override
  String get enterEmailAndPassword => '请输入邮箱和密码。';

  @override
  String get recoveryLinkSent => '重置链接已发送，请查看收件箱。';

  @override
  String get couldNotSavePins => '无法保存你的 PIN 码，请重试。';

  @override
  String get welcomeTo => '欢迎使用';

  @override
  String get welcomeTagline => '建立一个可信的圈子，让总有人知道你平安。';

  @override
  String get start => '开始';

  @override
  String get skipIntro => '跳过介绍';

  @override
  String get createAccount => '创建账号';

  @override
  String get joinInSeconds => '几秒钟即可加入 SafeCircle。';

  @override
  String get name => '姓名';

  @override
  String get nameExample => '例如：王小明';

  @override
  String get email => '邮箱';

  @override
  String get emailExample => 'name@example.com';

  @override
  String get phone => '电话';

  @override
  String get password => '密码';

  @override
  String get repeatPassword => '再次输入密码';

  @override
  String get creatingAccount => '正在创建账号…';

  @override
  String get register => '注册';

  @override
  String get alreadyHaveAccount => '已有账号？';

  @override
  String get login => '登录';

  @override
  String get loginTagline => '总有人知道你平安。';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get loggingIn => '正在登录…';

  @override
  String get orLoginWith => '或使用以下方式登录…';

  @override
  String get noAccountYet => '还没有账号？';

  @override
  String get registerExclaim => '立即注册！';

  @override
  String get socialLoginSoon => '社交账号登录即将推出。';

  @override
  String get recoverPassword => '找回密码';

  @override
  String get recoverPasswordHint => '输入账号绑定的邮箱，我们会发送一个安全链接帮你重置密码。';

  @override
  String get sending => '正在发送…';

  @override
  String stepOf(int step, int total) {
    return '第 $step 步，共 $total 步';
  }

  @override
  String get setPanicPin => '设置求救 PIN 码';

  @override
  String get setSafetyPin => '设置平安 PIN 码';

  @override
  String get panicPinHint => '如果你被迫打开应用，请输入此 PIN 码。屏幕看起来一切正常，但你的圈子会悄悄收到警报。';

  @override
  String get safetyPinHint => '报平安时用这个 PIN 码确认你安全。';

  @override
  String get panicPinMatchesSafety => '与你的平安 PIN 码相同，请换一个。';

  @override
  String get panicPinMustDiffer => '必须与平安 PIN 码不同。';

  @override
  String get saving => '正在保存…';

  @override
  String get finish => '完成';

  @override
  String get continueLabel => '继续';

  @override
  String get gettingStarted => '快速上手';

  @override
  String get createFirstCircle => '创建你的第一个圈子';

  @override
  String get tapPrefix => '点按底部栏中的';

  @override
  String get tabCircles => '圈子';

  @override
  String get createFirstCircleHint => '，起个名字，然后添加你信任的人。他们会收到邀请，可以关注你的行程。';

  @override
  String get next => '下一步';

  @override
  String get allSet => '一切就绪！';

  @override
  String get allSetHint => '你的 SafeCircle 已准备好。出门时就可以规划第一段行程。';

  @override
  String get enterSafeCircle => '进入 SafeCircle';

  @override
  String get authInvalidEmail => '邮箱地址无效。';

  @override
  String get authEmailInUse => '该邮箱已被注册。';

  @override
  String get authWeakPassword => '密码太弱（至少 6 个字符）。';

  @override
  String get authWrongCredentials => '邮箱或密码错误。';

  @override
  String get authTooManyAttempts => '尝试次数过多，请稍后再试。';

  @override
  String get authNetwork => '网络错误，请检查网络连接。';

  @override
  String get authReloginNeeded => '请重新登录后再进行此操作。';

  @override
  String get authGenericError => '身份验证出错。';

  @override
  String get somethingWentWrong => '出了点问题，请重试。';

  @override
  String get settings => '设置';

  @override
  String get security => '安全';

  @override
  String get changeSafetyPin => '更改平安 PIN 码';

  @override
  String get changeSafetyPinSub => '报平安时确认你安全';

  @override
  String get changePanicPin => '更改求救 PIN 码';

  @override
  String get changePanicPinSub => '无声胁迫码 · 发送隐藏警报';

  @override
  String get notifications => '通知';

  @override
  String get checkInReminders => '报平安提醒';

  @override
  String get checkInRemindersSub => '到报平安时间时提醒我';

  @override
  String get overdueCheckIns => '逾期报平安';

  @override
  String get overdueCheckInsSub => '朋友错过报平安时通知我。求救和 SOS 警报始终开启。';

  @override
  String get permissions => '权限';

  @override
  String get permissionsSub => '位置、通知、闹钟和电池';

  @override
  String get permissionsReason => 'SafeCircle 仅用这些权限保护你和你的圈子。';

  @override
  String get done => '完成';

  @override
  String get sendTestNotification => '发送测试通知';

  @override
  String get sendTestNotificationSub => '确认警报能送达这部手机';

  @override
  String get testNotificationSent => '已发送 — 请查看通知栏。';

  @override
  String get testNotificationFailed => '发送失败。请在系统设置中检查通知权限。';

  @override
  String get account => '账号';

  @override
  String get changeEmail => '更改邮箱';

  @override
  String get changePassword => '更改密码';

  @override
  String get logOut => '退出登录';

  @override
  String get logOutQuestion => '要退出登录吗？';

  @override
  String get logOutBody => '在重新登录之前，你将收不到圈子的警报。';

  @override
  String get loggedOut => '已退出登录。';

  @override
  String get deleteAccount => '删除账号';

  @override
  String get deleteAccountSub => '永久清除你的圈子和历史记录';

  @override
  String get deleteAccountQuestion => '要删除账号吗？';

  @override
  String get deleteAccountBody => '这将永久清除你的圈子、联系人和行程记录，且无法撤销。';

  @override
  String get accountDeleted => '账号已删除。';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get termsOfService => '服务条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get aboutFooter => 'SafeCircle · 守护你的圈子';

  @override
  String get cancel => '取消';

  @override
  String get beforeYouStart => '开始之前';

  @override
  String get journeyPermissionsReason => '行程需要这些权限，才能让报平安提醒准时响起，并让你的圈子看到你在哪里。';

  @override
  String get shareLiveLocation => '共享你的实时位置';

  @override
  String get shareLiveLocationReason => '你的圈子可以在地图上看到你的位置。';

  @override
  String get notificationsOffWarning => '你将收不到警报通知 — 请在设置中开启通知。';

  @override
  String get almostThere => '快完成了';

  @override
  String get allowPermissions => '允许权限';

  @override
  String get allowPermissionsHint =>
      'SafeCircle 仅用这些权限保障你和圈子的安全。一切由你掌控 — 随时可在设置中更改。';

  @override
  String get locationDenied => '位置权限被拒绝 — 请在系统设置中开启。';

  @override
  String get notificationsDenied => '通知权限被拒绝 — 请在系统设置中开启。';

  @override
  String get turnOnAlarms => '请为 SafeCircle 开启“闹钟和提醒”，然后返回。';

  @override
  String get contactsDenied => '通讯录权限被拒绝 — 请在系统设置中开启。';

  @override
  String get location => '位置';

  @override
  String get locationPermissionSub => '让你的圈子知道你已平安到达。';

  @override
  String get notificationsPermissionSub => '在报平安时间到来时提醒你。';

  @override
  String get alarmsAndReminders => '闹钟和提醒';

  @override
  String get alarmsPermissionSub => '让报平安提醒准时响起。';

  @override
  String get backgroundActivity => '后台活动（推荐）';

  @override
  String get backgroundPermissionSub => '手机闲置时提醒也能正常触发。';

  @override
  String get contactsOptional => '通讯录（可选）';

  @override
  String get contactsPermissionSub => '快速邀请你信任的人。';

  @override
  String get locationAndNotificationsRequired => 'SafeCircle 需要位置和通知权限才能保护你。';

  @override
  String get locationRequired => 'SafeCircle 需要位置权限才能保护你。';

  @override
  String get setUpLater => '稍后设置';

  @override
  String get openSystemSettings => '打开系统设置';

  @override
  String get allowed => '已允许';

  @override
  String get allow => '允许';

  @override
  String get profileUpdated => '个人资料已更新';

  @override
  String verificationLinkSent(String email) {
    return '验证链接已发送至 $email — 确认后即可切换。';
  }

  @override
  String get passwordChanged => '密码已更改';

  @override
  String get safetyPinUpdated => '平安 PIN 码已更新';

  @override
  String get panicPinUpdated => '求救 PIN 码已更新';

  @override
  String get editProfile => '编辑个人资料';

  @override
  String get editProfileHint => '更新你在圈子中的显示信息。留下电话，朋友在行程中可以直接打给你。';

  @override
  String changeEmailHint(String email) {
    return '我们会向新地址发送验证链接。确认后，登录和邀请都会转到新邮箱。当前邮箱：$email';
  }

  @override
  String get newEmail => '新邮箱';

  @override
  String get currentPassword => '当前密码';

  @override
  String get useSixCharacters => '至少使用 6 个字符。';

  @override
  String get newPassword => '新密码';

  @override
  String get confirmNewPassword => '确认新密码';

  @override
  String get safetyPinHintShort => '每次报平安时用此 PIN 码确认你安全。';

  @override
  String get currentPin => '当前 PIN 码';

  @override
  String get newPin => '新 PIN 码';

  @override
  String get panicPinHintShort => '输入此 PIN 码时一切看似正常，但会悄悄通知你的圈子。';

  @override
  String get currentPanicPin => '当前求救 PIN 码';

  @override
  String get newPanicPin => '新求救 PIN 码';

  @override
  String get fullName => '全名';

  @override
  String get saveChanges => '保存更改';

  @override
  String deleteCircleQuestion(String circle) {
    return '要删除$circle吗？';
  }

  @override
  String get deleteCircleBody => '圈子里的所有人将不再关注你的行程和警报，且无法撤销。';

  @override
  String get deleteCircle => '删除圈子';

  @override
  String get theOwner => '创建者';

  @override
  String leaveCircleQuestion(String circle) {
    return '要退出$circle吗？';
  }

  @override
  String leaveCircleBody(String owner) {
    return '你将不再关注$owner的行程和警报，这个圈子也将看不到你的位置。$owner可以再次邀请你。';
  }

  @override
  String get leaveCircle => '退出圈子';

  @override
  String get couldNotLeaveCircle => '无法退出圈子，请重试。';

  @override
  String resendInvitationQuestion(String name) {
    return '要重新邀请$name吗？';
  }

  @override
  String resendInvitationTextBody(String phone) {
    return '我们会再次向 $phone 发送短信，并在应用内提醒对方。';
  }

  @override
  String get resendInvitationAppBody =>
      '如果对方有 SafeCircle，我们会在应用内提醒。如果没有，你可以自己选择发送邀请的方式。';

  @override
  String get resend => '重新发送';

  @override
  String get couldNotResendInvitation => '无法重新发送邀请，请重试。';

  @override
  String removePersonQuestion(String name) {
    return '要移除$name吗？';
  }

  @override
  String get removePersonBody => '对方将不再关注你的行程，也收不到你的警报。';

  @override
  String get remove => '移除';

  @override
  String get couldNotRemoveParticipant => '无法移除该成员，请重试。';

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位成员',
    );
    return '$_temp0';
  }

  @override
  String get participants => '成员';

  @override
  String get addMoreParticipants => '添加更多成员';

  @override
  String get deleteThisCircle => '删除这个圈子';

  @override
  String get leaveThisCircle => '退出这个圈子';

  @override
  String get deleteJourneyQuestion => '要删除这段行程吗？';

  @override
  String deleteJourneyBody(String date) {
    return '这会从记录中删除 $date 的行程，且无法撤销。';
  }

  @override
  String get deleteJourneyBodyNoDate => '这会从记录中删除这段行程，且无法撤销。';

  @override
  String get deleteJourney => '删除行程';

  @override
  String get couldNotDeleteJourney => '无法删除行程，请重试。';

  @override
  String get deleteAllJourneysQuestion => '要删除所有行程吗？';

  @override
  String deleteAllJourneysBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '这会从记录中删除全部 $count 段行程，且无法撤销。',
    );
    return '$_temp0';
  }

  @override
  String get deleteAll => '全部删除';

  @override
  String journeysDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已删除 $count 段行程。',
    );
    return '$_temp0';
  }

  @override
  String get couldNotDeleteJourneys => '无法删除你的行程，请重试。';

  @override
  String get journeyHistory => '行程记录';

  @override
  String get planNewJourney => '规划新行程';

  @override
  String get noPastJourneys => '还没有过往行程';

  @override
  String get noPastJourneysHint => '完成行程后，记录会显示在这里。';

  @override
  String get journey => '行程';

  @override
  String get completed => '已完成';

  @override
  String get checkInOverdue => '报平安已逾期';

  @override
  String get checkInDueNow => '该报平安了';

  @override
  String get journeyActive => '行程进行中';

  @override
  String journeyActiveAt(String place) {
    return '行程进行中 · $place';
  }

  @override
  String get circleColon => '圈子：';

  @override
  String get checkIns => '报平安';

  @override
  String get endJourney => '结束行程';

  @override
  String get getMeOut => '带我离开这里';

  @override
  String get messages => '信息';

  @override
  String get overdue => '已逾期';

  @override
  String get dueNow => '现在';

  @override
  String get confirmed => '已确认';

  @override
  String get confirm => '确认';

  @override
  String get upcoming => '即将到来';

  @override
  String get missedCheckInTitle => '你错过了一次报平安';

  @override
  String get checkInDueTitle => '该报平安了 — 你还好吗？';

  @override
  String missedCheckInBody(String label, String time) {
    return '$label · $time。你的圈子已收到警报 — 现在确认，让他们知道你没事。';
  }

  @override
  String confirmWithinBody(int minutes) {
    return '请在 $minutes 分钟内确认，否则你的圈子会收到警报。';
  }

  @override
  String get pickOneAlert => '请至少选择一种提醒。';

  @override
  String get waitingForLocation => '正在等待定位 — 请稍后再试。';

  @override
  String get newPlace => '新地点';

  @override
  String placeAdded(String name) {
    return '已添加$name · 圈子将收到提醒';
  }

  @override
  String get couldNotSavePlace => '无法保存地点，请重试。';

  @override
  String deleteNamedQuestion(String name) {
    return '要删除$name吗？';
  }

  @override
  String get deletePlaceBody => '你的圈子将不再收到此处的到达和离开提醒。';

  @override
  String get deletePlace => '删除地点';

  @override
  String get editPlace => '编辑地点';

  @override
  String get placeNameExample => '例如：健身房、外婆家';

  @override
  String get gettingLocation => '正在获取你的位置…';

  @override
  String get noLocationYet => '暂无位置';

  @override
  String get useCurrentLocation => '使用我当前的位置';

  @override
  String get alertRadius => '提醒范围';

  @override
  String get arrives => '到达时';

  @override
  String get leaves => '离开时';

  @override
  String get savePlace => '保存地点';

  @override
  String get you => '你';

  @override
  String get locating => '正在定位…';

  @override
  String tripHistoryToday(String today) {
    return '出行记录 · $today';
  }

  @override
  String get pauseSharing => '暂停共享';

  @override
  String get resumeSharing => '恢复共享';

  @override
  String get call => '打电话';

  @override
  String get message => '发信息';

  @override
  String get sharingAgain => '已重新共享你的实时位置。';

  @override
  String get locationOffOnPhone => '这部手机的定位已关闭 — 请在设置中开启。';

  @override
  String get pauseSharingQuestion => '要暂停位置共享吗？';

  @override
  String get pauseSharingBody => '在你恢复之前，圈子看不到你的位置。行程、报平安和 SOS 仍可正常使用。';

  @override
  String get pause => '暂停';

  @override
  String get sharingPaused => '位置共享已暂停。';

  @override
  String get charging => '充电中';

  @override
  String get lowBattery => '电量低';

  @override
  String get battery => '电量';

  @override
  String get alertResolvedReturning => '警报已解除 — 正在返回首页…';

  @override
  String get markedResolved => '已标记为解除';

  @override
  String youConfirmedSafe(String name) {
    return '你已确认$name安全 · 刚刚';
  }

  @override
  String get liveLocation => '实时位置';

  @override
  String get updating => '更新中';

  @override
  String get atTimeOfAlert => '警报发出时';

  @override
  String get locationUnavailable => '位置不可用';

  @override
  String get pinnedOnMap => '已在地图上标记';

  @override
  String get noPositionShared => '未共享位置';

  @override
  String get lastRecordedCheckIn => '最近一次报平安';

  @override
  String callName(String name) {
    return '打给$name';
  }

  @override
  String get openInMaps => '在地图中打开';

  @override
  String get reopenAlert => '重新打开警报';

  @override
  String get markAsResolved => '标记为解除';

  @override
  String get tripHistoryEyebrow => '出行记录';

  @override
  String get yourTrips => '你的出行';

  @override
  String namesTrips(String name) {
    return '$name的出行';
  }

  @override
  String get noTripsThisWeek => '本周没有出行';

  @override
  String weekSummary(String miles, String speed) {
    return '$miles 英里 · 最高速度 $speed';
  }

  @override
  String allTripsCount(int count) {
    return '全部出行 $count';
  }

  @override
  String overSpeedCount(String speed, int count) {
    return '超过 $speed $count';
  }

  @override
  String tripsRecordedYou(int meters, int minutes) {
    return '当你离开 $meters 米范围时会自动记录出行，停留 $minutes 分钟后结束。';
  }

  @override
  String tripsRecordedName(String name, int meters, int minutes) {
    return '当$name离开 $meters 米范围时会自动记录出行，停留 $minutes 分钟后结束。';
  }

  @override
  String get noTripsRecorded => '本周没有出行记录。';

  @override
  String get noTripsMatch => '没有符合筛选条件的出行。';

  @override
  String get thisWeek => '本周';

  @override
  String get lastWeek => '上周';

  @override
  String sinceDay(String day) {
    return '自 $day 起';
  }

  @override
  String get tripsPerWeek => '每周出行次数';

  @override
  String get thisWeekShort => '本周';

  @override
  String get lastWeekShort => '上周';

  @override
  String get termsServiceTitle => '1. 服务内容';

  @override
  String get termsServiceBody =>
      'SafeCircle 帮你与信任的人分享计划行程和报平安记录。它是紧急服务的补充 — 绝不能替代紧急服务。';

  @override
  String get termsResponsibilitiesTitle => '2. 你的责任';

  @override
  String get termsResponsibilitiesBody =>
      '请妥善保管你的账号、平安 PIN 码和求救 PIN 码，并且只添加同意代你接收警报的紧急联系人。';

  @override
  String get termsAlertsTitle => '3. 警报';

  @override
  String get termsAlertsBody => '警报取决于设备的网络连接和定位权限。遇到危及生命的情况，请始终先联系当地紧急服务。';

  @override
  String get privacyCollectTitle => '我们收集的信息';

  @override
  String get privacyCollectBody => '你的个人资料、行程计划、报平安确认，以及 — 仅在行程进行期间 — 你的位置。';

  @override
  String get privacyWhoTitle => '谁能看到';

  @override
  String get privacyWhoBody => '只有你选择的圈子和紧急联系人。你的位置绝不会被出售或分享给广告商。';

  @override
  String get privacyControlTitle => '由你掌控';

  @override
  String get privacyControlBody => '你可以随时停止共享，删除账号会永久清除你的圈子和行程记录。';

  @override
  String get lastUpdatedJune2026 => '最后更新 · 2026 年 6 月';

  @override
  String get allCheckInsConfirmed => '所有报平安均已确认 — 到达后请结束行程';

  @override
  String labelCheckInOverdue(String label) {
    return '“$label”报平安已逾期 — 你的圈子已收到警报';
  }

  @override
  String labelCheckInDueNow(String label) {
    return '“$label”该报平安了 — 请确认你安全';
  }

  @override
  String nextCheckInLabel(String label, String time) {
    return '下次报平安：$label · $time';
  }

  @override
  String yourJourneyWith(String circle) {
    return '你的行程 · $circle';
  }

  @override
  String get noActiveFriendJourneys => '目前没有朋友在行程中';

  @override
  String get nextCheckInPrefix => '下次报平安：';

  @override
  String get panicAlert => '求救警报';

  @override
  String get checkInDuePrefix => '该报平安：';

  @override
  String get waiting => '· 等待中';

  @override
  String journeyWith(String circle) {
    return '与$circle的行程';
  }

  @override
  String get silentAlert => '无声警报';

  @override
  String get onTime => '准时';

  @override
  String usedPanicPin(String name, String emergency) {
    return '$name使用了求救 PIN 码 — 可能有危险。请给对方打电话，或拨打 $emergency。';
  }

  @override
  String missedCheckInAt(String time, String name) {
    return '错过了 $time 的报平安。请联系$name。';
  }

  @override
  String aCheckInWasMissed(String name) {
    return '错过了一次报平安。请联系$name。';
  }

  @override
  String get missed => '已错过';

  @override
  String get alertSent => '警报已发送';

  @override
  String sentJustNow(String time) {
    return '$time · 刚刚';
  }

  @override
  String get locationShared => '已共享位置';

  @override
  String get enableLocationToShare => '开启定位以共享你的位置';

  @override
  String get live => '实时';

  @override
  String alertedInApp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已在应用内通知 · $count 人',
    );
    return '$_temp0';
  }

  @override
  String get noOneToAlert => 'SafeCircle 上还没有可通知的人';

  @override
  String get textMyLocation => '用短信把我的位置发给联系人';

  @override
  String get emergencySmsNoLocation => '紧急情况 — 我需要帮助。通过 SafeCircle 发送。';

  @override
  String emergencySmsWithLocation(String link, String place) {
    return '紧急情况 — 我需要帮助。我的位置：$link（$place）';
  }

  @override
  String alsoCall(String number) {
    return '同时拨打 $number';
  }

  @override
  String get cancelAlertSafe => '取消警报 — 我很安全';

  @override
  String get callOrTextToCheck => '打电话或发信息确认一下';

  @override
  String get newJourney => '新行程';

  @override
  String get newJourneyHint => '安排报平安的时间。如果错过一次，你的圈子会收到警报。';

  @override
  String get selectTiming => '选择时间';

  @override
  String get otherInformation => '其他信息';

  @override
  String get journeyNoteExample => '在酒吧见面';

  @override
  String get addCheckIn => '添加报平安';

  @override
  String get startJourney => '开始行程';

  @override
  String get pickTimeOneMinute => '请选择至少 1 分钟之后的时间。';

  @override
  String textInvitationsSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已通过短信邀请 $count 人。',
    );
    return '$_temp0';
  }

  @override
  String noAccountYetFor(String emails) {
    return '以下邮箱还没有 SafeCircle 账号：$emails';
  }

  @override
  String get couldNotSaveCircle => '无法保存圈子，请重试。';

  @override
  String get addParticipants => '添加成员';

  @override
  String get addingTo => '正在添加到';

  @override
  String get addingToHint => '。成员使用其 SafeCircle 账号的邮箱加入 — 这样他们才能关注你的行程。';

  @override
  String get saveParticipant => '保存成员';

  @override
  String get add => '添加';

  @override
  String participantsCount(int count) {
    return '成员 · $count';
  }

  @override
  String get noParticipantsYet => '还没有成员';

  @override
  String get saveCircle => '保存圈子';

  @override
  String get createCircle => '创建圈子';

  @override
  String resendAlreadyJoined(String name) {
    return '$name已经加入了这个圈子。';
  }

  @override
  String resendTexted(String name) {
    return '已再次通过短信邀请$name。';
  }

  @override
  String resendTooSoon(String name, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '你刚给$name发过短信，请在 $minutes 分钟后再试。',
    );
    return '$_temp0';
  }

  @override
  String get resendLimited => '已达到每日短信上限，请明天再试。';

  @override
  String resendFailed(String name) {
    return '无法给$name发送短信。';
  }

  @override
  String resendFailedInAppWaiting(String name) {
    return '无法给$name发送短信。应用内邀请仍在等待对方接受。';
  }

  @override
  String resendInApp(String name) {
    return '已在应用内再次邀请$name。';
  }

  @override
  String resendNoAccount(String name) {
    return '$name还没有 SafeCircle 账号。添加电话号码即可发送短信。';
  }

  @override
  String circleNotifiedNextAt(String time) {
    return '已通知你的圈子。下次报平安时间：$time。';
  }

  @override
  String get allCheckedIn => '这段行程的报平安都已完成。一路平安。';

  @override
  String get checkInConfirmed => '报平安已确认！';

  @override
  String get backToJourney => '返回行程';

  @override
  String get journeyFinished => '行程已结束';

  @override
  String get journeyFinishedHint => '你很安全，圈子已收到你到达的通知。';

  @override
  String get backHome => '返回首页';

  @override
  String get emergencyContacts => '紧急联系人';

  @override
  String get emergencyContactsHint =>
      '发生任何警报时，他们都会收到附有你位置的短信；如果他们使用 SafeCircle，还会收到应用通知。';

  @override
  String get addTwoContacts => '至少添加 2 位紧急联系人才能开始行程。';

  @override
  String alwaysAlerted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '始终通知 · $count 位联系人',
    );
    return '$_temp0';
  }

  @override
  String get removeContactBody => '你发出 SOS 时，对方将不再收到警报。';

  @override
  String get removeContact => '移除联系人';

  @override
  String get addEmergencyContact => '添加紧急联系人';

  @override
  String get noPhoneNumber => '没有可用的电话号码。';

  @override
  String get couldNotOpenDialer => '无法打开拨号界面。';

  @override
  String get couldNotOpenMessages => '无法打开信息。';

  @override
  String get noPhoneNumbers => '没有可用的电话号码。';

  @override
  String get noLocationYetShort => '暂无可用位置。';

  @override
  String get couldNotOpenMaps => '无法打开地图应用。';

  @override
  String replayOf(String day) {
    return '$day · 回放';
  }

  @override
  String tripSummaryTop(
      String start, String end, String distance, String speed) {
    return '$start – $end · $distance · 最高 $speed';
  }

  @override
  String get metricTime => '时间';

  @override
  String get metricSpeed => '速度';

  @override
  String get metricDistance => '距离';

  @override
  String get unitMph => ' 英里/时';

  @override
  String get unitMi => ' 英里';

  @override
  String leftPlace(String place) {
    return '离开$place';
  }

  @override
  String get theStart => '起点';

  @override
  String speedingOver(String speed) {
    return '超速 · 超过 $speed';
  }

  @override
  String arrivedAt(String place) {
    return '到达$place';
  }

  @override
  String get theEnd => '终点';

  @override
  String get editProfileSub => '姓名、照片和个人信息';

  @override
  String get myEmergencyContacts => '我的紧急联系人';

  @override
  String peopleWillBeAlerted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '将通知 $count 人',
    );
    return '$_temp0';
  }

  @override
  String get myCircles => '我的圈子';

  @override
  String completedJourneys(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已完成 $count 段行程',
    );
    return '$_temp0';
  }

  @override
  String get profile => '我的';

  @override
  String get me => '我';

  @override
  String get couldNotUpdatePhoto => '无法更新照片。';

  @override
  String get waitingFirstUpdate => '正在等待首次更新';

  @override
  String get liveUpdatedJustNow => '实时 · 刚刚更新';

  @override
  String updatedMinAgo(int minutes) {
    return '$minutes 分钟前更新';
  }

  @override
  String get noRecentUpdate => '近期没有更新';

  @override
  String get moving => '移动中';

  @override
  String movingAt(String speed) {
    return '移动中 · $speed';
  }

  @override
  String get stopped => '已停留';

  @override
  String atPlaceSince(String time) {
    return '自 $time 起停留于此';
  }

  @override
  String friendsNeedAttention(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位朋友需要关注',
    );
    return '$_temp0';
  }

  @override
  String namesCheckInDue(String name) {
    return '$name该报平安了';
  }

  @override
  String checkInsAreDue(int count) {
    return '$count 个报平安已到时间';
  }

  @override
  String friendsOnJourney(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位朋友在行程中',
    );
    return '$_temp0';
  }

  @override
  String get whosWatching => '谁来关注你？';

  @override
  String get pickCircleHint => '选择关注这段行程的圈子。';

  @override
  String get nobodyAcceptedYet => '这个圈子里还没有人接受邀请，所以没人能看到这段行程。请等成员接受后再开始。';

  @override
  String get addTwoContactsBeforeStart => '开始前请添加 2 位紧急联系人';

  @override
  String get schedule => '时间安排';

  @override
  String get starting => '正在开始…';

  @override
  String get startJourneyButton => '开始行程';

  @override
  String get needCircleFirst => '你需要先有一个圈子。点按下方的“圈子”标签来创建。';

  @override
  String peopleWatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人在关注',
    );
    return '$_temp0';
  }

  @override
  String get couldNotOpenContacts => '无法打开你的通讯录。';

  @override
  String get nameExampleContact => '例如：李小红';

  @override
  String get photo => '照片';

  @override
  String get couldNotOpenPhotos => '无法打开相册。';

  @override
  String get photoAdded => '已添加照片';

  @override
  String get addPhoto => '添加照片';

  @override
  String get emailRequired => '邮箱（必填）';

  @override
  String get emailShouldMatch => '需与对方账号邮箱一致';

  @override
  String get importFromContacts => '从通讯录导入';

  @override
  String circlesSummary(int circles, int members) {
    String _temp0 = intl.Intl.pluralLogic(
      circles,
      locale: localeName,
      other: '$circles 个圈子',
    );
    String _temp1 = intl.Intl.pluralLogic(
      members,
      locale: localeName,
      other: '$members 位成员',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get currentPinWrong => '当前 PIN 码不正确。';

  @override
  String get currentPanicPinWrong => '当前求救 PIN 码不正确。';

  @override
  String get newPinFourDigits => '新 PIN 码必须是 4 位数字。';

  @override
  String get mustDifferFromPanic => '必须与求救 PIN 码不同。';

  @override
  String get mustDifferFromSafety => '必须与平安 PIN 码不同。';

  @override
  String get enterValidEmail => '请输入有效的邮箱。';

  @override
  String get enterCurrentPassword => '请输入当前密码。';

  @override
  String get newPasswordTooShort => '新密码至少需要 6 个字符。';

  @override
  String tripsToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '今天 $count 次出行',
    );
    return '$_temp0';
  }

  @override
  String tripsTodayMiles(int count, String miles) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '今天 $count 次出行 · $miles 英里',
    );
    return '$_temp0';
  }

  @override
  String get alertsOff => '提醒已关闭';

  @override
  String get alertArriveLeave => '到达和离开时提醒';

  @override
  String get alertArrive => '到达时提醒';

  @override
  String get alertLeave => '离开时提醒';

  @override
  String get tripStart => '起点';

  @override
  String get tripEnd => '终点';

  @override
  String arrivedAtPlace(String name, String place) {
    return '$name已到达$place';
  }

  @override
  String leftPlaceNamed(String name, String place) {
    return '$name已离开$place';
  }

  @override
  String hasLowBattery(String name) {
    return '$name的手机电量低';
  }

  @override
  String lowBatterySub(String level) {
    return '$level · 位置可能很快停止更新';
  }

  @override
  String get myCirclesTitle => '我的圈子';

  @override
  String get createNewCircle => '创建新圈子';

  @override
  String get noCircleYet => '你还没有创建任何圈子';

  @override
  String get noCircleYetHint => '创建一个圈子，把你信任的人聚在一起，与他们分享你的行程。';

  @override
  String get newCircleInvite => '新的圈子邀请';

  @override
  String get newBadge => '新';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位成员',
    );
    return '$_temp0';
  }

  @override
  String get emergencySos => '紧急 SOS';

  @override
  String get sosHint => '这会在应用内通知你的圈子，并通过短信把你的位置发给圈子和紧急联系人。';

  @override
  String get sosNeedsContact => '请先至少添加一位紧急联系人，才能发送警报。';

  @override
  String yourEmergencyContactsCount(int count) {
    return '你的紧急联系人 · $count';
  }

  @override
  String get unavailable => '不可用';

  @override
  String get keepHolding => '继续按住…';

  @override
  String get holdToAlert => '按住发出警报';

  @override
  String get addContactBeforeAlert => '发送警报前请先添加紧急联系人。';

  @override
  String get notificationChannelName => 'SafeCircle 警报';

  @override
  String get notificationChannelDescription => '报平安提醒和安全警报';

  @override
  String get reminderDueTitle => '该报平安了';

  @override
  String reminderDueBody(String label, String time) {
    return '$label · $time — 打开 SafeCircle 确认你安全。';
  }

  @override
  String get reminderLastCallTitle => '最后提醒：请确认报平安';

  @override
  String reminderLastCallBody(String label, String time) {
    return '$label · $time — 1 分钟后将通知你的圈子。';
  }

  @override
  String get testNotificationTitle => 'SafeCircle 通知工作正常';

  @override
  String get testNotificationBody => '报平安、朋友逾期和紧急情况都会这样提醒你。';

  @override
  String get circleInvite => '圈子邀请';

  @override
  String inviteNotificationBody(String summary) {
    return '$summary — 打开 SafeCircle 接受邀请。';
  }

  @override
  String get speedAlertTitle => '上次出行超速提醒';

  @override
  String speedAlertBody(String trip, String speed) {
    return '$trip · 最高 $speed';
  }

  @override
  String get checkIn => '报平安';

  @override
  String checkInOverdueReachOut(String label) {
    return '$label已逾期 — 请联系对方。';
  }

  @override
  String get places => '地点';

  @override
  String get placesHint => '有人到达或离开这些地点时，你的圈子会收到提醒。';

  @override
  String get noPlacesYet => '还没有地点。添加家、学校或公司，有人到达时圈子就会知道。';

  @override
  String get addPlace => '添加地点';

  @override
  String get savedLocation => '已保存的位置';

  @override
  String get couldNotUpdatePlace => '无法更新地点。';

  @override
  String get sharingPausedBanner => '你的位置共享已暂停';

  @override
  String get turnOnLocation => '开启你的定位';

  @override
  String get sharingPausedBannerSub => '你的圈子看不到你的位置。点按即可恢复。';

  @override
  String get turnOnLocationSub => '你的圈子还看不到你。点按以允许定位。';

  @override
  String get noOneSharing => '还没有人共享位置';

  @override
  String get noOneSharingHint => '邀请你信任的人加入圈子。加入并共享位置的人都会显示在这里。';

  @override
  String get goToCircles => '前往圈子';

  @override
  String get firstCheckIn => '第一次报平安';

  @override
  String get secondCheckIn => '第二次报平安';

  @override
  String get checkOut => '到达确认';

  @override
  String numberedCheckIn(int number) {
    return '第 $number 次报平安';
  }

  @override
  String couldNotJoinNoAccess(String name) {
    return '无法加入：应用暂时无法访问这个圈子。请让$name重新发送邀请。';
  }

  @override
  String get couldNotAcceptInvite => '无法接受邀请，请重试。';

  @override
  String get circleInviteEyebrow => '圈子邀请';

  @override
  String addedYouToCircle(String name, String circle) {
    return '$name在 SafeCircle 上把你加入了圈子$circle。';
  }

  @override
  String joinHint(String name) {
    return '加入后，$name可以邀请你关注其行程，并在其逾期时提醒你。你可以随时退出圈子。';
  }

  @override
  String get joining => '正在加入…';

  @override
  String get accept => '接受';

  @override
  String get decline => '拒绝';

  @override
  String get confirmToEndJourney => '确认以结束行程';

  @override
  String get confirmYourCheckIn => '确认报平安';

  @override
  String get enterPinToEnd => '输入 PIN 码以安全结束这段行程。';

  @override
  String get incorrectPin => 'PIN 码错误，请重试。';

  @override
  String get friendsJourneys => '朋友的行程';

  @override
  String get noNewNotifications => '没有新通知。';

  @override
  String get renameCircle => '重命名圈子';

  @override
  String get nameYourCircle => '给圈子起个名字';

  @override
  String get circleNameHint => '起个名字 — 加个表情符号更好找。';

  @override
  String get circlesName => '圈子名称';

  @override
  String get circleNameExample => '例如：🏠 家人';

  @override
  String get save => '保存';

  @override
  String get locationSharingChannel => '位置共享';

  @override
  String get locationSharingChannelDescription => '在 SafeCircle 与你的圈子共享位置时显示。';

  @override
  String get sharingNotificationTitle => 'SafeCircle 正在共享你的位置';

  @override
  String get sharingNotificationBody => '你的圈子可以看到你在哪里。';

  @override
  String checkInInPast(String label) {
    return '“$label”的时间已过 — 请调整时间。';
  }

  @override
  String get journeyStartsWithoutLocation => '位置不可用 — 行程将在没有地图位置的情况下开始。';

  @override
  String get couldNotStartJourney => '无法开始行程，请重试。';

  @override
  String get createYourFirstCircle => '创建你的第一个圈子';

  @override
  String get nothingNewYet => '暂无新动态。';

  @override
  String get activity => '动态';

  @override
  String get delete => '删除';

  @override
  String get back => '返回';

  @override
  String get checkConnection => '请检查网络连接后重试。';

  @override
  String get couldNotLoadThis => '无法加载';

  @override
  String get couldNotLoadAccount => '无法加载你的账号';

  @override
  String get checkInternet => '请检查网络连接后重试。';

  @override
  String get tryAgain => '重试';

  @override
  String get createACircle => '创建圈子';

  @override
  String get journeysList => '行程列表';

  @override
  String get couldNotSaveContact => '无法保存联系人，请重试。';

  @override
  String get editContact => '编辑联系人';

  @override
  String get addContactHint => '对方会在你每次行程中收到警报。我们会发一条短信告诉对方你添加了他们。';

  @override
  String get sharingWithCircles => '正在与你的圈子共享实时位置。';

  @override
  String get locationOffEnable => '定位已关闭 — 开启后才能共享你的位置。';

  @override
  String get positionNotShared => '你的位置尚未共享。';

  @override
  String get tabMap => '地图';

  @override
  String get tabJourneys => '行程';

  @override
  String get tabEmergency => '紧急';

  @override
  String get tabProfile => '我的';

  @override
  String get planAJourney => '规划行程';

  @override
  String get phoneNumber => '电话号码';

  @override
  String get addYourFirstCircle => '添加你的第一个圈子';

  @override
  String get resendInvitation => '重新发送邀请';

  @override
  String get locationNotSharedYet => '尚未共享位置';

  @override
  String get couldNotSendAlert => '无法发送警报。请检查网络连接后重试。';

  @override
  String get journeys => '行程';

  @override
  String overSpeed(String speed) {
    return '超过 $speed';
  }

  @override
  String get withinLimit => '未超速';

  @override
  String friendsNeedAttentionActive(int count, int active) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位朋友需要关注',
    );
    return '$_temp0 · $active 人在行程中';
  }

  @override
  String friendsOnJourneyNow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '目前有 $count 位朋友在行程中',
    );
    return '$_temp0';
  }

  @override
  String get countryUS => '美国';

  @override
  String get countryBR => '巴西';

  @override
  String get countryPT => '葡萄牙';

  @override
  String get countryGB => '英国';

  @override
  String get countryES => '西班牙';

  @override
  String get countryAR => '阿根廷';

  @override
  String get countryFR => '法国';

  @override
  String get countryMX => '墨西哥';

  @override
  String get countryCN => '中国';

  @override
  String get countryIN => '印度';

  @override
  String get enterPinToPause => '输入 PIN 码以暂停。';

  @override
  String get smsConsentLabel =>
      '对方已同意在此号码接收 SafeCircle 短信（邀请和安全警报）。可能产生短信和数据费用。对方可回复 STOP 退订。';

  @override
  String get profilePhoneSmsNote =>
      '添加号码即表示你同意接收有关你圈子安全警报的 SafeCircle 短信。可能产生短信和数据费用。回复 STOP 退订。';

  @override
  String get privacySmsTitle => '短信';

  @override
  String get privacySmsBody =>
      '只有在对方同意后，我们才会向该号码发送短信，且仅用于圈子邀请和安全警报，绝不用于营销。手机号码和同意记录绝不会出售或分享给第三方或关联方用于营销。回复任意短信 STOP 即可退订，回复 HELP 获取帮助。';

  @override
  String resendNoConsent(String name) {
    return '$name 尚未同意接收短信。对方同意后，请编辑其信息并勾选短信选项。';
  }

  @override
  String inviteShareMessage(String circle, String link, String email) {
    return '我把你加入了我的 SafeCircle 圈子\"$circle\"，让我们互相照应。下载应用：$link，用 $email 注册即可加入。';
  }

  @override
  String inviteShareMessageNoEmail(String circle, String link) {
    return '我把你加入了我的 SafeCircle 圈子\"$circle\"，让我们互相照应。下载应用：$link 即可加入。';
  }

  @override
  String get inviteShareSubject => '加入我的 SafeCircle 圈子';

  @override
  String participantSavedTo(String circle) {
    return '已保存到$circle';
  }

  @override
  String participantRemovedFrom(String circle) {
    return '已从$circle移除';
  }

  @override
  String notOnSafeCircleYet(String name) {
    return '$name 还没有加入 SafeCircle';
  }

  @override
  String get inviteByTextBody => '要给对方发送邀请吗？短信将会打开，邀请内容已准备好。';

  @override
  String get inviteByShareBody => '要给对方发送邀请吗？请选择发送方式：信息、WhatsApp、电子邮件…';

  @override
  String get sendInvitation => '发送邀请';

  @override
  String get notNow => '以后再说';
}
