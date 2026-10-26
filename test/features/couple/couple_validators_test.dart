import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/features/couple/domain/couple_validators.dart';
import 'package:rechivia/features/couple/domain/invitation_code.dart';

void main() {
  group('CoupleValidators.coupleName', () {
    test('accepts names with 2 to 30 characters after trimming', () {
      expect(CoupleValidators.coupleName('  Nous deux  '), isNull);
      expect(CoupleValidators.coupleName('A'), isNotNull);
      expect(CoupleValidators.coupleName(''), isNotNull);
      expect(CoupleValidators.coupleName('a' * 31), isNotNull);
    });
  });

  group('CoupleValidators.partnerContact', () {
    test('accepts an email or an international phone number', () {
      expect(CoupleValidators.partnerContact('alex@example.com'), isNull);
      expect(CoupleValidators.partnerContact('+33 6 12 34 56 78'), isNull);
    });

    test('rejects an empty or malformed contact', () {
      expect(CoupleValidators.partnerContact(''), isNotNull);
      expect(CoupleValidators.partnerContact('not-an-address'), isNotNull);
    });
  });

  group('InvitationCode', () {
    test('normalizes whitespace and casing', () {
      expect(InvitationCode.normalize(' k7m2pq '), 'K7M2PQ');
      expect(InvitationCode.normalize('ABC-123'), isNull);
    });

    test('extracts a code from a link path', () {
      expect(
        InvitationCode.fromLink('https://rechivia.app/invite/k7m2pq'),
        'K7M2PQ',
      );
      expect(
        InvitationCode.fromLink('https://rechivia.app/invite/nope'),
        isNull,
      );
    });
  });
}
