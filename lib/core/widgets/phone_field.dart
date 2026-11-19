import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';

import 'package:safecircle/core/utils/phone.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/l10n/l10n.dart';

class ScPhoneField extends StatefulWidget {
  const ScPhoneField({
    super.key,
    this.label,
    this.initialCountryCode = kDefaultCountry,
    this.initialDigits = '',
    required this.onChanged,
  });

  final String? label;
  final String initialCountryCode;
  final String initialDigits;
  final void Function(String countryCode, String digits) onChanged;

  @override
  State<ScPhoneField> createState() => _ScPhoneFieldState();
}

class _ScPhoneFieldState extends State<ScPhoneField> {
  late String countryCode;
  late final TextEditingController phoneCtrl;
  bool open = false;

  @override
  void initState() {
    super.initState();
    countryCode = widget.initialCountryCode;
    phoneCtrl = TextEditingController(
        text: maskPhone(widget.initialDigits, country: widget.initialCountryCode));
  }

  @override
  void dispose() {
    phoneCtrl.dispose();
    super.dispose();
  }

  String get _digits => phoneCtrl.text.replaceAll(RegExp(r'\D'), '');

  void _emit() => widget.onChanged(countryCode, _digits);

  @override
  Widget build(BuildContext context) {
    final country = countryByCode(countryCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label ?? context.l10n.phoneNumber, style: ScText.sans(size: 14, weight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: ScColors.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            boxShadow: ScShadows.card,
          ),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => open = !open),
                child: Container(
                  padding: const EdgeInsets.only(left: 2, right: 10, top: 6, bottom: 6),
                  decoration: const BoxDecoration(
                    border: Border(right: BorderSide(color: ScColors.borderDefault)),
                  ),
                  child: Row(
                    children: [
                      Text(country.flag, style: const TextStyle(fontSize: 19)),
                      const SizedBox(width: 7),
                      Text(country.dial, style: ScText.sans(size: 16, weight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      const Icon(FeatherIcons.chevronDown, size: 16, color: ScColors.textMuted),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [PhoneMaskFormatter(countryCode)],
                  style: ScText.mono(size: 16, spacing: .3),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: countryCode == 'BR' ? '00 00000-0000' : '(000) 000-0000',
                    hintStyle: ScText.mono(size: 16, color: ScColors.textMuted),
                  ),
                  onChanged: (_) => _emit(),
                ),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 160),
          curve: ScMotion.easeOut,
          child: open
              ? Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: ScColors.surfaceCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: ScColors.borderDefault),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: .16), offset: const Offset(0, 12), blurRadius: 30),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (final c in kCountries)
                        InkWell(
                          onTap: () {
                            setState(() {
                              countryCode = c.code;
                              open = false;
                              phoneCtrl.text = maskPhone(_digits, country: c.code);
                            });
                            _emit();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            color: c.code == countryCode ? ScColors.brandTint : Colors.transparent,
                            child: Row(
                              children: [
                                Text(c.flag, style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 12),
                                Expanded(child: Text(countryName(c), style: ScText.sans(size: 15, weight: FontWeight.w600))),
                                Text(c.dial, style: ScText.mono(size: 14, color: ScColors.textSecondary)),
                                if (c.code == countryCode) ...[
                                  const SizedBox(width: 10),
                                  const Icon(FeatherIcons.check, size: 18, color: ScColors.brand),
                                ],
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class PhoneMaskFormatter extends TextInputFormatter {
  PhoneMaskFormatter(this.country);
  final String country;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final masked = maskPhone(newValue.text, country: country);
    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
    );
  }
}
