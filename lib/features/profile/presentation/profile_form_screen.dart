import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/phone.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/phone_field.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/auth/domain/auth_error.dart';
import 'package:safecircle/features/profile/application/profile_service.dart';
import 'package:safecircle/features/profile/domain/profile_rules.dart';
import 'package:safecircle/l10n/l10n.dart';

enum ProfileFormKind { editProfile, email, password, safetyPin, panicPin }

class ProfileFormScreen extends ConsumerStatefulWidget {
  const ProfileFormScreen({super.key, required this.kind});
  final ProfileFormKind kind;

  @override
  ConsumerState<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends ConsumerState<ProfileFormScreen> {
  final a = TextEditingController();
  final b = TextEditingController();
  final c = TextEditingController();
  bool saving = false;

  String phoneCode = kDefaultCountry;
  String phoneDigits = '';

  @override
  void initState() {
    super.initState();
    if (widget.kind == ProfileFormKind.editProfile) {
      a.text = ref.read(sessionProvider).userName;
      final phone = ref.read(sessionProvider).userPhone;
      if (phone.isNotEmpty) {
        final (code, digits) = parsePhone(phone);
        phoneCode = code;
        phoneDigits = digits;
      }
    }
  }

  @override
  void dispose() {
    a.dispose();
    b.dispose();
    c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (saving) return;
    final profile = ref.read(profileServiceProvider);
    final l10n = context.l10n;
    setState(() => saving = true);
    try {
      final done = switch (widget.kind) {
        ProfileFormKind.editProfile => await profile
            .updateProfile(
                name: a.text,
                phone: phoneDigits.isEmpty ? '' : formatPhone(phoneCode, phoneDigits))
            .then((_) => l10n.profileUpdated),
        ProfileFormKind.email => await profile
            .changeEmail(newEmail: a.text, password: b.text)
            .then((_) => l10n.verificationLinkSent(a.text.trim().toLowerCase())),
        ProfileFormKind.password => await profile
            .changePassword(current: a.text, next: b.text, repeat: c.text)
            .then((_) => l10n.passwordChanged),
        ProfileFormKind.safetyPin => await profile
            .changePin(PinKind.safety, current: a.text, next: b.text)
            .then((_) => l10n.safetyPinUpdated),
        ProfileFormKind.panicPin => await profile
            .changePin(PinKind.panic, current: a.text, next: b.text)
            .then((_) => l10n.panicPinUpdated),
      };
      if (mounted) {
        Navigator.of(context).pop();
        showScToast(context, done);
      }
    } catch (e) {
      if (mounted) {
        showScToast(context, e is ProfileException ? e.message : describeAuthError(e));
        setState(() => saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.read(sessionProvider);
    final l10n = context.l10n;
    final (title, hint, fields) = switch (widget.kind) {
      ProfileFormKind.editProfile => (
          l10n.editProfile,
          l10n.editProfileHint,
          <(String, String, bool, TextEditingController)>[],
        ),
      ProfileFormKind.email => (
          l10n.changeEmail,
          l10n.changeEmailHint(app.userEmail),
          [
            (l10n.newEmail, l10n.emailExample, false, a),
            (l10n.currentPassword, '••••••••', true, b),
          ],
        ),
      ProfileFormKind.password => (
          l10n.changePassword,
          l10n.useSixCharacters,
          [
            (l10n.currentPassword, '••••••••', true, a),
            (l10n.newPassword, '••••••••', true, b),
            (l10n.confirmNewPassword, '••••••••', true, c),
          ],
        ),
      ProfileFormKind.safetyPin => (
          l10n.changeSafetyPin,
          l10n.safetyPinHintShort,
          [(l10n.currentPin, '••••', true, a), (l10n.newPin, '••••', true, b)],
        ),
      ProfileFormKind.panicPin => (
          l10n.changePanicPin,
          l10n.panicPinHintShort,
          [(l10n.currentPanicPin, '••••', true, a), (l10n.newPanicPin, '••••', true, b)],
        ),
    };

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
                  Text(title, style: ScText.sans(size: 24, weight: FontWeight.w800, color: ScColors.textHeading, spacing: -.5)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                children: [
                  Text(hint, style: ScText.sans(size: 13.5, weight: FontWeight.w500, color: ScColors.textMuted, height: 19)),
                  const SizedBox(height: 16),
                  if (widget.kind == ProfileFormKind.editProfile) ...[
                    ScInput(label: l10n.fullName, controller: a),
                    const SizedBox(height: 16),
                    ScPhoneField(
                      label: l10n.phone,
                      initialCountryCode: phoneCode,
                      initialDigits: phoneDigits,
                      onChanged: (code, d) {
                        phoneCode = code;
                        phoneDigits = d;
                      },
                    ),
                    const SizedBox(height: 16),
                  ] else
                    for (final f in fields) ...[
                      ScInput(label: f.$1, placeholder: f.$2, obscure: f.$3, controller: f.$4),
                      const SizedBox(height: 16),
                    ],
                  const SizedBox(height: 6),
                  ScButton(
                    label: saving ? l10n.saving : l10n.saveChanges,
                    onPressed: saving ? null : _save,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
