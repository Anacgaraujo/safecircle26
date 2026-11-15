import 'dart:io';

import 'package:flutter/widgets.dart';

ImageProvider? localImageProvider(String path) {
  final f = File(path);
  return f.existsSync() ? FileImage(f) : null;
}
