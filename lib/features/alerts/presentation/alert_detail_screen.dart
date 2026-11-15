import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/actions.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_map.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/alerts/application/sos_service.dart';
import 'package:safecircle/features/alerts/domain/alert_position.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/live_map/data/status_repository.dart';

class AlertDetailScreen extends ConsumerStatefulWidget {
  const AlertDetailScreen({super.key, required this.alert});
  final SafetyAlert alert;

  @override
  ConsumerState<AlertDetailScreen> createState() => _AlertDetailScreenState();
}

class _AlertDetailScreenState extends ConsumerState<AlertDetailScreen> {
  late String friendFirst = widget.alert.fromFirstName;
  late bool resolved = widget.alert.resolved;

  void _toggleResolved() {
    final sos = ref.read(sosServiceProvider);
    if (resolved) {
      setState(() => resolved = false);
      sos.setResolved(widget.alert.id, false);
      return;
    }
    setState(() => resolved = true);
    sos.setResolved(widget.alert.id, true);
    showScToast(context, 'Alert resolved — returning home…');
    final navigator = Navigator.of(context);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) navigator.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = widget.alert.fromUid;
    final pos = AlertPosition(
        widget.alert, ref.watch(memberStatusProvider(uid)).value, DateTime.now());
    final lastConfirmed = ref.watch(activeJourneyOfProvider(uid)).value?.lastConfirmed;
    final headerGradient = resolved
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF10B981), Color(0xFF0EA371)])
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ScColors.magenta500, ScColors.magenta600]);

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(gradient: headerGradient),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 20, right: 20, bottom: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .18), shape: BoxShape.circle),
                    child: const Icon(FeatherIcons.arrowLeft, size: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: .2), shape: BoxShape.circle),
                      child: Icon(resolved ? FeatherIcons.checkCircle : FeatherIcons.alertTriangle, size: 28, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(resolved ? 'Marked as resolved' : '$friendFirst needs help',
                              style: ScText.sans(size: 23, weight: FontWeight.w800, color: Colors.white, height: 27, spacing: -.4)),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(FeatherIcons.clock, size: 14, color: Colors.white.withValues(alpha: .9)),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  resolved
                                      ? 'You confirmed $friendFirst is safe · just now'
                                      : '${widget.alert.kindLabel} · ${widget.alert.timeLabel}',
                                  style: ScText.sans(size: 13, weight: FontWeight.w600, color: Colors.white.withValues(alpha: .9)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ScSectionLabel('Live location', icon: FeatherIcons.mapPin),
                    if (pos.isLive)
                      Row(
                        children: [
                          Container(width: 7, height: 7, decoration: const BoxDecoration(color: ScColors.green500, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text('Updating', style: ScText.sans(size: 11.5, weight: FontWeight.w700, color: ScColors.green500)),
                        ],
                      )
                    else if (widget.alert.lat != null)
                      Text('At the time of the alert',
                          style: ScText.sans(size: 11.5, weight: FontWeight.w700, color: ScColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 9),
                ScPressable(
                  pressedScale: .99,
                  onTap: () => openInMaps(context, pos.lat, pos.lng, label: pos.place),
                  child: Container(
                    height: 220,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: ScShadows.card),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ScMapView(
                          lat: pos.lat,
                          lng: pos.lng,
                          pinIcon: FeatherIcons.alertTriangle,
                          attributionAlignment: Alignment.topRight,
                        ),
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .92),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Icon(FeatherIcons.navigation, size: 18, color: ScColors.brand),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(pos.place.isEmpty ? (pos.lat == null ? 'Location unavailable' : 'Pinned on the map') : pos.place,
                                          style: ScText.sans(size: 13.5, weight: FontWeight.w800, color: ScColors.textHeading)),
                                      const SizedBox(height: 1),
                                      Text(
                                          pos.lat == null
                                              ? 'No position shared'
                                              : '${pos.lat!.toStringAsFixed(4)}, ${pos.lng!.toStringAsFixed(4)}',
                                          style: ScText.mono(size: 11, color: ScColors.textMuted)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (lastConfirmed != null) ...[
                  const SizedBox(height: 16),
                  const ScSectionLabel('Last recorded check-in', icon: FeatherIcons.clock),
                  const SizedBox(height: 9),
                  ScCard(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(color: ScColors.green50, shape: BoxShape.circle),
                          child: const Icon(FeatherIcons.check, size: 20, color: ScColors.green500),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lastConfirmed.label,
                                  style: ScText.sans(size: 15, weight: FontWeight.w800, color: ScColors.textHeading)),
                              const SizedBox(height: 2),
                              Text(
                                  '${lastConfirmed.date} · ${lastConfirmed.time}${(lastConfirmed.place ?? '').isEmpty ? '' : ' · ${lastConfirmed.place}'}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: ScText.mono(size: 12.5, color: ScColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 16 + MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(
              color: ScColors.surfaceCard,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .07), offset: const Offset(0, -6), blurRadius: 22)],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ScButton(
                        label: 'Call $friendFirst',
                        leftIcon: FeatherIcons.phoneCall,
                        onPressed: () => callPhone(context, widget.alert.fromPhone),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: ScButton(
                        label: 'Open in Maps',
                        variant: ScButtonVariant.ink,
                        leftIcon: FeatherIcons.navigation,
                        onPressed: () => openInMaps(context, pos.lat, pos.lng, label: pos.place),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: _toggleResolved,
                  icon: Icon(resolved ? FeatherIcons.alertCircle : FeatherIcons.check,
                      size: 16, color: resolved ? ScColors.brand : ScColors.textMuted),
                  label: Text(resolved ? 'Reopen alert' : 'Mark as resolved',
                      style: ScText.sans(size: 13.5, weight: FontWeight.w700, color: resolved ? ScColors.brand : ScColors.textMuted)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
