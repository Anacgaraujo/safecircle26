import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';

class ScAsyncView<T> extends StatelessWidget {
  const ScAsyncView({super.key, required this.value, required this.data});

  final AsyncValue<T> value;
  final Widget Function(T value) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, _) => ScStreamError(error: e),
      loading: () => const ScSpinner(),
    );
  }
}

class ScSpinner extends StatelessWidget {
  const ScSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: ScColors.brand),
      ),
    );
  }
}
