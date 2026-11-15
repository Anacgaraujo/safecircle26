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
    setState(() => saving = true);
    try {
      final done = switch (widget.kind) {
        ProfileFormKind.editProfile => await profile
            .updateProfile(
                name: a.text,
                phone: phoneDigits.isEmpty ? '' : formatPhone(phoneCode, phoneDigits))
            .then((_) => 'Profile updated'),
        ProfileFormKind.email => await profile
            .changeEmail(newEmail: a.text, password: b.text)
            .then((_) => 'Verification link sent to ${a.text.trim().toLowerCase()} — confirm it to switch.'),
        ProfileFormKind.password => await profile
            .changePassword(current: a.text, next: b.text, repeat: c.text)
            .then((_) => 'Password changed'),
        ProfileFormKind.safetyPin => await profile
            .changePin(PinKind.safety, current: a.text, next: b.text)
            .then((_) => 'Safety PIN updated'),
        ProfileFormKind.panicPin => await profile
            .changePin(PinKind.panic, current: a.text, next: b.text)
            .then((_) => 'Panic PIN updated'),
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
    final (title, hint, fields) = switch (widget.kind) {
      ProfileFormKind.editProfile => (
          'Edit profile',
          'Update how your circle sees you. Your phone lets friends call you during a journey.',
          <(String, String, bool, TextEditingController)>[],
        ),
      ProfileFormKind.email => (
          'Change email',
          "We'll send a verification link to the new address. Sign-in and invites move to it once confirmed. Current: ${app.userEmail}",
          [
            ('New email', 'you@email.com', false, a),
            ('Current password', '••••••••', true, b),
          ],
        ),
      ProfileFormKind.password => (
          'Change password',
          'Use at least 6 characters.',
          [
            ('Current password', '••••••••', true, a),
            ('New password', '••••••••', true, b),
            ('Confirm new password', '••••••••', true, c),
          ],
        ),
      ProfileFormKind.safetyPin => (
          'Change safety PIN',
          'This PIN confirms you are OK at each check-in.',
          [('Current PIN', '••••', true, a), ('New PIN', '••••', true, b)],
        ),
      ProfileFormKind.panicPin => (
          'Change panic PIN',
          'Entering this PIN looks normal but silently alerts your circle.',
          [('Current panic PIN', '••••', true, a), ('New panic PIN', '••••', true, b)],
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
                    ScInput(label: 'Full name', controller: a),
                    const SizedBox(height: 16),
                    ScPhoneField(
                      label: 'Phone',
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
                    label: saving ? 'Saving…' : 'Save changes',
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
