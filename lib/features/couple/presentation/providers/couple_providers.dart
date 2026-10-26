import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/features/couple/data/fake_couple_repository.dart';
import 'package:rechivia/features/couple/domain/couple.dart';
import 'package:rechivia/features/couple/domain/couple_repository.dart';

/// Fournit le dépôt couple à l'application.
final coupleRepositoryProvider = Provider<CoupleRepository>(
  (ref) => FakeCoupleRepository(),
);

/// Espace de couple actuel (`null` si l'utilisateur n'en a pas).
final currentCoupleProvider = FutureProvider.autoDispose<Couple?>(
  (ref) => ref.watch(coupleRepositoryProvider).getCurrentCouple(),
);
