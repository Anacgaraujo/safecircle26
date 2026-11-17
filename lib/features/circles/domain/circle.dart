import 'package:characters/characters.dart';

import 'package:safecircle/core/utils/phone.dart';
import 'package:safecircle/l10n/l10n.dart';

class Person {
  Person({
    this.id,
    required this.name,
    this.countryCode = kDefaultCountry,
    this.digits = '',
    this.image,
    this.uid,
    this.email,
  });

  String? id;
  String name;
  String countryCode;
  String digits;

  String? image;

  String? uid;
  String? email;

  String get fullPhone =>
      digits.isEmpty ? countryByCode(countryCode).dial : formatPhone(countryCode, digits);

  String get firstName => name.trim().split(' ').first;

  Map<String, dynamic> toMap() => {
        'name': name,
        'countryCode': countryCode,
        'digits': digits,
        if (image != null) 'image': image,
        if (uid != null) 'uid': uid,
        if (email != null) 'email': email,
      };

  factory Person.fromMap(Map<String, dynamic> m, {String? id}) => Person(
        id: id,
        name: (m['name'] ?? '') as String,
        countryCode: (m['countryCode'] ?? 'BR') as String,
        digits: (m['digits'] ?? '') as String,
        image: m['image'] as String?,
        uid: m['uid'] as String?,
        email: m['email'] as String?,
      );
}

class Circle {
  Circle({this.id, required this.name, List<Person>? members, this.ownerId, this.ownerName, List<String>? memberIds})
      : members = members ?? [],
        memberIds = memberIds ?? [];

  String? id;
  String name;
  final List<Person> members;
  String? ownerId;
  String? ownerName;

  final List<String> memberIds;

  List<Person> peopleSeenBy(String me, {String myEmail = ''}) {
    if (ownerId == null || ownerId == me) return members;
    final email = myEmail.toLowerCase();
    bool isMe(Person p) =>
        p.uid == me || (email.isNotEmpty && p.email?.toLowerCase() == email);
    return [
      Person(name: ownerName ?? appL10n.circleOwner, uid: ownerId),
      ...members.where((p) => !isMe(p)),
    ];
  }

  (String emoji, String text) get parts {
    final t = name.trim();
    if (t.isEmpty) return ('👥', t);
    final first = t.characters.first;
    final cp = first.runes.first;
    final isEmoji = cp >= 0x1F000 || (cp >= 0x2600 && cp <= 0x27BF) || (cp >= 0x2B00 && cp <= 0x2BFF);
    if (!isEmoji) return ('👥', t);
    return (first, t.substring(first.length).trim());
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'ownerId': ownerId,
        'ownerName': ownerName,
        'members': members.map((p) => p.toMap()).toList(),
        'memberIds': memberIds,
      };

  factory Circle.fromMap(Map<String, dynamic> m, {String? id}) => Circle(
        id: id,
        name: (m['name'] ?? '') as String,
        ownerId: m['ownerId'] as String?,
        ownerName: m['ownerName'] as String?,
        members: _dedupe(((m['members'] ?? []) as List)
            .map((e) => Person.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList()),
        memberIds: ((m['memberIds'] ?? []) as List).cast<String>(),
      );

  static List<Person> _dedupe(List<Person> people) {
    final seen = <String>{};
    final out = <Person>[];
    for (final p in people) {
      final key = p.uid?.isNotEmpty == true
          ? 'u:${p.uid}'
          : p.email?.isNotEmpty == true
              ? 'e:${p.email!.toLowerCase()}'
              : 'n:${p.name.trim().toLowerCase()}|${p.digits}';
      if (seen.add(key)) out.add(p);
    }
    return out;
  }
}
