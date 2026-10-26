import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/features/auth/domain/auth_validators.dart';

void main() {
  group('email', () {
    test('refuse un champ vide', () {
      expect(AuthValidators.email(''), isNotNull);
      expect(AuthValidators.email(null), isNotNull);
    });

    test('refuse un format invalide', () {
      expect(AuthValidators.email('abc'), isNotNull);
      expect(AuthValidators.email('abc@'), isNotNull);
      expect(AuthValidators.email('abc@mail'), isNotNull);
    });

    test('accepte une adresse valide, même avec des espaces autour', () {
      expect(AuthValidators.email('emilie@mail.com'), isNull);
      expect(AuthValidators.email('  emilie@mail.com  '), isNull);
    });
  });

  group('username', () {
    test('refuse trop court ou trop long', () {
      expect(AuthValidators.username('ab'), isNotNull);
      expect(AuthValidators.username('a' * 21), isNotNull);
    });

    test('refuse les caractères spéciaux', () {
      expect(AuthValidators.username('emi@lie'), isNotNull);
    });

    test('accepte les accents', () {
      expect(AuthValidators.username('Émilie'), isNull);
    });
  });

  group('newPassword', () {
    test('refuse vide et trop court', () {
      expect(AuthValidators.newPassword(''), isNotNull);
      expect(AuthValidators.newPassword('1234567'), isNotNull);
    });

    test('accepte 8 caractères', () {
      expect(AuthValidators.newPassword('12345678'), isNull);
    });
  });

  group('confirmPassword', () {
    test('refuse un mot de passe différent', () {
      expect(AuthValidators.confirmPassword('abcdefgh', 'abcdefgi'), isNotNull);
    });

    test('accepte un mot de passe identique', () {
      expect(AuthValidators.confirmPassword('abcdefgh', 'abcdefgh'), isNull);
    });
  });
}
