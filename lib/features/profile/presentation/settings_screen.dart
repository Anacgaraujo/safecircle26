import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:safecircle/core/notifications/notification_service.dart';
import 'package:safecircle/core/permissions/permissions.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/auth/data/auth_repository.dart';
import 'package:safecircle/features/auth/domain/auth_error.dart';
import 'package:safecircle/features/profile/application/profile_service.dart';
import 'package:safecircle/features/profile/presentation/legal_doc_screen.dart';
import 'package:safecircle/features/profile/presentation/profile_form_screen.dart';
import 'package:safecircle/features/profile/presentation/widgets/profile_ui.dart';
import 'package:safecircle/l10n/l10n.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool checkinReminder = NotificationService.instance.checkinReminder;
  bool circleAlerts = NotificationService.instance.circleAlerts;
  bool overdueAlerts = NotificationService.instance.overdueAlerts;

  void _saveToggle(String key, bool value) {
    ref.read(profileServiceProvider).setNotificationSetting(key, value).catchError(
        (e) => debugPrint('[SafeCircle] saveSetting $key: $e'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(FeatherIcons.arrowLeft, size: 24, color: ScColors.textPrimary),
                  ),
                  Text(context.l10n.settings,
                      style: ScText.sans(size: 24, weight: FontWeight.w800, color: ScColors.textHeading, spacing: -.5)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                children: [
                  _sectionHeader(FeatherIcons.lock, context.l10n.security),
                  _groupCard([
                    _settingRow(
                      tile: const Icon(FeatherIcons.checkCircle, size: 19, color: ScColors.green500),
                      tileBg: ScColors.green50,
                      label: context.l10n.changeSafetyPin,
                      sub: context.l10n.changeSafetyPinSub,
                      onTap: () => pushScreen(context, const ProfileFormScreen(kind: ProfileFormKind.safetyPin)),
                    ),
                    _settingRow(
                      tile: const Icon(FeatherIcons.shield, size: 19, color: ScColors.brand),
                      tileBg: ScColors.brandTint,
                      label: context.l10n.changePanicPin,
                      sub: context.l10n.changePanicPinSub,
                      onTap: () => pushScreen(context, const ProfileFormScreen(kind: ProfileFormKind.panicPin)),
                      topBorder: true,
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _sectionHeader(FeatherIcons.bell, context.l10n.notifications),
                  _groupCard([
                    _toggleRow(FeatherIcons.clock, context.l10n.checkInReminders, context.l10n.checkInRemindersSub,
                        checkinReminder, (v) {
                      setState(() => checkinReminder = v);
                      _saveToggle('checkinReminder', v);
                    }),
                    _toggleRow(FeatherIcons.alertTriangle, context.l10n.overdueCheckIns, context.l10n.overdueCheckInsSub,
                        overdueAlerts, (v) {
                      setState(() => overdueAlerts = v);
                      _saveToggle('overdueAlerts', v);
                    }, topBorder: true),
                    _settingRow(
                      tile: const Icon(FeatherIcons.shield, size: 19, color: ScColors.purple700),
                      tileBg: profileTileBg,
                      label: context.l10n.permissions,
                      sub: context.l10n.permissionsSub,
                      onTap: () => showPermissionSheet(
                        context,
                        title: context.l10n.permissions,
                        reason: context.l10n.permissionsReason,
                        continueLabel: context.l10n.done,
                      ),
                      topBorder: true,
                    ),
                    _settingRow(
                      tile: const Icon(FeatherIcons.send, size: 19, color: ScColors.purple700),
                      tileBg: profileTileBg,
                      label: context.l10n.sendTestNotification,
                      sub: context.l10n.sendTestNotificationSub,
                      onTap: () async {
                        final ok = await NotificationService.instance.sendTest();
                        if (!context.mounted) return;
                        showScToast(
                            context,
                            ok
                                ? context.l10n.testNotificationSent
                                : context.l10n.testNotificationFailed);
                      },
                      topBorder: true,
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _sectionHeader(FeatherIcons.user, context.l10n.account),
                  _groupCard([
                    _settingRow(
                      tile: const Icon(FeatherIcons.mail, size: 19, color: ScColors.purple700),
                      tileBg: profileTileBg,
                      label: context.l10n.changeEmail,
                      onTap: () => pushScreen(context, const ProfileFormScreen(kind: ProfileFormKind.email)),
                    ),
                    _settingRow(
                      tile: const Icon(FeatherIcons.lock, size: 19, color: ScColors.purple700),
                      tileBg: profileTileBg,
                      label: context.l10n.changePassword,
                      onTap: () => pushScreen(context, const ProfileFormScreen(kind: ProfileFormKind.password)),
                      topBorder: true,
                    ),
                    _settingRow(
                      tile: const Icon(FeatherIcons.logOut, size: 19, color: ScColors.textBody),
                      tileBg: ScColors.surfaceSunken,
                      label: context.l10n.logOut,
                      labelColor: ScColors.textBody,
                      chevronColor: ScColors.textMuted,
                      onTap: () => _confirm(
                        context,
                        icon: FeatherIcons.logOut,
                        tint: ScColors.surfaceSunken,
                        fg: ScColors.textBody,
                        btnBg: ScColors.ink,
                        title: context.l10n.logOutQuestion,
                        body: context.l10n.logOutBody,
                        cta: context.l10n.logOut,
                        done: context.l10n.loggedOut,
                        action: () async {
                          final nav = Navigator.of(context);
                          await ref.read(authRepositoryProvider).logout();
                          nav.popUntil((r) => r.isFirst);
                        },
                      ),
                      topBorder: true,
                    ),
                    _settingRow(
                      tile: const Icon(FeatherIcons.trash2, size: 19, color: ScColors.red500),
                      tileBg: ScColors.red50,
                      label: context.l10n.deleteAccount,
                      labelColor: ScColors.red500,
                      sub: context.l10n.deleteAccountSub,
                      subColor: ScColors.red500,
                      chevronColor: ScColors.red500,
                      onTap: () => _confirm(
                        context,
                        icon: FeatherIcons.trash2,
                        tint: ScColors.red50,
                        fg: ScColors.red500,
                        btnBg: ScColors.red500,
                        title: context.l10n.deleteAccountQuestion,
                        body: context.l10n.deleteAccountBody,
                        cta: context.l10n.deleteAccount,
                        done: context.l10n.accountDeleted,
                        action: () async {
                          final nav = Navigator.of(context);
                          await ref.read(profileServiceProvider).deleteAccount();
                          nav.popUntil((r) => r.isFirst);
                        },
                      ),
                      topBorder: true,
                      borderColor: ScColors.red100,
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _sectionHeader(FeatherIcons.info, context.l10n.about),
                  _groupCard([
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      child: Row(
                        children: [
                          _tile(const Icon(FeatherIcons.smartphone, size: 19, color: ScColors.purple700), profileTileBg),
                          const SizedBox(width: 13),
                          Expanded(child: Text(context.l10n.version, style: ScText.sans(size: 15, weight: FontWeight.w700, color: ScColors.textHeading))),
                          FutureBuilder<PackageInfo>(
                            future: PackageInfo.fromPlatform(),
                            builder: (_, snap) => Text(
                                snap.hasData
                                    ? '${snap.data!.version}+${snap.data!.buildNumber}'
                                    : '…',
                                style: ScText.mono(size: 13, color: ScColors.textMuted)),
                          ),
                        ],
                      ),
                    ),
                    _settingRow(
                      tile: const Icon(FeatherIcons.flag, size: 19, color: ScColors.purple700),
                      tileBg: profileTileBg,
                      label: context.l10n.termsOfService,
                      onTap: () => pushScreen(context, const LegalDocScreen(isTerms: true)),
                      topBorder: true,
                    ),
                    _settingRow(
                      tile: const Icon(FeatherIcons.shield, size: 19, color: ScColors.purple700),
                      tileBg: profileTileBg,
                      label: context.l10n.privacyPolicy,
                      onTap: () => pushScreen(context, const LegalDocScreen(isTerms: false)),
                      topBorder: true,
                    ),
                  ]),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(context.l10n.aboutFooter,
                        style: ScText.sans(size: 12, weight: FontWeight.w600, color: ScColors.textMuted)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 9),
      child: Row(
        children: [
          Icon(icon, size: 14, color: ScColors.purple700),
          const SizedBox(width: 7),
          Text(label.toUpperCase(), style: ScText.sans(size: 11, weight: FontWeight.w700, color: ScColors.textMuted, spacing: 1.2)),
        ],
      ),
    );
  }

  Widget _groupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: ScColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: ScShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _tile(Widget icon, Color bg) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(11)),
        alignment: Alignment.center,
        child: icon,
      );

  Widget _settingRow({
    required Widget tile,
    required Color tileBg,
    required String label,
    String? sub,
    Color labelColor = ScColors.textHeading,
    Color? subColor,
    Color chevronColor = ScColors.brand,
    required VoidCallback onTap,
    bool topBorder = false,
    Color borderColor = ScColors.borderHairline,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(border: topBorder ? Border(top: BorderSide(color: borderColor)) : null),
        child: Row(
          children: [
            _tile(tile, tileBg),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: ScText.sans(size: 15, weight: FontWeight.w700, color: labelColor)),
                  if (sub != null) ...[
                    const SizedBox(height: 1),
                    Text(sub, style: ScText.sans(size: 12.5, weight: FontWeight.w500, color: subColor ?? ScColors.textMuted)),
                  ],
                ],
              ),
            ),
            Icon(FeatherIcons.chevronRight, size: 20, color: chevronColor),
          ],
        ),
      ),
    );
  }

  Widget _toggleRow(IconData icon, String label, String sub, bool value, ValueChanged<bool> onChanged,
      {bool topBorder = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(border: topBorder ? const Border(top: BorderSide(color: ScColors.borderHairline)) : null),
      child: Row(
        children: [
          _tile(Icon(icon, size: 19, color: ScColors.purple700), profileTileBg),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: ScText.sans(size: 15, weight: FontWeight.w700, color: ScColors.textHeading)),
                const SizedBox(height: 1),
                Text(sub, style: ScText.sans(size: 12.5, weight: FontWeight.w500, color: ScColors.textMuted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: ScColors.brand,
            activeThumbColor: Colors.white,
            inactiveTrackColor: ScColors.slate200,
            inactiveThumbColor: Colors.white,
            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
          ),
        ],
      ),
    );
  }

  void _confirm(
    BuildContext context, {
    required IconData icon,
    required Color tint,
    required Color fg,
    required Color btnBg,
    required String title,
    required String body,
    required String cta,
    required String done,
    Future<void> Function()? action,
  }) {
    showDialog<void>(
      context: context,
      barrierColor: const Color(0x730C0710),
      builder: (dialogContext) => Dialog(
        backgroundColor: ScColors.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
                child: Icon(icon, size: 24, color: fg),
              ),
              const SizedBox(height: 14),
              Text(title, style: ScText.sans(size: 19, weight: FontWeight.w800, color: ScColors.textHeading)),
              const SizedBox(height: 8),
              Text(body,
                  textAlign: TextAlign.center,
                  style: ScText.sans(size: 13.5, weight: FontWeight.w500, color: ScColors.textSecondary, height: 19)),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: btnBg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () async {
                    Navigator.of(dialogContext).pop();
                    try {
                      await action?.call();
                      if (context.mounted) showScToast(context, done);
                    } catch (e) {
                      if (context.mounted) {
                        showScToast(context, describeAuthError(e));
                      }
                    }
                  },
                  child: Text(cta, style: ScText.sans(size: 15, weight: FontWeight.w800, color: Colors.white)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(context.l10n.cancel, style: ScText.sans(size: 14, weight: FontWeight.w700, color: ScColors.textMuted)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
