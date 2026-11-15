import 'package:flutter/material.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';

class CheckInPinStep extends StatelessWidget {
  const CheckInPinStep({
    super.key,
    required this.finishing,
    required this.checkIn,
    required this.pinLength,
    required this.pinError,
    required this.onDigit,
    required this.onDelete,
    required this.onBack,
  });

  final bool finishing;

  final CheckIn? checkIn;
  final int pinLength;
  final bool pinError;
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final active = checkIn;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 8, 26, 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: onBack,
                      icon: const Icon(FeatherIcons.arrowLeft, size: 22, color: ScColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(finishing ? 'Confirm to end journey' : 'Confirm your check-in',
                      textAlign: TextAlign.center,
                      style: ScText.sans(
                          size: 26,
                          weight: FontWeight.w800,
                          color: ScColors.textHeading,
                          height: 32,
                          spacing: -0.5)),
                  const SizedBox(height: 8),
                  if (finishing)
                    Text('Enter your PIN to end this journey safely.',
                        textAlign: TextAlign.center,
                        style: ScText.sans(size: 15, weight: FontWeight.w600, color: ScColors.textSubtle))
                  else if (active != null)
                    Text.rich(
                      TextSpan(
                        text: '${active.label} · ',
                        style: ScText.sans(size: 15, weight: FontWeight.w600, color: ScColors.textSubtle),
                        children: [
                          TextSpan(
                              text: '${active.date} · ${active.time}',
                              style: ScText.mono(size: 14, color: ScColors.brand)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 34),
                  PinBoxes(length: pinLength, error: pinError),
                  SizedBox(height: pinError ? 12 : 24),
                  if (pinError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('Incorrect PIN. Try again.',
                          style: ScText.sans(size: 13, weight: FontWeight.w700, color: ScColors.red500)),
                    ),
                  const Spacer(),
                  PinKeypad(onDigit: onDigit, onDelete: onDelete),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
