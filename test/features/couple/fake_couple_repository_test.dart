import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/features/couple/data/fake_couple_repository.dart';
import 'package:rechivia/features/couple/domain/couple_exception.dart';
import 'package:rechivia/features/couple/domain/couple_icon.dart';
import 'package:rechivia/features/couple/domain/invitation_code.dart';

void main() {
  final now = DateTime.utc(2026, 1, 1);

  test('creates one named couple and rejects a second active couple', () async {
    final repository = FakeCoupleRepository(
      latency: Duration.zero,
      clock: () => now,
    );

    final created = await repository.createCouple(
      name: '  Nous deux  ',
      icon: CoupleIcon.moon,
    );

    expect(created.name, 'Nous deux');
    expect(created.icon, CoupleIcon.moon);
    expect(
      () => repository.createCouple(name: 'Autre', icon: CoupleIcon.heart),
      throwsA(
        isA<CoupleException>().having(
          (error) => error.failure,
          'failure',
          CoupleFailure.alreadyInCouple,
        ),
      ),
    );
  });

  test(
    'generates a unique-format invitation that expires in seven days',
    () async {
      final repository = FakeCoupleRepository(
        latency: Duration.zero,
        clock: () => now,
      );
      await repository.createCouple(name: 'Nous deux', icon: CoupleIcon.heart);

      final invitation = await repository.invitePartner(
        contact: 'partner@example.com',
      );

      expect(InvitationCode.normalize(invitation.code), invitation.code);
      expect(invitation.expiresAt, now.add(const Duration(days: 7)));
    },
  );

  test(
    'joins using the development seed and rejects an expired seed',
    () async {
      var clock = now;
      final repository = FakeCoupleRepository(
        latency: Duration.zero,
        clock: () => clock,
      );

      final joined = await repository.joinCouple(code: ' k7m2pq ');
      expect(joined.id, 'development-couple');

      final expiredRepository = FakeCoupleRepository(
        latency: Duration.zero,
        clock: () => clock,
      );
      clock = now.add(const Duration(days: 8));
      await expectLater(
        expiredRepository.joinCouple(
          code: FakeCoupleRepository.developmentSeedCode,
        ),
        throwsA(
          isA<CoupleException>().having(
            (error) => error.failure,
            'failure',
            CoupleFailure.invalidInvitation,
          ),
        ),
      );
    },
  );

  test('uses one generic failure for unknown invitation codes', () async {
    final repository = FakeCoupleRepository(latency: Duration.zero);

    await expectLater(
      repository.joinCouple(code: 'XXXXXX'),
      throwsA(
        isA<CoupleException>().having(
          (error) => error.failure,
          'failure',
          CoupleFailure.invalidInvitation,
        ),
      ),
    );
  });
}
