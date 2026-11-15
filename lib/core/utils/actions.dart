import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:safecircle/core/widgets/sc_widgets.dart';

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
    showScToast(context, 'No phone number available.');
    return Future.value();
  }
  return _launch(context, Uri(scheme: 'tel', path: digits), 'Could not open the dialer.');
}

Future<void> messagePhone(BuildContext context, String? phone) {
  final digits = (phone ?? '').replaceAll(RegExp(r'[^\d+]'), '');
  if (digits.isEmpty) {
    showScToast(context, 'No phone number available.');
    return Future.value();
  }
  return _launch(context, Uri(scheme: 'smsto', path: digits), 'Could not open messages.');
}

Future<void> messageGroup(BuildContext context, Iterable<String?> phones, {String? body}) {
  final list = phones
      .map((p) => (p ?? '').replaceAll(RegExp(r'[^\d+]'), ''))
      .where((d) => d.isNotEmpty)
      .toSet();
  if (list.isEmpty) {
    showScToast(context, 'No phone numbers available.');
    return Future.value();
  }
  final uri = Uri(
    scheme: 'smsto',
    path: list.join(','),
    queryParameters: body == null || body.isEmpty ? null : {'body': body},
  );
  return _launch(context, uri, 'Could not open messages.');
}

Future<void> openInMaps(BuildContext context, double? lat, double? lng, {String? label}) {
  if (lat == null || lng == null) {
    showScToast(context, 'No location available yet.');
    return Future.value();
  }
  final q = Uri.encodeComponent(label == null || label.isEmpty ? '$lat,$lng' : label);
  final uri = kIsWeb
      ? Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat%2C$lng')
      : Uri.parse('geo:$lat,$lng?q=$lat,$lng($q)');
  return _launch(context, uri, 'Could not open the maps app.');
}
