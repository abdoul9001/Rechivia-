import 'dart:math';

import 'package:rechivia/features/couple/domain/couple.dart';
import 'package:rechivia/features/couple/domain/couple_exception.dart';
import 'package:rechivia/features/couple/domain/couple_icon.dart';
import 'package:rechivia/features/couple/domain/couple_repository.dart';
import 'package:rechivia/features/couple/domain/couple_validators.dart';
import 'package:rechivia/features/couple/domain/invitation.dart';
import 'package:rechivia/features/couple/domain/invitation_code.dart';

/// Dépôt en mémoire pour le développement, en attendant le backend.
class FakeCoupleRepository implements CoupleRepository {
  FakeCoupleRepository({
    this.latency = const Duration(milliseconds: 250),
    DateTime Function()? clock,
    Random? random,
  }) : _clock = clock ?? DateTime.now,
       _random = random ?? Random() {
    _invitations[developmentSeedCode] = _StoredInvitation(
      couple: const Couple(
        id: 'development-couple',
        name: 'Notre espace',
        icon: CoupleIcon.heart,
      ),
      invitation: Invitation(
        code: developmentSeedCode,
        expiresAt: _clock().add(invitationLifetime),
      ),
    );
  }

  static const String developmentSeedCode = 'K7M2PQ';
  static const Duration invitationLifetime = Duration(days: 7);
  static const String _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  final Duration latency;
  final DateTime Function() _clock;
  final Random _random;
  final Map<String, _StoredInvitation> _invitations = {};
  Couple? _couple;

  Couple? get currentCouple => _couple;

  @override
  Future<Couple> createCouple({
    required String name,
    required CoupleIcon icon,
  }) async {
    await Future<void>.delayed(latency);
    if (_couple != null) {
      throw const CoupleException(CoupleFailure.alreadyInCouple);
    }
    if (CoupleValidators.coupleName(name) != null) {
      throw const CoupleException(CoupleFailure.unknown);
    }

    final couple = Couple(
      id: 'couple-${_random.nextInt(1 << 32)}',
      name: name.trim(),
      icon: icon,
    );
    _couple = couple;
    return couple;
  }

  @override
  Future<Invitation> invitePartner({required String contact}) async {
    await Future<void>.delayed(latency);
    final couple = _couple;
    if (couple == null) {
      throw const CoupleException(CoupleFailure.noCouple);
    }
    if (CoupleValidators.partnerContact(contact) != null) {
      throw const CoupleException(CoupleFailure.unknown);
    }

    final code = _generateCode();
    final invitation = Invitation(
      code: code,
      expiresAt: _clock().add(invitationLifetime),
    );
    _invitations[code] = _StoredInvitation(
      couple: couple,
      invitation: invitation,
    );
    return invitation;
  }

  @override
  Future<Couple> joinCouple({required String code}) async {
    await Future<void>.delayed(latency);
    if (_couple != null) {
      throw const CoupleException(CoupleFailure.alreadyInCouple);
    }

    final normalizedCode = InvitationCode.normalize(code);
    final stored = normalizedCode == null ? null : _invitations[normalizedCode];
    if (stored == null ||
        stored.used ||
        !_clock().isBefore(stored.invitation.expiresAt)) {
      throw const CoupleException(CoupleFailure.invalidInvitation);
    }

    stored.used = true;
    _couple = stored.couple;
    return stored.couple;
  }

  String _generateCode() {
    while (true) {
      final code = List.generate(
        6,
        (_) => _alphabet[_random.nextInt(_alphabet.length)],
      ).join();
      if (!_invitations.containsKey(code)) return code;
    }
  }
}

class _StoredInvitation {
  _StoredInvitation({required this.couple, required this.invitation});

  final Couple couple;
  final Invitation invitation;
  bool used = false;
}
