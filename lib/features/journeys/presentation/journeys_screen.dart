import 'package:flutter/material.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/journeys/presentation/friends_journeys_screen.dart';

class JourneysScreen extends StatelessWidget {
  const JourneysScreen({super.key, this.onGoCircles});
  final VoidCallback? onGoCircles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  ScBackButton(onTap: () => Navigator.of(context).pop()),
                  const SizedBox(width: 12),
                  Text('Journeys',
                      style: ScText.sans(
                          size: 18, weight: FontWeight.w800, color: ScColors.textHeading)),
                  const Spacer(),
                  const Icon(FeatherIcons.navigation, size: 20, color: ScColors.brand),
                ],
              ),
            ),
            Expanded(child: HomeScreen(onGoCircles: onGoCircles, showHeader: false)),
          ],
        ),
      ),
    );
  }
}
