import 'package:flutter/widgets.dart';

ImageProvider? localImageProvider(String path) {
  if (path.startsWith('blob:') || path.startsWith('http')) return NetworkImage(path);
  return null;
}
