import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/permissions/permissions.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/actions.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/pin_prompt.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/journeys/domain/pin_check.dart';
import 'package:safecircle/features/live_map/application/live_sharing.dart';
import 'package:safecircle/features/live_map/domain/map_rules.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/trips/presentation/trip_history_screen.dart';
import 'package:safecircle/l10n/l10n.dart';

class MemberCard extends ConsumerWidget {
  const MemberCard({super.key, required this.status, required this.isMe, required this.now, this.phone});
  final MemberStatus status;
  final bool isMe;
  final DateTime now;
  final String? phone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stale = status.isStale(now);
    final movingChip = status.moving && !stale;

    return ScCard(
      radius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ScAvatar(
                image: status.photo,
                name: status.name,
                size: 52,
                ring: movingChip ? ScAvatarRing.brand : ScAvatarRing.safe,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isMe ? context.l10n.you : status.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ScText.sans(
                            size: 18, weight: FontWeight.w800, spacing: -.3)),
                    const SizedBox(height: 5),
                    _StateChip(status: status, stale: stale),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _BatteryBadge(status: status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(FeatherIcons.mapPin, size: 15, color: ScColors.brand),
              const SizedBox(width: 7),
              Expanded(
                child: Text(status.place.isEmpty ? context.l10n.locating : status.place,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ScText.sans(size: 14.5, weight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                    color: stale ? ScColors.textMuted : ScColors.green500,
                    shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(freshnessLabel(status, now),
                  style: ScText.sans(
                      size: 12.5, weight: FontWeight.w600, color: ScColors.textMuted)),
            ],
          ),
          const SizedBox(height: 12),
          ScPressable(
            pressedScale: .99,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => TripHistoryScreen(
                    userId: status.uid, name: isMe ? context.l10n.you : status.name))),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                  color: ScColors.surfaceSunken, borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  const Icon(FeatherIcons.navigation, size: 15, color: ScColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(context.l10n.tripHistoryToday(status.todayLabel),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ScText.sans(
                            size: 12.5, weight: FontWeight.w700, color: ScColors.textSecondary)),
                  ),
                  const Icon(FeatherIcons.chevronRight, size: 16, color: ScColors.brand),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (isMe)
            Builder(builder: (context) {
              final on = ref.watch(liveSharingProvider);
              return ScButton(
                label: on ? context.l10n.pauseSharing : context.l10n.resumeSharing,
                variant: on ? ScButtonVariant.secondary : ScButtonVariant.primary,
                height: 46,
                leftIcon: on ? FeatherIcons.pause : FeatherIcons.play,
                onPressed: () => _toggleSharing(context, ref, on),
              );
            })
          else
            Row(
              children: [
                Expanded(
                  child: ScButton(
                    label: context.l10n.call,
                    height: 46,
                    leftIcon: FeatherIcons.phoneCall,
                    onPressed: () => callPhone(context, phone),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ScButton(
                    label: context.l10n.message,
                    variant: ScButtonVariant.secondary,
                    height: 46,
                    leftIcon: FeatherIcons.messageCircle,
                    onPressed: () => messagePhone(context, phone),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _toggleSharing(BuildContext context, WidgetRef ref, bool on) async {
    final sharing = ref.read(liveSharingProvider.notifier);
    if (!on) {
      if (!await ensureLiveSharingPermissions(context)) return;
      final running = await sharing.resume();
      if (context.mounted) {
        showScToast(
            context,
            running
                ? context.l10n.sharingAgain
                : context.l10n.locationOffOnPhone);
      }
      return;
    }
    // Pausing needs a PIN, so nobody can quietly stop the circle from seeing
    // where you are. The panic PIN looks the same here but keeps sharing and
    // silently alerts the circle.
    final session = ref.read(sessionProvider);
    final hasPins = session.safetyPin.isNotEmpty || session.panicPin.isNotEmpty;
    final PinResult? result;
    if (hasPins) {
      result = await askForPin(context,
          title: context.l10n.pauseSharingQuestion,
          body: '${context.l10n.pauseSharingBody} ${context.l10n.enterPinToPause}');
    } else {
      final ok = await showScConfirm(
        context,
        title: context.l10n.pauseSharingQuestion,
        body: context.l10n.pauseSharingBody,
        confirmLabel: context.l10n.pause,
        icon: FeatherIcons.pause,
      );
      result = ok ? PinResult.safety : null;
    }
    if (result == null || result == PinResult.wrong) return;
    if (result == PinResult.panic) {
      sharing.pauseUnderDuress();
      final alerts = ref.read(alertRepositoryProvider);
      LocationService.instance
          .getCurrent()
          .then((loc) => alerts.fireAlert(type: 'panic', location: loc))
          .catchError((Object e) {
        debugPrint('[SafeCircle] duress alert: $e');
        return 0;
      });
    } else {
      await sharing.pause();
    }
    if (context.mounted) showScToast(context, context.l10n.sharingPaused);
  }
}

class _StateChip extends StatelessWidget {
  const _StateChip({required this.status, required this.stale});
  final MemberStatus status;
  final bool stale;

  @override
  Widget build(BuildContext context) {
    final moving = status.moving && !stale;
    final label = motionLabel(status, stale: stale);
    final fg = stale
        ? ScColors.textMuted
        : moving
            ? ScColors.brandSecondary
            : ScColors.green600;
    final bg = stale
        ? ScColors.surfaceSunken
        : moving
            ? ScColors.brandTint
            : ScColors.green50;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: ScText.sans(size: 12, weight: FontWeight.w700, color: fg)),
        ],
      ),
    );
  }
}

class _BatteryBadge extends StatelessWidget {
  const _BatteryBadge({required this.status});
  final MemberStatus status;

  @override
  Widget build(BuildContext context) {
    if (status.battery < 0) return const SizedBox.shrink();
    final color = status.lowBattery
        ? ScColors.red500
        : status.charging
            ? ScColors.green600
            : ScColors.textSecondary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Icon(FeatherIcons.battery, size: 18, color: color),
            const SizedBox(width: 5),
            Text('${status.battery}%',
                style: ScText.mono(size: 14, weight: FontWeight.w700, color: color)),
          ],
        ),
        const SizedBox(height: 1),
        Text(
          status.charging
              ? context.l10n.charging
              : status.lowBattery
                  ? context.l10n.lowBattery
                  : context.l10n.battery,
          style: ScText.sans(size: 11, weight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}
