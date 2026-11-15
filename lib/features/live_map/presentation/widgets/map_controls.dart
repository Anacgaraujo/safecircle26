import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/live_map/application/live_sharing.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/places/presentation/place_icons.dart';

class MapStrip extends StatelessWidget {
  const MapStrip({super.key, required this.color, required this.icon, required this.label, required this.onTap});
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScPressable(
      pressedScale: .98,
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
          boxShadow: ScShadows.card,
        ),
        child: Row(
          children: [
            Icon(icon, size: 17, color: Colors.white),
            const SizedBox(width: 9),
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ScText.sans(size: 13.5, weight: FontWeight.w800, color: Colors.white)),
            ),
            const Icon(FeatherIcons.chevronRight, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class MapRoundButton extends StatelessWidget {
  const MapRoundButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.showDot = false,
    this.iconColor = ScColors.textHeading,
    this.tooltip,
  });
  final IconData icon;
  final VoidCallback? onTap;
  final bool showDot;
  final Color iconColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = ScPressable(
      pressedScale: .94,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ScColors.surfaceCard,
              shape: BoxShape.circle,
              boxShadow: ScShadows.card,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          if (showDot)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(color: ScColors.brand, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

class PlaceLabel extends StatelessWidget {
  const PlaceLabel({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: ScShadows.card,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(placeIcon(place.icon), size: 12, color: ScColors.brandSecondary),
          const SizedBox(width: 5),
          Text(place.name,
              style: ScText.sans(
                  size: 11, weight: FontWeight.w800, color: ScColors.brandSecondary)),
        ],
      ),
    );
  }
}

class ShareLocationCta extends ConsumerWidget {
  const ShareLocationCta({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(liveSharingProvider);
    final paused = ref.read(liveSharingProvider.notifier).paused;
    return ScPressable(
      pressedScale: .99,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        decoration: BoxDecoration(
          color: ScColors.brandTint,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ScColors.brand.withValues(alpha: .3)),
        ),
        child: Row(
          children: [
            const Icon(FeatherIcons.share2, size: 20, color: ScColors.brand),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      paused
                          ? 'Your location sharing is paused'
                          : 'Turn on your location',
                      style: ScText.sans(size: 14.5, weight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(
                      paused
                          ? "Your circle can't see where you are. Tap to resume."
                          : "Your circle can't see you yet. Tap to allow location.",
                      style: ScText.sans(
                          size: 12.5, weight: FontWeight.w500, color: ScColors.textSecondary)),
                ],
              ),
            ),
            const Icon(FeatherIcons.chevronRight, size: 18, color: ScColors.brand),
          ],
        ),
      ),
    );
  }
}

class NoOneSharing extends StatelessWidget {
  const NoOneSharing({super.key, this.onGoCircles});
  final VoidCallback? onGoCircles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 6, 24, 10),
      child: Column(
        children: [
          Text('No one is sharing yet',
              style: ScText.sans(size: 17, weight: FontWeight.w800, color: ScColors.textHeading)),
          const SizedBox(height: 6),
          Text(
            'Invite the people you trust to a circle. Everyone who joins and shares their location appears here.',
            textAlign: TextAlign.center,
            style: ScText.sans(
                size: 13, weight: FontWeight.w500, color: ScColors.textSubtle, height: 18),
          ),
          const SizedBox(height: 14),
          ScButton(label: 'Go to circles', height: 48, onPressed: onGoCircles),
        ],
      ),
    );
  }
}
