import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/features/auth/data/fake_auth_repository.dart';
import 'package:rechivia/features/auth/domain/auth_exception.dart';

Matcher _throwsFailure(AuthFailure failure) {
  return throwsA(
    isA<AuthException>().having((e) => e.failure, 'failure', failure),
  );
}

void main() {
  late FakeAuthRepository repository;

  setUp(() => repository = FakeAuthRepository(latency: Duration.zero));

  Future<void> signUp() async {
    await repository.signUp(
      email: 'emilie@mail.com',
      username: 'Émilie',
      password: 'motdepasse1',
    );
  }

  test('l\'inscription connecte l\'utilisateur', () async {
    await signUp();

    expect((await repository.getCurrentUser())?.username, 'Émilie');
  });

  group('signOut', () {
    test('efface la session mais garde le compte', () async {
      await signUp();

      await repository.signOut();

      expect(await repository.getCurrentUser(), isNull);
      final user = await repository.signIn(
        email: 'emilie@mail.com',
        password: 'motdepasse1',
      );
      expect(user.username, 'Émilie');
    });

    test('est sans effet quand personne n\'est connecté', () async {
      await repository.signOut();

      expect(await repository.getCurrentUser(), isNull);
    });
  });

  group('deleteAccount', () {
    test('supprime le compte et déconnecte', () async {
      await signUp();

      await repository.deleteAccount();

      expect(await repository.getCurrentUser(), isNull);
      await expectLater(
        repository.signIn(email: 'emilie@mail.com', password: 'motdepasse1'),
        _throwsFailure(AuthFailure.invalidCredentials),
      );
    });

    test('libère l\'adresse e-mail', () async {
      await signUp();
      await repository.deleteAccount();

      await signUp();

      expect((await repository.getCurrentUser())?.email, 'emilie@mail.com');
    });

    test('échoue quand personne n\'est connecté', () async {
      await expectLater(
        repository.deleteAccount(),
        _throwsFailure(AuthFailure.notSignedIn),
      );
    });
  });
}
