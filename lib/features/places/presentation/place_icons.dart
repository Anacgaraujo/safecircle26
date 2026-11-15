import 'package:flutter/widgets.dart';

import 'package:safecircle/core/widgets/feather_icons.dart';

IconData placeIcon(String key) => switch (key) {
      'home' => FeatherIcons.home,
      'flag' => FeatherIcons.flag,
      'briefcase' => FeatherIcons.briefcase,
      'heart' => FeatherIcons.heart,
      _ => FeatherIcons.mapPin,
    };

const placeIconKeys = ['home', 'flag', 'briefcase', 'heart', 'mapPin'];
