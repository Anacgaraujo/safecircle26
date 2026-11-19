import 'package:flutter/material.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/l10n/l10n.dart';

class PersonRow extends StatelessWidget {
  const PersonRow(
      {super.key, required this.person, this.subtitle, this.onResend, this.onEdit, this.onDelete});
  final Person person;

  final String? subtitle;
  /// Shows a "Resend invitation" button.
  final VoidCallback? onResend;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ScCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ScAvatar(image: person.image, name: person.name, size: 44),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(person.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ScText.sans(size: 16, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle ?? person.email ?? person.fullPhone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ScText.mono(size: 13, color: ScColors.textSecondary)),
              ],
            ),
          ),
          if (onResend != null)
            IconButton(
              tooltip: context.l10n.resendInvitation,
              onPressed: onResend,
              icon: const Icon(FeatherIcons.send, size: 18, color: ScColors.brand),
            ),
          if (onEdit != null)
            IconButton(
              onPressed: onEdit,
              icon: const Icon(FeatherIcons.edit3, size: 18, color: ScColors.textSecondary),
            ),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(FeatherIcons.trash2, size: 18, color: ScColors.red500),
            ),
        ],
      ),
    );
  }
}
