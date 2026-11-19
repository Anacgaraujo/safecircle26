import 'package:flutter/material.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/l10n/l10n.dart';

class LegalDocScreen extends StatelessWidget {
  const LegalDocScreen({super.key, required this.isTerms});
  final bool isTerms;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sections = isTerms
        ? [
            (l.termsServiceTitle, l.termsServiceBody),
            (l.termsResponsibilitiesTitle, l.termsResponsibilitiesBody),
            (l.termsAlertsTitle, l.termsAlertsBody),
            (l.termsMembershipTitle, l.termsMembershipBody),
          ]
        : [
            (l.privacyCollectTitle, l.privacyCollectBody),
            (l.privacyWhoTitle, l.privacyWhoBody),
            (l.privacySmsTitle, l.privacySmsBody),
            (l.privacyControlTitle, l.privacyControlBody),
          ];
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
                  Text(isTerms ? l.termsOfService : l.privacyPolicy,
                      style: ScText.sans(size: 24, weight: FontWeight.w800, color: ScColors.textHeading, spacing: -.5)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                children: [
                  Text(l.lastUpdatedJune2026, style: ScText.mono(size: 12, color: ScColors.textMuted)),
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
