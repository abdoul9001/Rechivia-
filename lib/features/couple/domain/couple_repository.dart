import 'package:rechivia/features/couple/domain/couple.dart';
import 'package:rechivia/features/couple/domain/couple_icon.dart';
import 'package:rechivia/features/couple/domain/invitation.dart';

/// Contrat de gestion de l'espace de couple.
abstract interface class CoupleRepository {
  /// Crée l'espace de couple de l'utilisateur.
  Future<Couple> createCouple({required String name, required CoupleIcon icon});

  /// Invite un partenaire avec une adresse e-mail ou un numéro.
  Future<Invitation> invitePartner({required String contact});

  /// Rejoint un espace avec un code d'invitation.
  Future<Couple> joinCouple({required String code});

  /// Espace de couple actuel de l'utilisateur, ou `null` s'il n'en a pas.
  Future<Couple?> getCurrentCouple();
}
