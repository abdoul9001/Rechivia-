/// Lecture et normalisation d'un code ou lien d'invitation.
abstract final class InvitationCode {
  static final RegExp _pattern = RegExp(r'^[A-Z0-9]{6}$');

  /// Retire les espaces et convertit en majuscules ; invalide sinon.
  static String? normalize(String? raw) {
    final text = raw?.replaceAll(RegExp(r'\s'), '').toUpperCase() ?? '';
    return _pattern.hasMatch(text) ? text : null;
  }

  /// Extrait un code valide du dernier segment d'une URI.
  static String? fromLink(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return null;

    final uri = Uri.tryParse(text);
    if (uri == null) return null;

    final segments = uri.pathSegments.where((segment) => segment.isNotEmpty);
    if (segments.isEmpty) return null;

    return normalize(segments.last);
  }
}
