import 'package:flutter/material.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:image_picker/image_picker.dart';

import 'package:safecircle/core/platform/contact_picker.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/core/utils/phone.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/phone_field.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/l10n/l10n.dart';

class PersonForm extends StatefulWidget {
  const PersonForm({super.key, this.initial, required this.onChanged, this.showEmailField = false});

  final Person? initial;
  final ValueChanged<Person> onChanged;

  final bool showEmailField;

  @override
  State<PersonForm> createState() => PersonFormState();
}

class PersonFormState extends State<PersonForm> {
  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  late String countryCode;
  late String digits;
  String? photo;

  int _phoneKey = 0;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    emailCtrl = TextEditingController(text: widget.initial?.email ?? '');
    countryCode = widget.initial?.countryCode ?? kDefaultCountry;
    digits = widget.initial?.digits ?? '';
    photo = widget.initial?.image;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  Person buildPerson() => Person(
        name: nameCtrl.text.trim(),
        countryCode: countryCode,
        digits: digits,
        image: photo,
        email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim().toLowerCase(),
        uid: widget.initial?.uid,
      );

  void reset() {
    setState(() {
      nameCtrl.clear();
      emailCtrl.clear();
      digits = '';
      countryCode = kDefaultCountry;
      photo = null;
      _phoneKey++;
    });
    widget.onChanged(buildPerson());
  }

  void _notify() => widget.onChanged(buildPerson());

  Future<void> _importFromContacts() async {
    try {
      final contact = await pickContact();
      if (contact == null) return;
      setState(() {
        nameCtrl.text = contact.name;
        if (contact.phone != null) {
          digits = nationalDigits(contact.phone!, country: countryCode);
          _phoneKey++;
        }
        if (widget.showEmailField && contact.email != null) {
          emailCtrl.text = contact.email!;
        }
      });
      _notify();
    } catch (_) {
      if (mounted) showScToast(context, context.l10n.couldNotOpenContacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScInput(
          label: context.l10n.name,
          placeholder: context.l10n.nameExampleContact,
          leadingIcon: FeatherIcons.user,
          controller: nameCtrl,
          onChanged: (_) {
            setState(() {});
            _notify();
          },
        ),
        const SizedBox(height: 16),

        Text(context.l10n.photo, style: ScText.sans(size: 14, weight: FontWeight.w700)),
        const SizedBox(height: 8),
        ScPressable(
          pressedScale: .99,
          onTap: () async {
            try {
              final picked = await ImagePicker()
                  .pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512);
              if (picked != null) {
                setState(() => photo = picked.path);
                _notify();
              }
            } catch (_) {
              if (context.mounted) showScToast(context, context.l10n.couldNotOpenPhotos);
            }
          },
          child: Container(
            height: 56,
            padding: const EdgeInsets.only(left: 16, right: 12),
            decoration: BoxDecoration(
              color: ScColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              boxShadow: ScShadows.card,
            ),
            child: Row(
              children: [
                const Icon(FeatherIcons.image, size: 20, color: ScColors.textSubtle),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    photo != null ? context.l10n.photoAdded : context.l10n.addPhoto,
                    style: ScText.sans(
                        size: 16,
                        weight: FontWeight.w500,
                        color: photo != null ? ScColors.textPrimary : ScColors.textSubtle),
                  ),
                ),
                if (photo != null)
                  ScAvatar(image: photo, name: nameCtrl.text, size: 36)
                else
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(color: ScColors.brandTint, shape: BoxShape.circle),
                    child: const Icon(FeatherIcons.plus, size: 18, color: ScColors.brand),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        ScPhoneField(
          key: ValueKey(_phoneKey),
          initialCountryCode: countryCode,
          initialDigits: digits,
          onChanged: (code, d) {
            countryCode = code;
            digits = d;
            _notify();
          },
        ),

        if (widget.showEmailField) ...[
          const SizedBox(height: 16),
          ScInput(
            label: context.l10n.emailRequired,
            placeholder: context.l10n.emailShouldMatch,
            leadingIcon: FeatherIcons.mail,
            keyboardType: TextInputType.emailAddress,
            controller: emailCtrl,
            onChanged: (_) => _notify(),
          ),
        ],

        if (contactPickerAvailable) ...[
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: _importFromContacts,
              icon: const Icon(FeatherIcons.users, size: 18, color: ScColors.brand),
              label: Text(context.l10n.importFromContacts, style: ScText.sans(size: 15, weight: FontWeight.w700, color: ScColors.brand)),
            ),
          ),
        ],
      ],
    );
  }
}
