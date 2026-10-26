import 'package:rechivia/features/history/domain/history_exception.dart';

String historyErrorMessage(Object error) {
  if (error is HistoryException) {
    return switch (error.failure) {
      HistoryFailure.unknownEntry =>
        'Cet élément n\'existe plus. Actualisez la liste.',
      HistoryFailure.network => 'Connexion impossible. Vérifiez votre réseau.',
      HistoryFailure.unknown => _genericMessage,
    };
  }
  return _genericMessage;
}

const String _genericMessage = 'Une erreur est survenue. Réessayez.';
