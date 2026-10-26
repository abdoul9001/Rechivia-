/// Type d'échange conservé dans l'historique.
enum HistoryKind { dailyQuestion, guidedConversation }

/// Issue d'une session passée.
enum HistoryStatus { revealed, waitingForPartner, passed, expired }

/// Entrée d'historique, sans réponse partenaire avant le dévoilement.
class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.kind,
    required this.date,
    required this.questionText,
    required this.status,
    this.myAnswer,
    this.partnerAnswer,
    this.isFavorite = false,
  }) : assert(
         partnerAnswer == null || status == HistoryStatus.revealed,
         'La réponse partenaire est disponible uniquement après le dévoilement.',
       ),
       assert(
         status != HistoryStatus.revealed || myAnswer != null,
         'Une session dévoilée contient la réponse de l’utilisateur.',
       );

  final String id;
  final HistoryKind kind;
  final DateTime date;
  final String questionText;
  final HistoryStatus status;
  final String? myAnswer;
  final String? partnerAnswer;
  final bool isFavorite;

  HistoryEntry copyWith({bool? isFavorite}) {
    return HistoryEntry(
      id: id,
      kind: kind,
      date: date,
      questionText: questionText,
      status: status,
      myAnswer: myAnswer,
      partnerAnswer: partnerAnswer,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
