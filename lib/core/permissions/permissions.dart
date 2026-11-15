import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/notifications/notification_service.dart';
import 'package:safecircle/features/live_map/data/tracking_service.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';

bool get _isAndroid => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

const _emulatorBuild = kIsWeb && bool.fromEnvironment('USE_EMULATORS');

class PermissionSnapshot {
  const PermissionSnapshot({
    this.location = false,
    this.notifications = false,
    this.exactAlarms = true,
    this.battery = true,
    this.contacts = false,
  });

  final bool location;
  final bool notifications;

  final bool exactAlarms;

  final bool battery;
  final bool contacts;

  static bool get notificationsRequired => !kIsWeb || NotificationService.instance.isReady;

  bool get requiredGranted =>
      _emulatorBuild ||
      (location && (notifications || !notificationsRequired) && exactAlarms);

  static Future<PermissionSnapshot> read() async {
    if (kIsWeb) {
      return PermissionSnapshot(
        location: await LocationService.instance.hasPermission(),
        notifications: NotificationService.instance.webGranted,
      );
    }
    final loc = await Permission.location.status;
    final notif = await Permission.notification.status;
    final contacts = await Permission.contacts.status;
    var exact = true;
    var battery = true;
    if (_isAndroid) {
      exact = (await Permission.scheduleExactAlarm.status).isGranted;
      battery = (await Permission.ignoreBatteryOptimizations.status).isGranted;
    }
    return PermissionSnapshot(
      location: loc.isGranted,
      notifications: notif.isGranted,
      exactAlarms: exact,
      battery: battery,
      contacts: contacts.isGranted,
    );
  }
}

Future<bool> ensureJourneyPermissions(BuildContext context) async {
  final snap = await PermissionSnapshot.read();
  if (snap.requiredGranted) return true;
  if (!context.mounted) return false;
  return await showPermissionSheet(
        context,
        title: 'Before you start',
        reason: 'A journey needs these so your check-in reminders ring on time and '
            'your circle can see where you are.',
      ) ??
      false;
}

Future<bool> ensureLiveSharingPermissions(BuildContext context) async {
  final snap = await PermissionSnapshot.read();
  if (snap.location) return true;
  if (!context.mounted) return false;
  final ok = await showPermissionSheet(
    context,
    title: 'Share your live location',
    reason: 'Your circle sees where you are on the map.',
  );
  return ok == true;
}

Future<void> startLiveSharingByDefault(BuildContext context) async {
  final t = TrackingService.instance;
  if (t.isRunning || t.paused) return;
  if (!await LocationService.instance.hasPermission()) {
    if (!context.mounted || !await ensureLiveSharingPermissions(context)) return;
  }
  await t.start();
}

Future<void> ensureAlertNotifications(BuildContext context) async {
  if (!PermissionSnapshot.notificationsRequired) return;
  final snap = await PermissionSnapshot.read();
  if (snap.notifications) return;
  final ok = kIsWeb
      ? await NotificationService.instance.requestWebPermission()
      : (await Permission.notification.request()).isGranted;
  if (!ok && context.mounted) {
    showScToast(context, "You won't be notified about alerts — enable notifications in Settings.");
  }
}

Future<bool?> showPermissionSheet(
  BuildContext context, {
  required String title,
  required String reason,
  String continueLabel = 'Continue',
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: ScColors.canvas,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + MediaQuery.of(sheetContext).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                      color: ScColors.borderDefault, borderRadius: BorderRadius.circular(3)),
                ),
              ),
              const SizedBox(height: 16),
              Text(title,
                  style: ScText.sans(size: 20, weight: FontWeight.w800, color: ScColors.textHeading)),
              const SizedBox(height: 6),
              Text(reason,
                  style: ScText.sans(
                      size: 14, weight: FontWeight.w500, color: ScColors.textSubtle, height: 20)),
              const SizedBox(height: 18),
              PermissionRows(
                onContinue: () => Navigator.of(sheetContext).pop(true),
                continueLabel: continueLabel,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key, required this.onContinue, this.eyebrow = 'ALMOST THERE'});
  final VoidCallback onContinue;
  final String eyebrow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(eyebrow,
                    style: ScText.sans(
                        size: 12, weight: FontWeight.w700, color: ScColors.brand, spacing: .9)),
                const SizedBox(height: 8),
                Text('Allow permissions',
                    style: ScText.sans(
                        size: 28,
                        weight: FontWeight.w800,
                        color: ScColors.textHeading,
                        height: 34,
                        spacing: -0.6)),
                const SizedBox(height: 10),
                Text(
                  "SafeCircle only uses these to keep you and your circle safe. You're always in control — change them anytime in Settings.",
                  style: ScText.sans(
                      size: 14, weight: FontWeight.w500, color: ScColors.textSubtle, height: 21),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PermissionRows(onContinue: onContinue, onSkip: onContinue, fillHeight: true),
          ),
        ],
      ),
    );
  }
}

class PermissionRows extends StatefulWidget {
  const PermissionRows({
    super.key,
    required this.onContinue,
    this.continueLabel = 'Continue',
    this.fillHeight = false,
    this.onSkip,
  });
  final VoidCallback onContinue;
  final String continueLabel;

  final VoidCallback? onSkip;

  final bool fillHeight;

