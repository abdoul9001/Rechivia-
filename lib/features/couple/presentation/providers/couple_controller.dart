import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/features/couple/domain/couple.dart';
import 'package:rechivia/features/couple/domain/couple_exception.dart';
import 'package:rechivia/features/couple/domain/couple_icon.dart';
import 'package:rechivia/features/couple/domain/invitation.dart';
import 'package:rechivia/features/couple/presentation/providers/couple_providers.dart';

/// État partagé du parcours de création et d'invitation.
@immutable
class CoupleState {
  const CoupleState({
    this.couple,
    this.invitation,
    this.isLoading = false,
    this.errorMessage,
  });

  final Couple? couple;
  final Invitation? invitation;
  final bool isLoading;
  final String? errorMessage;

  CoupleState copyWith({
    Couple? couple,
    Invitation? invitation,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CoupleState(
      couple: couple ?? this.couple,
      invitation: invitation ?? this.invitation,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

/// Orchestre les opérations couple et conserve leurs erreurs visibles.
class CoupleController extends Notifier<CoupleState> {
  @override
  CoupleState build() => const CoupleState();

  Future<Couple?> create({
    required String name,
    required CoupleIcon icon,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final couple = await ref
          .read(coupleRepositoryProvider)
          .createCouple(name: name, icon: icon);
      if (ref.mounted) {
        state = state.copyWith(couple: couple, isLoading: false);
        ref.invalidate(currentCoupleProvider);
      }
      return couple;
    } on CoupleException catch (error) {
      if (ref.mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: coupleFailureMessage(error.failure),
        );
      }
      return null;
    } finally {
      if (ref.mounted && state.isLoading) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<Invitation?> invite({required String contact}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final invitation = await ref
          .read(coupleRepositoryProvider)
          .invitePartner(contact: contact);
      if (ref.mounted) {
        state = state.copyWith(invitation: invitation, isLoading: false);
      }
      return invitation;
    } on CoupleException catch (error) {
      if (ref.mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: coupleFailureMessage(error.failure),
        );
      }
      return null;
    } finally {
      if (ref.mounted && state.isLoading) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<Couple?> join({required String code}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final couple = await ref
          .read(coupleRepositoryProvider)
          .joinCouple(code: code);
      if (ref.mounted) {
        state = state.copyWith(couple: couple, isLoading: false);
        ref.invalidate(currentCoupleProvider);
      }
      return couple;
    } on CoupleException catch (error) {
      if (ref.mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: coupleFailureMessage(error.failure),
        );
      }
      return null;
    } finally {
      if (ref.mounted && state.isLoading) {
        state = state.copyWith(isLoading: false);
      }
    }
  }
}

String coupleFailureMessage(CoupleFailure failure) => switch (failure) {
  CoupleFailure.invalidInvitation =>
    'Ce code est invalide ou a expiré. Vérifiez-le puis réessayez.',
  CoupleFailure.alreadyInCouple => 'Vous avez déjà un espace de couple actif.',
  CoupleFailure.noCouple => 'Créez d’abord votre espace de couple.',
  CoupleFailure.network => 'Connexion impossible. Réessayez.',
  CoupleFailure.unknown => 'Une erreur est survenue. Réessayez.',
};

final coupleControllerProvider =
    NotifierProvider.autoDispose<CoupleController, CoupleState>(
      CoupleController.new,
    );
