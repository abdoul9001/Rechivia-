import 'package:rechivia/features/daily_question/domain/answer_validators.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_conversation_exception.dart';

/// Transforme une erreur de conversation en message lisible.
String guidedErrorMessage(Object error) {
  if (error is GuidedConversationException) {
    return switch (error.failure) {
      GuidedConversationFailure.invalidAnswer =>
        'Votre réponse doit contenir entre 1 et '
            '${AnswerValidators.maxLength} caractères.',
      GuidedConversationFailure.unknownStep =>
        'Cette étape n\'existe plus. Actualisez la conversation.',
      GuidedConversationFailure.alreadyResolved =>
        'Cette étape a déjà été traitée.',
      GuidedConversationFailure.network =>
        'Connexion impossible. Vérifiez votre réseau.',
      GuidedConversationFailure.unknown => _genericMessage,
    };
  }
  return _genericMessage;
}

const String _genericMessage = 'Une erreur est survenue. Réessayez.';
