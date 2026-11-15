import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider = StreamProvider.autoDispose.family<DateTime, Duration>(
  (ref, period) async* {
    yield DateTime.now();
    yield* Stream.periodic(period, (_) => DateTime.now());
  },
);

extension ClockRef on WidgetRef {
  DateTime now(Duration period) => watch(clockProvider(period)).value ?? DateTime.now();
}
