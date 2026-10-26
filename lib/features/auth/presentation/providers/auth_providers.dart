import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/features/auth/data/fake_auth_repository.dart';
import 'package:rechivia/features/auth/domain/app_user.dart';
import 'package:rechivia/features/auth/domain/auth_repository.dart';

/// Fournit le dépôt d'authentification à toute l'application.
///
/// C'est LE seul endroit à modifier pour passer du faux backend à Supabase.
/// Les tests peuvent aussi le remplacer (`overrideWithValue`).
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FakeAuthRepository(),
);

/// Pilote les actions d'authentification déclenchées par les écrans.
///
/// L'état est un `AsyncValue` : loading pendant une requête et error en cas
/// d'échec. Les écrans utilisent le succès de chaque méthode pour naviguer.
class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> signIn({required String email, required String password}) {
    return _run(
      () => ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password),
    );
  }

  Future<bool> signUp({
    required String email,
    required String username,
    required String password,
  }) {
    return _run(
      () => ref
          .read(authRepositoryProvider)
          .signUp(email: email, username: username, password: password),
    );
  }

  Future<bool> sendPasswordResetEmail({required String email}) {
    return _run(
      () =>
          ref.read(authRepositoryProvider).sendPasswordResetEmail(email: email),
    );
  }

  Future<bool> _run(Future<Object?> Function() action) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    if (!ref.mounted) return false;

    state = result.hasError
        ? AsyncError<void>(result.error!, result.stackTrace!)
        : const AsyncData<void>(null);
    return !result.hasError;
  }
}

/// `autoDispose` : les erreurs et le chargement sont effacés quand l'écran
/// d'authentification est quitté.
final authControllerProvider =
    AsyncNotifierProvider.autoDispose<AuthController, void>(AuthController.new);

/// Utilisateur actuellement connecté (`null` si aucun).
///
/// Le dépôt reste la seule source de vérité de la session.
final currentUserProvider = FutureProvider.autoDispose<AppUser?>(
  (ref) => ref.watch(authRepositoryProvider).getCurrentUser(),
);
