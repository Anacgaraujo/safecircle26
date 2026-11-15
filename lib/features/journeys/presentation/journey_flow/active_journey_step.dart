import 'package:flutter/material.dart';

import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/actions.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_map.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';

class ActiveJourneyStep extends StatelessWidget {
  const ActiveJourneyStep({
    super.key,
    required this.circle,
    required this.checkIns,
    required this.location,
    required this.now,
    required this.onConfirm,
    required this.onFinish,
  });

  final Circle circle;
  final List<CheckIn> checkIns;
  final ScLocation? location;
  final DateTime now;

  final ValueChanged<int> onConfirm;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final lastLocation = location;
    final pendingIdx = checkIns.indexWhere((c) => !c.confirmed);
    final next = pendingIdx >= 0 ? checkIns[pendingIdx] : null;
    final late = next?.isLate(now) ?? false;
    final due = late || (next?.isDueNow(now) ?? false);
    final statusColor = late ? ScColors.red500 : due ? ScColors.amber800 : ScColors.green500;
    final statusText = late
        ? 'Check-in overdue'
        : due
            ? 'Check-in due now'
            : lastLocation == null
                ? 'Journey active'
                : 'Journey active · ${lastLocation.label}';

    return LayoutBuilder(builder: (context, constraints) {
      final mapHeight = constraints.maxHeight * .44;
      return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: mapHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ScMapView(lat: lastLocation?.lat, lng: lastLocation?.lng),
                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [ScColors.canvas.withValues(alpha: 0), ScColors.canvas],
                        stops: const [.72, 1],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .9),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: .08),
                              offset: const Offset(0, 2),
                              blurRadius: 6)
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(statusText,
                              style: ScText.sans(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: due ? statusColor : ScColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: mapHeight - 68,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 10, 24, 16 + MediaQuery.of(context).padding.bottom),
              decoration: const BoxDecoration(
                color: ScColors.canvas,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                boxShadow: ScShadows.sheet,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration:
                          BoxDecoration(color: ScColors.borderDefault, borderRadius: BorderRadius.circular(3)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Circle:', style: ScText.sans(size: 14, weight: FontWeight.w500, color: ScColors.textMuted)),
                      const SizedBox(width: 9),
                      Expanded(
                          child: Text(circle.name,
                              style: ScText.sans(size: 17, weight: FontWeight.w800, color: ScColors.textHeading))),
                      SizedBox(
                        height: 32,
                        width: 32.0 + (circle.members.length.clamp(1, 3) - 1) * 22,
                        child: Stack(
                          children: [
                            for (var i = 0; i < circle.members.length.clamp(0, 3); i++)
                              Positioned(
                                left: i * 22,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: ScColors.canvas, width: 2),
                                  ),
                                  child: ScAvatar(
                                      image: circle.members[i].image,
                                      name: circle.members[i].name,
                                      size: 28),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (due && next != null) ...[
                    const SizedBox(height: 16),
                    _DueBanner(
                      checkIn: next,
                      late: late,
                      onConfirm: () => onConfirm(pendingIdx),
                    ),
                    const SizedBox(height: 14),
                  ] else
                    const SizedBox(height: 22),
                  const ScSectionLabel('Check-ins', icon: FeatherIcons.clock),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        for (var i = 0; i < checkIns.length; i++)
                          _ActiveCheckInRow(
                              checkIn: checkIns[i], index: i, pendingIdx: pendingIdx, now: now, onConfirm: onConfirm),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Builder(builder: (context) {
                    final allDone = checkIns.every((c) => c.confirmed);
                    return ScButton(
                      label: allDone ? 'End journey' : 'Get me out of here',
                      variant: allDone ? ScButtonVariant.primary : ScButtonVariant.danger,
                      leftIcon: allDone ? FeatherIcons.checkCircle : FeatherIcons.logOut,
                      onPressed: onFinish,
                    );
                  }),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => messageGroup(
                        context,
                        circle.members.map((m) => m.digits.isEmpty ? null : m.fullPhone),
                      ),
                      icon: const Icon(FeatherIcons.messageCircle, size: 18, color: ScColors.textSecondary),
                      label: Text('Messages',
                          style: ScText.sans(size: 15, weight: FontWeight.w700, color: ScColors.textSecondary)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _ActiveCheckInRow extends StatelessWidget {
  const _ActiveCheckInRow({required this.checkIn, required this.index, required this.pendingIdx, required this.now, required this.onConfirm});
  final CheckIn checkIn;
  final int index;
  final int pendingIdx;
  final DateTime now;
  final ValueChanged<int> onConfirm;

  @override
  Widget build(BuildContext context) {
    final c = checkIn;
    final i = index;
    final isNext = !c.confirmed && i == pendingIdx;
    final isFuture = !c.confirmed && !isNext;
    final late = isNext && c.isLate(now);
    final due = late || (isNext && c.isDueNow(now));
    final accent = late ? ScColors.red500 : due ? ScColors.amber800 : ScColors.brand;
    final accentBg = late ? ScColors.red50 : due ? ScColors.amber100 : ScColors.brandTint;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ScColors.borderHairline))),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.confirmed
                  ? ScColors.green50
                  : isNext
                      ? accentBg
                      : ScColors.surfaceSunken,
              shape: BoxShape.circle,
            ),
            child: c.confirmed
                ? const Icon(FeatherIcons.check, size: 18, color: ScColors.green500)
                : due
                    ? Icon(late ? FeatherIcons.alertCircle : FeatherIcons.bell, size: 17, color: accent)
                    : isNext
                    ? Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(color: ScColors.brand, shape: BoxShape.circle))
                    : Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: ScColors.borderDefault, shape: BoxShape.circle)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.label,
                    style: ScText.sans(
                        size: 15,
                        weight: FontWeight.w700,
                        color: c.confirmed
                            ? ScColors.textSecondary
                            : isNext
                                ? ScColors.textHeading
                                : ScColors.textMuted)),
                const SizedBox(height: 1),
                Text(
                    due
                        ? '${c.time} · ${late ? 'Overdue' : 'Due now'}'
                        : '${c.date} · ${c.time}',
                    style: ScText.mono(size: 12.5, color: due ? accent : ScColors.textMuted)),
                if (c.confirmed && (c.place ?? '').isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(FeatherIcons.mapPin, size: 12, color: ScColors.green500),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(c.place!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: ScText.sans(size: 12, weight: FontWeight.w500, color: ScColors.textSecondary, height: 15)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (c.confirmed)
            Row(children: [
              const Icon(FeatherIcons.checkCircle, size: 15, color: ScColors.green500),
              const SizedBox(width: 5),
              Text('Confirmed', style: ScText.sans(size: 13, weight: FontWeight.w700, color: ScColors.green500)),
            ])
          else if (isNext)
            due
                ? ScButton(
                    label: 'Confirm',
                    fullWidth: false,
                    height: 36,
                    variant: late ? ScButtonVariant.danger : ScButtonVariant.primary,
                    onPressed: () => onConfirm(i))
                : GestureDetector(
                    onTap: () => onConfirm(i),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text('Confirm',
                          style: ScText.sans(size: 14, weight: FontWeight.w800, color: ScColors.brand)),
                    ),
                  )
          else if (isFuture)
            Text('Upcoming', style: ScText.sans(size: 12.5, weight: FontWeight.w600, color: ScColors.textMuted)),
        ],
      ),
    );
  }
}

