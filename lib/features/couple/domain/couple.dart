import 'package:rechivia/features/couple/domain/couple_icon.dart';

/// Espace privé partagé par les deux partenaires.
class Couple {
  const Couple({required this.id, required this.name, required this.icon});

  /// Identifiant unique fourni par le serveur.
  final String id;

  /// Nom choisi par les partenaires.
  final String name;

  final CoupleIcon icon;
}
