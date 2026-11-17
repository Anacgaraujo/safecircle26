import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/async_view.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/person_row.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/contacts/data/contacts_repository.dart';
import 'package:safecircle/features/contacts/presentation/add_contact_screen.dart';
import 'package:safecircle/l10n/l10n.dart';

class EmergencyContactsScreen extends ConsumerWidget {
  const EmergencyContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactsProvider);
    final count = contactsAsync.value?.length ?? 0;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: ScBackButton(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 6, 26, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.emergencyContacts,
                      style: ScText.sans(
                          size: 28,
                          weight: FontWeight.w800,
                          color: ScColors.textHeading,
                          height: 34,
                          spacing: -0.6)),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.emergencyContactsHint,
                    style: ScText.sub(),
                  ),
                ],
              ),
            ),
            if (contactsAsync.hasValue && count < 2)
              Container(
                margin: const EdgeInsets.fromLTRB(26, 18, 26, 0),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                decoration: BoxDecoration(
                  color: ScColors.brandTint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ScColors.brand.withValues(alpha: .18)),
                ),
                child: Row(
                  children: [
                    const Icon(FeatherIcons.alertCircle, size: 20, color: ScColors.brand),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(context.l10n.addTwoContacts,
                          style: ScText.sans(
                              size: 13.5,
                              weight: FontWeight.w600,
                              color: ScColors.magenta600,
                              height: 19)),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 22, 26, 12),
              child: ScSectionLabel(
                context.l10n.alwaysAlerted(count),
                icon: FeatherIcons.shield,
              ),
            ),
            Expanded(
              child: ScAsyncView(
                value: contactsAsync,
                data: (contacts) => ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  children: [
                    for (final c in contacts) ...[
                      PersonRow(
                        person: c,
                        onEdit: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddContactScreen(existing: c)),
                        ),
                        onDelete: () async {
                          final ok = await showScConfirm(
                            context,
                            title: context.l10n.removePersonQuestion(c.name),
                            body: context.l10n.removeContactBody,
                            confirmLabel: context.l10n.removeContact,
                          );
                          if (ok) await ref.read(contactsRepositoryProvider).deleteContact(c.id!);
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 8, 26, 20),
              child: ScButton(
                label: context.l10n.addEmergencyContact,
                leftIcon: FeatherIcons.userPlus,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddContactScreen()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
