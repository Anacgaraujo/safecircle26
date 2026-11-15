import 'package:flutter/material.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';

class LegalDocScreen extends StatelessWidget {
  const LegalDocScreen({super.key, required this.isTerms});
  final bool isTerms;

  static const _terms = [
    ('1. The service',
        'SafeCircle helps you share planned journeys and check-ins with people you trust. It complements — never replaces — emergency services.'),
    ('2. Your responsibilities',
        'Keep your account, safety PIN and panic PIN private, and only add emergency contacts who have agreed to receive alerts on your behalf.'),
    ('3. Alerts',
        'Alerts depend on your device connectivity and location permissions. In a life-threatening situation, always contact local emergency services first.'),
  ];

  static const _privacy = [
    ('What we collect',
        'Your profile details, journey plans, check-in confirmations and — only while a journey is active — your location.'),
    ('Who can see it',
        'Only the circles and emergency contacts you choose. Your location is never sold or shared with advertisers.'),
    ('Your control',
        'You can end sharing at any time, and deleting your account permanently erases your circles and journey history.'),
  ];

  @override
  Widget build(BuildContext context) {
    final sections = isTerms ? _terms : _privacy;
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
                  Text(isTerms ? 'Terms of Service' : 'Privacy Policy',
                      style: ScText.sans(size: 24, weight: FontWeight.w800, color: ScColors.textHeading, spacing: -.5)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                children: [
                  Text('Last updated · June 2026', style: ScText.mono(size: 12, color: ScColors.textMuted)),
                  for (final s in sections) ...[
                    const SizedBox(height: 20),
                    Text(s.$1, style: ScText.sans(size: 16, weight: FontWeight.w800, color: ScColors.textHeading)),
                    const SizedBox(height: 7),
                    Text(s.$2, style: ScText.sans(size: 14, weight: FontWeight.w500, color: ScColors.textSecondary, height: 21)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
