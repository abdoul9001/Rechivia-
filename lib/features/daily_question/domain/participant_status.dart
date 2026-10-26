/// Situation d'un partenaire vis-à-vis de la question du jour.
enum ParticipantStatus {
  /// N'a pas encore répondu ni passé.
  pending,

  /// A envoyé sa réponse.
  answered,

  /// A passé la question sans pénalité.
  passed,
}
