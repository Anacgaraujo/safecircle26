import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/actions.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/contacts/data/contacts_repository.dart';
import 'package:safecircle/l10n/l10n.dart';

class AlertSentView extends ConsumerWidget {
  const AlertSentView(
      {super.key, required this.sentAt, required this.onCancel, this.location, this.reached = 0});
  final String sentAt;
  final VoidCallback onCancel;
  final ScLocation? location;

  final int reached;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildBody(context, ref.watch(contactsProvider).value ?? const <Person>[]);
  }

  Widget _buildBody(BuildContext context, List<Person> contacts) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(26, 14, 26, 4),
            children: [
              const SizedBox(height: 14),
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: .4, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: ScMotion.easeOut,
                  builder: (_, t, c) => Opacity(opacity: t.clamp(0, 1), child: Transform.scale(scale: t, child: c)),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: ScColors.green50,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: ScColors.green500.withValues(alpha: .45),
                            offset: const Offset(0, 8),
                            blurRadius: 20,
                            spreadRadius: -6),
                      ],
                    ),
                    child: const Icon(FeatherIcons.check, size: 34, color: ScColors.green500),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(child: Text(context.l10n.alertSent, style: ScText.title())),
              const SizedBox(height: 8),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(FeatherIcons.clock, size: 14, color: ScColors.textSubtle),
                    const SizedBox(width: 7),
                    Text(context.l10n.sentJustNow(sentAt), style: ScText.sans(size: 13.5, weight: FontWeight.w600, color: ScColors.textSubtle)),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              ScCard(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: ScColors.brandTint, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(FeatherIcons.mapPin, size: 20, color: ScColors.brand),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(location == null ? context.l10n.locationUnavailable : context.l10n.locationShared,
                              style: ScText.sans(size: 14.5, weight: FontWeight.w700, color: ScColors.textHeading)),
                          const SizedBox(height: 2),
                          Text(location?.label ?? context.l10n.enableLocationToShare,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ScText.mono(size: 12, color: ScColors.textMuted)),
                        ],
                      ),
                    ),
                    if (location != null)
                      Row(
                        children: [
                          Container(width: 7, height: 7, decoration: const BoxDecoration(color: ScColors.green500, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(context.l10n.live, style: ScText.sans(size: 11.5, weight: FontWeight.w700, color: ScColors.green500)),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ScSectionLabel(
                reached > 0
                    ? context.l10n.alertedInApp(reached)
                    : context.l10n.noOneToAlert,
                icon: FeatherIcons.users,
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < contacts.length; i++) ...[
                _NotifiedRow(person: contacts[i], delayMs: 120 + i * 100),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(26, 14, 26, 14 + MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: ScColors.surfaceCard,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .06), offset: const Offset(0, -6), blurRadius: 22)],
          ),
          child: Column(
            children: [
              ScButton(
                label: context.l10n.textMyLocation,
                variant: ScButtonVariant.secondary,
                leftIcon: FeatherIcons.messageCircle,
                height: 54,
                onPressed: () => messageGroup(
                  context,
                  contacts.map((c) => c.digits.isEmpty ? null : c.fullPhone),
                  body: location == null
                      ? context.l10n.emergencySmsNoLocation
                      : context.l10n.emergencySmsWithLocation(
                          'https://maps.google.com/?q=${location!.lat},${location!.lng}', location!.label),
                ),
              ),
              const SizedBox(height: 10),
              ScButton(
                label: context.l10n.alsoCall(kEmergencyNumber),
                variant: ScButtonVariant.ink,
                leftIcon: FeatherIcons.phoneCall,
                height: 54,
                onPressed: () => callPhone(context, kEmergencyNumber),
              ),
              const SizedBox(height: 4),
              TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(FeatherIcons.x, size: 16, color: ScColors.red500),
                label: Text(context.l10n.cancelAlertSafe, style: ScText.sans(size: 14, weight: FontWeight.w700, color: ScColors.red500)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotifiedRow extends StatelessWidget {
  const _NotifiedRow({required this.person, required this.delayMs});
  final Person person;
  final int delayMs;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + delayMs),
      curve: Interval(delayMs / (400 + delayMs), 1, curve: ScMotion.easeOut),
      builder: (_, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, (1 - t) * 8), child: child),
      ),
      child: ScCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ScAvatar(image: person.image, name: person.name, size: 42),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(person.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ScText.sans(size: 15.5, weight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(FeatherIcons.check, size: 13, color: ScColors.green500),
                      const SizedBox(width: 6),
                      Text(context.l10n.callOrTextToCheck, style: ScText.sans(size: 12.5, weight: FontWeight.w600, color: ScColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => callPhone(context, person.fullPhone),
              icon: const Icon(FeatherIcons.phoneCall, size: 16, color: ScColors.textMuted),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => messagePhone(context, person.fullPhone),
              icon: const Icon(FeatherIcons.messageCircle, size: 16, color: ScColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
