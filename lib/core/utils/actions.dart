import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/l10n/l10n.dart';

const kEmergencyNumber = '911';

Future<void> _launch(BuildContext context, Uri uri, String failMsg) async {
  try {
    final ok = await launchUrl(uri,
        mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication);
    if (!ok && context.mounted) showScToast(context, failMsg);
  } catch (_) {
    if (context.mounted) showScToast(context, failMsg);
  }
}

Future<void> callPhone(BuildContext context, String? phone) {
  final digits = (phone ?? '').replaceAll(RegExp(r'[^\d+]'), '');
  if (digits.isEmpty) {
    showScToast(context, context.l10n.noPhoneNumber);
    return Future.value();
  }
  return _launch(context, Uri(scheme: 'tel', path: digits), context.l10n.couldNotOpenDialer);
}

/// A link that opens the phone's messaging app addressed to [numbers].
/// iPhones don't understand Android's `smsto:`, and take several
/// recipients only through `sms://open?addresses=`.
Uri smsUri(Iterable<String> numbers, {String? body, TargetPlatform? platform}) {
  final ios = (platform ?? defaultTargetPlatform) == TargetPlatform.iOS && !kIsWeb;
  final to = numbers.join(',');
  final text = body == null || body.isEmpty ? '' : body;
  if (ios) {
    final multiple = numbers.length > 1;
    final base = multiple ? 'sms://open?addresses=$to' : 'sms:$to';
    if (text.isEmpty) return Uri.parse(base);
    return Uri.parse('$base${multiple ? '&' : '&'}body=${Uri.encodeComponent(text)}');
  }
  return Uri(scheme: 'smsto', path: to, queryParameters: text.isEmpty ? null : {'body': text});
}

Future<void> messagePhone(BuildContext context, String? phone) {
  final digits = (phone ?? '').replaceAll(RegExp(r'[^\d+]'), '');
  if (digits.isEmpty) {
    showScToast(context, context.l10n.noPhoneNumber);
    return Future.value();
  }
  return _launch(context, smsUri([digits]), context.l10n.couldNotOpenMessages);
}

Future<void> messageGroup(BuildContext context, Iterable<String?> phones, {String? body}) {
  final list = phones
      .map((p) => (p ?? '').replaceAll(RegExp(r'[^\d+]'), ''))
      .where((d) => d.isNotEmpty)
      .toSet();
  if (list.isEmpty) {
    showScToast(context, context.l10n.noPhoneNumbers);
    return Future.value();
  }
  return _launch(context, smsUri(list, body: body), context.l10n.couldNotOpenMessages);
}

Future<void> openInMaps(BuildContext context, double? lat, double? lng, {String? label}) {
  if (lat == null || lng == null) {
    showScToast(context, context.l10n.noLocationYetShort);
    return Future.value();
  }
  final q = Uri.encodeComponent(label == null || label.isEmpty ? '$lat,$lng' : label);
  final uri = kIsWeb
      ? Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat%2C$lng')
      : Uri.parse('geo:$lat,$lng?q=$lat,$lng($q)');
  return _launch(context, uri, context.l10n.couldNotOpenMaps);
}
