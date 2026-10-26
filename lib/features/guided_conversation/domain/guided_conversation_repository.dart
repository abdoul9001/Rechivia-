import 'package:rechivia/features/guided_conversation/domain/guided_conversation.dart';

/// Contrat d'accès à une conversation guidée.
abstract interface class GuidedConversationRepository {
  Future<GuidedConversation> getConversation();

  /// Répond définitivement à une étape.
  Future<GuidedConversation> answerStep({
    required String stepId,
    required String text,
  });

  /// Passe définitivement une étape sans pénalité.
  Future<GuidedConversation> passStep({required String stepId});
}
