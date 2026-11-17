import 'package:flutter/material.dart';

import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/journeys/domain/pin_check.dart';
import 'package:safecircle/l10n/l10n.dart';

/// Asks for the safety or panic PIN on a full screen. Returns which one was
/// typed, or null if the person went back. Both PINs behave the same on
/// screen, so someone watching can't tell the panic PIN was used.
Future<PinResult?> askForPin(BuildContext context, {required String title, required String body}) =>
    Navigator.of(context).push<PinResult>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _PinPrompt(title: title, body: body),
    ));

class _PinPrompt extends StatefulWidget {
  const _PinPrompt({required this.title, required this.body});
  final String title;
  final String body;

  @override
  State<_PinPrompt> createState() => _PinPromptState();
}

class _PinPromptState extends State<_PinPrompt> {
  String _pin = '';
  bool _error = false;

  void _digit(String d) {
    if (_pin.length >= 4) return;
    setState(() {
      _pin += d;
      _error = false;
    });
    if (_pin.length < 4) return;
    final result = checkPin(Session.instance, _pin);
    if (result == PinResult.wrong) {
      setState(() {
        _pin = '';
        _error = true;
      });
    } else {
      Navigator.of(context).pop(result);
    }
  }

  void _delete() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 8, 26, 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: context.l10n.cancel,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(FeatherIcons.arrowLeft, size: 22, color: ScColors.textSecondary),
                ),
              ),
              const SizedBox(height: 14),
              Text(widget.title,
                  textAlign: TextAlign.center,
                  style: ScText.sans(
                      size: 26, weight: FontWeight.w800, color: ScColors.textHeading, height: 32, spacing: -0.5)),
              const SizedBox(height: 8),
              Text(widget.body,
                  textAlign: TextAlign.center,
                  style: ScText.sans(size: 15, weight: FontWeight.w600, color: ScColors.textSubtle, height: 21)),
              const SizedBox(height: 34),
              PinBoxes(length: _pin.length, error: _error),
              SizedBox(height: _error ? 12 : 24),
              if (_error)
                Text(context.l10n.incorrectPin,
                    style: ScText.sans(size: 13, weight: FontWeight.w700, color: ScColors.red500)),
              const Spacer(),
              PinKeypad(onDigit: _digit, onDelete: _delete),
            ],
          ),
        ),
      ),
    );
  }
}
