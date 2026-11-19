import 'package:flutter/material.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/journeys/domain/journey_schedule.dart';
import 'package:safecircle/l10n/l10n.dart';

class PlanTimingStep extends StatelessWidget {
  const PlanTimingStep({
    super.key,
    required this.checkIns,
    required this.noteCtrl,
    required this.onChanged,
    required this.onNext,
  });

  final List<CheckIn> checkIns;
  final TextEditingController noteCtrl;

  final VoidCallback onChanged;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.fromLTRB(24, 6, 24, 0), child: ScBackButton()),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 10),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.newJourney, style: ScText.headline()),
                    const SizedBox(height: 6),
                    Text(context.l10n.newJourneyHint,
                        style: ScText.sub()),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              ScCard(
                radius: 18,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                      child: Row(
                        children: [
                          const _StepBadge('1', active: true),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Text(context.l10n.selectTiming,
                                  style: ScText.sans(
                                      size: 17, weight: FontWeight.w800, color: ScColors.textHeading))),
                          const Icon(FeatherIcons.chevronUp, size: 20, color: ScColors.textMuted),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                      child: Column(
                        children: [
                          for (final c in checkIns) ...[
                            _TimingField(checkIn: c, onChanged: onChanged),
                            const SizedBox(height: 12),
                          ],
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.l10n.otherInformation,
                                  style: ScText.sans(size: 13, weight: FontWeight.w700)),
                              const SizedBox(height: 7),
                              Container(
                                height: 52,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: ScColors.canvas,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: ScColors.borderDefault),
                                ),
                                child: TextField(
                                  controller: noteCtrl,
                                  style: ScText.sans(size: 15, weight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    hintText: context.l10n.journeyNoteExample,
                                    hintStyle: ScText.sans(
                                        size: 15, weight: FontWeight.w500, color: ScColors.textMuted),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ScPressable(
                            onTap: () {
                              addCheckIn(checkIns, DateTime.now());
                              onChanged();
                            },
                            pressedScale: .98,
                            child: Container(
                              height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: ScColors.borderDefault, width: 1.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.plus, size: 16, color: ScColors.brand),
                                  const SizedBox(width: 7),
                                  Text(context.l10n.addCheckIn,
                                      style: ScText.sans(
                                          size: 14, weight: FontWeight.w700, color: ScColors.brand)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ScPressable(
                onTap: onNext,
                pressedScale: .99,
                child: ScCard(
                  radius: 18,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      const _StepBadge('2', active: false),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(context.l10n.startJourney,
                              style: ScText.sans(
                                  size: 17, weight: FontWeight.w800, color: ScColors.textMuted))),
                      const Icon(FeatherIcons.chevronDown, size: 20, color: ScColors.textMuted),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 8, 26, 20),
          child: ScButton(label: context.l10n.next, rightIcon: FeatherIcons.arrowRight, onPressed: onNext),
        ),
      ],
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge(this.n, {required this.active});
  final String n;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? ScColors.brand : ScColors.surfaceSunken,
        shape: BoxShape.circle,
      ),
      child: Text(n,
          style: ScText.sans(
              size: 13, weight: FontWeight.w800, color: active ? Colors.white : ScColors.textMuted)),
    );
  }
}

class _TimingField extends StatelessWidget {
  const _TimingField({required this.checkIn, required this.onChanged});
  final CheckIn checkIn;
  final VoidCallback onChanged;

  Future<void> _pick(BuildContext context) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked == null) return;
    final now = DateTime.now();
    final at = nextOccurrence(picked.hour, picked.minute, now);
    if (at == null) {
      if (context.mounted) showScToast(context, context.l10n.pickTimeOneMinute);
      return;
    }
    reschedule(checkIn, at, now: now);
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(checkIn.label, style: ScText.sans(size: 13, weight: FontWeight.w700)),
        const SizedBox(height: 7),
        GestureDetector(
          onTap: () => _pick(context),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: ScColors.canvas,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ScColors.borderDefault),
            ),
            child: Row(
              children: [
                const Icon(FeatherIcons.calendar, size: 18, color: ScColors.brand),
                const SizedBox(width: 10),
                Expanded(child: Text(checkIn.dateText, style: ScText.sans(size: 15, weight: FontWeight.w600))),
                Text(checkIn.timeText,
                    style: ScText.mono(size: 15, weight: FontWeight.w600, color: ScColors.brand)),
                const SizedBox(width: 10),
                const Icon(FeatherIcons.chevronDown, size: 16, color: ScColors.textMuted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
