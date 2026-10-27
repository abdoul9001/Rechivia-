/// Réglages de notification de l'utilisateur.
///
/// Ils sont enregistrés par l'application et appliqués par le serveur avant
/// l'envoi d'une notification.
class NotificationSettings {
  const NotificationSettings({
    this.dailyQuestion = true,
    this.partnerAnswers = true,
    this.coupleEvents = true,
    this.system = true,
    this.quietMode = false,
  });

  final bool dailyQuestion;
  final bool partnerAnswers;
  final bool coupleEvents;
  final bool system;
  final bool quietMode;

  NotificationSettings copyWith({
    bool? dailyQuestion,
    bool? partnerAnswers,
    bool? coupleEvents,
    bool? system,
    bool? quietMode,
  }) {
    return NotificationSettings(
      dailyQuestion: dailyQuestion ?? this.dailyQuestion,
      partnerAnswers: partnerAnswers ?? this.partnerAnswers,
      coupleEvents: coupleEvents ?? this.coupleEvents,
      system: system ?? this.system,
      quietMode: quietMode ?? this.quietMode,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationSettings &&
        other.dailyQuestion == dailyQuestion &&
        other.partnerAnswers == partnerAnswers &&
        other.coupleEvents == coupleEvents &&
        other.system == system &&
        other.quietMode == quietMode;
  }

  @override
  int get hashCode => Object.hash(
    dailyQuestion,
    partnerAnswers,
    coupleEvents,
    system,
    quietMode,
  );
}
