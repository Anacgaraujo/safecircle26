import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/permissions/permissions.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/person_form.dart';
import 'package:safecircle/core/widgets/person_row.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/application/circle_service.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/circles/presentation/circle_detail_screen.dart';

class AddParticipantsScreen extends ConsumerStatefulWidget {
  const AddParticipantsScreen({super.key, required this.draft, this.isExisting = false});

  final Circle draft;

  final bool isExisting;

  @override
  ConsumerState<AddParticipantsScreen> createState() => _AddParticipantsScreenState();
}

class _AddParticipantsScreenState extends ConsumerState<AddParticipantsScreen> {
  final _formKey = GlobalKey<PersonFormState>();
  Person _current = Person(name: '');
  int? editIndex;
  bool _saving = false;

  bool get _canAdd =>
      _current.name.trim().isNotEmpty && (_current.email ?? '').contains('@');

  void _add() {
    if (!_canAdd) return;
    setState(() {
      if (editIndex != null) {
        widget.draft.members[editIndex!] = _current;
        editIndex = null;
      } else {
        widget.draft.members.add(_current);
      }
    });
    _formKey.currentState?.reset();
  }

  Future<void> _finalize() async {
    if (widget.draft.members.isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      final missing = await ref
          .read(circleServiceProvider)
          .saveAndInvite(widget.draft, isNew: !widget.isExisting);
      if (!mounted) return;
      if (missing.isNotEmpty) {
        showScToast(context, 'No SafeCircle account for: ${missing.join(', ')}');
      }
      if (!widget.isExisting) await startLiveSharingByDefault(context);
      if (!mounted) return;
      Navigator.of(context).pop();
      if (!widget.isExisting) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => CircleDetailScreen(circle: widget.draft)),
        );
      }
    } catch (_) {
      if (mounted) {
        showScToast(context, 'Could not save the circle. Try again.');
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final members = widget.draft.members;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
              child: ScBackButton(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(26, 10, 26, 10),
                children: [
                  Text('Add participants', style: ScText.headline()),
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      text: 'Adding to ',
                      style: ScText.sub(),
                      children: [
                        TextSpan(
                            text: widget.draft.name,
                            style: ScText.sans(size: 15, weight: FontWeight.w800, color: ScColors.brand)),
                        const TextSpan(
                            text:
                                ". Participants join with the email of their SafeCircle account — that's how they follow your journeys."),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  PersonForm(
                    key: _formKey,
                    showEmailField: true,
                    onChanged: (p) => setState(() => _current = p),
                  ),
                  const SizedBox(height: 8),
                  ScButton(
                    label: editIndex != null ? 'Save participant' : 'Add',
                    leftIcon: FeatherIcons.userPlus,
                    variant: editIndex != null || members.isEmpty
                        ? ScButtonVariant.primary
                        : ScButtonVariant.secondary,
                    onPressed: _canAdd ? _add : null,
                  ),
                  const SizedBox(height: 24),
                  Text('PARTICIPANTS · ${members.length}', style: ScText.micro()),
                  const SizedBox(height: 12),
                  if (members.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: ScColors.borderDefault, width: 1.5),
                      ),
                      child: Text('No participants yet',
                          style: ScText.sans(size: 14, weight: FontWeight.w500, color: ScColors.textMuted)),
                    )
                  else
                    for (var i = 0; i < members.length; i++) ...[
                      PersonRow(
                        person: members[i],
                        onEdit: () => setState(() => editIndex = i),
                        onDelete: () => setState(() => members.removeAt(i)),
                      ),
                      const SizedBox(height: 10),
                    ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 8, 26, 20),
              child: ScButton(
                label: _saving
                    ? 'Saving…'
                    : (widget.isExisting ? 'Save circle' : 'Create circle'),
                onPressed: members.isEmpty || _saving ? null : _finalize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
