import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/person_form.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/contacts/data/contacts_repository.dart';
import 'package:safecircle/l10n/l10n.dart';

class AddContactScreen extends ConsumerStatefulWidget {
  const AddContactScreen({super.key, this.existing});

  final Person? existing;

  @override
  ConsumerState<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends ConsumerState<AddContactScreen> {
  Person _current = Person(name: '');
  bool _saving = false;

  bool get isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) _current = widget.existing!;
  }

  Future<void> _submit() async {
    if (_current.name.trim().isEmpty || _saving) return;
    setState(() => _saving = true);
    final contacts = ref.read(contactsRepositoryProvider);
    try {
      if (isEdit) {
        _current.id = widget.existing!.id;
        await contacts.updateContact(_current);
      } else {
        await contacts.addContact(_current);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        showScToast(context, context.l10n.couldNotSaveContact);
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(isEdit ? context.l10n.editContact : context.l10n.addEmergencyContact,
                      style: ScText.headline()),
                  const SizedBox(height: 6),
                  Text(
                      context.l10n.addContactHint,
                      style: ScText.sub()),
                  const SizedBox(height: 24),
                  PersonForm(
                    initial: isEdit ? _current : null,
                    onChanged: (p) => setState(() => _current = p),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 8, 26, 20),
              child: ScButton(
                label: _saving ? context.l10n.saving : (isEdit ? context.l10n.saveChanges : context.l10n.add),
                onPressed: _current.name.trim().isEmpty || _saving ? null : _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
