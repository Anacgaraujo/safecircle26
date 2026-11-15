import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:safecircle/core/utils/phone.dart';

String hashPin(String uid, String pin) => sha256.convert(utf8.encode('$uid:$pin')).toString();

String lookupHash(String value) => sha256.convert(utf8.encode('sc:$value')).toString();

String emailHash(String email) => lookupHash(email.trim().toLowerCase());

String phoneHash(String rawPhone) => lookupHash(phoneE164FromDisplay(rawPhone));

const kLookupVersion = 2;
