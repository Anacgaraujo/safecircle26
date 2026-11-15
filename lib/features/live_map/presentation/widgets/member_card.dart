import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/permissions/permissions.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/actions.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/live_map/application/live_sharing.dart';
import 'package:safecircle/features/live_map/domain/map_rules.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/trips/presentation/trip_history_screen.dart';

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
                    Text(isMe ? 'You' : status.name,
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
                child: Text(status.place.isEmpty ? 'Locating…' : status.place,
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
                    userId: status.uid, name: isMe ? 'You' : status.name))),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                  color: ScColors.surfaceSunken, borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  const Icon(FeatherIcons.navigation, size: 15, color: ScColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Trip history · ${status.todayLabel}',
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
                label: on ? 'Pause sharing' : 'Resume sharing',
                variant: on ? ScButtonVariant.secondary : ScButtonVariant.primary,
                height: 46,
                leftIcon: on ? FeatherIcons.pause : FeatherIcons.play,
                onPressed: () => _toggleSharing(context, ref.read(liveSharingProvider.notifier), on),
              );
            })
          else
            Row(
              children: [
                Expanded(
                  child: ScButton(
                    label: 'Call',
                    height: 46,
                    leftIcon: FeatherIcons.phoneCall,
                    onPressed: () => callPhone(context, phone),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ScButton(
                    label: 'Message',
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

  Future<void> _toggleSharing(BuildContext context, LiveSharing sharing, bool on) async {
    if (!on) {
      if (!await ensureLiveSharingPermissions(context)) return;
      final running = await sharing.resume();
      if (context.mounted) {
        showScToast(
            context,
            running
                ? 'Sharing your live location again.'
                : 'Location is off on this phone — turn it on in Settings.');
      }
      return;
    }
    final ok = await showScConfirm(
      context,
      title: 'Pause location sharing?',
      body: "Your circle won't see where you are until you resume. "
          'Journeys, check-ins and SOS keep working.',
      confirmLabel: 'Pause',
      icon: FeatherIcons.pause,
    );
    if (!ok) return;
    await sharing.pause();
    if (context.mounted) showScToast(context, 'Location sharing paused.');
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
              ? 'Charging'
              : status.lowBattery
                  ? 'Low battery'
                  : 'Battery',
          style: ScText.sans(size: 11, weight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}
