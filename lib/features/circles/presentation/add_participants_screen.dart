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
import 'package:safecircle/features/circles/presentation/invite_by_text.dart';
import 'package:safecircle/l10n/l10n.dart';

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

  Future<void> _add() async {
    if (!_canAdd || _saving) return;
    final members = widget.draft.members;
    final before = List<Person>.of(members);
    final added = _current;
    setState(() {
      if (editIndex != null) {
        members[editIndex!] = _current;
        editIndex = null;
      } else {
        members.add(_current);
      }
    });
    _formKey.currentState?.reset();
    if (widget.isExisting) {
      await _saveNow(before, (l) => l.participantSavedTo(widget.draft.name), person: added);
    }
  }

  Future<void> _remove(int i) async {
    if (_saving) return;
    final before = List<Person>.of(widget.draft.members);
    setState(() {
      widget.draft.members.removeAt(i);
      if (editIndex == i) {
        editIndex = null;
        _formKey.currentState?.reset();
      } else if (editIndex != null && editIndex! > i) {
        editIndex = editIndex! - 1;
      }
    });
    if (widget.isExisting) {
      await _saveNow(before, (l) => l.participantRemovedFrom(widget.draft.name));
    }
  }

  /// An existing circle has no Save button: each add, edit or removal is
  /// saved (and new people invited) straight away. On failure the list goes
  /// back to how it was, so the screen never shows unsaved people.
  ///
  /// [person] is who was just added or edited. If they have no account and
  /// SafeCircle couldn't text them (no number or no consent), the owner is
  /// offered to send the invitation from their own phone. If the user left
  /// the screen before saving finished, a message says so instead.
  Future<void> _saveNow(List<Person> before, String Function(AppLocalizations) done,
      {Person? person}) async {
    final overlay = Overlay.of(context, rootOverlay: true);
    final l10n = context.l10n;
    setState(() => _saving = true);
    try {
      final service = ref.read(circleServiceProvider);
      final missing = await service.saveAndInvite(widget.draft, isNew: false);
      final texted = await service.sendInviteTexts(widget.draft);
      final offer = person != null && _needsOwnInvite(person, missing);
      if (offer && mounted) {
        showScToastOn(overlay, done(l10n));
        await offerInviteByText(context, widget.draft, person);
        return;
      }
      showScToastOn(overlay, [
        done(l10n),
        if (texted > 0) l10n.textInvitationsSent(texted),
        if (offer) l10n.noAccountYetFor(person.email!.trim()),
      ].join('\n'));
    } catch (_) {
      widget.draft.members
        ..clear()
        ..addAll(before);
      showScToastOn(overlay, l10n.couldNotSaveCircle);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// [p] has no SafeCircle account (their email is in [missing]) and
  /// SafeCircle can't text them either, so only the owner can reach them.
  static bool _needsOwnInvite(Person p, List<String> missing) {
    final email = (p.email ?? '').trim().toLowerCase();
    if (email.isEmpty || !missing.any((m) => m.trim().toLowerCase() == email)) return false;
    return !(p.smsConsent && p.digits.isNotEmpty);
  }

  /// Creates a new circle and invites everyone added so far.
  Future<void> _finalize() async {
    if (widget.draft.members.isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      final service = ref.read(circleServiceProvider);
      final missing = await service.saveAndInvite(widget.draft, isNew: !widget.isExisting);
      final texted = await service.sendInviteTexts(widget.draft);
      if (!mounted) return;
      if (texted > 0) showScToast(context, context.l10n.textInvitationsSent(texted));
      for (final p in List<Person>.of(widget.draft.members)) {
        if (!mounted) return;
        if (_needsOwnInvite(p, missing)) await offerInviteByText(context, widget.draft, p);
      }
      if (!mounted) return;
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
        showScToast(context, context.l10n.couldNotSaveCircle);
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
                  Text(context.l10n.addParticipants, style: ScText.headline()),
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      text: context.l10n.addingTo,
                      style: ScText.sub(),
                      children: [
                        TextSpan(
                            text: widget.draft.name,
                            style: ScText.sans(size: 15, weight: FontWeight.w800, color: ScColors.brand)),
                        TextSpan(text: context.l10n.addingToHint),
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
                    label: editIndex != null ? context.l10n.saveParticipant : context.l10n.add,
                    leftIcon: FeatherIcons.userPlus,
                    variant: editIndex != null || members.isEmpty
                        ? ScButtonVariant.primary
                        : ScButtonVariant.secondary,
                    onPressed: _canAdd && !_saving ? _add : null,
                  ),
                  const SizedBox(height: 24),
                  Text(context.l10n.participantsCount(members.length), style: ScText.micro()),
                  const SizedBox(height: 12),
                  if (members.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: ScColors.borderDefault, width: 1.5),
                      ),
                      child: Text(context.l10n.noParticipantsYet,
                          style: ScText.sans(size: 14, weight: FontWeight.w500, color: ScColors.textMuted)),
                    )
                  else
                    for (var i = 0; i < members.length; i++) ...[
                      PersonRow(
                        person: members[i],
                        onEdit: () {
                          setState(() => editIndex = i);
                          _formKey.currentState?.load(members[i]);
                        },
                        onDelete: () => _remove(i),
                      ),
                      const SizedBox(height: 10),
                    ],
                ],
              ),
            ),
            if (!widget.isExisting)
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 8, 26, 20),
                child: ScButton(
                  label: _saving ? context.l10n.saving : context.l10n.createCircle,
                  onPressed: members.isEmpty || _saving ? null : _finalize,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