class _DueBanner extends StatelessWidget {
  const _DueBanner({required this.checkIn, required this.late, required this.onConfirm});
  final CheckIn checkIn;
  final bool late;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final accent = late ? ScColors.red500 : ScColors.amber800;
    final bg = late ? ScColors.red50 : ScColors.amber100;
    final title = late ? 'You missed a check-in' : 'Check-in due — are you safe?';
    final sub = late
        ? '${checkIn.label} · ${checkIn.time}. Your circle has been alerted — confirm now to let them know you\'re okay.'
        : 'Confirm within ${kCheckInGrace.inMinutes} min or your circle will be alerted.';
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: .35)),
      ),
      child: Row(
        children: [
          Icon(late ? FeatherIcons.alertCircle : FeatherIcons.bell, size: 22, color: accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: ScText.sans(size: 14.5, weight: FontWeight.w800, color: accent, height: 18)),
                const SizedBox(height: 2),
                Text(sub,
                    style: ScText.sans(
                        size: 12.5, weight: FontWeight.w500, color: ScColors.textSecondary, height: 16)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ScButton(
              label: 'Confirm',
              fullWidth: false,
              height: 38,
              variant: late ? ScButtonVariant.danger : ScButtonVariant.primary,
              onPressed: onConfirm),
        ],
      ),
    );
  }
}
