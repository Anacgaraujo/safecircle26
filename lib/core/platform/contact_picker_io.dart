import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:safecircle/core/platform/picked_contact.dart';

const bool contactPickerAvailable = true;

Future<PickedContact?> pickContact() async {
  final contact = await FlutterContacts.openExternalPick();
  if (contact == null) return null;
  final full = await FlutterContacts.getContact(contact.id) ?? contact;
  return PickedContact(
    name: full.displayName,
    phone: full.phones.isNotEmpty ? full.phones.first.number : null,
    email: full.emails.isNotEmpty ? full.emails.first.address : null,
  );
}