  @override
  State<PermissionRows> createState() => _PermissionRowsState();
}

class _PermissionRowsState extends State<PermissionRows> with WidgetsBindingObserver {
  PermissionSnapshot snap = const PermissionSnapshot();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    final s = await PermissionSnapshot.read();
    if (mounted) setState(() => snap = s);
  }

  Future<void> _allowLocation() async {
    final ok = await LocationService.instance.ensurePermission();
    if (!mounted) return;
    if (!ok) showScToast(context, 'Location denied — enable it in system settings.');
    await _refresh();
  }

  Future<void> _allowNotifications() async {
    final ok = kIsWeb
        ? await NotificationService.instance.requestWebPermission()
        : (await Permission.notification.request()).isGranted;
    if (!mounted) return;
    if (!ok) showScToast(context, 'Notifications denied — enable them in system settings.');
    await _refresh();
  }

  Future<void> _allowExactAlarms() async {
    final status = await Permission.scheduleExactAlarm.request();
    if (!mounted) return;
    if (!status.isGranted) {
      showScToast(context, 'Turn on "Alarms & reminders" for SafeCircle, then come back.');
    }
    await _refresh();
  }

  Future<void> _allowBattery() async {
    await Permission.ignoreBatteryOptimizations.request();
    if (mounted) await _refresh();
  }

  Future<void> _allowContacts() async {
    final status = await Permission.contacts.request();
    if (!mounted) return;
    if (!status.isGranted) showScToast(context, 'Contacts denied — enable it in system settings.');
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final notifRequired = PermissionSnapshot.notificationsRequired;
    final ready = snap.requiredGranted;

    final rows = <Widget>[
      _PermissionRow(
        icon: FeatherIcons.mapPin,
        title: 'Location',
        sub: "So your circle can see you've arrived safely.",
        granted: snap.location,
        onAllow: _allowLocation,
      ),
      if (notifRequired)
        _PermissionRow(
          icon: FeatherIcons.bell,
          title: 'Notifications',
          sub: 'So we can remind you when a check-in is due.',
          granted: snap.notifications,
          onAllow: _allowNotifications,
        ),
      if (_isAndroid && !snap.exactAlarms)
        _PermissionRow(
          icon: FeatherIcons.clock,
          title: 'Alarms & reminders',
          sub: 'So check-in reminders ring exactly on time.',
          granted: snap.exactAlarms,
          onAllow: _allowExactAlarms,
        ),
      if (_isAndroid)
        _PermissionRow(
          icon: FeatherIcons.batteryCharging,
          title: 'Background activity (recommended)',
          sub: 'So reminders still fire when your phone is idle.',
          granted: snap.battery,
          onAllow: _allowBattery,
        ),
      if (!kIsWeb)
        _PermissionRow(
          icon: FeatherIcons.users,
          title: 'Contacts (optional)',
          sub: 'To quickly invite the people you trust.',
          granted: snap.contacts,
          onAllow: _allowContacts,
        ),
    ];

    final footer = <Widget>[
      const SizedBox(height: 16),
      if (!ready)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            notifRequired
                ? 'Location and Notifications are required for SafeCircle to protect you.'
                : 'Location is required for SafeCircle to protect you.',
            textAlign: TextAlign.center,
            style: ScText.sans(
                size: 12.5, weight: FontWeight.w600, color: ScColors.textMuted, height: 17),
          ),
        ),
      ScButton(
          label: widget.continueLabel,
          rightIcon: FeatherIcons.arrowRight,
          onPressed: ready ? widget.onContinue : null),
      if (!ready && widget.onSkip != null) ...[
        const SizedBox(height: 6),
        Center(
          child: ScButton(
            label: 'Set up later',
            variant: ScButtonVariant.link,
            fullWidth: false,
            onPressed: widget.onSkip,
          ),
        ),
      ],
      if (!kIsWeb) ...[
        const SizedBox(height: 6),
        Center(
          child: ScButton(
            label: 'Open system settings',
            variant: ScButtonVariant.link,
            fullWidth: false,
            onPressed: openAppSettings,
          ),
        ),
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: widget.fillHeight ? MainAxisSize.max : MainAxisSize.min,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: 14),
          rows[i],
        ],
        if (widget.fillHeight) const Spacer(),
        ...footer,
      ],
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.icon,
    required this.title,
    required this.sub,
    required this.granted,
    required this.onAllow,
  });

  final IconData icon;
  final String title;
  final String sub;
  final bool granted;
  final VoidCallback onAllow;

  @override
  Widget build(BuildContext context) {
    return ScCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                color: ScColors.brandTint, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, size: 22, color: ScColors.brand),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: ScText.sans(size: 16, weight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(sub,
                    style: ScText.sans(
                        size: 13,
                        weight: FontWeight.w500,
                        color: ScColors.textSecondary,
                        height: 18)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          granted
              ? Row(children: [
                  const Icon(FeatherIcons.check, size: 20, color: ScColors.green500),
                  const SizedBox(width: 5),
                  Text('Allowed',
                      style: ScText.sans(
                          size: 14, weight: FontWeight.w700, color: ScColors.green500)),
                ])
              : ScButton(label: 'Allow', fullWidth: false, height: 40, onPressed: onAllow),
        ],
      ),
    );
  }
}
