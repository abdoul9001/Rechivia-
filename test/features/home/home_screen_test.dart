import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/widgets/placeholder_screen.dart';
import 'package:rechivia/features/auth/data/fake_auth_repository.dart';
import 'package:rechivia/features/couple/data/fake_couple_repository.dart';
import 'package:rechivia/features/couple/domain/couple_icon.dart';
import 'package:rechivia/features/daily_question/data/fake_daily_question_repository.dart';
import 'package:rechivia/features/daily_question/domain/daily_question_repository.dart';
import 'package:rechivia/features/daily_question/domain/daily_session.dart';
import 'package:rechivia/features/daily_question/domain/daily_session_exception.dart';

import '../../helpers/pump_rechivia.dart';

class _FailingDailyQuestionRepository implements DailyQuestionRepository {
  @override
  Future<DailySession> getTodaySession() async {
    throw Exception('Échec simulé');
  }

  @override
  Future<DailySession> submitAnswer({required String text}) {
    throw const DailySessionException(DailySessionFailure.unknown);
  }

  @override
  Future<DailySession> passToday() {
    throw const DailySessionException(DailySessionFailure.unknown);
  }
}

Finder _placeholderText(String text) {
  return find.descendant(
    of: find.byType(PlaceholderScreen),
    matching: find.text(text),
  );
}

void main() {
  FakeDailyQuestionRepository buildQuestions() {
    return FakeDailyQuestionRepository(
      latency: Duration.zero,
      clock: () => DateTime(2026, 10, 26),
    );
  }

  testWidgets('affiche la question du jour', (tester) async {
    final questions = buildQuestions();
    final expected = (await questions.getTodaySession()).question;

    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.home,
      dailyQuestionRepository: questions,
    );

    expect(find.text('Question du jour'), findsOneWidget);
    expect(find.text(expected.text), findsOneWidget);
  });

  testWidgets('salue l\'utilisateur par son nom', (tester) async {
    final auth = FakeAuthRepository(latency: Duration.zero);
    await auth.signUp(
      email: 'emilie@mail.com',
      username: 'Émilie',
      password: 'motdepasse1',
    );

    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.home,
      authRepository: auth,
    );

    expect(find.text('Bonjour Émilie'), findsOneWidget);
  });

  testWidgets('salue sans nom quand personne n\'est connecté', (tester) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.home);

    expect(find.text('Bonjour'), findsOneWidget);
  });

  testWidgets('affiche l\'espace de couple quand il existe', (tester) async {
    final couples = FakeCoupleRepository(latency: Duration.zero);
    await couples.createCouple(name: 'Nous deux', icon: CoupleIcon.heart);

    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.home,
      coupleRepository: couples,
    );

    expect(find.text('Nous deux'), findsOneWidget);
  });

  testWidgets('propose de créer un espace quand il n\'y en a pas', (
    tester,
  ) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.home);

    expect(
      find.text('Vous n\'avez pas encore d\'espace de couple.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Créer mon espace'));
    await tester.pumpAndSettle();

    expect(find.text('Créez votre espace de couple'), findsOneWidget);
  });

  testWidgets('"Voir la question" ouvre l\'écran de réponse', (tester) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.home);

    await tester.tap(find.text('Voir la question'));
    await tester.pumpAndSettle();

    expect(find.text('Votre réponse reste privée'), findsOneWidget);
  });

  testWidgets('"Voir l\'historique" ouvre l\'onglet Historique', (
    tester,
  ) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.home);

    final historyAction = find.text('Voir l\'historique');
    await tester.ensureVisible(historyAction);
    await tester.tap(historyAction);
    await tester.pumpAndSettle();

    expect(_placeholderText('Historique'), findsOneWidget);
  });

  testWidgets('affiche "Réessayer" quand la question ne charge pas', (
    tester,
  ) async {
    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.home,
      dailyQuestionRepository: _FailingDailyQuestionRepository(),
    );

    expect(
      find.text('Impossible de charger la question du jour.'),
      findsOneWidget,
    );
    expect(find.text('Réessayer'), findsOneWidget);
  });
}
