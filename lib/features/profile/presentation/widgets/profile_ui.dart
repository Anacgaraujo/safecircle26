import 'package:flutter/material.dart';

const profileTileBg = Color(0x1737207B);

void pushScreen(BuildContext context, Widget screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
}
