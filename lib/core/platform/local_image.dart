export 'package:safecircle/core/platform/local_image_stub.dart'
    if (dart.library.io) 'local_image_io.dart'
    if (dart.library.js_interop) 'local_image_web.dart';
