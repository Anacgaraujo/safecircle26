import 'package:flutter_test/flutter_test.dart';

import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/core/utils/phone.dart';

void main() {
  group('maskPhone (Brazil)', () {
    test('formats a full Brazilian mobile number', () {
      expect(maskPhone('71983544219', country: 'BR'), '71 98354-4219');
    });

    test('formats progressively while typing (hyphen before last 4)', () {
      expect(maskPhone('7', country: 'BR'), '7');
      expect(maskPhone('719', country: 'BR'), '71 9');
      expect(maskPhone('7198354', country: 'BR'), '71 9-8354');
    });

    test('caps at 11 digits', () {
      expect(maskPhone('719835442190000', country: 'BR'), '71 98354-4219');
    });
  });

  group('US phone numbers', () {
    test('mask as (212) 555-1234 and cap at 10 digits', () {
      expect(maskPhone('212555'), '(212) 555');
      expect(maskPhone('21255512349'), '(212) 555-1234');
      expect(formatPhone('US', '2125551234'), '+1 (212) 555-1234');
    });

    test('drop a pasted country code', () {
      expect(nationalDigits('+1 (212) 555-1234'), '2125551234');
      expect(nationalDigits('212-555-1234'), '2125551234');
    });
  });

  group('phone matching key (E.164)', () {
    test('a contact and the stored profile phone give the same key', () {
      expect(phoneE164('US', '(212) 555-1234'), '+12125551234');
      expect(phoneE164FromDisplay('+1 (212) 555-1234'), '+12125551234');
      expect(phoneE164FromDisplay('(+55) 71 98354-4219'), '+5571983544219');
      expect(phoneE164('BR', '71983544219'), '+5571983544219');
    });

    test('the same digits in different countries never match', () {
      expect(phoneE164('US', '7198354421') == phoneE164('BR', '7198354421'), isFalse);
    });

    test('parsePhone restores the saved country', () {
      expect(parsePhone('+55 71 98354-4219'), ('BR', '71983544219'));
      expect(parsePhone('+1 (212) 555-1234'), ('US', '2125551234'));
    });
  });

  group('overdue detection', () {
    Journey journey(List<CheckIn> checkIns) => Journey(
          id: 'j1',
          ownerId: 'u1',
          ownerName: 'Ana Lima',
          circleId: 'c1',
          circleName: '🏠 Family',
          status: 'active',
          checkIns: checkIns,
          alertRaised: false,
        );

    final now = DateTime(2026, 7, 12, 20, 0);
    CheckIn at(DateTime t, {bool confirmed = false}) => CheckIn(
          label: 'Check-in',
          date: 'Today',
          time: '',
          atMillis: t.millisecondsSinceEpoch,
          confirmed: confirmed,
        );

    test('not late before the scheduled time', () {
      expect(at(now.add(const Duration(minutes: 10))).isLate(now), isFalse);
    });

    test('not late within the grace period', () {
      expect(at(now.subtract(const Duration(minutes: 4))).isLate(now), isFalse);
    });

    test('late after time + grace', () {
      expect(at(now.subtract(const Duration(minutes: 6))).isLate(now), isTrue);
    });

    test('confirmed check-ins are never late', () {
      expect(at(now.subtract(const Duration(hours: 1)), confirmed: true).isLate(now), isFalse);
    });

    test('journey overdue follows the first pending check-in', () {
      final j = journey([
        at(now.subtract(const Duration(hours: 2)), confirmed: true),
        at(now.subtract(const Duration(minutes: 10))),
        at(now.add(const Duration(hours: 1))),
      ]);
      expect(j.isOverdue(now), isTrue);
      expect(j.missedCheckIn(now), same(j.checkIns[1]));
    });

    test('journey on time when next check-in is in the future', () {
      final j = journey([
        at(now.subtract(const Duration(hours: 2)), confirmed: true),
        at(now.add(const Duration(minutes: 30))),
      ]);
      expect(j.isOverdue(now), isFalse);
      expect(j.missedCheckIn(now), isNull);
    });
  });
}
