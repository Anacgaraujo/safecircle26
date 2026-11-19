import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:safecircle/core/utils/phone.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/application/circle_service.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/l10n/l10n.dart';

/// A text message to [person] with [body] already written, for the phone's
/// Messages app. iOS wants `&body=` after the number, Android `?body=`.
/// Null when the person has no phone number.
Uri? inviteSmsUri(Person person, String body, {required bool ios}) {
  if (person.digits.isEmpty) return null;
  final number = '${countryByCode(person.countryCode).dial}${person.digits}'
      .replaceAll(RegExp(r'[^\d+]'), '');
  final text = Uri.encodeComponent(body);
  return Uri.parse(ios ? 'sms:$number&body=$text' : 'sms:$number?body=$text');
}

/// Tells the owner that [person] isn't on SafeCircle yet and offers to send
/// them the invitation from the owner's own phone: Messages opens with the
/// invitation written and the number filled in, or the share sheet when
/// there is no number (or no Messages app, e.g. on a simulator). The text
/// comes from the owner, so it needs no SafeCircle text consent.
Future<void> offerInviteByText(BuildContext context, Circle circle, Person person) async {
  final l10n = context.l10n;
  final hasPhone = person.digits.isNotEmpty;
  final yes = await showScConfirm(
    context,
    title: l10n.notOnSafeCircleYet(person.firstName),
    body: hasPhone ? l10n.inviteByTextBody : l10n.inviteByShareBody,
    confirmLabel: l10n.sendInvitation,
    cancelLabel: l10n.notNow,
    icon: FeatherIcons.send,
    danger: false,
  );
  if (!yes || !context.mounted) return;

  final message = inviteShareMessage(circle, person);
  final sms = inviteSmsUri(person, message, ios: defaultTargetPlatform == TargetPlatform.iOS);
  if (sms != null) {
    try {
      if (await launchUrl(sms)) return;
    } catch (e) {
      debugPrint('[SafeCircle] open Messages: $e');
    }
  }
  if (!context.mounted) return;
  final box = context.findRenderObject() as RenderBox?;
  await SharePlus.instance.share(ShareParams(
    text: message,
    subject: l10n.inviteShareSubject,
    // iPad anchors the share popover here.
    sharePositionOrigin: box == null ? null : box.localToGlobal(Offset.zero) & box.size,
  ));
}
