import 'package:rechivia/core/data/simulated_latency.dart';
import 'package:rechivia/features/auth/domain/app_user.dart';
import 'package:rechivia/features/auth/domain/auth_exception.dart';
import 'package:rechivia/features/auth/domain/auth_repository.dart';

/// Implémentation FACTICE de [AuthRepository], gardée en mémoire.
///
/// Elle sert à développer et tester les écrans sans serveur. Les comptes
/// disparaissent à la fermeture de l'application. Elle sera remplacée par
/// l'implémentation Supabase à la tâche 15.
///
/// Les mots de passe sont stockés en clair ICI uniquement parce que cette
/// classe n'existe qu'en mémoire pour le développement ; le vrai backend ne
/// les stockera jamais ainsi.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.latency = const Duration(milliseconds: 600)});

  /// Délai simulé d'un appel réseau (mis à zéro dans les tests).
  final Duration latency;

  /// Comptes créés, indexés par e-mail en minuscules.
  final Map<String, _Account> _accounts = {};

  int _nextId = 1;

  /// Utilisateur connecté ; le dépôt joue le rôle de session serveur.
  AppUser? _currentUser;

  @override
  Future<AppUser> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    await simulateLatency(latency);

    final key = _normalize(email);
    if (_accounts.containsKey(key)) {
      throw const AuthException(AuthFailure.emailAlreadyUsed);
    }

    final user = AppUser(
      id: 'user-${_nextId++}',
      email: key,
      username: username.trim(),
    );
    _accounts[key] = _Account(user: user, password: password);
    _currentUser = user;
    return user;
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    await simulateLatency(latency);

    final account = _accounts[_normalize(email)];
    if (account == null || account.password != password) {
      throw const AuthException(AuthFailure.invalidCredentials);
    }
    _currentUser = account.user;
    return account.user;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await simulateLatency(latency);
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    await simulateLatency(latency);
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    await simulateLatency(latency);
    _currentUser = null;
  }

  @override
  Future<void> deleteAccount() async {
    await simulateLatency(latency);

    final user = _currentUser;
    if (user == null) {
      throw const AuthException(AuthFailure.notSignedIn);
    }

    _accounts.remove(_normalize(user.email));
    _currentUser = null;
  }

  String _normalize(String email) => email.trim().toLowerCase();
}

/// Compte stocké en mémoire : l'utilisateur et son mot de passe.
class _Account {
  const _Account({required this.user, required this.password});

  final AppUser user;
  final String password;
}
